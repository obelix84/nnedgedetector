//
//  FileTableDataSource.h
//  NeuralEdge
//
//  Created by Dmitry Putilin on 13.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FileTableDataSource: NSObject {
	IBOutlet NSTableView	*fileTable;
	//имена файлов... в массиве
	NSMutableArray	* dataStorage;
	int index;
}

-(IBAction)addFileToTable:(id)sender;
-(void)setData:(id)element;
-(void)clearStorage;
-(NSMutableArray *) dataStorage;
@end

