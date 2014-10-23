//
//  AddTableController.m
//  Nora
//
//  Created by Paul Smal on 5/23/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import "AddTableController.h"
#import "AppDelegate.h"
@interface AddTableController ()

@end

@implementation AddTableController
@synthesize tableNameField;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(IBAction)createTable:(id)sender {
    NSString *tableName = [tableNameField stringValue];
    
    NSLog(@"tetet %@", tableName);
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    [appDelegate addNewTable:tableName ];
    
    [self close];
}

@end
