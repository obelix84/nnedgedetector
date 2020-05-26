//
//  BrightnessNeuron.h
//  NeuralEdge
//
//  Created by Dmitry Putilin on 19.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BrightnessNeuron : NSObject {
	double brightnessPrototype;
}
-(double)brightnessPrototype;
-(double)output:(double)m;
-(double)setBrightnessPrototype:(double)pr;
@end
