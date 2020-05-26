//
//  BrightnessSegmentation.h
//  NeuralEdge
//
//  Created by Dmitry Putilin on 19.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ImageIntensity.h"
#import "ImageInfo.h"
#import "NeuronArray.h"


@interface BrightnessSegmentation : NSObject {
	int segmentsCount;
	int windowSize;
	NSMutableArray * bNeurons;
}
-(id)initWithWindowSize:(int)w_size andSegmentsCount:(int)sc;
-(void)segmentation:(ImageInfo *)imgInfo;
-(NSMutableArray *) bNeurons;
//методо для обучения сети, на вход поступает массив имен файлов и коэффициент
-(void) trainNetworkWithImages:(NSMutableArray *) fileNames andEta:(double)eta; 
-(int) segmentsCount;
-(int) windowSize;
@end
