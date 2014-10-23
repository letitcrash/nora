//
//  IndexViewClt.h
//  Nora
//
//  Created by Paul on 9/17/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "ColorGradientView.h"
#import "ocilib.h"
#import "NOColumn.h"
#import "NOTable.h"
#import "IndexCellView.h"

@interface TypeViewClt : NSViewController  <NSTableViewDataSource, NSTableViewDelegate>
{
    NSMutableArray *list;
    int colCountIndex;
    int dCountIndex;
    
}
@property (weak) IBOutlet NSTabView *tableTabsView;

@property (weak) IBOutlet NSTextField *dateCreated;
@property (weak) IBOutlet NSTextField *lastddl;
@property (weak) IBOutlet NSTextField *status;
@property (weak) IBOutlet NSTextField *name;
@property (weak) IBOutlet NSTextField *type;

@property (strong) IBOutlet ColorGradientView *topBar;
@property (strong) IBOutlet ColorGradientView *propView;

@property (weak) IBOutlet NSButton *colButton;
@property (weak) IBOutlet NSButton *codeButton;
@property (weak) IBOutlet NSButton *propButton;


@property (weak) IBOutlet NSTableView *colTableView;

@property (unsafe_unretained) IBOutlet NSTextView *codeView;


- (IBAction)colButtAction:(id)sender;
- (IBAction)codeAction:(id)sender;
- (IBAction)propAction:(id)sender;


- (IBAction)refreshAction:(id)sender;
//- (IBAction)insertAction:(id)sender;
- (IBAction)commitAction:(id)sender;
- (IBAction)rollBackAction:(id)sender;
//- (IBAction)removeAction:(id)sender;


@end
