//
//  DataSource.m
//  NeuralEdge
//
//  Created by Dmitry Putilin on 10.04.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ImageInfo.h"
#import "ImageIntensity.h"

@implementation ImageInfo

-(id)initWithImage:(NSString *)fileName
{
	self = [super init];
	if(self != nil)
	{
		NSFileManager *fm = [NSFileManager defaultManager];
		if([fm fileExistsAtPath:fileName] == YES)
		{
			//если изображение есть, то получаем матрицу интенсивности 
			sourceImage = [[ImageIntensity alloc] initWithFileName:fileName];
			//получаем размер картинки в пикселях
			int height = [sourceImage height];
			//int width = [sourceImage width];
			segmentsImage = [sourceImage copy];
			edgeImage = [sourceImage copy];
			meanImage = [sourceImage copy];
			m1Image = [sourceImage copy];
			m2Image = [sourceImage copy];
			//и создем массив в памяти для хранения номера сегмента
			segmentPerPixel = calloc(height * [sourceImage rowSize], sizeof(unsigned char));
		}
		else
		{
			NSLog(@"File %d not exist!", fileName);
			return nil;
		}
	}
	return self;
}

-(unsigned char *) segmentPerPixel
{
	return segmentPerPixel;
}

-(ImageIntensity *) source
{
	return sourceImage;
}

-(ImageIntensity *) segments
{
	return segmentsImage;
}

-(ImageIntensity *) edge
{
	return edgeImage;
}

-(ImageIntensity *) mean
{
	return meanImage;
}

-(ImageIntensity *) M1
{
	return m1Image;
}

-(ImageIntensity *) M2
{
	return m2Image;
}


-(void)dealloc
{
	free(segmentPerPixel);
	[sourceImage release];
	[edgeImage release];
	[segmentsImage release];
	[meanImage release];
	[m1Image release];
	[m2Image release];
	[super dealloc];
}



@end
