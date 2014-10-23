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
#import "NOColumn.h"
#import "NOTable.h"
#import "IndexCellView.h"

@interface TestViewController : NSViewController  <NSTableViewDataSource, NSTableViewDelegate>
{
    NSMutableArray *list;
    NSMutableArray *depList;
    NSMutableArray *constrList;
    NSMutableArray *triggersList;
    NSMutableArray *tableOptions;
    
    NSMutableArray *dataSaveArray;
    NSMutableDictionary *dataSaveList;

    
    NSMutableArray *listToRemove;
    // NSMutableArray *colList;
    NSMutableArray *dataCols;
    NSMutableArray *indexCols;
    NSMutableArray *constrCols;
    NSMutableArray *triggersCols;
    OCI_Resultset *rs;

    NSMutableArray *colCols;
    NSString *mode;
    //OCI_Connection *cn;
    int colCountIndex;
    int dCountIndex;
    int count;
    int uploaded;
    
}
@property (weak) IBOutlet NSTabView *tableTabsView;
@property (weak) IBOutlet NSTextField *optTableName;

@property (weak) IBOutlet NSTextField *optType;
@property (weak) IBOutlet NSTextField *optSchem;
@property (weak) IBOutlet NSTextField *optTBSpace;
@property (weak) IBOutlet NSTextField *optStatus;
@property (weak) IBOutlet NSTextField *triggertype;
@property (weak) IBOutlet NSTextField *trigerown;
@property (weak) IBOutlet NSTextField *triggerstatus;
@property (weak) IBOutlet NSTextField *triggerName;

@property (weak) IBOutlet NSTextField *triggerStatus;
/// TODO


@property (weak) IBOutlet NSTextField *optCreated;
@property (weak) IBOutlet NSTextField *optDDL;



@property (strong) IBOutlet ColorGradientView *topBar;
@property (strong) IBOutlet ColorGradientView *propView;
@property (weak) IBOutlet NSScrollView *scrollView;

@property (strong) NSMutableArray  *colList;
@property (strong) NSMutableArray  *colNames;


@property (weak) IBOutlet NSButton *colButton;
@property (weak) IBOutlet NSButton *dataButton;
@property (weak) IBOutlet NSButton *depButt;
@property (weak) IBOutlet NSButton *trigButt;
@property (weak) IBOutlet NSButton *othersButt;




@property (weak) IBOutlet NSTableView *colTableView;
@property (weak) IBOutlet NSTableView *indexTableView;
@property (weak) IBOutlet NSTableView *consTableView;
@property (weak) IBOutlet NSTableView *triggersTableView;
@property (unsafe_unretained) IBOutlet NSTableView *tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@property (weak) IBOutlet NSButton *CommitButton;
@property (weak) IBOutlet NSButton *refreshButton;
@property (weak) IBOutlet NSButton *rollbackButton;
@property (weak) IBOutlet NSButton *insertButton;

-(void)refresh;
-(void)nextColumn;
- (void)remove;


- (IBAction)colButtAction:(id)sender;
- (IBAction)dataButtonAction:(id)sender;
- (IBAction)depButtAct:(id)sender;
- (IBAction)trigButtAction:(id)sender;
- (IBAction)otherButtAction:(id)sender;

- (IBAction)refreshAction:(id)sender;
- (IBAction)insertAction:(id)sender;
- (IBAction)commitAction:(id)sender;
- (IBAction)rollBackAction:(id)sender;
- (IBAction)removeAction:(id)sender;


@end
