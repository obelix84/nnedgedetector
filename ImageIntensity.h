//
//  ImageIntensity.h
//  NeuralEdge
//
//  Created by Dmitry Putilin on 30.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ImageIntensity : NSImage {
	NSString * fileName;
	int height;
	int width;
	int rowSize;
	unsigned char * imageBuffer;
}
-(id) initWithFileName:(NSString *)file;
-(unsigned char * ) imageBuffer;
-(void) saveImageFile:(NSString *)file;
-(int) height;
-(int) width;
-(int) rowSize;
@end
