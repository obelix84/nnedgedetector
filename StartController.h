//
//  StartController.h
//  NeuralEdge
//
//  Created by Dmitry Putilin on 20.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BrightnessSegmentation.h"
#import "NeuralNetworkEdgeDetector.h"

@interface StartController : NSObject {
	id BSeg;
	ImageInfo * II3;
	NeuralNetworkEdgeDetector * NNED;
	IBOutlet NSTableView * fileTable;
	IBOutlet NSImageView * imageView;
}

- (id) init;
- (void) dealloc;
- (IBAction) startNetwork:(id)sender;
- (IBAction) trainNetwork:(id)sender;
- (IBAction) showSource:(id)sender;
- (IBAction) showSegments:(id)sender;
- (IBAction) showMean:(id)sender;
- (IBAction) showEdge:(id)sender;
@end
