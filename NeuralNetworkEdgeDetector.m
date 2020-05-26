//
//  NeuralNetworkEdgeDetector.m
//  NeuralEdge
//
//  Created by Dmitry Putilin on 19.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "NeuralNetworkEdgeDetector.h"
#import "BrightnessSegmentation.h"
#import "NeuronsLayer.h"

@implementation NeuralNetworkEdgeDetector

-(id)initWithSegmentsCount:(int)segments andNeuronsCount:(int)neurons andWindowSize:(int)win_size 
{
	self = [super init];
	segmentsCount = segments;
	neuronsCount = neurons;
	BSeg = [[BrightnessSegmentation alloc] initWithWindowSize:win_size andSegmentsCount:segments];
	NLayer = [[NeuronsLayer alloc] initWithSegmentsCount:segments andNeuronCapacity:neurons andWindowSize:win_size andSegmentsCount:segments];
	return self;
}

-(void)trainNetworkWith:(NSMutableArray *) fileNames andEta:(double)eta;
{
	[BSeg trainNetworkWithImages:fileNames andEta:eta];
	[NLayer trainLayerWithImages:fileNames andEta:eta andBrightnessNeurons:[BSeg bNeurons]];
}

-(ImageInfo * )doIt:(NSString *) file
{
		ImageInfo *II = [[ImageInfo alloc] initWithImage:file];
		[BSeg segmentation:II];
		[NLayer edgeMap:II];
		NSLog([II description]);
		return II;
}
@end
