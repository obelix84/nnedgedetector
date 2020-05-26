//
//  NeuralNetworkEdgeDetector.h
//  NeuralEdge
//
//  Created by Dmitry Putilin on 19.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BrightnessSegmentation.h"
#import "NeuronsLayer.h"

@interface NeuralNetworkEdgeDetector : NSObject {
	//Класс сегментации по яркости
	BrightnessSegmentation * BSeg;
	//Класс с нейронами 
	NeuronsLayer * NLayer;
	// кол-во сегментов
	int segmentsCount;
	//кол-во нейронов на сегмент
	int neuronsCount; //по умолчанию 2 нейрона на сегмент
}
-(id)initWithSegmentsCount:(int)segments andNeuronsCount:(int)neurons andWindowSize:(int)win_size;
-(void)trainNetworkWith:(NSMutableArray *) fileNames andEta:(double)eta;
-(ImageInfo *)doIt:(NSString *) file;

@end
