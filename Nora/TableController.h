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

@interface TableController : NSViewController  <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate>
{
    NSMutableArray *list;
    NSMutableArray *dataSaveArray;
    NSMutableDictionary *dataSaveList;
    NSMutableArray *indexList;
    NSMutableArray *constrList;
    NSMutableArray *triggersList;
    NSMutableArray *tableOptions;

    NSMutableArray *listToRemove;
   // NSMutableArray *colList;
    NSMutableArray *dataCols;
    NSMutableArray *indexCols;
    NSMutableArray *constrCols;
    NSMutableArray *triggersCols;

    NSMutableArray *colCols;
    NSString *mode;
    //OCI_Connection *cn;
    OCI_Resultset *rs;

    int colCountIndex;
    int dCountIndex;
    int count;
    int uploaded;

}

@property (assign) IBOutlet NSWindow *sheet;

@property (weak) IBOutlet NSTabView *tableTabsView;
@property (weak) IBOutlet NSTextField *optTableName;

@property (weak) IBOutlet NSTextField *optType;
@property (weak) IBOutlet NSTextField *optSchem;
@property (weak) IBOutlet NSTextField *optRows;
@property (weak) IBOutlet NSTextField *optBlocks;
@property (weak) IBOutlet NSTextField *optTBSpace;

@property (weak) IBOutlet NSTextField *optStatus;

@property (weak) IBOutlet NSTextField *optAVGRowLen;
@property (weak) IBOutlet NSTextField *optSampleSize;
@property (weak) IBOutlet NSTextField *optInstances;
@property (weak) IBOutlet NSTextField *optCache;
@property (weak) IBOutlet NSTextField *optPCTFree;
@property (weak) IBOutlet NSTextField *optPCTUsed;
@property (weak) IBOutlet NSTextField *optIniTrans;
@property (weak) IBOutlet NSTextField *optMaxTarns;
@property (weak) IBOutlet NSTextField *optCreated;
@property (weak) IBOutlet NSTextField *optLAnalyzed;
@property (weak) IBOutlet NSTextField *triggertype;
@property (weak) IBOutlet NSTextField *trigerown;
@property (weak) IBOutlet NSTextField *triggerstatus;
@property (weak) IBOutlet NSScrollView *tableScrollView;
@property (weak) IBOutlet NSTextField *triggerName;

@property (weak) IBOutlet NSTextField *triggerStatus;
/// TODO


@property (strong) IBOutlet ColorGradientView *topBar;
@property (strong) IBOutlet ColorGradientView *propView;
@property (weak) IBOutlet NSScrollView *scrollView;

@property (strong) NSMutableArray  *colList;
@property (strong) NSMutableArray  *colNames;
@property (weak) IBOutlet NSButton *colButton;
@property (weak) IBOutlet NSButton *dataButton;
@property (weak) IBOutlet NSButton *constrainsButton;
@property (weak) IBOutlet NSButton *indexButt;
@property (weak) IBOutlet NSButton *funcButt;
@property (weak) IBOutlet NSButton *removeButt;
@property (weak) IBOutlet NSButton *othersButt;
- (IBAction)typeSelected:(id)sender;


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

- (IBAction)runQueries:(id)sender;
-(void)refresh;
-(void)nextColumn;
- (void)remove;
- (IBAction)colButtAction:(id)sender;
- (IBAction)test:(id)sender;
- (IBAction)dataButtonAction:(id)sender;
- (IBAction)constrainButtAct:(id)sender;
- (IBAction)indexesButtAction:(id)sender;
- (IBAction)otherButtAction:(id)sender;
- (IBAction)funcButtAction:(id)sender;
- (IBAction)refreshAction:(id)sender;
- (IBAction)insertAction:(id)sender;
- (IBAction)commitAction:(id)sender;
- (IBAction)rollBackAction:(id)sender;
- (IBAction)removeAction:(id)sender;

- (IBAction)activateSheet:(id)sender;
- (IBAction)closeSheet:(id)sender;
-(IBAction)createTable:(id)sender;
- (void)doubleClick:(id)nid;


@end
