//
//  ImageIntensity.m
//  NeuralEdge
//
//  Created by Dmitry Putilin on 30.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ImageIntensity.h"


@implementation ImageIntensity

-(id)initWithFileName:(NSString *) file
{
	self = [super initWithContentsOfFile:file];
	fileName = file;
	//Задача метода получить изображение, его преобразовать в нужный вид
	int numRep = [[self representations] count];
	//проверяем сколько тут пластин, поидее должна бить только одна
	if(numRep == 1)
	{
		//получаем репрезентацию
		NSBitmapImageRep * repr =[[self representations] objectAtIndex:0];
		unsigned char bits = [repr bitsPerPixel]; 
		if(bits == 8 && [repr isPlanar] == NO && [repr hasAlpha] == NO)
		{
			return self;
		}
		else 
		if (bits > 8 && [repr isPlanar] == NO && [repr hasAlpha] == NO) 
		{
			//int max = 2^bits-1;
			int h = [repr pixelsHigh];
			int w = [repr pixelsWide];
			height = h;
			width = w;
			NSBitmapImageRep * intensyRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL 
																					pixelsWide:w 
																					pixelsHigh:h 
																				 bitsPerSample:8 
																			   samplesPerPixel:1 
																					  hasAlpha:NO 
																					  isPlanar:NO 
																				colorSpaceName:@"NSCalibratedWhiteColorSpace" 
																				   bytesPerRow:0 
																				  bitsPerPixel:8] ;
			unsigned char * buff = [intensyRep bitmapData];
			int bytesPR = [repr bytesPerRow];
			int bytesPRintensy = [intensyRep bytesPerRow];
			int bps = [repr bitsPerSample];
			int bpp = [repr bitsPerPixel];
			unsigned char * src =  [repr bitmapData];
			//проверим характеристики изображения
			if(bpp/bps == 1);
			{
				if(bpp == 8)
				{	
					for(int i=0;i<w; i++)
					{
						*(buff+i) = *(src+i);
					}
				}
			}
			if(bpp/bps == 3)
			{
				for(int i=0;i<w; i++)
				{
					for(int j=0;j<h;j++)
					{
						int k = i*3 + bytesPR*j;
						*(buff+i+bytesPRintensy*j) =(int)( 0.3 * (*(src+k)) + 0.59 * (*(src+k+1))  + 0.11 * (*(src+k+2)));
					}
				}
			}
			[self removeRepresentation:repr];
			[self addRepresentation:intensyRep];
			rowSize = [intensyRep bytesPerRow];
			imageBuffer = [repr bitmapData];
			return  self;
		}
		else
		{
			NSLog(@"File Format Not Supported!");
		}
		return nil;
	}
	else
	{
		NSLog(@"File Format Not Supported!");
	}
	return self;
}

-(unsigned char *) imageBuffer
{
	return [[[self representations] objectAtIndex:0] bitmapData];
}

-(int) height
{
	return height;
}

-(int) width
{
	return width;
}

-(int) rowSize
{
	return rowSize;
}

-(void)saveImageFile:(NSString *) file
{
	NSData * imageData = [[[self representations] objectAtIndex:0] representationUsingType:NSBMPFileType properties: nil];
	[imageData writeToFile:file atomically:NO];
}

@end
