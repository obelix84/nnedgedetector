//
//  StartController.m
//  NeuralEdge
//
//  Created by Dmitry Putilin on 20.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "StartController.h"
#import "ImageIntensity.h"
#import "BrightnessSegmentation.h"
#import "FileTableDataSource.h"
#import "NeuralNetworkEdgeDetector.h"

@implementation StartController


- (id) init
{
	NNED = [[NeuralNetworkEdgeDetector alloc]initWithSegmentsCount:10 andNeuronsCount:2 andWindowSize:5];
	BSeg = [[BrightnessSegmentation alloc] initWithWindowSize:5 andSegmentsCount:10];
	II3 = [[ImageInfo alloc] initWithImage:@"pm101.bmp"];
	return [super init];
}

- (void) dealloc
{
	[BSeg release];
	[II3 release];
	[super dealloc];
}

- (IBAction) startNetwork:(id)sender
{		
	II3 = [NNED doIt:@"pm101.bmp"];
	[imageView setImage:[II3 edge]];
	[II3 retain];
};

- (IBAction) trainNetwork:(id)sender
{
	//[BSeg trainNetworkWithImages:[[fileTable dataSource] dataStorage] andEta:0.5];
	[NNED trainNetworkWith:[[fileTable dataSource] dataStorage] andEta:0.5];
}

- (IBAction) showSource:(id)sender
{
		[imageView setImage:[II3 source]];
}

- (IBAction) showSegments:(id)sender
{
		[imageView setImage:[II3 segments]];
}

- (IBAction) showMean:(id)sender
{
		[imageView setImage:[II3 mean]];
}

- (IBAction) showEdge:(id)sender
{
	[imageView setImage:[II3 edge]];
}

-(id) BSeg
{
	return BSeg;
}

@end
