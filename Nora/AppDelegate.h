//
//  AppDelegate.h
//  Nora
//
//  Created by Paul Smal on 3/27/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PXSourceList.h"
#import "ColorGradientView.h"
#import "ColorGradWithShadow.h"
#import "Connection.h"
#import "NOError.h"
#import "NOTempObject.h"
#import "NOColumn.h"
@class AddTableController;

#ifndef MAC_OS_X_VERSION_10_6
@protocol NSApplicationDelegate <NSObject> @end
#endif

@interface AppDelegate : NSObject <NSApplicationDelegate, PXSourceListDataSource, PXSourceListDelegate, NSOutlineViewDataSource, NSOutlineViewDelegate,NSTextFieldDelegate>  {
	
    int coldStart;
    
    IBOutlet PXSourceList *sourceList;
	
	NSMutableArray *sourceListItems;
	NSMutableArray *typesList;
	@public NSMutableDictionary *connections;
	NSMutableDictionary *conids;
	@public NSMutableDictionary *newnames;
	NSMutableDictionary *objProps;
	NSMutableDictionary *connectionViews;
	NSMutableArray *logEntries;
    NSString *mode;
    CGFloat lastSplitViewSubViewLeftWidth;
    NSString *config;
    //OCI_Connection *cn;
    NSMutableDictionary *plist;
    int conCountIndex;
    int qCountIndex;
    int allConCount;
    
    NSMutableDictionary *QsavedSelectedRows;
    NSMutableDictionary *IsavedSelectedRows;
    NSMutableDictionary *VsavedSelectedRows;
    NSMutableDictionary *FsavedSelectedRows;
    NSMutableDictionary *TsavedSelectedRows;
    NSMutableDictionary *PsavedSelectedRows;

    NSInteger qSelectedRow;
    NSInteger iSelectedRow;
    NSInteger vSelectedRow;
    NSInteger fSelectedRow;
    NSInteger tSelectedRow;
    NSInteger pSelectedRow;
@private
    NSWindow *acc;



}

//pass change props
@property (weak) IBOutlet NSTextField *curPass;
@property (weak) IBOutlet NSTextField *conPass;
@property (weak) IBOutlet NSTextField *nsPass;
@property (weak) IBOutlet NSButton *dbmsButton;
@property (weak) IBOutlet NSButton *propButton;

-(IBAction)bindSheetView:(id)sender;
- (IBAction)changeSQLPass:(id)sender;

@property (weak) IBOutlet NSButton *refreshButton;
- (IBAction)refreshAction:(id)sender;

@property (assign) IBOutlet NSWindow *sheet;
@property (assign) IBOutlet NSWindow *pass;
@property (assign) IBOutlet NSView*				subView;

@property (weak) IBOutlet NSSearchField *filterField;

@property (strong) IBOutlet NSOutlineView *logView;
@property (strong) NSMutableArray  *conNames;

@property (strong) IBOutlet ColorGradientView *topBar;
@property (strong) IBOutlet ColorGradientView *bottomBar;
@property (assign) IBOutlet NSTextField *selectedItemLabel;
@property (assign) NSString *selectedItem;
@property (assign) NSString *tableMode;
@property (assign) NSString *config;
@property (assign) NSInteger selectedItemIndex;


@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSToolbar *toolbar;
@property (weak) IBOutlet NSSegmentedControl *viewsSegment;
@property (weak) IBOutlet NSButton *addMainButton;
@property (weak) IBOutlet NSButton *removeMainButton;

@property (weak) IBOutlet ColorGradientView *mainview;
@property (strong) NSViewController *viewcontroller;
@property (weak) IBOutlet NSButton *qButton;
@property (weak) IBOutlet NSButton *tButton;
@property (weak) IBOutlet NSButton *vButton;
@property (weak) IBOutlet NSTextField *connname;
@property (weak) IBOutlet NSTextField *usernmaef;
@property (weak) IBOutlet NSTextField *passwordf;
@property (weak) IBOutlet NSTextField *hostf;
@property (weak) IBOutlet NSToolbarItem *rowActions;
@property (weak) IBOutlet NSToolbarItem *tableActions;
@property (weak) IBOutlet NSToolbarItem *queryActions;
@property (weak) IBOutlet NSSegmentedControl *tableActionsSegment;
@property (weak) IBOutlet NSSegmentedControl *queryActionSegment;
@property (weak) IBOutlet NSSegmentedControl *addOrRemoveActions;
@property (weak) IBOutlet NSSegmentedControl *viewSegmentCl;
@property (weak) IBOutlet NSSplitView *mainSplitView;
@property (weak) IBOutlet NSSplitView *hzSplitView;
@property (weak) IBOutlet NSView *bottomLogView;
@property (weak) IBOutlet NSView *leftListView;

@property (weak) IBOutlet NSTextField *portf;
@property (weak) IBOutlet NSTextField *sidf;
@property (weak) IBOutlet NSButton *connectionButt;

@property (weak) IBOutlet NSTextField *tableNameField;

@property (unsafe_unretained) IBOutlet NSTextView *dbmsTextView;


///

@property (weak) IBOutlet NSButton *connectionsList;

@property (weak) IBOutlet NSButton *sqlButt;

@property (weak) IBOutlet NSButton *leftSideToggle;
@property (weak) IBOutlet NSButton *bottomSideToggle;
@property (assign) IBOutlet NSButton *cnButt;
@property (weak) IBOutlet NSSegmentedControl *logSwitch;
@property (weak) IBOutlet NSTabView *logTabView;

- (IBAction)logAction:(id)sender;
@property (weak) IBOutlet NSButton *DBMSbutt;
- (IBAction)emableDBMS:(id)sender;

-(IBAction)resetPassView:(id)sender;
- (void)doubleClick:(id)nid;
-(void)loadSourceList;
-(void)addNewTable:(NSString*)tableName;
-(void)reload:(NSString*)idcn mode:(NSString*)mode;
- (IBAction)switchConnection:(id)sender;
-(void)refresh:(BOOL)select;
- (IBAction)showTables:(id)sender;
- (IBAction)showViews:(id)sender;
- (int)connect:(NSString*)password;
- (int)disconnect:(NSString*)connName;
- (IBAction)viewsSegmentAction:(id)sender;
- (IBAction)saveConnection:(NSString*)ident ord:(NSNumber*)ord name:(NSString*)name user:(NSString*)user pass:(NSString*)pass host:(NSString*)host port:(NSString*)port sid:(NSString*)sid tag:(NSInteger)tag;
-(void)removeColumn:(NOTempObject*)obj;
-(NSMutableArray*)getTempTableColumns:(NSString*)tableName;
-(NSMutableArray*)getTempColNames:(NSString*)tableName;

- (IBAction)sqlButtAction:(id)sender;
@property (weak) IBOutlet NSButton *conListAction;


-(void)selectSidebarItem:(NSString*)tableName;

-(void)insertColumn:(NOTempObject*)col;
-(void)insertTempObjectsToDB;
-(void)dropObjectsToRemove;
-(void)performModificationForTempObjects;
-(void)renameObjects;
-(void)openNewQuery:(NSString*)text fname:(NSString*)name;
-(void)renameTable:(NSString*)tname to:(NSString*)newname;

-(NSArray*)getScemaTableNames:(NSString*)objName;



-(NSDictionary*)getObjectProperties:(NSString*)objName;


- (IBAction)queryActions:(id)sender;
-(void)logEntry:(NSString*)str sql:(NSString*)sql;
- (NSToolbarItem *) toolbar:(NSToolbar *)toolbar
      itemForItemIdentifier:(NSString *)itemIdentifier
  willBeInsertedIntoToolbar:(BOOL)flag;
-(BOOL)ifObjectInTemp:(NSString*)objName;
-(BOOL)isConnected:(NSString*)cName;

- (IBAction)addMainAction:(id)sender;
- (IBAction)removaMainAction:(id)sender;
- (IBAction) toggleLeftSubView:(id)sender;
- (int)executeUpdate:(NSString*)query;
-(void)selectSourceListItemByName:(NSString*)name;
-(NSArray*)getAllTypes;

- (IBAction)activateSheet:(id)sender;
- (IBAction)closeSheet:(id)sender;
-(IBAction)createTable:(id)sender;


@end