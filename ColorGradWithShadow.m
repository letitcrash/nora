//
//  ColorGradWithShadow.m
//  Nora
//
//  Created by Paul Smal on 6/12/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import "ColorGradWithShadow.h"

@implementation ColorGradWithShadow

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
    NSRect rect = NSMakeRect([self bounds].origin.x + 7, [self bounds].origin.y + 7, [self bounds].size.width - 9, [self bounds].size.height - 9);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:6.0 yRadius:6.0];
    [path addClip];
    


    
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
    
     [super drawRect:dirtyRect];
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
	//NSIndexSet *selectedIndexes = [_colTableView selectedRowIndexes];
	
    
    
}

@end