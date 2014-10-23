//
//  DataTableView.m
//  Nora
//
//  Created by Paul Smal on 6/3/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import "DataTableView.h"

@implementation DataTableView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
	//NSIndexSet *selectedIndexes = [_colTableView selectedRowIndexes];
	
    
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {

    return 10;
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSMutableDictionary *dc = [list objectAtIndex:row];
    NSString *identifier = [tableColumn identifier];
    return [dc valueForKey:identifier];
    
}




@end
