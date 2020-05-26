//
//  NeuronsLayer.m
//  NeuralEdge
//
//  Created by Dmitry Putilin on 07.05.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NeuronsLayer.h"
#import "BrightnessNeuron.h"
#import "ThresholdNeuron.h"


@implementation NeuronsLayer

-(id) initWithSegmentsCount:(int)segments andNeuronCapacity:(int)neuronsCount andWindowSize:(int)w_size andSegmentsCount:(int)sc
{
	self = [super init];
	neuCount = neuronsCount;
	windowSize = w_size;
	segmentsCount = sc;
	Neurons = [NSMutableArray arrayWithCapacity:segments];
	[Neurons retain];
	for(int i=0;i<segments;i++)
	{
		[Neurons addObject:[NSMutableArray arrayWithCapacity:neuronsCount]];
		for(int j=0;j<neuronsCount;j++)
		{
			[[Neurons objectAtIndex:i] addObject:[[ThresholdNeuron alloc] init]];
		}
	}
	return self;
	
}

-(void) dealoc
{
	[Neurons release];
	[super dealloc];
}

-(void) trainLayerWithImages:(NSMutableArray *) fileNames andEta:(double) eta andBrightnessNeurons:(NSMutableArray *)bNeurons;
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
	//рассчитываем характеристики
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
				//находим подсеть победитель
				unsigned char mem = 0;
				double min = [[bNeurons objectAtIndex:0] output:m_mean];
				for(int i=0;i<[bNeurons count]; i++)
				{
					if([[bNeurons objectAtIndex:i] output:m_mean] < min)
					{
						mem = i;
						min = [[bNeurons objectAtIndex:i] output:m_mean];
					}
				}
				//находим нейрон победитель подсети mem
				unsigned char n = 0; 
				ThresholdNeuron * tn = [[Neurons objectAtIndex:mem] objectAtIndex:n]; 
				min = [tn output:_m1:_m2];
				//нейроны относящиеся к подсети
				NSMutableArray * subnetNeurons = [Neurons objectAtIndex:mem];
				for(int i=0;i<neuCount; i++)
				{
					if([[subnetNeurons objectAtIndex:i] output:_m1:_m2] < min)
					{
						n = i;
						min = [[subnetNeurons objectAtIndex:i] output:_m1:_m2];
					}
				}
				//после того как нашли, обучаем сеть, изменяем вес по правилу
				double w1=0, w2=0;
				ThresholdNeuron * neu =[[Neurons objectAtIndex:mem] objectAtIndex:n];
				[neu retain];
				double et = eta * (1 - t/tf); 
				t++;
				w1 = [neu w1];
				w2 = [neu w2];
				w1 = w1 + et * (_m1 - w1);
				w2 = w2 + et * (_m2 - w2);
				[neu setW1:w1];
				[neu setW2:w2];
				[neu release];
			}
		}
		[self logWeights];
		[img release];
	}
	
}

-(void) edgeMap:(ImageInfo *)image 
{
	[image retain];
			int leftOffset = (int) windowSize / 2 ;
	//проводим бинаризацию по порогу из нейрона
	//сначала тестируем кусок изображения и относим его к нейрону какому-либо
	//первый цикл проходит по всем точкам изображеия, второй проходит по окну
	int width = [[image edge] width];
	int height = [[image edge] height];
	//указатель на память с картинкой :)
	unsigned char * buff = [[image edge] imageBuffer];
	//unsigned char * m1buff = [[image M1] imageBuffer];
	//unsigned char * m2buff = [[image M2] imageBuffer];
	int bpr = [[image edge] rowSize];
	//указатель на массив с сегментами
	unsigned char * segm = [image segmentPerPixel];
	
	//теперь нахродим индексы слабого и сильного нейрона для каждой подсети
	//и сохраняем их в массиве
	NSMutableArray * minNeurons = [NSMutableArray arrayWithCapacity:[Neurons count]];
	[minNeurons retain];
	NSLog([minNeurons description]);
	for(int k=0;k<[Neurons count];k++)
	{
		NSMutableArray * subnetNeurons = [Neurons objectAtIndex:k];
		NSLog([subnetNeurons description]);
		unsigned char ind_max = 0;
		unsigned char ind_min = 0;
		double min = [[subnetNeurons objectAtIndex:0] w1] - [[subnetNeurons objectAtIndex:0] w2];
		double max = 0;
		for(int i=0; i<[subnetNeurons count];i++)
		{
			double w1 = [[subnetNeurons objectAtIndex:i] w1];
			double w2 = [[subnetNeurons objectAtIndex:i] w2];
			if(!(w1 == 0 && w2 ==0))
			{
				if(min > w1-w2)
				{
					ind_min = i;
				}
				if(max <= w1-w2)
				{	
					ind_max = i;
				}
			}
		}
		for(int i=0; i<[minNeurons count];i++)
		{
			NSLog(@"%F %F",[[minNeurons objectAtIndex:i] w1],[[minNeurons objectAtIndex:i] w2]);
		}
		NSLog(@"ind_min: %d",ind_min);
		[minNeurons addObject:[subnetNeurons objectAtIndex:ind_min]];
	}
	NSLog([minNeurons description]);
	//делаем проход по изображению, а затем по окну	
	for(int x=0;x<width;x++)
	{
		for(int y=0;y<height;y++)
		{		
			//расчитываем m1 и m2
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
			
			//находим нейрон  победитель
			unsigned char mem = *(segm+x+y*bpr) ;
			//получаем нейроны подсети
			ThresholdNeuron * tn = [minNeurons objectAtIndex:mem];
			if(_m2-_m1 >= [tn w2] - [tn w1])
			{
				*(buff+x+y*bpr) = 255;
			}else
			{
				*(buff+x+y*bpr) = 0;
			}
									
		}
	}
	[minNeurons release];
	[image release];
}

-(void)logWeights
{
	NSMutableString * outstr = [[NSMutableString alloc] initWithString:@"Weights"];
	NSLog(@"Count");
	NSLog(@"Count: %d \n",[Neurons count]);
	for(int i=0;i<[Neurons count]; i++)
	{
		for(int j=0;j<[[Neurons objectAtIndex:i] count]; j++)
		{
			[outstr appendFormat:@" n%d%d: %F %F\n",i,j, [[[Neurons objectAtIndex:i] objectAtIndex:j] w1], [[[Neurons objectAtIndex:i] objectAtIndex:j] w2]];
		}
		[outstr appendString:@"\n"];
	}
	NSLog(@"%@",outstr);
	[outstr release];
}


@end
