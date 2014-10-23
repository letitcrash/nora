//
//  TableViewViewController.m
//  Nora
//
//  Created by Paul Smal on 4/20/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import "TableViewViewController.h"

@interface TableViewViewController ()

@end

@implementation TableViewViewController
@synthesize topBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.

    }
    
    return self;
}

-(void)awakeFromNib
{
    
    [topBar setStartingColor:
     [NSColor colorWithCalibratedWhite:0.88 alpha:1.0]]; //64-88
    [topBar setEndingColor:
     [NSColor colorWithCalibratedWhite:0.78 alpha:1.0]];
    [topBar setAngle:270];
}

@end
