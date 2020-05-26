//
//  BrightnessSegmentation.m
//  NeuralEdge
//
//  Created by Dmitry Putilin on 19.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BrightnessSegmentation.h"
#import "BrightnessNeuron.h"
#import "ImageIntensity.h"
#import "ImageInfo.h"


@implementation BrightnessSegmentation

-(id)initWithWindowSize:(int)w_size andSegmentsCount:(int)sc
{
	if (self = [super init])
	{	
		windowSize = w_size;
		segmentsCount = sc;
		bNeurons = [NSMutableArray arrayWithCapacity:sc];
		[bNeurons retain];
	}
	for(int i=0;i<sc;i++)
	{
		BrightnessNeuron * neuron = [[BrightnessNeuron alloc] init];
		[neuron setBrightnessPrototype:(double) 255*i/sc]; 
		[bNeurons addObject:neuron];
	}
	return self;
};

- (void) dealloc
{
	[bNeurons release];
	[super dealloc];
}

- (NSMutableArray *) bNeurons
{
	return bNeurons;
}

-(void)segmentation:(ImageInfo *)imgInfo
{
	ImageIntensity * img = [imgInfo source];
	[img retain];
	//обрабатываем сразу все изображение и получаем результаты
	//первый цикл проходит по всем точкам изображеия, второй проходит по окну
	int width = [img width];
	int height = [img height];
	//указатель на память с картинкой :)
	unsigned char * buff = [img imageBuffer];

	int leftOffset = (int) windowSize / 2 ;
	int bpr = [img rowSize];
	for(int x=0;x<width;x++)
	{
		for(int y=0;y<height;y++)
		{
			//для каждого нового окна считаем
			double x_sred = 0;
			double m_mean = 0;
			//первый проход для расчета среднего
			for(int i=x-leftOffset; i<=x+leftOffset; i++)
				for (int j=y-leftOffset; j<=y+leftOffset; j++)
				{
					//если не выходим за пределы, то получаем пиксель
					if (i<width && j<height && i>=0 && j>=0)
					{
						x_sred += (double)*(buff+i+j*bpr);
					}
				}
			x_sred = x_sred / (windowSize * windowSize);
			//расчиваем M1 и M2
			double _m1 = 0;
			double _m2 = 0;
			int c1 = 0;
			int c2 = 0;
			for(int i=x-leftOffset; i<=x+leftOffset; i++)
				for (int j=y-leftOffset; j<=y+leftOffset; j++)
				{
					//расчитываем m1 и m2
					//если не выходим за пределы, то получаем пиксель, если выходим то ничего не меняется
					//просто ноль
					if (i<=width && j<=height && i>=0 && j>=0)
					{
						double pix = (double) (*(buff+i+j*bpr));
						if (pix < x_sred)
						{
							_m1 += pix;
							c1++;
						}
						if (pix >= x_sred)
						{
							_m2 += pix;
							c2++;
						}
					}
					//если вышли то цвет нулевой
				}
			//делим вычисленные элементы
			if (c1 != 0)
				_m1 = _m1 / c1;
			if (c2 != 0)
				_m2 = _m2 / c2;
			m_mean = (_m1 + _m2) / 2;
			//формируем теперь матрицу изображения сегментов и выдаем ее
			unsigned char mem = 0;
			double min = [[[self bNeurons] objectAtIndex:0] output:m_mean];
			for(int i=0;i<[bNeurons count]; i++)
			{
				if([[bNeurons objectAtIndex:i] output:m_mean] < min)
				{
					mem = i;
					min = [[bNeurons objectAtIndex:i] output:m_mean];
				}
			}
			//часть пихаем в буфер с номерами сегментов
			unsigned char * segIndex = [imgInfo segmentPerPixel];
			unsigned char * segms = [[imgInfo segments] imageBuffer];
			unsigned char * means = [[imgInfo mean] imageBuffer];
			unsigned char * m1 = [[imgInfo M1] imageBuffer];
			unsigned char * m2 = [[imgInfo M2] imageBuffer];
			*(segIndex+x+y*bpr) = mem;
			*(m1+x+y*bpr) = _m1;
			*(m2+x+y*bpr) = _m2;
			*(means+x+y*bpr) = m_mean;
			*(segms+x+y*bpr) = (unsigned char) [[bNeurons objectAtIndex:mem] brightnessPrototype];
		}
	}
	[img release];
};

-(void) trainNetworkWithImages:(NSMutableArray *) fileNames andEta:(double)eta 
{
	double t = 0;
	double tf = 0;
	//надо рассчитать коэфиициент обучения
	for(int i=0;i<[fileNames count];i++)
	{
		ImageIntensity * img = [[ImageIntensity alloc] initWithFileName:[fileNames objectAtIndex:i]];
		int width = [img width];
		int height = [img height];
		tf += width * height;
		[img release];
	}
	NSLog(@"Train Count: %F", tf);
	for(int i=0;i<[fileNames count];i++)
	{
		ImageIntensity * img = [[ImageIntensity alloc] initWithFileName:[fileNames objectAtIndex:i]];
		//для каждого окна обучением нейроны сегментации
		//первый цикл проходит по всем точкам изображеия, второй проходит по окну
		int width = [img width];
		int height = [img height];
		//указатель на память с картинкой :)
		unsigned char * buff = [img imageBuffer];
		int leftOffset = (int) windowSize / 2 ;
		int bpr = [img rowSize];
		for(int x=0;x<width;x++)
		{
			for(int y=0;y<height;y++)
			{
				//для каждого нового окна считаем
				double x_sred = 0;
				double m_mean = 0;
				//первый проход для расчета среднего
				for(int i=x-leftOffset; i<=x+leftOffset; i++)
					for (int j=y-leftOffset; j<=y+leftOffset; j++)
					{
						//если не выходим за пределы, то получаем пиксель
						if (i<width && j<height && i>=0 && j>=0)
						{
							x_sred += (double)*(buff+i+j*bpr);
						}
					}
				x_sred = x_sred / (windowSize * windowSize);
				//расчиваем M1 и M2
				double _m1 = 0;
				double _m2 = 0;
				int c1 = 0;
				int c2 = 0;
				for(int i=x-leftOffset; i<=x+leftOffset; i++)
					for (int j=y-leftOffset; j<=y+leftOffset; j++)
					{
						//расчитываем m1 и m2
						//если не выходим за пределы, то получаем пиксель, если выходим то ничего не меняется
						//просто ноль
						if (i<=width && j<=height && i>=0 && j>=0)
						{
							double pix = (double) (*(buff+i+j*bpr));
							if (pix < x_sred)
							{
								_m1 += pix;
								c1++;
							}
							if (pix >= x_sred)
							{
								_m2 += pix;
								c2++;
							}
						}
						//если вышли то цвет нулевой
					}
				//делим вычисленные элементы
				if (c1 != 0)
					_m1 = _m1 / c1;
				if (c2 != 0)
					_m2 = _m2 / c2;
				m_mean = (_m1 + _m2) / 2;
				//находим нейрон победитель
				unsigned char mem = 0;
				BrightnessNeuron * b = [bNeurons objectAtIndex:0]; 
				double min = [b output:m_mean];
				for(int i=0;i<[bNeurons count]; i++)
				{
					if([[bNeurons objectAtIndex:i] output:m_mean] < min)
					{
						mem = i;
						min = [[bNeurons objectAtIndex:i] output:m_mean];
					}
				}
				//после того как раччитали, обучаем сеть, изменяем вес по правилу
				BrightnessNeuron * neu =[bNeurons objectAtIndex:mem];
				[neu retain];
				double et = eta * (1 - t/tf); 
				t++;
				double bp = [neu brightnessPrototype];
				bp = bp + et * (m_mean - bp);
				[neu setBrightnessPrototype:bp];
				[neu release];
			}
		}
		[self logWeights];
		[img release];
	}
}

-(void)logWeights
{
	NSMutableString * outstr = [[NSMutableString alloc] initWithString:@"Weights"];
	for(int i=0;i<[[self bNeurons] count]; i++)
	{
		[outstr appendFormat:@" n%d: %F",i, [[[self bNeurons] objectAtIndex:i] brightnessPrototype]];
	}
	NSLog(@"%@",outstr);
}

-(int) windowSize
{
	return windowSize;
}

-(int) segmentsCount
{
	return segmentsCount;
}
@end
