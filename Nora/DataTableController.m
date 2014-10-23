//
//  DataTableController.m
//  Nora
//
//  Created by Paul Smal on 6/3/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import "DataTableController.h"

@implementation DataTableController



//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

        NSMutableDictionary *dc = [list objectAtIndex:row];
        NSString *identifier = [tableColumn identifier];
        return [dc valueForKey:identifier];

}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return 10;
}


- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    // //NSLog(object);
    //  //NSLog([tableColumn identifier]);
    
    
    NSString *ident = [tableColumn identifier];
    NSMutableDictionary *dc = [list objectAtIndex:row];
    
    [dc setValue:object forKey:ident];
    
    
    // NSInteger *u = [dc
    // //NSLog(@"idex %ld", tt);
    // [tableView editColumn:tt row:row withEvent:nil select:YES];
    // [[tableView cell] setBackgroundColor:[NSColor blackColor]];
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
	//NSIndexSet *selectedIndexes = [_colTableView selectedRowIndexes];
	
    

}



//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////



@end
