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

@interface IndexViewClt : NSViewController  <NSTableViewDataSource, NSTableViewDelegate>
{
    NSMutableArray *list;
    NSMutableArray *tableOptions;
    int colCountIndex;
    long dCountIndex;
    
}
@property (weak) IBOutlet NSTabView *tableTabsView;


@property (strong) IBOutlet ColorGradientView *topBar;
@property (strong) IBOutlet ColorGradientView *propView;


@property (weak) IBOutlet NSButton *colButton;
@property (weak) IBOutlet NSButton *propButton;

@property (weak) IBOutlet NSTextField *dateCreated;
@property (weak) IBOutlet NSTextField *lastddl;
@property (weak) IBOutlet NSTextField *status;
@property (weak) IBOutlet NSTextField *name;
@property (weak) IBOutlet NSTextField *type;
@property (weak) IBOutlet NSTextField *uniq;
@property (weak) IBOutlet NSTextField *compress;
@property (weak) IBOutlet NSTextField *logging;
@property (weak) IBOutlet NSTextField *analyzed;
@property (weak) IBOutlet NSTextField *numrows;
@property (weak) IBOutlet NSTextField *ssize;
@property (weak) IBOutlet NSTextField *tname;
@property (weak) IBOutlet NSTextField *towner;
@property (weak) IBOutlet NSTableView *colTableView;



- (IBAction)colButtAction:(id)sender;
- (IBAction)propButtonAction:(id)sender;


- (IBAction)refreshAction:(id)sender;
//- (IBAction)insertAction:(id)sender;
- (IBAction)commitAction:(id)sender;
- (IBAction)rollBackAction:(id)sender;
//- (IBAction)removeAction:(id)sender;


@end
