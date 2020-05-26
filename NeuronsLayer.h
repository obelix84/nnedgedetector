//
//  NeuronsLayer.h
//  NeuralEdge
//
//  Created by Dmitry Putilin on 07.05.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ImageInfo.h"


@interface NeuronsLayer : NSObject {
	NSMutableArray * Neurons;
	int neuCount;
	int segmentsCount;
	int windowSize;
}
-(void) trainLayerWithImages:(NSMutableArray *) fileNames andEta:(double) eta andBrightnessNeurons:(NSMutableArray *)bNeurons;
-(void) edgeMap:(ImageInfo *)img;
-(id) initWithSegmentsCount:(int)segments andNeuronCapacity:(int)neuronsCount andWindowSize:(int)w_size andSegmentsCount:(int)sc; 
@end
