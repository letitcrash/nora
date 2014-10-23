//
//  ViewTableDelegate.m
//  Nora
//
//  Created by Paul on 9/24/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import "ViewTableDelegate.h"

@implementation ViewTableDelegate


- (void)boundsDidChange:(NSNotification *)aNotification
{
    
    NSScrollView *scrollView = [aNotification object];
    int currentPosition = CGRectGetMaxY([scrollView visibleRect]);
    int tableViewHeight = [[scrollView enclosingScrollView] bounds].size.height - 100;
    
    
    
    if ([aNotification object] == [[scrollView enclosingScrollView] contentView]) {
        
        
        
        if (currentPosition > tableViewHeight - 100)
        {
            
        }
        
    }
    
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    
    
}
- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    //    //NSLog(@"called datacell");
    
    //  [tableColumn setWidth:40];
    
    NSTextFieldCell *cell = [tableColumn dataCell];
    
    // //NSLog(@"ID =  %@", [tableColumn identifier]);
    if([[tableColumn identifier] isEqualToString:@"First"]) {
        [cell setTextColor: [NSColor blackColor]];
        //[cell setBackgroundColor:[NSColor blackColor]];
        [tableColumn setWidth:30];
        NSFont *mainTitleFont = [NSFont systemFontOfSize:11.0];
        [cell setFont:mainTitleFont];
        [cell setAlignment:NSCenterTextAlignment];
        
        
        [cell setDrawsBackground: YES];
        [cell setBackgroundColor: [NSColor colorWithCalibratedRed: 227.0 / 255.0
                                                            green: 233.0 / 255.0
                                                             blue: 254.0 / 255.0
                                                            alpha: 1.0]];
        
    } else {
        [cell setTextColor: [NSColor blackColor]];
        [cell setBackgroundColor:[NSColor whiteColor]];
        
    }
    return cell;
}


@end
