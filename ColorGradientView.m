//
//  ColorGradientView.m
//  Macora
//
//  Created by Paul Smal on 3/20/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import "ColorGradientView.h"
#import "TableController.h"


@implementation ColorGradientView

@synthesize startingColor;
@synthesize endingColor;
@synthesize angle;


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setStartingColor:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0]];
        [self setEndingColor:nil];
        [self setAngle:270];
        
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    if (endingColor == nil || [startingColor isEqual:endingColor]) {
        // Fill view with a standard background color
        [startingColor set];
        NSRectFill(dirtyRect);
    }
    else {
        // Fill view with a top-down gradient
        // from startingColor to endingColor
        NSGradient* aGradient = [[NSGradient alloc]
                                 initWithStartingColor:startingColor
                                 endingColor:endingColor];
        [aGradient drawInRect:[self bounds] angle:angle];
    }
}

- (void)boundsDidChange:(NSNotification *)aNotification
{

    NSScrollView *scrollView = [aNotification object];
    int currentPosition = CGRectGetMaxY([scrollView visibleRect]);
    int tableViewHeight = [[scrollView enclosingScrollView] bounds].size.height - 100;
    
    
    
    if ([aNotification object] == [[scrollView enclosingScrollView] contentView]) {
        
        
        
        if (currentPosition > tableViewHeight - 100)
        {
            /*
            if(rs != nil) {
                //NSLog(@"Getting more");
                // [self performSelectorInBackground:@selector(runAdditionalRows:) withObject:nil];
                //perform in ui thread
                [self runAdditionalRows:nil];
            }
             
             */
            
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
        //[tableColumn setWidth:30];
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
