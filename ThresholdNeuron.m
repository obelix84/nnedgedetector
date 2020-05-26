//
//  ThresholdNeuron.m
//  NeuralEdge
//
//  Created by Dmitry Putilin on 13.05.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ThresholdNeuron.h"


@implementation ThresholdNeuron

-(id)init
{
	self = [super init];
	w1 = 0;
	w2 = 0;
	return self;
}

-(double)w1
{
	return w1;
}

-(double)w2
{
	return w2;
}

-(void)setW1:(double)w
{
	w1 = w;
}

-(void)setW2:(double)w
{
	w2 = w;
}

-(double)output:(double)m1: (double)m2
{
	return sqrt((w1-m1)*(w1-m1) + (w2-m2)*(w2-m2));
}

@end
