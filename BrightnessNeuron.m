//
//  BrightnessNeuron.m
//  NeuralEdge
//
//  Created by Dmitry Putilin on 19.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BrightnessNeuron.h"


@implementation BrightnessNeuron

-(void) dealloc
{
	NSLog(@"Neuron Dead!");
	[super dealloc];
}

-(double)brightnessPrototype
{
	return brightnessPrototype;
};

-(double)output:(double)m
{
	return (fabs(m-brightnessPrototype));
};

-(double)setBrightnessPrototype:(double)pr
{
	brightnessPrototype = pr;
};

@end
