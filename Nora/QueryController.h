//
//  QueryController.h
//  Nora
//
//  Created by Paul Smal on 3/27/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ColorGradientView.h"
#import "ocilib.h"
#import "ConnectionManager.h"

@class AddTableController;
@class MGSFragaria;



@interface QueryController : NSViewController
{
    IBOutlet NSView *editView;
	MGSFragaria *fragaria;
	BOOL isEdited;

    NSMutableArray *list;
    NSMutableArray *metalist;
    NSMutableDictionary *keyWords;
    OCI_Connection *cn;
    NSString *sqlode;
    OCI_Resultset *rs;
    int rowCount;
    int count;
    int uploaded;
@private
    AddTableController *acc;

}
@property (weak) IBOutlet NSButton *refreshButton;
@property (weak) IBOutlet NSButton *runScriptButton;
@property (weak) IBOutlet NSButton *saveCodeButton;

@property (weak) IBOutlet NSButton *exportButton;
- (IBAction)exportAction:(id)sender;

@property (strong) IBOutlet ColorGradientView *topBar;
@property (weak) IBOutlet NSTableView *tableView;

@property (assign) IBOutlet NSButton *runButton;
@property (weak) IBOutlet NSSplitView *splitView;



- (void)setSyntaxDefinition:(NSString *)name;
- (NSString *)syntaxDefinition;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSQL:(NSString *)sql;
- (IBAction)enableDBMS:(id)sender;

- (IBAction)runButton:(id)sender;
- (IBAction)crossButton:(id)sender;
- (IBAction)saveQuery:(id)sender;
- (IBAction)runScript:(id)sender;
-(void)getAllTypes;

@end
