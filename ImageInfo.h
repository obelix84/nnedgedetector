//
//  DataSource.h
//  NeuralEdge
//
//  Created by Dmitry Putilin on 10.04.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ImageIntensity.h"


@interface ImageInfo : NSObject {
	ImageIntensity * sourceImage;
	ImageIntensity * segmentsImage;
	ImageIntensity * meanImage;
	ImageIntensity * m1Image;
	ImageIntensity * m2Image;
	ImageIntensity * edgeImage;
	unsigned char * segmentPerPixel;
}
-(id)initWithImage:(NSString *)fileName;
-(ImageIntensity *) source;
-(ImageIntensity *) segments;
-(ImageIntensity *) M1;
-(ImageIntensity *) M2;
-(ImageIntensity *) edge;
-(ImageIntensity *) mean;
-(unsigned char *) segmentPerPixel;
@end
