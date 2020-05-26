//
//  FileTableDataSource.m
//  NeuralEdge
//
//  Created by Dmitry Putilin on 13.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "FileTableDataSource.h"


@implementation FileTableDataSource

- (id) init
{
	if (self = [super init])
	{
		dataStorage = [NSMutableArray arrayWithCapacity:3];
		[dataStorage retain];
	}
	return (self);
}

- (void) dealloc
{
	[dataStorage release];
	NSLog(@"Release storage");
	[super dealloc];
}

-(void)awakeFromNib
{
	[fileTable setDoubleAction:@selector(rowDoubleClick:)];
	[fileTable setTarget:self];
}

-(void) setData:(id)element
{
	[dataStorage addObject:element];
}

-(NSMutableArray *) dataStorage
{
	return dataStorage;
}

-(void) clearStorage
{
	[dataStorage removeAllObjects];
}


-(IBAction)addFileToTable:(id)sender
{
	NSArray *fileTypes = [NSArray arrayWithObjects:@"jpg", @"jpeg", @"bmp",@"gif",@"png",@"psd",@"tga", nil];
	NSOpenPanel* oPanel = [NSOpenPanel openPanel];
	
	[oPanel setCanChooseDirectories:NO];
	[oPanel setCanChooseFiles:YES];
	[oPanel setCanCreateDirectories:YES];
	[oPanel setAllowsMultipleSelection:YES];
	[oPanel setAlphaValue:0.95];
	[oPanel setTitle:@"Select an image to open"];
	
	if ( [oPanel runModalForDirectory:nil file:nil types:fileTypes] == NSOKButton )
	{
		// Get an array containing the full filenames of all
		// files and directories selected.
		NSArray* files = [oPanel filenames];
		for( int i = 0; i < [files count]; i++ )
		{
			NSString* fileName = [files objectAtIndex:i];
			[self setData:fileName];
		}
			
	}
	[fileTable reloadData];
}

- (int)numberOfRowsInTableView:(NSTableView *)  aTbl
{
	return ([[self dataStorage] count]);
}

// -- Return the cell data for the specified row/column, 2006 Mar 27
- (id)tableView:(NSTableView *)aTbl 
	objectValueForTableColumn:(NSTableColumn *)aCol
			row:(int)aRow
{
		return ([[self dataStorage] objectAtIndex:aRow]);
}

// обработка двойного клика на имя изображения
- (void)rowDoubleClick:(id)sender
{
	NSLog(@"row: %d", [sender selectedRow]);
}

@end
