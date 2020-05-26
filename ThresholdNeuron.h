//
//  ThresholdNeuron.h
//  NeuralEdge
//
//  Created by Dmitry Putilin on 13.05.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ThresholdNeuron : NSObject {
	double w1, w2;
}
-(id)init;
-(double)w1;
-(double)w2;
-(void)setW1:(double)w;
-(void)setW2:(double)w;
-(double)output:(double)m1:(double) m2;
@end
