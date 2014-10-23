//
//  ColorGradWithShadow.h
//  Nora
//
//  Created by Paul Smal on 6/12/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ColorGradWithShadow : NSView

{
    NSColor *startingColor;
    NSColor *endingColor;
    int angle;
}

// Define the variables as properties
@property(nonatomic, retain) NSColor *startingColor;
@property(nonatomic, retain) NSColor *endingColor;
@property(assign) int angle;

@end
