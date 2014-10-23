//
//  AppDelegate.m
//  PXSourceList
//
//  Created by Alex Rozanski on 08/01/2010.
//  Copyright 2010 Alex Rozanski http://perspx.com
//

#import "AppDelegate.h"
#import "SourceListItem.h"
#import "ConnectionViewViewController.h"
#import "QueryController.h"
#import "TableViewViewController.h"
#import "DMTabBar.h"
#import "ocilib.h"
#import "Connection.h"
#import "TableController.h"
#import "ConnectionManager.h"
#import "AddTableController.h"
#import "IndexViewClt.h"
#import "TestViewController.h"
#import "TypeViewClt.h"
#import "IndexViewController.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import <SystemConfiguration/SCNetworkReachability.h>


#define kTabBarElements     [NSMutableArray arrayWithObjects: \
[NSDictionary dictionaryWithObjectsAndKeys: [NSImage imageNamed:@"Document"],@"image",@"Queries",@"title",nil], \
[NSDictionary dictionaryWithObjectsAndKeys: [NSImage imageNamed:@"tablebw"],@"image",@"Tables",@"title",nil], \
[NSDictionary dictionaryWithObjectsAndKeys: [NSImage imageNamed:@"tabBarItem1"],@"image",@"Views",@"title",nil], \
[NSDictionary dictionaryWithObjectsAndKeys: [NSImage imageNamed:@"stock_function_autopilot"],@"image",@"Functions",@"title",nil], \
[NSDictionary dictionaryWithObjectsAndKeys: [NSImage imageNamed:@"PagesView3"],@"image",@"Types",@"title",nil], \
[NSDictionary dictionaryWithObjectsAndKeys: [NSImage imageNamed:@"stock_insert_index_marker"],@"image",@"Indexes",@"title",nil],nil]

id refToSelf;

@interface AppDelegate() {
    IBOutlet    DMTabBar*   tabBar;
    IBOutlet    NSTabView*  tabView;
}

@end



@implementation AppDelegate




@synthesize toolbar;
@synthesize topBar;
@synthesize viewcontroller;
@synthesize mainview;
@synthesize window;
@synthesize qButton;
@synthesize tButton;
@synthesize vButton;
@synthesize connname,usernmaef,passwordf,hostf,portf,sidf;
@synthesize connectionButt;
@synthesize selectedItemLabel;
@synthesize selectedItem, selectedItemIndex;
//@synthesize logViewer;
@synthesize addOrRemoveActions;
@synthesize rowActions, tableActions, queryActions;

@synthesize tableActionsSegment;

@synthesize mainSplitView;


#pragma mark -
#pragma mark Init/Dealloc

- (id)init {
    self = [super init];
    refToSelf = self;
    
    allConCount = 0;
    conCountIndex = 1;
    qCountIndex = 1;
    _conNames = [[NSMutableArray alloc]init];
    connectionViews = [[NSMutableDictionary alloc]init];
    mode = [[NSString alloc] init];
    config = [[NSString alloc] init];
    logEntries = [[NSMutableArray alloc] init];
	sourceListItems = [[NSMutableArray alloc] init];
	connections = [[NSMutableDictionary alloc] init];
	newnames = [[NSMutableDictionary alloc] init];
    objProps = [[NSMutableDictionary alloc] init];
    
    return self;
}

-(void) showToolbarButtons {
    //////NSLog(@" mode is %@", mode);
    
    if([mode isEqualToString:@"query"]) {
        
        [_addMainButton setImage:[NSImage imageNamed:@"blue-document--plus"]];
        [_removeMainButton setImage:[NSImage imageNamed:@"blue-document--minus"]];


    } else if([mode isEqualToString:@"table"]) {
    
        [_addMainButton setImage:[NSImage imageNamed:@"table--plus"]];
        [_removeMainButton setImage:[NSImage imageNamed:@"table--minus"]];

        
    } else if([mode isEqualToString:@"connection"]) {
        [_addMainButton setImage:[NSImage imageNamed:@"database--plus"]];
        [_removeMainButton setImage:[NSImage imageNamed:@"database--minus"]];

        
    }

}

-(void)loadSourceList {
    
    //////NSLog(@"LOADING SLIST");
    NSString *currentConnName = [_cnButt title];
    
   // ////NSLog(@"LOADING SLIST %@" , [_cnButt title]);

   // NSString *ident = [[connections valueForKey:currentConnName] getCID];

    [sourceListItems removeAllObjects];
    
    NSString *filter = [_filterField stringValue];

    if([mode isEqualToString:@"query"]) {
        
        SourceListItem *libraryItem = [SourceListItem itemWithTitle:@"QUERIES" identifier:@"queries" ];
        NSMutableArray *array = [NSMutableArray arrayWithObjects:nil];
        
        
        for (id key in [[connections valueForKey:currentConnName] getQViews])
        {
            SourceListItem *item = [SourceListItem itemWithTitle:key  identifier:key type: @"query"];
            [item setIcon:[NSImage imageNamed:@"blue-documen-sql"]];
            [array addObject:item];
            
            
        }
        
        
        [libraryItem setChildren:array];
        
        [sourceListItems addObject:libraryItem];
        
        [self showTabBarItems:0];

        
            
    } else if([mode isEqualToString:@"table"]) {
        
        SourceListItem *libraryItem = [SourceListItem itemWithTitle:@"TABLES" identifier:@"table" ];
        
        NSMutableArray *array = [NSMutableArray arrayWithObjects:nil];
        
        int connectionsCount = 0;
        for( SourceListItem *item in [[connections objectForKey:currentConnName] getTables] )
        {
            
            connectionsCount++;
            
            if([filter length] > 0) {
                //apply filter
                
                if ([[item title] rangeOfString:filter options:NSCaseInsensitiveSearch].location == NSNotFound) {
                    
                } else {
                    [array addObject:item];
                    
                }
                
            } else {
                [array addObject:item];
                
            }            
        }
        
        [libraryItem setChildren:array];
        
        [sourceListItems addObject:libraryItem];
        [self showTabBarItems:1];

        
    }
    else if([mode isEqualToString:@"other"]) {
        
        SourceListItem *libraryItem = [SourceListItem itemWithTitle:@"TYPES" identifier:@"type" ];
        
        [libraryItem setChildren:[[connections objectForKey:currentConnName] getTypes]];
        

        [sourceListItems addObject:libraryItem];
        [self showTabBarItems:4];
        
        
        
    }
    
    else if([mode isEqualToString:@"indexes"]) {
                
        SourceListItem *libraryItemInd = [SourceListItem itemWithTitle:@"INDEXES" identifier:@"index" ];
        
        [libraryItemInd setChildren:[[connections objectForKey:currentConnName] getUserIndexes]];
        
        [sourceListItems addObject:libraryItemInd];
        
        [self showTabBarItems:5];

        
        
    }
    
    else if([mode isEqualToString:@"functions"]) {
                
        SourceListItem *libraryItemInd = [SourceListItem itemWithTitle:@"FUNCTIONS" identifier:@"functions" ];
        
        [libraryItemInd setChildren:[[connections objectForKey:currentConnName] getUserFuncs]];
        
        [sourceListItems addObject:libraryItemInd];
        
        [self showTabBarItems:3];

        
    }
    
    else if([mode isEqualToString:@"view"]) {
        
        SourceListItem *libraryItemInd = [SourceListItem itemWithTitle:@"VIEWS" identifier:@"views" ];
        
        
        [libraryItemInd setChildren:[[connections objectForKey:currentConnName] getViews]];
        
        [sourceListItems addObject:libraryItemInd];
        [self showTabBarItems:2];

        
        
    } else  {
        
        [self showTabBarItems:0];

        
        SourceListItem *libraryItem = [SourceListItem itemWithTitle:@"CONNECTIONS" identifier:@"library" ];
        
        NSMutableArray *array = [NSMutableArray arrayWithObjects:nil];
        
        int firstConnected = 0;
        int connectionsCount = 0;
        
        for( NSString *aKey in plist )
        {
            connectionsCount++;
            
            NSString *title = [[plist objectForKey:aKey] objectAtIndex:1];
            
            SourceListItem * item = [SourceListItem itemWithTitle:title identifier:aKey type:@"connection" order:[[plist objectForKey:aKey] objectAtIndex:0]];
            
            //            SourceListItem *item = [SourceListItem itemWithTitle:title identifier:aKey type:@"connection" ];

            
            [item setIcon:[NSImage imageNamed:@"database.png"]];
            
            if([[connections allKeys] containsObject:[[plist objectForKey:aKey] objectAtIndex:1]])
            {
                firstConnected = connectionsCount;
                //////NSLog(@"Connected %d", connectionsCount );
                [item setIcon:[NSImage imageNamed:@"database--arrow"]];
                [item setBadgeValue:1]; //set queries count TO_DO
                
            }
            
            if([filter length] > 0) {
                //apply filter
                
                if ([title rangeOfString:filter options:NSCaseInsensitiveSearch].location == NSNotFound) {
                    //////NSLog(@"string does not contain bla");
                } else {
                    //////NSLog(@"string contains bla!");
                    [array addObject:item];

                }

            } else {
                [array addObject:item];

            }
            
            
                      
        }
        
        
        
        NSArray *sortedArray;
        sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id a,id b) {
            NSNumber *first = [a aorder];
            NSNumber *second = [b aorder];
            return [first compare:second];
        }];
        NSArray* reversedArray = [[sortedArray reverseObjectEnumerator] allObjects];
        
        [libraryItem setChildren:array];

        [sourceListItems addObject:libraryItem];
        //[sourceList reloadData];
       // if(firstConnected > 0)
        //    [self selectSourceListRow:firstConnected];


        
    }
    
    [sourceList reloadData];

   // NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
    [sourceList expandItem:[sourceList itemAtRow:0]];
    
    
    if([mode isEqualToString:@"view"]) {
        NSNumber * sr = [VsavedSelectedRows valueForKey:[_cnButt title]];
        ////NSLog(@"saved row val is %@" , sr);
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[sr intValue]];
        [sourceList selectRowIndexes:indexSet byExtendingSelection:NO];


    } else if([mode isEqualToString:@"table"]) {
        
        //
        NSNumber * sr = [TsavedSelectedRows valueForKey:[_cnButt title]];
        ////NSLog(@"saved row val is %@" , sr);
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[sr intValue]];
        [sourceList selectRowIndexes:indexSet byExtendingSelection:NO];
    
    } else if([mode isEqualToString:@"query"]) {
        
        
        NSNumber * sr = [QsavedSelectedRows valueForKey:[_cnButt title]];
        ////NSLog(@"saved row val is %@" , sr);
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[sr intValue]];
        [sourceList selectRowIndexes:indexSet byExtendingSelection:NO];
        
    } else if([mode isEqualToString:@"functions"]) {
        NSNumber * sr = [FsavedSelectedRows valueForKey:[_cnButt title]];
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[sr intValue]];
        [sourceList selectRowIndexes:indexSet byExtendingSelection:NO];
    } else if([mode isEqualToString:@"indexes"]) {
        NSNumber * sr = [IsavedSelectedRows valueForKey:[_cnButt title]];
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[sr intValue]];
        [sourceList selectRowIndexes:indexSet byExtendingSelection:NO];
    } else if([mode isEqualToString:@"other"]) {
        NSNumber * sr = [PsavedSelectedRows valueForKey:[_cnButt title]];
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[sr intValue]];
        [sourceList selectRowIndexes:indexSet byExtendingSelection:NO];
    }


   // [sourceList selectRowIndexes:indexSet byExtendingSelection:NO];
    //NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
    //[sourceList selectRowIndexes:indexSet byExtendingSelection:NO];

    
}
-(NSArray*)getAllTypes {
    return typesList;
}

-(void)selectSavedItem {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
    [sourceList selectRowIndexes:indexSet byExtendingSelection:NO];

}

/*
-(void)selectSourceListRow:(int)row {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:row];
    [sourceList selectRowIndexes:indexSet byExtendingSelection:NO];
    [sourceList expandItem:[sourceList itemAtRow:0]];

}
 
 */

- (void)saveSelectedRow {
    
    if([mode isEqualToString:@"query"]) {
        //qSelectedRow = [sourceList selectedRow];
        
        NSNumber * sr = [NSNumber numberWithInteger:[sourceList selectedRow]];
        [QsavedSelectedRows setValue:sr forKey:[_cnButt title]];
        
    } else if ([mode isEqualToString:@"table"]) {
        NSNumber * sr = [NSNumber numberWithInteger:[sourceList selectedRow]];
        
        ////NSLog(@"saving selected row %@ ", sr);
        [TsavedSelectedRows setValue:sr forKey:[_cnButt title]];
        
    } else if ([mode isEqualToString:@"view"]) {
        NSNumber * sr = [NSNumber numberWithInteger:[sourceList selectedRow]];
        [VsavedSelectedRows setValue:sr forKey:[_cnButt title]];

        
    } else if ([mode isEqualToString:@"indexes"]) {
        NSNumber * sr = [NSNumber numberWithInteger:[sourceList selectedRow]];
        [IsavedSelectedRows setValue:sr forKey:[_cnButt title]];

        
    } else if ([mode isEqualToString:@"functions"]) {
        NSNumber * sr = [NSNumber numberWithInteger:[sourceList selectedRow]];
        [FsavedSelectedRows setValue:sr forKey:[_cnButt title]];

        
    } else if ([mode isEqualToString:@"other"]) {
        NSNumber * sr = [NSNumber numberWithInteger:[sourceList selectedRow]];
        [PsavedSelectedRows setValue:sr forKey:[_cnButt title]];
        
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    
    // Handle bar selection events
    [tabBar handleTabBarItemSelection:^(DMTabBarItemSelectionType selectionType, DMTabBarItem *targetTabBarItem, NSUInteger targetTabBarItemIndex) {
        if (selectionType == DMTabBarItemSelectionType_WillSelect) {
            
            [_filterField setStringValue:@""];
            
            if(targetTabBarItemIndex == 0) {
                
                [self saveSelectedRow];
                mode = @"query";
            
            }
            else if(targetTabBarItemIndex == 1)  {
                [self saveSelectedRow];
                mode = @"table";
               
                
            }
            else if(targetTabBarItemIndex == 2)  {
                [self saveSelectedRow];
                mode = @"view";
              
                
            }
            else if(targetTabBarItemIndex == 3)  {
                [self saveSelectedRow];
                
                mode = @"functions";

                
            }
            else if(targetTabBarItemIndex == 4)  {
                [self saveSelectedRow];
                
                mode = @"other";
                          }
            else if(targetTabBarItemIndex == 5)  {
                [self saveSelectedRow];
                
                mode = @"indexes";
                               
            }
            else {
                mode = @"na";
            }
            
                        
            [self showToolbarButtons];
            [self loadSourceList];
           // [self selectSourceListRow:1];
            
        } else if (selectionType == DMTabBarItemSelectionType_DidSelect) {

                //////NSLog(@"Did select %lu/%@",targetTabBarItemIndex,targetTabBarItem);
        }
    }];
    
}
-(void)showTabBarItems:(int)itemToSel {
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:2];

    if([mode isEqualToString:@"connection"]) {
        //no
        //[_refreshButton setHidden:YES];
        
        [window setTitle:@"Nora"];


    }
    else {
        //[_refreshButton setHidden:NO];
        [window setTitle:[NSString stringWithFormat:@"Nora - %@" , [_cnButt title]]];

        // Create an array of DMTabBarItem objects
        [kTabBarElements enumerateObjectsUsingBlock:^(NSDictionary* objDict, NSUInteger idx, BOOL *stop) {
            NSImage *iconImage = [objDict objectForKey:@"image"];
            [iconImage setTemplate:YES];
            
            DMTabBarItem *item1 = [DMTabBarItem tabBarItemWithIcon:iconImage tag:idx];
            item1.toolTip = [objDict objectForKey:@"title"];
            item1.keyEquivalent = [NSString stringWithFormat:@"%ld",(unsigned long)idx +1];
            item1.keyEquivalentModifierMask = NSCommandKeyMask;
            [items addObject:item1];
        }];
    }


    // Load them
    tabBar.tabBarItems = items;
    tabBar.selectedIndex = itemToSel;

}


///connections actions



- (void)removeQuery
{
	NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];
    
    NSString *identifier = [[sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
    
    // NSMutableDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:config];
    //[plist removeObjectForKey:identifier];
    
    //[plist writeToFile:config atomically:YES];
    
    [[[connections objectForKey:[_cnButt title]] getQViews] removeObjectForKey:identifier];
    
    [self loadSourceList];
    
    
}



- (IBAction)removeConnection:(id)sender {
 
	NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];
    
    NSString *identifier = [[sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
    
   // NSMutableDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:config];
    [plist removeObjectForKey:identifier];
    
    [plist writeToFile:config atomically:YES];
    
    [self loadSourceList];


}
-(void)addNewConnection{
   
    //////NSLog(@" CCIndex = %i",conCountIndex);
    NSString *coName = [NSString stringWithFormat:@"Connection1"];
    
    while(TRUE) {
        
        //////NSLog(@"COL = %i", conCountIndex);
        
        int t = conCountIndex;
        
        for (NSString *object in _conNames) {
            coName = [NSString stringWithFormat:@"Connection%d", conCountIndex];
            
            // do something with object
            //  NSString *cname = object;
            
            
            // //////NSLog(coName);
            // //////NSLog(cname);
            
            if ([object isEqualToString:coName]) {
                
                ////////NSLog(@"equel");
                t = conCountIndex;
                conCountIndex++;
            }
            
            
        }
        if(t == conCountIndex) {
            
            //////NSLog(@"T = %i , COL = %i", t, conCountIndex);
            break;
        }
        
        
        
        
    }
    

    
    NSString *uuidString = [[NSUUID UUID] UUIDString];
    NSNumber *ordr = [NSNumber numberWithInt:allConCount+1];
    NSArray *connarray = [NSArray arrayWithObjects:ordr,coName,@"localhost",@"",@"1521",@"",@"XE",@"1", nil];
    [plist setObject:connarray forKey:uuidString];    
    [plist writeToFile:config atomically:YES];
    
    [_conNames addObject:coName];
    allConCount++;
    [self loadSourceList];

    int cCount = 0;
    int newC = 1;
    
    for( NSString *aKey in plist )
    {
        
        cCount++;
        if([aKey isEqualToString:@"NewConnection"]) {
            newC = cCount;
            //////NSLog(@" NEWC = %i", newC);
        }
    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:newC];
    [sourceList selectRowIndexes:indexSet byExtendingSelection:NO];

    /*
    
    [sourceListItems removeAllObjects];
    
    
	SourceListItem *libraryItem = [SourceListItem itemWithTitle:@"CONNECTIONS" identifier:@"library" ];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:nil];
    
    
    int cCount = 0;
    int newC = 1;
    
    for( NSString *aKey in plist )
    {
        
        cCount++;
        if([aKey isEqualToString:@"NewConnection"]) {
            newC = cCount;
            //////NSLog(@" NEWC = %i", newC);
        }
         
      	SourceListItem *item = [SourceListItem itemWithTitle:[[plist objectForKey:aKey] objectAtIndex:1] identifier:aKey type:@"connection" order:[[plist objectForKey:aKey] objectAtIndex:1]];
        [item setIcon:[NSImage imageNamed:@"database"]];
        [array addObject:item];
        
    }


    NSArray *sortedArray;
    sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id a,id b) {
        NSNumber *first = [a aorder];
        NSNumber *second = [b aorder];
        return [first compare:second];
    }];

    NSArray* reversedArray = [[sortedArray reverseObjectEnumerator] allObjects];

    [libraryItem setChildren:reversedArray];
    
	[sourceListItems addObject:libraryItem];
	
	[sourceList reloadData];
     
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:newC];
    [sourceList selectRowIndexes:indexSet byExtendingSelection:NO];
    */


}

- (IBAction)saveConnection:(NSString*)ident ord:(NSNumber *)ord name:(NSString *)name user:(NSString *)user pass:(NSString *)pass host:(NSString *)host port:(NSString *)port sid:(NSString *)sid tag:(NSInteger)tag {
    
    
    ////NSLog(@" saving for id %@ " , ident);

    
    NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];
    NSString *fgg = [[NSString alloc]initWithFormat:@"%ld", tag ];
    NSArray *connarray = [NSArray arrayWithObjects:ord,name,host,user,port,pass,sid,fgg, nil];
    
    //
    BOOL proceed = YES;
    
    for( NSString *aKey in plist )
    {
        NSString *sname = [[plist objectForKey:aKey] objectAtIndex:1];
        if([sname isEqualToString:name]) {
            if(![aKey isEqualToString:ident]) {
                ////NSLog(@"Equal names , not saving warning idk %@ for id %@ ", aKey , ident);
                proceed = NO;
            }
            
            //ident = aKey;
        }
    }
    
    if(proceed) {
        [plist setObject:connarray forKey:ident];
        
        [plist writeToFile:config atomically:YES];

    } else {
        ////NSLog(@"not proceeded");
        
        [self logEntry:@"Saving connection information has not been proceeded, name already exist" sql:nil];
        [self openLogSubView];

        [connectionViews removeObjectForKey:ident];
    }
    

    
    [self loadSourceList];
    
    [sourceList selectRowIndexes:selectedIndexes byExtendingSelection:NO];
    
    [_conNames addObject:name];
    
    
}


- (IBAction)viewsSegmentAction:(id)sender {
    NSInteger sIndex = [_viewSegmentCl selectedSegment];
    
    
    if(sIndex == 0) { //left
        [self toggleLeftSubView:nil];
        
    }
    else if(sIndex == 1) { //bottom
        [self toggleBottomSubView:nil];

    }
    
    else {
        
    }
    
    
}



- (void) mainSplitViewWillResizeSubviewsHandler:(id)object
{
    lastSplitViewSubViewLeftWidth = [_bottomLogView frame].size.width;

}

- (void) hzSplitViewWillResizeSubviewsHandler:(id)object
{
    lastSplitViewSubViewLeftWidth = [_leftListView frame].size.width;
    
}

-(void)openLogSubView {
    if([_bottomLogView isHidden]) {
        [_bottomLogView setHidden:NO];
        
        [mainSplitView
         setPosition:450 //if todo
         ofDividerAtIndex:0
         ];
    }
    
    [_logSwitch selectSegmentWithTag:0];
    [_logTabView selectTabViewItemAtIndex:0];

    
    


}

- (IBAction) toggleLeftSubView:(id)sender
{
    [_hzSplitView adjustSubviews];
    if ([_leftListView isHidden]) {
        
        [_leftListView setHidden:NO];

        [_hzSplitView
         setPosition:240
         ofDividerAtIndex:0
         ];
        


    }
    else {
        [_hzSplitView
         setPosition:[_hzSplitView minPossiblePositionOfDividerAtIndex:0]
         ofDividerAtIndex:0
         ];
        [_leftListView setHidden:YES];

    }

}

- (IBAction) toggleBottomSubView:(id)sender
{
    [mainSplitView adjustSubviews];
    if ([_bottomLogView isHidden]) {
        
        [_bottomLogView setHidden:NO];
        
        [mainSplitView
         setPosition:450
         ofDividerAtIndex:0
         ];
        
        
        
    }
    else {
        [mainSplitView
         setPosition:[mainSplitView maxPossiblePositionOfDividerAtIndex:0]
         ofDividerAtIndex:0
         ];
        [_bottomLogView setHidden:YES];
        
    }
    
}



- (void)awakeFromNib
{
    [_refreshButton setToolTip:@"Refresh"];
    [_addMainButton setToolTip:@"Add"];
    [_removeMainButton setToolTip:@"Remove"];
    [_dbmsButton setToolTip:@"Enable DBMS Output"];
    [_propButton setToolTip:@"Properties"];

    QsavedSelectedRows = [[NSMutableDictionary alloc] init];
    VsavedSelectedRows = [[NSMutableDictionary alloc] init];
    TsavedSelectedRows = [[NSMutableDictionary alloc] init];
    IsavedSelectedRows = [[NSMutableDictionary alloc] init];
    FsavedSelectedRows = [[NSMutableDictionary alloc] init];
    PsavedSelectedRows = [[NSMutableDictionary alloc] init];
    
    typesList = [[NSMutableArray alloc] init];

    //[self showTabBarItems];

    if(!coldStart)
    {
        
   // [_cnButt setHidden:YES];

    [self toggleBottomSubView:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(mainSplitViewWillResizeSubviewsHandler:)
     name:NSSplitViewWillResizeSubviewsNotification
     object:mainSplitView
     ];
    

    
    BOOL selectFirst = NO;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    config = [documentsDirectory stringByAppendingPathComponent:@"Nora/com.noraapp.plist"];
    NSString *configDir = [documentsDirectory stringByAppendingPathComponent:@"Nora"];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    
    if (![fileManager fileExistsAtPath: configDir])
    {
        NSError* error;

        if(![fileManager createDirectoryAtPath:configDir withIntermediateDirectories:NO attributes:nil error:&error]) {
            //////NSLog(@"[%@] ERROR: attempting to write create MyFolder directory", [self class]);

        } else {
            config = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"Nora/com.noraapp.plist"] ];

        }
    }
    
    
    
    
   // NSFileManager *fileManager = [NSFileManager defaultManager];
   // NSMutableDictionary *data;
    
    if ([fileManager fileExistsAtPath: config])
        
    {
        
        //////NSLog(@"Getting info from file %@", config);

        plist = [[NSMutableDictionary alloc] initWithContentsOfFile: config];
        
        //get all names
        for( NSString *aKey in plist )
        {
            allConCount++;
            selectFirst = YES;
            NSString *name = [[plist objectForKey:aKey] objectAtIndex:1];
            int order = [[[plist objectForKey:aKey] objectAtIndex:0] intValue];
            
            if(order > allConCount) {
                allConCount = order;
            }

            [_conNames addObject:name ];
            /*
            cCount++;
            if([aKey isEqualToString:@"NewConnection"]) {
                newC = cCount;
                //////NSLog(@" NEWC = %i", newC);
            }
            SourceListItem *item = [SourceListItem itemWithTitle:[[plist objectForKey:aKey] objectAtIndex:0] identifier:[[plist objectForKey:aKey] objectAtIndex:0] type:@"connection" ];
            [item setIcon:[NSImage imageNamed:@"database"]];
            [array addObject:item];
             */
        }
        

        
        
    }
    else
    {
        //////NSLog(@"Creating new file");

        // If the file doesn’t exist, create an empty dictionary
        plist = [[NSMutableDictionary alloc] init];
    }
    
    mode = @"connection";

    
    
          
    [sourceList setTarget:self];
    [sourceList setDoubleAction:@selector(doubleClick:)];

    
    [topBar setStartingColor:
     [NSColor colorWithCalibratedWhite:0.98 alpha:1.0]]; //64-88
    [topBar setEndingColor:
     [NSColor colorWithCalibratedWhite:0.88 alpha:1.0]];
    [topBar setAngle:270];
    
    [_bottomBar setStartingColor:
     [NSColor colorWithCalibratedWhite:0.98 alpha:1.0]]; //64-88
    [_bottomBar setEndingColor:
     [NSColor colorWithCalibratedWhite:0.88 alpha:1.0]];
    [_bottomBar setAngle:270];
    
   
    [mainview setStartingColor:
     [NSColor colorWithCalibratedWhite:0.96 alpha:1.0]]; //64-88
    [mainview setEndingColor:
     [NSColor colorWithCalibratedWhite:0.98 alpha:1.0]];
    [mainview setAngle:270];

	[selectedItemLabel setStringValue:@"(none)"];
	
    
    [self loadSourceList];
    

    coldStart = YES;
    }
}

///log actions
-(IBAction)createTable:(id)sender {
    NSString *tableName = [_tableNameField stringValue];
    
    //////NSLog(@"tetet %@", tableName);
    //AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    //[appDelegate addNewTable:tableName ];
    Connection *nconn = [connections valueForKey:[_cnButt title]];
    
    
    // if(![nconn->actualUsername length] > 0) {
    

    
    
     if(![nconn->actualUsername length] > 0) {
        [self addNewTable:tableName];
    } else {
        [self addNewTable:[NSString stringWithFormat:@"%@.%@" , nconn->actualUsername ,tableName]];
    }

    [self closeSheet:nil];
}

-(void)logEntry:(NSString*)str sql:(NSString*)sql {
    
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh:mm:ss a"];
    //////NSLog(@"newDateString %@", newDateString);
    
   // NSString *title = [NSString stringWithFormat:@"%@: %s",newDateString,OCI_ErrorGetString(err) ];
   /// NSString *sql = [NSString stringWithFormat:@"sql: %s",OCI_GetSql(OCI_ErrorGetStatement(err)) ];
    
    NSMutableDictionary *error = [[NSMutableDictionary alloc]init];
    [error setValue:str forKey:@"title"];
    [error setValue:sql forKey:@"sql"];
    
    NOError *errorObj = [[NOError alloc] initWithName:str];
    if(sql != nil) {
        [errorObj addChild:[[NOError alloc] initWithName:sql ]];
    }
    
    
    [logEntries addObject:errorObj];
    
    
    [_logView reloadData];
    
   // [self openLogSubView];
    
    NSInteger numberOfRows = [_logView numberOfRows];
    
    if (numberOfRows > 0)
        [_logView scrollRowToVisible:numberOfRows - 1];

    
}



-(void)logMsg:(OCI_Error*)err {

    /*
    printf(
           "code  : ORA-%05i\n"
           "msg   : %s\n"
           "sql   : %s\n",
           OCI_ErrorGetOCICode(err),
           OCI_ErrorGetString(err),
           OCI_GetSql(OCI_ErrorGetStatement(err))
           );
    */
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh:mm:ss a"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    //////NSLog(@"newDateString %@", newDateString);

    NSString *title = [NSString stringWithFormat:@"%@: %s",newDateString,OCI_ErrorGetString(err) ];
    NSString *sql = [NSString stringWithFormat:@"sql: %s",OCI_GetSql(OCI_ErrorGetStatement(err)) ];
    
    NSMutableDictionary *error = [[NSMutableDictionary alloc]init];
    [error setValue:title forKey:@"title"];
    [error setValue:sql forKey:@"sql"];
    
    NOError *errorObj = [[NOError alloc] initWithName:title];
    if(OCI_GetSql(OCI_ErrorGetStatement(err)) != nil) {
        [errorObj addChild:[[NOError alloc] initWithName:sql ]];
    }
    
    
    [logEntries addObject:errorObj];
    
    
    [_logView reloadData];
    
    [self openLogSubView];
    
    NSInteger numberOfRows = [_logView numberOfRows];
    
    if (numberOfRows > 0)
        [_logView scrollRowToVisible:numberOfRows - 1];
    

}

-(void)reload:(NSString*)idcn mode:(NSString*)aMode {
    
    _tableMode = aMode;
    
    //NSString *connName = [[plist objectForKey:identifier] objectAtIndex:1];
    //NSString *identifier = [[sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
    
    NSString *identifier = [[connections objectForKey:idcn] getCID];
    //[[plist objectForKey:identifier] objectAtIndex:1];
    //////NSLog(@"reload con name %@", identifier);

  //  [connections objectForKey:identifier];
    
    //////NSLog(@"ident %@", identifier); //CHANGE
    
    

        
        NSString *connName = [[plist objectForKey:identifier] objectAtIndex:1];
        NSString *address = [[plist objectForKey:identifier] objectAtIndex:2];
        NSString *username = [[plist objectForKey:identifier] objectAtIndex:3];
        NSString *password = [[plist objectForKey:identifier] objectAtIndex:5];
        NSString *sid = [[plist objectForKey:identifier] objectAtIndex:6];
        NSString *port = [[plist objectForKey:identifier] objectAtIndex:4];
        NSString *fgg = [[plist objectForKey:identifier] objectAtIndex:7];
        BOOL isSID = YES;
        if([fgg integerValue] ==1 ) {
            isSID = YES;
        } else {
            isSID = NO;
        }
        
        //SERVICE_NAME
        NSString *connectionString;
        
        if(isSID) {
            connectionString = [NSString stringWithFormat:@"(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=%@)(PORT=%@)))(CONNECT_DATA=(SERVER=DEDICATED)(SID=%@)))", address, port, sid];
            
        }else {
            connectionString = [NSString stringWithFormat:@"(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=%@)(PORT=%@)))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=%@)))", address, port, sid];
            
        }
    
    
    
        if([[connections allKeys] containsObject:connName])
        {
        
            
            //TO_DO SERVICE NAME
            //Create Connection
            
            
            OCI_Connection *cn;
            OCI_Statement *st;
            OCI_Resultset *rs;
            
            OCI_EnableWarnings(TRUE);
            
            //////NSLog(@"MODE %u", OCI_GetImportMode());
            
            /* init OCILIB */
            if (OCI_Initialize(error, NULL, OCI_ENV_DEFAULT))
            {
                ConnectionManager *cm = [ConnectionManager sharedManager];
                NSString *cname = [_cnButt title];
                
                int cnid = [[connections objectForKey:cname] getCNID];
                
                cn = cm->cnarray[cnid];
                

                
                //cn = OCI_ConnectionCreate([connectionString UTF8String], [username UTF8String], [password UTF8String],OCI_SESSION_DEFAULT);
                
                if (cn)
                {
                    st = OCI_StatementCreate(cn);
                    //////NSLog(@"Connection ok" );
                    
                    /// getting info tables, views, types, functions , procedures, indexes
                    
                    //
                    
                    Connection *nconn = [connections valueForKey:cname];
                    
                    
                   // if(![nconn->actualUsername length] > 0) {

                    
                    ////NSLog(@" user length : %ld " , [nconn->actualUsername length]);
                    
                    
                    if(![nconn->actualUsername length] > 0) {
                        // def user
                        
                        ////NSLog(@"def user / l: %@ " , nconn->actualUsername);
                        
                        OCI_ExecuteStmt(st, "select * from user_objects ");
                        
                    } else {
                        ////NSLog(@"using user %@ " , nconn->actualUsername);
                        
                        NSString *query = [NSString stringWithFormat:@"select * from all_objects where owner like '%@' ", nconn->actualUsername];
                        OCI_ExecuteStmt(st, [query UTF8String]);
                        
                    }
                    
                    // OCI_ExecuteStmt(st, "select * from user_objects ");
                    
                    rs = OCI_GetResultset(st);
                    NSMutableArray *arrayTables = [NSMutableArray arrayWithObjects:nil];
                    NSMutableArray *arrayTViews = [NSMutableArray arrayWithObjects:nil];
                    NSMutableArray *arrayViews = [NSMutableArray arrayWithObjects:nil];
                    NSMutableArray *arrayFuncs = [NSMutableArray arrayWithObjects:nil];
                    NSMutableArray *arrayIndexes = [NSMutableArray arrayWithObjects:nil];
                    
                    while (OCI_FetchNext(rs))
                    {
                        //printf("name %s\n", OCI_GetString(rs, 2));
                        NSString *objName = [NSString stringWithFormat:@"%s", OCI_GetString2(rs, "OBJECT_NAME")];
                        NSString *objType = [NSString stringWithFormat:@"%s", OCI_GetString2(rs, "OBJECT_TYPE")];
                        NSString *objStatus = [NSString stringWithFormat:@"%s", OCI_GetString2(rs, "STATUS")];
                        NSString *objCreated = [NSString stringWithFormat:@"%s", OCI_GetString2(rs, "CREATED")];
                        NSString *objDDL = [NSString stringWithFormat:@"%s", OCI_GetString2(rs, "LAST_DDL_TIME")];
                        
                        //add props
                        NSMutableDictionary *props = [[NSMutableDictionary alloc] init];
                        if(objStatus != nil) {
                            [props setObject:objStatus forKey:@"STATUS"];
                        }
                        if(objCreated != nil) {
                            [props setObject:objCreated forKey:@"DATECREATED"];
                        }
                        if(objDDL != nil) {
                            [props setObject:objDDL forKey:@"LASTDDL"];
                        }
                        
                        [objProps setObject:props forKey:objName];
                        
                        
                        if([objType isEqualToString:@"TABLE"]) {
                            SourceListItem *item = [SourceListItem itemWithTitle:objName identifier:objName type:@"table" ];
                            [item setIcon:[NSImage imageNamed:@"table"]];
                            
                            [arrayTables addObject:item];
                            
                            
                            
                            
                        } else if([objType isEqualToString:@"VIEW"]) {
                            SourceListItem *item = [SourceListItem itemWithTitle:objName identifier:objName type:@"view" ];
                            [item setIcon:[NSImage imageNamed:@"view"]];
                            
                            [arrayTViews addObject:item];
                            
                        } else if([objType isEqualToString:@"INDEX"]) {
                            SourceListItem *item = [SourceListItem itemWithTitle:objName identifier:objName type:@"index" ];
                            [item setIcon:[NSImage imageNamed:@"category"]];
                            
                            [arrayIndexes addObject:item];
                            
                        } else if([objType isEqualToString:@"TYPE"]) {
                            SourceListItem *item = [SourceListItem itemWithTitle:objName identifier:objName type:@"type" ];
                            [item setIcon:[NSImage imageNamed:@"block"]];
                            
                            [arrayViews addObject:item];
                            
                        } else if([objType isEqualToString:@"FUNCTION"]) {
                            SourceListItem *item = [SourceListItem itemWithTitle:objName identifier:objName type:@"procedure" ];
                            [item setIcon:[NSImage imageNamed:@"fnodc"]];
                            
                            [arrayFuncs addObject:item];
                            
                        }
                        
                        
                    }
                    
                    OCI_ExecuteStmt(st, "select username from all_users");
                    
                    rs = OCI_GetResultset(st);
                    
                    NSMutableArray *arrayUsers = [NSMutableArray arrayWithObjects:nil];
                    
                    while (OCI_FetchNext(rs))
                    {
                        ///printf("name %s\n", OCI_GetString(rs, 1));
                        NSString *user = [NSString stringWithUTF8String:OCI_GetString(rs, 1)];
                        
                        [arrayUsers addObject:user];
                    }
                    
                    Connection *conn = [[Connection alloc] init];
                    [conn addTables:arrayTables];
                    [conn addViews:arrayTViews];
                    [conn addTypes:arrayViews];
                    [conn addIndexes:arrayIndexes];
                    [conn addFunctions:arrayFuncs];
                    [conn addUsers:arrayUsers];
                    conn->originalUsername = nconn->originalUsername;
                    conn->actualUsername = nconn->actualUsername;
                    
                    //save old queries
                    
                    //Open query view
                    
                    // [[viewcontroller view] removeFromSuperview];
                    
                    //NSViewController *vc = [[QueryController alloc] initWithNibName:@"QueryController" bundle:nil];
                    
                    //OCI_Cleanup();
                    
                    //self.viewcontroller = vc;
                    
                    
                    // NSString *qName2 = [NSString stringWithFormat:@"%@%d", connName, 1];
                    
                    
                    ////////NSLog(@"saving name %@ for conn %@",qName2, connName);
                    // [[[connections valueForKey:connName] qNames ]addObject:qName2];
                    
                    NSMutableDictionary *qviews = [[connections objectForKey:connName] getQViews];
                    
                    
                    for( NSString *aKey in qviews )
                    {
                        [conn addQView:[qviews objectForKey:aKey] forID:aKey];
                    }
                    //[conn addQView:vc forID:qName2];
                    [conn setCID:identifier];
                    
                    //  //////NSLog(@"name %@ , key saved: %@", connName,qName2);
                    //[mainview addSubview:[viewcontroller view]];
                    
                    
                    
                    //[[viewcontroller view] setFrame:[mainview bounds]];
                    //[[viewcontroller view] setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
                    
                    
                    /*
                     
                     
                     NSMenuItem* mi = [[NSMenuItem alloc] initWithTitle:connName action:nil keyEquivalent:@""];
                     
                     ConnectionManager *cm = [ConnectionManager sharedManager];
                     long tag = (long)[[connbutton selectedItem] tag];
                     
                     cm->cnarray[cm->count] = cm->cnarray[tag];
                     
                     cm->cnarray[cm->count] = cn;
                     
                     [mi setTag:cm->count];
                     
                     //cm->count++;
                     
                     [mi setTarget:self];
                     [[connbutton menu]addItem:mi];
                     [connbutton selectItemWithTag:mi.tag];
                     */
                    [connections setValue:conn forKey:connName];
                    //////NSLog(@"Connection saved");
                    
                    //mode = @"query";
                    [self loadSourceList];
                    //////NSLog(@"SList reloaded");
                    
                    //[self showTabBarItems];
                    //[self showToolbarButtons];
                    
                    
                }
                
                
                
            }
            
            
        }

        
        
}




void error(OCI_Error *err)
{

    [refToSelf logMsg:err];
}


-(BOOL)isConnected:(NSString*)cName {
    
    NSString *connName = [[plist objectForKey:cName] objectAtIndex:1];

    if([[connections allKeys] containsObject:connName]) {
        return YES;
    } else {
        return NO;
    }
    
}
-(void)openNewQuery:(NSString*)text fname:(NSString *)name {
    NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];
    
    NSString *identifier = [[sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
    //////NSLog(@"ident %@", identifier);
    // NSString *connName = [[plist objectForKey:identifier] objectAtIndex:1];
    
    NSString *connName = [_cnButt title];
    //////NSLog(@"con name %@", connName);
    
    
    [[[connections valueForKey:connName] qNames ]addObject:name];
    
    //Open query view
    
    // [[viewcontroller view] removeFromSuperview];
    
    NSViewController *vc = [[QueryController alloc] initWithNibName:@"QueryController" bundle:nil withSQL:text];
    
    //OCI_Cleanup();
    
    //self.viewcontroller = vc;
    
    
    //get name
    
        [[[connections valueForKey:connName] qNames ]addObject:name];
    ////////
    
    /// NSString *uuidString = [[NSUUID UUID] UUIDString];
    
    
    [[connections valueForKey:connName] addQView:vc forID:name];
    //  [conn addQView:vc forID:qName];
    //  [conn setCID:identifier];
    
    //////NSLog(@"name %@ , key saved: %@", connName,name);
    
    /*
     [mainview addSubview:[viewcontroller view]];
     
     
     
     [[viewcontroller view] setFrame:[mainview bounds]];
     [[viewcontroller view] setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
     
     
     */
    
    
    [self loadSourceList];
    
    
    NSString *currentConnName = [_cnButt title];
    


    
    
    //select table with name
    int rowToSelect = -1;
    int count = 0;
    for (id key in [[connections valueForKey:currentConnName] getQViews])
    {
        count++;
        if([key isEqualToString:name]) {
            rowToSelect = count;
        }
    }

    
    [sourceList selectRowIndexes:[NSIndexSet indexSetWithIndex:rowToSelect] byExtendingSelection:NO];


    
}



- (IBAction) addNewQuery:(id)sender {
    
    
    NSString *connName = [_cnButt title];
    //////NSLog(@"con name %@", connName);
    
    
    NSString *qName2 = [NSString stringWithFormat:@"%@%d", connName, 1];
    
    [[[connections valueForKey:connName] qNames ]addObject:qName2];


    
    //get name
    
    
    //////NSLog(@" Query Name Index = %i",qCountIndex);
    NSString *qName = [NSString stringWithFormat:@"%@%d",connName, qCountIndex];
    
    
    while(TRUE) {
        
        //////NSLog(@"Q COL = %i", qCountIndex);
        
        int t = qCountIndex;
        
        for (NSString *object in [[connections valueForKey:connName] qNames]) {
            qName = [NSString stringWithFormat:@"%@%d",connName, qCountIndex];
            
            // do something with object
            //  NSString *cname = object;
            
            
            // //////NSLog(coName);
            // //////NSLog(cname);
            
            if ([object isEqualToString:qName]) {
                
                ////////NSLog(@"equel");
                t = qCountIndex;
                qCountIndex++;
            }
            
            
        }
        if(t == qCountIndex) {
            
            //////NSLog(@"T = %i , COL = %i", t, qCountIndex);
            break;
        }
        
        
        
        
    }
    
    
    
    

    [self openNewQuery:@"" fname:qName];


}

/*


- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

*/
/*
-(BOOL)networkConnected: (NSString *)ipAdress  {
    SCNetworkReachabilityFlags  flags = 0;
    SCNetworkReachabilityRef    netReachability;
    BOOL                        retrievedFlags = NO;
    
    // added the "if" and first part of if statement
    //
    if (hasLeadingNumberInString(ipAdress)) {
        struct sockaddr_in the_addr;
        memset((void *)&the_addr, 0, sizeof(the_addr));
        the_addr.sin_family = AF_INET;
        //the_addr.sin_port = htons(port);
        const char* server_addr = [ipAdress UTF8String];
        unsigned long ip_addr = inet_addr(server_addr);
        the_addr.sin_addr.s_addr = ip_addr;
        the_addr.sin_len = sizeof(the_addr);
        netReachability =    SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (struct sockaddr*)&the_addr);
    } else {
        netReachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [ipAdress UTF8String]);
    }
    if (netReachability) {
        retrievedFlags = SCNetworkReachabilityGetFlags(netReachability, &flags);
        CFRelease(netReachability);
    }
    if (!retrievedFlags || !flags) {
        return NO;
    }
    return YES;
}
*/
- (BOOL)networkIsReachable:(NSString*)addr
{
    const char *c = [addr UTF8String];
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithName(NULL, c );
    SCNetworkReachabilityFlags flags;
    BOOL gotFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!gotFlags) {
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkReachabilityFlagsReachable;
    BOOL istst = flags & kSCNetworkReachabilityFlagsIsDirect;
    BOOL istst2 = flags & kSCNetworkReachabilityFlagsConnectionOnTraffic;
    
    //////NSLog(@"++++++++++++++++++++++++++++++++++++");

    
    if(isReachable) {
        //////NSLog(@"REACHABL ");
    }
    
    if(istst) {
        //////NSLog(@"REACHABL DIRECTE");
    }
    
    if(istst2) {
        //////NSLog(@"REACHABL ON TRANS");
    }
    
    
    BOOL noConnectionRequired = !(flags & kSCNetworkReachabilityFlagsConnectionRequired);
    if ((flags & kSCNetworkReachabilityFlagsIsDirect)) {
        noConnectionRequired = YES;
    }
    
    return NO;//(isReachable && noConnectionRequired) ? YES : NO;
}

- (BOOL)isNetworkAvailable {
    CFStreamError cfStreamError;
    
    CFHostRef hostRef = CFHostCreateWithName(kCFAllocatorDefault,
                                             CFSTR("192.168.0.55"));
    
    Boolean result = CFHostStartInfoResolution(hostRef,
                                               kCFHostReachability, &cfStreamError);
    
    
    CFDataRef data = CFHostGetReachability(hostRef, nil);
    
    SCNetworkConnectionFlags *flags;
    
    flags = (SCNetworkConnectionFlags *)CFDataGetBytePtr(data);
    
    int reachable = *flags & kSCNetworkReachabilityFlagsReachable;
   // int cellular = *flags & kSCNetworkReachabilityFlagsIsWWAN;
    
    if (reachable == 0) {
        return NO;
    }
    
     
    return result;
}

/*
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag{
    if(!flag){
        [[self window] makeKeyAndOrderFront:self];
    }
    
    return YES;
}
 
 */

-(void)renameTable:(NSString*)tname to:(NSString*)newname {
   // ////NSLog(@"rename added");
    [newnames setObject:newname forKey:tname];
}

-(void)renameObjects {
    //////NSLog(@"iterating rename");

    for (NSString* key in [newnames allKeys]) {
        NSString *newname = [newnames objectForKey:key];
        
       // ////NSLog(@"got name %@ fro key %@", newname, key);

        if(![newname isEqualToString:key]) {
          //  ////NSLog(@"performing");

            NSString *query = [NSString stringWithFormat:@"RENAME %@ TO %@", key , newname];
            [self executeUpdate:query];            
        }
    }
    
}


- (BOOL)pinghosttoCheckNetworkStatus
{
    bool success = false;
    const char *host_name = [@"192.168.0.55"
                             cStringUsingEncoding:NSASCIIStringEncoding];
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL,host_name);
    SCNetworkReachabilityFlags flags;
    success = SCNetworkReachabilityGetFlags(reachability, &flags);
    bool isAvailable = success && (flags & kSCNetworkFlagsReachable) &&
    !(flags & kSCNetworkFlagsConnectionRequired);
    if (isAvailable)
    {
        return YES;
    }else{
        return NO;
    }
}


/*
-(IBAction)connectTODB:(id)sender {
    if(![self connect]) {
        ////NSLog(@"Connection error");
    }
}
 
 */


- (int)connect:(NSString*)password {

   	NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];
    NSString *identifier = [[sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
    ////NSLog(@"ident %@", identifier); //CHANGE
    NSString *connName = [[plist objectForKey:identifier] objectAtIndex:1];
    ////NSLog(@"con name %@", connName);
    
    
    
    //check conns array

    if([[connections allKeys] containsObject:connName])
    {
        
        Connection *cn = [connections objectForKey:connName];
        ////NSLog(@"restoring  mode %@ ", mode);
        
        mode = cn->viewMode; //что-то намудрил todo fix
        
        [_cnButt setTitle:connName];
        
        
        //show tab bar items
        [self showToolbarButtons];
        [self loadSourceList];
        //load first connection info
        
       // NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
        //[sourceList expandItem:[sourceList itemAtRow:0]];
       
        //[sourceList selectRowIndexes:indexSet byExtendingSelection:NO];
        
        return 0;
        
    } else {
        //////NSLog(@"NOT Connected");

        NSString *connName = [[plist objectForKey:identifier] objectAtIndex:1];
        NSString *address = [[plist objectForKey:identifier] objectAtIndex:2];
        NSString *username = [[plist objectForKey:identifier] objectAtIndex:3];
        //NSString *password = [[plist objectForKey:identifier] objectAtIndex:5];
        NSString *sid = [[plist objectForKey:identifier] objectAtIndex:6];
        NSString *port = [[plist objectForKey:identifier] objectAtIndex:4];
        NSString *fgg = [[plist objectForKey:identifier] objectAtIndex:7];
        BOOL isSID = YES;
        if([fgg integerValue] ==1 ) {
            isSID = YES;
        } else {
            isSID = NO;
        }
        
        /*
        
        if([self pingHost:address]) {
            ////////NSLog(@"host reachble");
        } else {
            //////NSLog(@"host not reachble");

        }
         
         */
        
        //SERVICE_NAME
        NSString *connectionString;
        
        if(isSID) {
             connectionString = [NSString stringWithFormat:@"(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=%@)(PORT=%@)))(CONNECT_DATA=(SID=%@)))", address, port, sid];

        }else {
            connectionString = [NSString stringWithFormat:@"(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=%@)(PORT=%@)))(CONNECT_DATA=(SERVICE_NAME=%@)))", address, port, sid];

        }
        
        
            
        OCI_Connection *cn;
        OCI_Statement *st;
        OCI_Resultset *rs;
        
        OCI_EnableWarnings(TRUE);
        
        ////////NSLog(@"MODE %u", OCI_GetImportMode());
        //////NSLog(@"RV %u", OCI_GetOCIRuntimeVersion());
        //////NSLog(@"CV %u", OCI_GetOCICompileVersion());
        
        
        //select username from dba_users
        
        
        /* init OCILIB */
        if (OCI_Initialize(error, NULL, OCI_ENV_DEFAULT))
        {
            //OCI_SESSION_SYSDBA
            cn = OCI_ConnectionCreate([connectionString UTF8String], [username UTF8String], [password UTF8String],OCI_SESSION_DEFAULT);
            
            if (cn)
            {
                st = OCI_StatementCreate(cn);
                //////NSLog(@"Connection ok" );
                
                /// getting info tables, views, types, functions , procedures, indexes
                
                OCI_ExecuteStmt(st, "select * from user_objects ");
                
                rs = OCI_GetResultset(st);
                NSMutableArray *arrayTables = [NSMutableArray arrayWithObjects:nil];
                NSMutableArray *arrayTViews = [NSMutableArray arrayWithObjects:nil];
                NSMutableArray *arrayViews = [NSMutableArray arrayWithObjects:nil];
                NSMutableArray *arrayFuncs = [NSMutableArray arrayWithObjects:nil];
                NSMutableArray *arrayIndexes = [NSMutableArray arrayWithObjects:nil];
                
                while (OCI_FetchNext(rs))
                {
                    //printf("name %s\n", OCI_GetString(rs, 1));
                    NSString *objName = [NSString stringWithFormat:@"%s", OCI_GetString(rs, 1)];
                    NSString *objType = [NSString stringWithFormat:@"%s", OCI_GetString(rs, 5)];
                    NSString *objStatus = [NSString stringWithFormat:@"%s", OCI_GetString(rs, 9)];
                    NSString *objCreated = [NSString stringWithFormat:@"%s", OCI_GetString(rs, 6)];
                    NSString *objDDL = [NSString stringWithFormat:@"%s", OCI_GetString(rs, 7)];
                    
                    //add props
                    NSMutableDictionary *props = [[NSMutableDictionary alloc] init];
                    [props setObject:objStatus forKey:@"STATUS"];
                    [props setObject:objCreated forKey:@"DATECREATED"];
                    [props setObject:objDDL forKey:@"LASTDDL"];
                    
                    [objProps setObject:props forKey:objName];
                    
                    
                    if([objType isEqualToString:@"TABLE"]) {
                        SourceListItem *item = [SourceListItem itemWithTitle:objName identifier:objName type:@"table" ];
                        [item setIcon:[NSImage imageNamed:@"table"]];
                        
                        [arrayTables addObject:item];
                        
                      
                        

                    } else if([objType isEqualToString:@"VIEW"]) {
                        SourceListItem *item = [SourceListItem itemWithTitle:objName identifier:objName type:@"view" ];
                        [item setIcon:[NSImage imageNamed:@"view"]];
                        
                        [arrayTViews addObject:item];

                    } else if([objType isEqualToString:@"INDEX"]) {
                        SourceListItem *item = [SourceListItem itemWithTitle:objName identifier:objName type:@"index" ];
                        [item setIcon:[NSImage imageNamed:@"category"]];
                        
                        [arrayIndexes addObject:item];
                        
                    } else if([objType isEqualToString:@"TYPE"]) {
                        SourceListItem *item = [SourceListItem itemWithTitle:objName identifier:objName type:@"type" ];
                        [item setIcon:[NSImage imageNamed:@"block"]];
                        
                        [typesList addObject:objName];
                        
                        [arrayViews addObject:item];
                        
                    } else if([objType isEqualToString:@"FUNCTION"]) {
                        SourceListItem *item = [SourceListItem itemWithTitle:objName identifier:objName type:@"procedure" ];
                        [item setIcon:[NSImage imageNamed:@"fnodc"]];
                        
                        [arrayFuncs addObject:item];
                        
                    }

                    
                }
                
                OCI_ExecuteStmt(st, "select username from all_users");
                
                rs = OCI_GetResultset(st);
                
                NSMutableArray *arrayUsers = [NSMutableArray arrayWithObjects:nil];
                
                while (OCI_FetchNext(rs))
                {
                    //printf("name %s\n", OCI_GetString(rs, 1));
                    NSString *user = [NSString stringWithUTF8String:OCI_GetString(rs, 1)];

                    [arrayUsers addObject:user];
                }
                
                
                st = OCI_StatementCreate(cn);
                OCI_ExecuteStmt(st, "SELECT SYS_CONTEXT ('USERENV', 'SESSION_USER') FROM DUAL");
                
                rs = OCI_GetResultset(st);
                
                NSString *username;

                while (OCI_FetchNext(rs))
                {
                    //printf("name %s\n", OCI_GetString(rs, 1));
                    username = [NSString stringWithUTF8String:OCI_GetString(rs, 1)];
                    
                    //[arrayUsers addObject:user];
                }
                
                
                
                /// plsql version
                /*
                
                const dtext *p;
                
                OCI_ServerEnableOutput(cn, 32000, 5, 255);
                
                OCI_ExecuteStmt(st, "begin "
                                "dbms_output.put_line(user); "
                                    "end;"
                                    );
                
                p = OCI_ServerGetOutput(cn);
                NSString *username = [NSString stringWithUTF8String:p];
            
                ////NSLog(@"user %@", username);
                
                
                
                */
                              
                OCI_StatementFree(st);
                
                Connection *conn = [[Connection alloc] init];
                [conn addTables:arrayTables];
                [conn addViews:arrayTViews];
                [conn addTypes:arrayViews];
                [conn addIndexes:arrayIndexes];
                [conn addFunctions:arrayFuncs];
                [conn addUsers:arrayUsers];
                conn->originalUsername = username;
                
                
                ////NSLog(@"user %@", conn->originalUsername);
                
                //NSMenuItem* mi = [[NSMenuItem alloc] initWithTitle:connName action:nil keyEquivalent:@""];
                
                ConnectionManager *cm = [ConnectionManager sharedManager];
                cm->cnarray[cm->count] = cn;
            
                conn->cnid = cm->count;
                //[mi setTag:cm->count];
                
                cm->count++;
                
            
                
                
                //[mi setTarget:self];
                
                
                //[[connbutton menu]addItem:mi];
                //[connbutton selectItemWithTag:mi.tag];
               // [connbutton selectItemWithTitle:mi.title];
                //Open query view
                
                
                
                NSString *qName2 = [NSString stringWithFormat:@"%@%d", connName, 1];
                
                
                //////NSLog(@"saving name %@ for conn %@",qName2, connName);
                [[[connections valueForKey:connName] qNames ]addObject:qName2];
                
                
                [conn setCID:identifier];

                [connections setValue:conn forKey:connName];

                [[viewcontroller view] removeFromSuperview];
                
                NSViewController *vc = [[QueryController alloc] initWithNibName:@"QueryController" bundle:nil];
                
                self.viewcontroller = vc;
                [conn addQView:vc forID:qName2];

                
                [mainview addSubview:[viewcontroller view]];
                [[viewcontroller view] setFrame:[mainview bounds]];
                [[viewcontroller view] setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];

                
                

                mode = @"query";
                
                [_cnButt setEnabled:YES];
                //[_cnButt setHidden:NO];
                [_cnButt setTitle:connName];

                
                [self loadSourceList];
                [self showToolbarButtons];
                

                [_cnButt setTitle:connName];

                
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
                [sourceList selectRowIndexes:indexSet byExtendingSelection:NO];
                [sourceList expandItem:[sourceList itemAtRow:0]];

                return OCI_GetVersionConnection(cn);

            }
            
            
        }
    }
    return 0;

}

- (IBAction)emableDBMS:(id)sender {
    
    OCI_Connection *cn;
    
    ConnectionManager *cm = [ConnectionManager sharedManager];
    NSString *cname = [_cnButt title];
    int cnid = [[connections objectForKey:cname] getCNID];
    
    cn = cm->cnarray[cnid];

    if([_dbmsButton state] == 0) {
        [_dbmsButton setToolTip:@"Enable DBMS Output"];
        
        if(cn) {
            OCI_ServerDisableOutput(cn);
        }


    } else {
        [_dbmsButton setToolTip:@"Disable DBMS Output"];
        
        [_logSwitch setHidden:NO];
        
        
        if(cn) {
            OCI_ServerEnableOutput(cn, 32000, 5, 255);
        }
        
        
        if([_bottomLogView isHidden]) {
            [_bottomLogView setHidden:NO];
            
            [mainSplitView
             setPosition:450 //if todo
             ofDividerAtIndex:0
             ];
        }
        
        
        [_logSwitch selectSegmentWithTag:1];
        [_logTabView selectTabViewItemAtIndex:1];


    }

}


//double cliect event
- (void)doubleClick:(id)object {
    

   	NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];
    NSString *atype = [[sourceList itemAtRow:[selectedIndexes firstIndex]] atype];
    

    if([atype isEqualToString:@"table"])
    {
        mode = @"table";

        //table


    }
    else if([atype isEqualToString:@"connection"]) {
        //connection
        mode = @"connection";
        //    [self connect]; TODO
        
    }
    else if([atype isEqualToString:@"query"]){
        //
        mode = @"query";

    }

}

-(NSMutableArray*)getTempTableColumns:(NSString*)tableName {
    NSString *currentConnName = [_cnButt title];
    NSMutableArray *rt = [[NSMutableArray alloc]init];

    Connection *cnn = [connections valueForKey:currentConnName];
    NSMutableDictionary *dc = [cnn getTempObjects];
    
    for(id key in dc) {
        
        NOTempObject *to = [dc objectForKey:key];
        
        //////NSLog(@"got object %@", to.name);
        
        for(id obj in to.cols) {
            NOTempObject *ts = obj;
            
            //////NSLog(@"obj %@ propertie %@", to.name, ts.name );
           // //////NSLog(@"obj %@ propertie %@", to.name, ts.size );

            NSNumber *colSz = [NSNumber numberWithLong:ts.size];
            
            NSDictionary *obj;
            
            
            if(ts.isNULL) {
                obj = @{@"CID": ts.cid,@"ColName": ts.name,
                                      @"DataType": ts.type ,@"ColSize": colSz, @"Nullable": @"YES"};
                
            } else {
                obj = @{@"CID": ts.cid,@"ColName": ts.name,
                                      @"DataType": ts.type ,@"ColSize": colSz, @"Nullable": @"NO"};

            }
            
            [rt addObject:obj];
        }
        

        
    }
    
    return rt;

    
}

- ( void ) windowWillClose : ( NSNotification * ) ANotification {
    [ NSApp terminate : self ] ;
}

-(void)addNewTable:(NSString*)tableName {
    
    NSString *currentConnName = [_cnButt title];
    //NSString *tableName = @"NewTable";
    NSMutableArray *arr = [[connections valueForKey:currentConnName] getTables];
    
    SourceListItem *item = [SourceListItem itemWithTitle:tableName identifier:tableName type:@"table" ];
    [item setIcon:[NSImage imageNamed:@"table-draw"]];
    
    [arr addObject:item];
    [[connections valueForKey:currentConnName] addTables:arr];
    
    //add temp object
    
    NOTempObject  *table = [[NOTempObject alloc]init];
    table.name =tableName;
    table.kind = @"table";
    table.type = @"NORMAL";
    
  
    NSString *uuidString = [[NSUUID UUID] UUIDString];
    
    
    
    NOTempObject *col = [[NOTempObject alloc]init];
    
    col.name = @"COLUMN1";
    col.type = @"VARCHAR2";
    col.size = 30;
    col.cid = uuidString;
    col.isNULL = YES;
    
    
    table.cols = [[NSMutableArray alloc] init];

    [[table cols] addObject:col];
    
    Connection *cnn = [connections valueForKey:currentConnName];
    NSMutableDictionary *dc = [cnn getTempObjects];
    [dc setValue:table forKey:tableName];
    
    //////NSLog(@"ADDed table name %@", tableName);
    
    [self loadSourceList];
    //NSString *currentConnName = [_cnButt title];

    //select table with name
    int rowToSelect = -1;
    int count = 0;
    for( SourceListItem *item in [[connections objectForKey:currentConnName] getTables] )
    {
        count++;
        if([[item title] isEqualToString:tableName]) {
            rowToSelect = count;
        }
    }
    
    [sourceList selectRowIndexes:[NSIndexSet indexSetWithIndex:rowToSelect] byExtendingSelection:NO];

    
}

-(NSMutableArray*)getTempColNames:(NSString*)tableName {
    
    NSString *currentConnName = [_cnButt title];

    Connection *cnn = [connections valueForKey:currentConnName];
    NSMutableDictionary *dc = [cnn getTempObjects];

    NOTempObject  *table = [dc valueForKey:tableName];
    
    NSMutableArray *names = [[NSMutableArray alloc] init];
    
    for(NOTempObject *tobj in table.cols) {
        [names addObject:tobj.name];
    }
    
    return names;
}

- (void)PassAlertDidEnd:(NSAlert *)alert
                returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
    ////NSLog (@"Button %d clicked",returnCode);
}

-(IBAction)changeEnv:(id)sender {
    
    NSString *cnametoChange = [sender title];
    NSString *cname = [_cnButt title];
    NSString *pass;
    
    for(NSString *aKey in [plist allKeys]) {
        NSString *sname = [[plist objectForKey:aKey] objectAtIndex:1];
        if([sname isEqualToString:cnametoChange]) {
            pass = [[plist objectForKey:aKey] objectAtIndex:5];
        }
    }

    
    ////NSLog(@"passwd : %@", pass);
    ////NSLog(@"cname : %@", pass);
    
    if([pass length] == 0 ) {
        //alert
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"No password"];
        [alert setInformativeText:@"Password not provided"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert beginSheetModalForWindow:[[NSApplication sharedApplication] keyWindow]
                          modalDelegate:self
         
                         didEndSelector:@selector(PassAlertDidEnd:returnCode:
                                                  contextInfo:)
                            contextInfo:nil];
        
        

    } else {
        //save mode fff
        ////NSLog(@"saving mode %@ ", mode);
        Connection *cn = [connections objectForKey:cname];
        
        cn->viewMode = mode;
        
        
        mode = @"connection";
        [self loadSourceList];
        
        int newC = 1;
        int cCount = 1;
        
        NSString *idf;
        
        for( SourceListItem * item in [[sourceListItems objectAtIndex:0] children])
        {
            
            //NSArray * ch = [item children];
            
            NSString *sname = [item title] ;     // [[plist objectForKey:aKey] objectAtIndex:1];
            
            //  ////NSLog(@" sname %@ cname %@" , sname , cnName);
            
            if([sname isEqualToString:cnametoChange]) {
                newC = cCount;
                idf = [item identifier];
                
            }
            cCount++;
            
        }
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:newC];
        [sourceList selectRowIndexes:indexSet byExtendingSelection:NO];
        
        
        
        //    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
        //  [sourceList selectRowIndexes:indexSet byExtendingSelection:NO];
        
        [self connect:pass];
        
        [connectionViews removeObjectForKey:idf]; //

    }
    

}


-(IBAction)changeUser:(id)sender {

    NSString *cname = [_cnButt title];
    Connection *cn = [connections valueForKey:cname];

    
//    ////NSLog(@"change user %@ ", [sender title]);
    if([[sender title] isEqualToString:cn->originalUsername]) { //check original username todo
        cn->actualUsername = @"";
    } else {
        cn->actualUsername = [sender title];

    }
    
    [QsavedSelectedRows removeObjectForKey:cname];
    [TsavedSelectedRows removeObjectForKey:cname];
    [PsavedSelectedRows removeObjectForKey:cname];
    [IsavedSelectedRows removeObjectForKey:cname];
    [FsavedSelectedRows removeObjectForKey:cname];
    [VsavedSelectedRows removeObjectForKey:cname];

    
    
    [self refreshAction:nil];
    
    
    //[self reload:identifier mode:@"query"];
}

- (IBAction)sqlButtAction:(id)sender {
    
    NSMenu * m = [[NSMenu alloc] init];
    NSString *connString;
    
    Connection *nconn = [connections valueForKey:[_cnButt title]];
    
    
    // if(![nconn->actualUsername length] > 0) {
    

    
    
    if(![nconn->actualUsername length] > 0) {
        connString = [NSString stringWithFormat:@"Connected as %@" ,nconn->originalUsername ]; //TODO username
    } else {
        connString = [NSString stringWithFormat:@"Connected as %@" , nconn->actualUsername ];

    }
    [m addItemWithTitle:connString action:@selector(:) keyEquivalent:@""];


    
        NSMenu *submenu = [[NSMenu alloc] init];
    
    for(NSString *username in [[connections objectForKey:[_cnButt title]] getUsers]) {
        [submenu addItemWithTitle:username action:@selector(changeUser:) keyEquivalent:@""];
        
    }
    
    
    NSMenuItem *swuser = [[NSMenuItem alloc] init];
    [swuser setTitle:@"Change user"];
    [swuser setSubmenu:submenu];
    
    [m addItem:swuser];
    
    if([mode isEqualToString:@"connection"]) {
        [m addItemWithTitle:@"Open connection" action:@selector(deepin:) keyEquivalent:@""];
    } else {
        [m addItemWithTitle:@"Show all connections" action:@selector(deepin:) keyEquivalent:@""];
    }
    
    
    [m addItem:[NSMenuItem separatorItem]];
    
    
    /*
    
    if([mode isEqualToString:@"table"]) {
        [m addItemWithTitle:@"Add new table" action:@selector(addNewTable:) keyEquivalent:@""];
    } else {
        [m addItemWithTitle:@"Add new connections" action:@selector(deepin:) keyEquivalent:@""];
    }
    [m addItem:[NSMenuItem separatorItem]];

    */

    [m addItemWithTitle:@"Database settings" action:@selector(:) keyEquivalent:@""];
    //[m addItemWithTitle:@"Backup database" action:@selector(:) keyEquivalent:@""];
    [m addItemWithTitle:@"Reset password" action:@selector(resetPassView:) keyEquivalent:@""];
    [m addItemWithTitle:@"Connection information" action:@selector(:) keyEquivalent:@""];
    [m addItem:[NSMenuItem separatorItem]];

    NSMenu *submenu1 = [[NSMenu alloc] init];
    
    for(NSString *aKey in [plist allKeys]) {
        NSString *sname = [[plist objectForKey:aKey] objectAtIndex:1];

        [submenu1 addItemWithTitle:sname action:@selector(changeEnv:) keyEquivalent:@""];
        
    }

    
    NSMenuItem *swuser1 = [[NSMenuItem alloc] init];
    [swuser1 setTitle:@"Switch connection"];
    [swuser1 setSubmenu:submenu1];
    
    [m addItem:swuser1];

    
    [m addItemWithTitle:@"Disconnect" action:@selector(disconnectFM:) keyEquivalent:@""];

    
    [NSMenu popUpContextMenu:m withEvent:[[NSApplication sharedApplication] currentEvent] forView:(NSButton *)sender];

}
-(IBAction)deepin:(id)sender { //
    NSString *cname = [_cnButt title];

    if([mode isEqualToString:@"connection"]) {
        
        Connection *cn = [connections objectForKey:cname];
        ////NSLog(@"restoring  mode %@ ", mode);
        
        if([mode length] == 0) {
            mode = @"query";
        } else {
            mode = cn->viewMode;

        }
        
        
        [_cnButt setTitle:cname];
        
        [self showToolbarButtons];
        
        [self loadSourceList];
        
        int cCount = 0;
        int newC = -1;
        
        /*
        for( NSString *aKey in plist )
        {
            
            cCount++;
            NSString *sname = [[plist objectForKey:aKey] objectAtIndex:1];
            
            if([sname isEqualToString:cname]) {
                newC = cCount;

            }
        }
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:newC];
        [sourceList selectRowIndexes:indexSet byExtendingSelection:NO];

        */
        //[self selectSourceListItemByName:cname];

        
    } else {
        
        //save mode fff
        ////NSLog(@"saving mode %@ ", mode);
        Connection *cn = [connections objectForKey:cname];

        cn->viewMode = mode;
        
        mode = @"connection";
        
        [_cnButt setEnabled:NO];
        [_cnButt setTitle:@""];
        
        
        [self showToolbarButtons];
        
        [self loadSourceList];
        
        int cCount = 0;
        int newC = -1;
        
       // sourceListItems
        
        for( SourceListItem * item in [[sourceListItems objectAtIndex:0] children])
        {
            
            cCount++;
            //NSArray * ch = [item children];
            
            NSString *sname = [item title] ;     // [[plist objectForKey:aKey] objectAtIndex:1];
            
            //////NSLog(@" sname %@ cname %@" , sname , cname);
            
            if([sname isEqualToString:cname]) {
                newC = cCount;

            }
        }
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:newC];
        [sourceList selectRowIndexes:indexSet byExtendingSelection:NO];

        
    }
        
    
        

}

///// DATABASE ACTION METHODS

/*

-(OCI_Resultset*)runQuery:(NSString*)query {
    
    printf("Using connection version : %i\n\n", OCI_GetVersionConnection(cn));
    
    
    OCI_Statement *st = OCI_StatementCreate(cn);

 
    OCI_ExecuteStmt(st,[query UTF8String]);
    
    OCI_Resultset *rs = OCI_GetResultset(st);

    return rs;
}
 
 */



- (IBAction)refreshAction:(id)sender {
    
    [_refreshButton setEnabled:NO];
    
    NSString *tname = selectedItem;
    
    NSString *identifier = [_cnButt title];
    
    [self reload:identifier mode:mode];
    
    
    [self selectSidebarItem:tname];
    
    [_refreshButton setEnabled:YES];

    
}


- (int)executeUpdate:(NSString*)query {
    
    OCI_Connection *cn;
        
    ConnectionManager *cm = [ConnectionManager sharedManager];
    
    NSString *cname = [_cnButt title];
    
    int cnid = [[connections objectForKey:cname] getCNID];
    
    cn = cm->cnarray[cnid];

    

    OCI_Statement  *st;
    
    if (OCI_Initialize(NULL, NULL, OCI_ENV_DEFAULT)) {
        
        if(OCI_IsConnected(cn)) {
            
            st = OCI_StatementCreate(cn);
            
            /* prepare and execute in 2 steps */
            
            OCI_Prepare(st, [query UTF8String]);
            
            //toto check
            int success = OCI_Execute(st);
            
            /* prepare/execute in 1 step */
            
            // OCI_ExecuteStmt(st, "delete from test_fetch where code > 1");
            
            //printf("%d row updated", OCI_GetAffectedRows(st));
            
            OCI_Commit(cn);
            
            
            return success;

        }
        
    } else {
        return 0;
    }
        
}

-(BOOL)ifObjectInTemp:(NSString*)objName {
    
    Connection *cnn = [connections valueForKey:[_cnButt title]];
    NSMutableDictionary *dc = [cnn getTempObjects];

    if ([[dc allKeys] containsObject:objName]) {
        //temp table
        //////NSLog(@"temp obj");
        return YES;
    }
        //////NSLog(@"schema ");
    
    return NO;

}
            


-(void)insertColumn:(NOTempObject*)col {
    //////NSLog(col.name);
    
    NSString *tn = selectedItem;
    
    
    Connection *cnn = [connections valueForKey:[_cnButt title]];
    NSMutableDictionary *dc = [cnn getTempObjects];
    if ([[dc allKeys] containsObject:tn]) {
        //temp table
        //////NSLog(@"temp table");
        
        BOOL added = NO;
        
        //check if column exist
        
        for (int i = 0; i < [[[dc valueForKey:tn] cols] count]; i++) {
           // printf("%i\n", i);
            NOTempObject *to = [[[dc valueForKey:tn] cols] objectAtIndex:i];
            
           // //////NSLog(@"TEMP OBJECTS ======");

            //////NSLog(col.cid);
            
            
            
            if([to.cid isEqualToString:col.cid]) {
                
                //////NSLog(@"REPLACING OBJECT ======");
                


                [[[dc valueForKey:tn] cols ]replaceObjectAtIndex:i withObject:col];
                added = YES;
            }
        }
       
        
        if(!added) {
            //////NSLog(@"ADDING OBJECT ======");
            
            [[[dc valueForKey:tn] cols ]addObject:col];

        }
        

        

    }
    else {
        //table in schema
        //////NSLog(@"schema table set column %@ ", col.name);
        
        //if new - add, if exist - modify
        
        BOOL isTemp = NO;
        
        /* exp */
        
        for (NSString* key in [[cnn getTempObjects] allKeys]) {
            NOTempObject *to = [[cnn getTempObjects] objectForKey:key];
            // do stuff
            
            //////NSLog(@"Comparing [][][] cid's  =========");
            //////NSLog(@" 1:%@ ,2:%@", col.cid , to.cid);
            
            
            if([to.cid isEqualToString:col.cid]) { //equal cid
                //////NSLog(@"!!!! %@  is in temp array ", col.name);
                
                
                //temp
                [dc setValue:col forKey:col.cid]; //mutated while itarate
                isTemp = YES;
                
            }

        }
        
        


        
        if(col.isTEMP) {
            //new
            //create temp object
            //////NSLog(@" %@  is temp ", col.name);

            [dc setValue:col forKey:col.cid];

        } else {
            //exist
            //only modifying and removing
            //TO_DO - check for mods before remove
            
            BOOL added = NO;

            
            for (int i = 0; i < [[cnn getObjectsToModify] count]; i++) {
              //  printf("%i\n", i);
                NOTempObject *to = [[cnn getObjectsToModify] objectAtIndex:i];
                
                //////NSLog(@"Comparing cid's  =========");
                //////NSLog(@" 1:%@ ,2:%@", col.cid , to.cid);

                
                if([to.cid isEqualToString:col.cid]) { //equal cid
                    
                    //inherit properties from prev. rev
                    if(to.gotSize) {
                        col.gotSize = YES;
                    }
                    
                    if(to.gotType) {
                        col.gotType = YES;
                    }
                    
                    if(to.originalState == 0) {
                        //first time call
                        if(to.isNULL) {
                            col.originalState = 1;
                        } else {
                            col.originalState = -1;
                            
                        }
                    }
                    
                    //if(to.isNULL) {

                      //  col.gotType = YES;
                    //}
                    
                    if(to.gotOriginalName) {
                        col.gotOriginalName = YES;
                        col.originalname = to.originalname;
                        //////NSLog(@"already got name %@", to.originalname);

                    }
                    
                   // col.gotOriginalName = to.gotOriginalName;
                    
                    
                                       
                    //////NSLog(@"REPLACING OBJECT IN MOD ARRAY ======");
                    

                    
                    
                    if([to.name isEqualToString:col.name]) { //equal name
                        //////NSLog(@"Same name"); //adding object
                      //  [[[dc valueForKey:tn] cols ]replaceObjectAtIndex:i withObject:col];
                        
                    } else {
                        
                        
                        //////NSLog(@"Object renamed, saving original name"); //lazy to think right now TO_DO_CHECK
                        if(to.gotOriginalName) {
                            //col.gotOriginalName = YES;
                            //col.originalname = to.originalname;
                        } else {
                            //////NSLog(@"Old name: %@ New name:%@", to.name, col.name);
                            col.originalname = to.name;
                            col.gotOriginalName = YES;
                        }
                        

                      //  [[[dc valueForKey:tn] cols ]addObject:col];
                        
                        
                    }
                    
                     [[cnn getObjectsToModify] replaceObjectAtIndex:i  withObject:col];
                    added = YES;
                }
                
            }
            
            //adding object to mods 
            if(!added) {
                if(!isTemp) {
                    //////NSLog(@"ADDING OBJECT TO MOD ARRAY ====== CID:%@", col.cid);
                    [cnn addObjectToModify:col];

                }
                
                
            }

        
        }
        
                
    
        
             
        
        
        ///////////
        
        

     //   [dc setValue:col forKey:col.name];
        [cnn addTempObjects:dc];

        //TO_DO
    }
    
    
}


///////DB ACTIONS

-(void)performModificationForTempObjects {
    
    //////NSLog(@"Modification objects called");
    Connection *cnn = [connections valueForKey:[_cnButt title]];
    NSMutableArray *objToMod = [cnn getObjectsToModify];
    NSMutableArray *objToDrop = [cnn getObjectsToDrop];
    
    for (id object in objToMod) {
        NOTempObject *to = object;
        //////NSLog(@"object to mod %@", to.name);
        
        for (id dropObj in objToDrop) {
            NOTempObject *td = dropObj;

            if([to.cid isEqualToString:td.cid]) {
                //skip object
                goto outer; 
            }
        }

        if([to.kind isEqualToString:@"table"]) {
           // NSString *query = [NSString stringWithFormat:@"DROP %@ %@", to.type, to.name];
            
            //[self executeUpdate:query];
            
        }
        else if([to.kind isEqualToString:@"column"]) {
            
            //check if table not in drop list
            
            //[cnn getObjectsToDrop]


            
            if(to.gotOriginalName) {
                //need to be renamed
                NSString *query = [NSString stringWithFormat:@"ALTER TABLE %@ RENAME COLUMN %@ TO %@", to.parent, to.originalname, to.name];
                [self executeUpdate:query];
                //////NSLog(@"renamed %@", to.originalname);

                
            }
            
            
            //check if not init
            if(![to.action isEqualToString:@"init"]) {
                //////NSLog(@"ALTERING PROPERTIES FOR COLUMN %@", to.name);
                //////NSLog(@"ACTION %@", to.action);
                
                //ALTER TABLE NEWTABLE MODIFY (COLUMN4 NOT NULL);

                
                if(to.gotType) {
                    if(to.gotSize) {
                        if(to.isNULL) {
                            //////NSLog(@"size and type and null PROPERTIES ChANGE FOR COLUMN %@", to.name);

                        } else {
                            //////NSLog(@"size and type PROPERTIES ChANGE FOR COLUMN %@", to.name);

                        }

                    }
                    else {
                        if(to.isNULL) {
                            //////NSLog(@" type and null PROPERTIES ChANGE FOR COLUMN %@", to.name);

                            
                        } else {
                            //////NSLog(@" type PROPERTIES ChANGE FOR COLUMN %@", to.name);

                            
                        }
                        
                        NSString *query = [NSString stringWithFormat:@" ALTER TABLE %@ MODIFY (%@ %@ )", to.parent, to.name ,to.type];
                        [self executeUpdate:query];

                        
                    }
                } else {
                    if(to.gotSize) {
                        if(to.isNULL) {
                            //////NSLog(@"size adn null PROPERTIES ChANGE FOR COLUMN %@", to.name);

                            
                        } else {
                            //////NSLog(@"size PROPERTIES ChANGE FOR COLUMN %@", to.name);

                        }
                        
                    }
                    else {
                        //none above
                        if(to.isNULL) {
                            //////NSLog(@"just enable null PROPERTIE  FOR COLUMN %@", to.name);
                            
                            if(to.originalState == 1 || to.originalState == 0) {
                                //////NSLog(@"col  %@ original state is 1 - perform", to.name);
                                //ALTER TABLE NEWTABLE MODIFY (NAME NOT NULL);
                                NSString *query = [NSString stringWithFormat:@" ALTER TABLE %@ MODIFY (%@ NULL)", to.parent, to.name];
                                [self executeUpdate:query];

                            }
                            


                        } else {
                            //////NSLog(@"just disble null PROPERTIE  FOR COLUMN %@", to.name);
                            
                            if(to.originalState == -1 || to.originalState == 0) {
                                //////NSLog(@"col  %@ original state is -1 perform", to.name);
                                //ALTER TABLE NEWTABLE MODIFY (NAME NOT NULL);
                                NSString *query = [NSString stringWithFormat:@" ALTER TABLE %@ MODIFY (%@ NOT NULL)", to.parent, to.name];
                                [self executeUpdate:query];
                                
                            }
                            //ALTER TABLE NEWTABLE MODIFY (NAME NOT NULL);
                            //[self executeUpdate:query];

                        }
                        
                    }
                }
                
                /*
                
                if(to.isPrimaryKey) {
                    //////NSLog(@"jSetting PK FOR COLUMN %@", to.name);
                    NSString *pkName = [NSString stringWithFormat:@"%@_PK" , to.parent];

                    
                    //drop current pk
                    
                    //alter new pk


                    NSString *query = [NSString stringWithFormat:@" ALTER TABLE %@ ADD CONSTRAINT %@ PRIMARY KEY (%@) ENABLE", to.parent,pkName, to.name];
                    
                    [self executeUpdate:query];

                    
                }
                */

                
                
                
            } else {
                //////NSLog(@"NO PROPERTIES ChANGE FOR COLUMN %@", to.name);
                
            }
            
                        
            
                    
            
        }
        outer:;

    
    }
    
    [cnn purgeObjectsToModify];
    
    
    
}

-(NSArray*)getScemaTableNames:(NSString*)cName {
    
    //////NSLog(@"Getting tables for %@" ,cName);

    NSMutableArray *ar = [[NSMutableArray alloc]init];
    
    for( SourceListItem *item in [[connections objectForKey:cName] getTables] )
    {
       // //////NSLog(@"Key word added fd %@" , [item title]);

        [ar addObject:[item title]];
    }
    
    return ar;
    
}


-(void)dropObjectsToRemove {
    
    //////NSLog(@"Dropping objects called");
    Connection *cnn = [connections valueForKey:[_cnButt title]];
    NSMutableArray *objToDrop = [cnn getObjectsToDrop];
    

    
    
    for (id object in objToDrop) {
        NOTempObject *to = object;
        //////NSLog(@"object %@", to.name);
        
        //check if objects mods are exist and remove
        
        for (int i = 0; i < [[cnn getObjectsToModify] count]; i++) {
         //   printf("%i\n", i);
            NOTempObject *tm = [[cnn getObjectsToModify] objectAtIndex:i];
            
            //////NSLog(@"Comparing cid's  =========");
            //////NSLog(@" 1:%@ ,2:%@", tm.cid , to.cid);
            
            if(tm.cid == to.cid) {
                


                //////NSLog(@"object %@ got mods, they ll be removed", to.name);
                [[cnn getObjectsToModify] removeObjectAtIndex:i];
                
            }
            
        }
        //checking temp objects TO_DO
        
        /*
        
        for (int i = 0; i < [[cnn getObjectsToModify] count]; i++) {
            printf("%i\n", i);
            NOTempObject *tm = [[cnn getObjectsToModify] objectAtIndex:i];
            
            //////NSLog(@"Comparing cid's  =========");
            //////NSLog(@" 1:%@ ,2:%@", tm.cid , to.cid);
            
            if(tm.cid == to.cid) {
                
         
                
                //////NSLog(@"object %@ got mods, they ll be removed", to.name);
                [[cnn getObjectsToModify] removeObjectAtIndex:i];
                
            }
            
        }
        */
        

        if([to.kind isEqualToString:@"table"]) {
            NSString *query = [NSString stringWithFormat:@"DROP %@ %@", to.type, to.name];
            
            [self executeUpdate:query];

        }
        else if([to.kind isEqualToString:@"column"]) {
            NSString *query = [NSString stringWithFormat:@"ALTER TABLE %@ DROP %@ %@", to.parent, to.type, to.name];
            
            [self executeUpdate:query];
            

        }
        //[self performSelectorInBackground:@selector(executeUpdate:) withObject:query];

    }
    
    /* column
     
     ALTER TABLE DEPT
     DROP COLUMN COLUMN1;
     
     */
    
    [cnn purgeObjectsToDrop];

    
    
}
- (IBAction)disconnectFM:(id)sender {
    
    
    NSString *cnName = [_cnButt title];
    
    ////NSLog(@"disconnecting from %@ ", [_cnButt title]);

    
   // [connectionViews removeObjectForKey:[_cnButt title]];
    
    for( NSString *aKey in plist )
    {
        NSString *sname = [[plist objectForKey:aKey] objectAtIndex:1];
        if([sname isEqualToString:[_cnButt title]]) {
            [connectionViews removeObjectForKey:aKey];
          
        }
    }
    [self disconnect:cnName];
    
    mode = @"connection";
    [self showToolbarButtons];
    [self loadSourceList];
    
    
    
    int cCount = 0;
    int newC = -1;
    
    // sourceListItems
    
    for( SourceListItem * item in [[sourceListItems objectAtIndex:0] children])
    {
        
        cCount++;
        //NSArray * ch = [item children];
        
        NSString *sname = [item title] ;     // [[plist objectForKey:aKey] objectAtIndex:1];
        
      //  ////NSLog(@" sname %@ cname %@" , sname , cnName);
        
        if([sname isEqualToString:cnName]) {
            newC = cCount;
            
        }
    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:newC];
    [sourceList selectRowIndexes:indexSet byExtendingSelection:NO];
    
    
   
    
}

-(void)selectSourceListItemByName:(NSString*)name {
    
    //select table with name
    int rowToSelect = -1;
    int count = 0;
    
    if([mode isEqualToString:@"connection"]) {
        for( NSString *aKey in plist )
        {
            count++;
            NSString *title = [[plist objectForKey:aKey] objectAtIndex:1];
            
            if([title isEqualToString:name]) {
                rowToSelect = count;
                
              //  ////NSLog(@"row to count %ld ", rowToSelect);
            }
        }
 
    } else {
        //todo
    }
    
    
    [sourceList selectRowIndexes:[NSIndexSet indexSetWithIndex:rowToSelect] byExtendingSelection:NO];

}



- (int)disconnect:(NSString*)connName {
    //OCI_Cleanup();
    
    [_filterField setStringValue:@""];
    
    Connection *nconn = [connections valueForKey:connName];
    
    
    // if(![nconn->actualUsername length] > 0) {

    
    nconn->actualUsername = @"";
    
    ////NSLog(@"app del csid %@ ", connName);

    
    
    
    if(!connName) {
        connName = selectedItem;
    }

    [QsavedSelectedRows removeObjectForKey:connName];
    [TsavedSelectedRows removeObjectForKey:connName];
    [PsavedSelectedRows removeObjectForKey:connName];
    [IsavedSelectedRows removeObjectForKey:connName];
    [FsavedSelectedRows removeObjectForKey:connName];
    [VsavedSelectedRows removeObjectForKey:connName];

    
    
    
    [connections removeObjectForKey:connName];  //todo clean oci

    
   // [connbutton removeItemWithTitle:connName];
    
    
    [self loadSourceList];
    
    int cCount = 1;
    int newC = -1;

    
    for( SourceListItem * item in [[sourceListItems objectAtIndex:0] children])
    {
        
        //NSArray * ch = [item children];
        
        NSString *sname = [item title] ;     // [[plist objectForKey:aKey] objectAtIndex:1];
        
        //////NSLog(@" sname %@ cname %@" , sname , cname);
        
        if([sname isEqualToString:connName]) {
            newC = cCount;
            
        }
        cCount++;

    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:newC];
    [sourceList selectRowIndexes:indexSet byExtendingSelection:NO];
    
    
    return 1;
}



-(void)insertTempObjectsToDB {
    
    Connection *cnn = [connections valueForKey:[_cnButt title]];
    NSMutableDictionary *tempObj = [cnn getTempObjects];
    
    for(id key in tempObj) {
        
        NOTempObject *to = [tempObj objectForKey:key];
        
        //////NSLog(@"Inserting object %@ with cid: %@", to.name , to.cid);

        if([to.kind isEqualToString:@"table"]) { //tables
          //  //////NSLog(@"Inserting table %@", to.name);
            NSMutableString *colsString = [NSMutableString string];
            long count = [to.cols count] - 1;
          //  //////NSLog(@"Count %ld", count);

            NSMutableString* cols = [NSMutableString string];
            for (int i=0; i<=count;i++){
                NOColumn *col =[to.cols objectAtIndex:i];

                //////NSLog(@"Col %@", col.name);
                if(i == 0) {
                    if(col.isNULL) {
                        
                        //////NSLog(@"OBJECT NULLABLE");
                        [colsString appendString:[NSString stringWithFormat:@"%@ %@(%ld)",col.name, col.type, (long)col.size]];

                    } else {
                        
                        //////NSLog(@"OBJECT NOT NULLABLE");

                        [colsString appendString:[NSString stringWithFormat:@"%@ %@(%ld) NOT NULL",col.name, col.type, (long)col.size]];
                    }
                }
                else {
                    [colsString appendString:[NSString stringWithFormat:@", %@ %@(%ld)",col.name, col.type, (long)col.size]];

                }
            }
            
            NSString *query = [[NSString alloc] initWithFormat:@"CREATE TABLE %@ ( %@ )",to.name, colsString ];
            //////NSLog(@"====================================================================");

            //////NSLog(query);
            
            [self executeUpdate:query];
            //[self performSelectorInBackground:@selector(executeUpdate:) withObject:query];

            /*
             CREATE TABLE TABLE3
             (
             COLUMN1 VARCHAR2(20)
             , COLUMN2 VARCHAR2(20)
             );

             */
        }
        else if([to.kind isEqualToString:@"column"]) { //colums
            
            NSString *query;
            
            if(to.isNULL) {
                
                //ALTER TABLE NEWTABLE ADD (COLUMN4 VARCHAR2(20) NOT NULL);
            //    query = [[NSString alloc] initWithFormat:@"ALTER TABLE %@ ADD (%@ %@(%ld) NOT NULL)",to.parent, to.name, to.type,(long) to.size];
                query = [[NSString alloc] initWithFormat:@"ALTER TABLE %@ ADD ( %@ %@(%ld) )",to.parent, to.name, to.type,(long) to.size];


            } else {
                query = [[NSString alloc] initWithFormat:@"ALTER TABLE %@ ADD ( %@ %@(%ld)NOT NULL )",to.parent, to.name, to.type,(long) to.size];

            }
            
            
            [self executeUpdate:query];

                       
        }
        
    }
    
    [cnn purgeTempObjects];
    
}




#pragma mark -
#pragma mark Source List Data Source Methods

- (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item
{
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [sourceListItems count];
	}
	else {
		return [[item children] count];
	}
}


- (id)sourceList:(PXSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item
{
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [sourceListItems objectAtIndex:index];
	}
	else {
		return [[item children] objectAtIndex:index];
	}
}


- (id)sourceList:(PXSourceList*)aSourceList objectValueForItem:(id)item
{
	return [item title];
}


- (void)sourceList:(PXSourceList*)aSourceList setObjectValue:(id)object forItem:(id)item
{
	[item setTitle:object];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList isItemExpandable:(id)item
{
	return [item hasChildren];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasBadge:(id)item
{
	return [item hasBadge];
}


- (NSInteger)sourceList:(PXSourceList*)aSourceList badgeValueForItem:(id)item
{
	return [item badgeValue];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasIcon:(id)item
{
	return [item hasIcon];
}


- (NSImage*)sourceList:(PXSourceList*)aSourceList iconForItem:(id)item
{
	return [item icon];
}

-(void)removeColumn:(NOTempObject*)obj {
    
     
    Connection *cnn = [connections valueForKey:[_cnButt title]];
    

    //////NSLog(@"removeing object %@ , %@", obj.name, obj.cid);
    if([self ifObjectInTemp:obj.cid]) {
  //      //////NSLog(@" object %@ , %@ in temp", obj.name, obj.cid);

        
        //
        [[cnn getTempObjects] removeObjectForKey:obj.cid];
        
    } else {
//        //////NSLog(@" object %@ , %@ not found - drop", obj.name, obj.cid);

        [cnn addObjectToDrop:obj];

    }
    
    

}

- (IBAction) exportHTML:(id)sender {
    ////NSLog(@"html export");
}

- (IBAction) exportCSV:(id)sender {
    ////NSLog(@"csv export");
}

- (IBAction) addObjectToDrop:(id)sender {
    
    NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];
    NSString *identifier = [[sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
    
    NOTempObject *temp = [[NOTempObject alloc]init];
    temp.name = identifier;
    temp.type = mode;
    temp.kind = mode;
    
    //change icon
    [[sourceList itemAtRow:[selectedIndexes firstIndex]] setIcon:[NSImage imageNamed:@"table-delete.png"]];
    
    //[[sourceListItems objectAtIndex:[selectedIndexes firstIndex] ] shallRemove];
   // si.isRemoving = YES;
    
    //[[sourceList itemAtRow:[selectedIndexes firstIndex]] setEnabled:NO];
    
    [self loadSourceList];
    
    [sourceList selectRowIndexes:selectedIndexes byExtendingSelection:NO];
    
    
    Connection *cnn = [connections valueForKey:[_cnButt title]];
    
    [cnn addObjectToDrop:temp];

    
}

- (IBAction) truncateTable:(id)sender {
    
    //////NSLog(@"Turncating table %@", selectedItem);
    NSString *query = [NSString stringWithFormat:@"TRUNCATE TABLE %@", selectedItem];
    
    [self executeUpdate:query];
    //[self reload:selectedItem mode:@"data"];
    
}

- (NSMenu*)sourceList:(PXSourceList*)aSourceList menuForEvent:(NSEvent*)theEvent item:(id)item
{
	if ([theEvent type] == NSRightMouseDown || ([theEvent type] == NSLeftMouseDown && ([theEvent modifierFlags] & NSControlKeyMask) == NSControlKeyMask)) {
		NSMenu * m = [[NSMenu alloc] init];
        
        
        if([mode isEqualToString:@"table"]) {
            if (item != nil) {
                [m addItemWithTitle:@"Drop" action:@selector(addObjectToDrop:) keyEquivalent:@""];
                [m addItemWithTitle:@"Truncate" action:@selector(truncateTable:) keyEquivalent:@""];
                [m addItem:[NSMenuItem separatorItem]];
                [m addItemWithTitle:@"Import" action:@selector(nilSymbol:) keyEquivalent:@""];
                [m addItemWithTitle:@"Export" action:@selector(nilSymbol:) keyEquivalent:@""];

            } else {
                [m addItemWithTitle:@"Refresh" action:@selector(loadSourceList:) keyEquivalent:@""];
                [m addItemWithTitle:@"Add new table" action:@selector(addNewTable:) keyEquivalent:@""];
                
            }
        }
        else if([mode isEqualToString:@"connection"]) {
            if (item != nil) {
                //[m addItemWithTitle:@"Connect" action:@selector(connectTODB:) keyEquivalent:@""];
                [m addItemWithTitle:@"Disconnect" action:@selector(disconnectFM:) keyEquivalent:@""];
                //[m addItemWithTitle:@"Rename" action:@selector(addObjectToDrop:) keyEquivalent:@""];
                [m addItemWithTitle:@"Delete" action:@selector(removeConnection:) keyEquivalent:@""];

            } else {
                [m addItemWithTitle:@"Refresh" action:@selector(loadSourceList:) keyEquivalent:@""];
                [m addItemWithTitle:@"Add new connection" action:@selector(addNewConnection:) keyEquivalent:@""];

            }
        }
        else if([mode isEqualToString:@"view"]) {
            [m addItemWithTitle:@"Refresh" action:@selector(loadSourceList:) keyEquivalent:@""];

        }
        else if([mode isEqualToString:@"query"]) {
            [m addItemWithTitle:@"Refresh" action:@selector(loadSourceList:) keyEquivalent:@""];
        }
        /*
        
		if (item != nil) {
            //item click
            
			[m addItemWithTitle:[item title] action:nil keyEquivalent:@""];
            [m addItemWithTitle:@"connect" action:@selector(doubleClick:) keyEquivalent:@""];
            [m addItemWithTitle:@"delete" action:nil keyEquivalent:@""];
            [m insertItemWithTitle:@"Add package"
                                  action:@selector(addSite:)
                           keyEquivalent:@""
                                 atIndex:0];
            [m insertItemWithTitle:[NSString stringWithFormat:@"Remove test"]
                                  action:@selector(removeSite:)
                           keyEquivalent:@""
                                 atIndex:0];
            [m addItemWithTitle:@"remove table" action:@selector(addObjectToDrop:) keyEquivalent:@""];



		} else {
            if([mode isEqualToString:@"table"]) {
                [m addItemWithTitle:@"add new table" action:nil keyEquivalent:@""];
                
                [m addItemWithTitle:@"remove table" action:@selector(addObjectToDrop:) keyEquivalent:@""];

            }
			[m addItemWithTitle:@"clicked outside" action:nil keyEquivalent:@""];
		}
        
        */
		return m;
	}
	return nil;
}

#pragma mark -
#pragma mark Source List Delegate Methods

- (BOOL)sourceList:(PXSourceList*)aSourceList isGroupAlwaysExpanded:(id)group
{
	//if([[group identifier] isEqualToString:@"library"])
		return YES;
	
	//return NO;
}



#pragma mark NSOutlineView Data Source Methods


- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    //////NSLog(@"log entries = %lu", (unsigned long)[logEntries count]);

    return !item ? [logEntries count] : [[item children] count];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return !item ? YES : [[item children] count] != 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    return !item ? logEntries[index] : [item children][index];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
   
    return [item title];
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex {
    if([splitView isEqualTo:mainSplitView]) {
        return proposedMinimumPosition + 380; //ещ
    }
    return proposedMinimumPosition;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex {
    
    if([splitView isEqualTo:mainSplitView]) {
        return proposedMaximumPosition - 50;
    }
    return 238;
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview {
    //check
     
        //NSView *left = [[splitView subviews] objectAtIndex:0];
        NSView *right = [[splitView subviews] objectAtIndex:1];
        
        if ( [subview isEqual:right]) {
            return YES;
        }
        return NO;

    

}

- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex {
    return YES;
}
-(void)selectSidebarItem:(NSString*)tableName {
    //////NSLog(@"tname %@", tableName);
    
    if([[newnames allKeys] containsObject:tableName]) {
        //////NSLog(@"set name  %@", [newnames objectForKey:tableName]);

        tableName = [newnames objectForKey:tableName];
    }

    NSString *currentConnName = [_cnButt title];
    ////NSLog(@"////////////////////////////// in cn refresh nameto %@ ", tableName);


    int rowToSelect = -1;
    int count = 0;
    
    if([mode isEqualToString:@"connection"]) {
        
        //id
        for( NSString *aKey in plist )
        {
            count++;
            
            NSString *title = [[plist objectForKey:aKey] objectAtIndex:1];
            
            if([aKey isEqualToString:tableName]) {
                rowToSelect = count;
                ////NSLog(@"////////////////////////////// in cn refresh sel %@ ", title);

            }

        }
        
    } else if([mode isEqualToString:@"table"]) {
        
      
        for( SourceListItem *item in [[connections objectForKey:currentConnName] getTables] )
        {
              // ////NSLog(@"nname %@", [item title]);
            
            count++;
            if([[item title] isEqualToString:tableName]) {
                rowToSelect = count;
            }
        }
        

    }
        
    [sourceList selectRowIndexes:[NSIndexSet indexSetWithIndex:rowToSelect] byExtendingSelection:NO];
    
    if(mode) {
        
    }
    
}

-(NSDictionary*)getObjectProperties:(NSString*)objName {
    return [objProps objectForKey:objName];
}

-(void)controlTextDidChange:(NSNotification *)obj {
    //////NSLog(@"filter : %@", [_filterField stringValue]);
    
    if([obj object] == _filterField) {
        ////NSLog(@"obj filter");
        [self loadSourceList];

    }     
}

- (void)sourceListSelectionDidChange:(NSNotification *)notification
{
    ////NSLog(@" sl change");

	NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];
	
	//Set the label text to represent the new selection
	if([selectedIndexes count]>1)
		[selectedItemLabel setStringValue:@"(multiple)"];
	else if([selectedIndexes count]==1) {
		NSString *identifier = [[sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
		NSString *atype = [[sourceList itemAtRow:[selectedIndexes firstIndex]] atype];
		NSString *title = [[sourceList itemAtRow:[selectedIndexes firstIndex]] title];
		//////NSLog(@"%@, type:%@", identifier, atype);
		[selectedItemLabel setStringValue:identifier];
        selectedItem = identifier;
        selectedItemIndex = [selectedIndexes firstIndex];
                
        
        NSString *currentConnName = [_cnButt title];

        [_removeMainButton setEnabled:YES];
        [self saveSelectedRow];
        
        if([atype isEqualToString:@"connection"])
        {

            [_cnButt setTitle:title];
            
            [[viewcontroller view] removeFromSuperview];

 
            if ([[connectionViews allKeys] containsObject:identifier])
            {
                if([[connections allKeys] containsObject:[[plist objectForKey:identifier] objectAtIndex:1]])
                {
                    [_cnButt setEnabled:YES];
                }
                else {
                    [_cnButt setEnabled:NO];
                    
                }

                
                self.viewcontroller = [connectionViews valueForKey:identifier];
            }
            else
            {
                ////NSLog(@"conn alloc id %@", identifier);
                
                BOOL conStatus = NO;
                
                if([[connections allKeys] containsObject:[[plist objectForKey:identifier] objectAtIndex:1]])
                {
                    [_cnButt setEnabled:YES];
                    conStatus = YES;
                    
                }
                else {
                    [_cnButt setEnabled:NO];
                    conStatus = NO;

                }

                NSViewController *vc = [[ConnectionViewViewController alloc] initWithNibName:@"ConnectionViewViewController" bundle:nil withIdent:identifier withConfig:config connected:conStatus];
                [connectionViews setValue:vc forKey:identifier];
                self.viewcontroller = vc;

            }
            

            [mainview addSubview:[viewcontroller view]];
            
            [[viewcontroller view] setFrame:[mainview bounds]];
            [[viewcontroller view] setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
            
        }
        else if([atype isEqualToString:@"query"])
        {
            NSString *cname = [_cnButt title];
            
            //////NSLog(@"Loadin query");
            [[viewcontroller view] removeFromSuperview];
            
            //////NSLog(@"name: %@ , key restoring: %@", cname, identifier);

            self.viewcontroller = [[[connections valueForKey:cname] getQViews] valueForKey:identifier];
            
           // //////NSLog(self.viewcontroller);
            
            // [views addObject:vc];
            [mainview addSubview:[viewcontroller view]];
            
            [[viewcontroller view] setFrame:[mainview bounds]];
            [[viewcontroller view] setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
            
        }
        else if([atype isEqualToString:@"table"])
        {
            if([viewcontroller view]) {
                [[viewcontroller view] removeFromSuperview];
            }
            
            
            if ([[[[connections valueForKey:currentConnName] getTViews ]allKeys] containsObject:identifier])
            {
                //////NSLog(@"table exist id %@" , identifier);
                
                self.viewcontroller = [[[connections valueForKey:currentConnName] getTViews] objectForKey:identifier];
                
            }
            else
            {
                //////NSLog(@"table alloc %@  ___+++++++ %@", identifier, currentConnName);
                
                TableController *vc = [[TableController alloc] initWithNibName:@"TableController" bundle:nil ];
                
                //////NSLog(@"SETTING CONN TABLE VIEW");
                [[connections valueForKey:currentConnName] addTView:vc forID:identifier];
                
                self.viewcontroller = vc;
                
                
            }
            //else - alloc new
            
            
            [mainview addSubview:[viewcontroller view]];
            
            [[viewcontroller view] setFrame:[mainview bounds]];
            [[viewcontroller view] setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
            
        }
        else if([atype isEqualToString:@"index"])
        {

            [[viewcontroller view] removeFromSuperview];
            
            if ([[[[connections valueForKey:currentConnName] getIViews ]allKeys] containsObject:identifier])
            {
                //////NSLog(@"index view exist %@ for %@", identifier, currentConnName);
                
                self.viewcontroller = [[[connections valueForKey:currentConnName] getIViews] objectForKey:identifier];
                
            }
            else
            {
                //////NSLog(@"index view alloc %@ for %@", identifier, currentConnName);
                
                IndexViewClt *vc = [[IndexViewClt alloc] initWithNibName:@"IndexViewClt" bundle:nil ];
                [[connections valueForKey:currentConnName] addIView:vc forID:identifier];
                self.viewcontroller = vc;
                
                
            }
            //else - alloc new
            
            
            [mainview addSubview:[viewcontroller view]];
            
            [[viewcontroller view] setFrame:[mainview bounds]];
            [[viewcontroller view] setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
            
        }
        else if([atype isEqualToString:@"view"])
        {
                        

                                    
            [[viewcontroller view] removeFromSuperview];
            
            // if connection created - open viewcoontroller
            if ([[[[connections valueForKey:currentConnName] getVViews ]allKeys] containsObject:identifier])
            {
                //////NSLog(@"table exist");
                
                self.viewcontroller = [[[connections valueForKey:currentConnName] getVViews] objectForKey:identifier];
                
            }
            else
            {
                //////NSLog(@"index view alloc");
                
                TestViewController *vc = [[TestViewController alloc] initWithNibName:@"TestController" bundle:nil ];
                [[connections valueForKey:currentConnName] addVView:vc forID:identifier];
                self.viewcontroller = vc;
                
                
            }
            //else - alloc new
            
            
            [mainview addSubview:[viewcontroller view]];
            
            [[viewcontroller view] setFrame:[mainview bounds]];
            [[viewcontroller view] setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
            
        }
        else if([atype isEqualToString:@"type"])
        {

            
            [[viewcontroller view] removeFromSuperview];
            
            if ([[[[connections valueForKey:currentConnName] getTPViews ]allKeys] containsObject:identifier])
            {
                //////NSLog(@"table exist");
                
                self.viewcontroller = [[[connections valueForKey:currentConnName] getTPViews] objectForKey:identifier];
                
            }
            else
            {
                //////NSLog(@"index view alloc");
                
                TypeViewClt *vc = [[TypeViewClt alloc] initWithNibName:@"TypeViewClt" bundle:nil ];
                [[connections valueForKey:currentConnName] addTPView:vc forID:identifier];
                self.viewcontroller = vc;
                
                
            }            
            
            [mainview addSubview:[viewcontroller view]];
            
            [[viewcontroller view] setFrame:[mainview bounds]];
            [[viewcontroller view] setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
            
        }
        else if([atype isEqualToString:@"procedure"])
        {
            
            [[viewcontroller view] removeFromSuperview];
            
            if ([[[[connections valueForKey:currentConnName] getFViews ]allKeys] containsObject:identifier])
            {
                //////NSLog(@"table exist");
                
                self.viewcontroller = [[[connections valueForKey:currentConnName] getFViews ] objectForKey:identifier];
                
            }
            else
            {
                //////NSLog(@"index view alloc");
                
                IndexViewController *vc = [[IndexViewController alloc] initWithNibName:@"IndexViewController" bundle:nil ];
                [[connections valueForKey:currentConnName] addFView:vc forID:identifier];
                self.viewcontroller = vc;
                
                
            }
            
            
            [mainview addSubview:[viewcontroller view]];
            
            [[viewcontroller view] setFrame:[mainview bounds]];
            [[viewcontroller view] setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
            
        }
        
        
        

        
        
	}
	else {
		[selectedItemLabel setStringValue:@"(none)"];
        
        //activate remove button if conn mode
        if([mode isEqualToString:@"connection"]) {
            [_cnButt setTitle:@""];
        }
        
        

        //[_removeMainButton setEnabled:NO];
        [[viewcontroller view] removeFromSuperview];

	}
}



- (void)sourceListDeleteKeyPressedOnRows:(NSNotification *)notification
{
	NSIndexSet *rows = [[notification userInfo] objectForKey:@"rows"];
	
	//////NSLog(@"Delete key pressed on rows %@", rows);
	
	//Do something here
}


- (IBAction)closeSheet:(id)sender {
    [NSApp endSheet:self.sheet];
    [self.sheet close];
    self.sheet = nil;
}


/*
 
 
 NSSavePanel *save = [NSSavePanel savePanel];
 [save setAllowedFileTypes:[NSArray arrayWithObject:@"sql"]];
 [save setAllowsOtherFileTypes:NO];
 [save setNameFieldStringValue:[appDelegate selectedItem]];
 
 NSInteger result = [save runModal];
 NSError *error = nil;
 
 
 if (result == NSOKButton)
 {
 NSString *selectedFile = [[save URL] path];
 NSString *arrayCompleto = [textView string];
 
 [arrayCompleto writeToFile:selectedFile
 atomically:NO
 encoding:NSUTF8StringEncoding
 error:&error];
 }
 
 if (error) {
 // This is one way to handle the error, as an example
 [NSApp presentError:error];
 }
 

 */


-(NSString*)openFiles
{
        //NSArray *fileTypes = [NSArray arrayWithObjects:@"sql",nil];
        NSOpenPanel * panel = [NSOpenPanel openPanel];
        //[panel runModal];
        
        [panel setAllowedFileTypes:[NSArray arrayWithObject:@"sql"]];
        
        [panel setAllowsMultipleSelection:NO];
        [panel setCanChooseDirectories:NO];
        [panel setCanChooseFiles:YES];
        // [panel setFloatingPanel:YES];
        // NSInteger result = [panel runModalForDirectory:NSHomeDirectory() file:nil
        //                 types:fileTypes];
    
        NSInteger result = [panel runModal];
        
        
        if(result == NSOKButton)
        {
            NSString *selectedFile = [[panel URL] path];
            
            return selectedFile;
            
        }

return nil;

}

    
- (void)openFle:(id)sender {
    NSString * sqlCode = [self openFiles];
    //////NSLog(@"SQL %@",sqlCode);

    if(sqlCode)
    {
        //////NSLog(@"fcon %@", sqlCode);
        NSArray *ar = [sqlCode componentsSeparatedByString:@"/"];
        
         NSString * fileContents = [NSString stringWithContentsOfFile:sqlCode encoding:NSUTF8StringEncoding error:nil];
        [self openNewQuery:fileContents fname:[ar lastObject]];
        
        //NSString *currentConnName = [_cnButt title];
        //Connection *cn =[connections objectForKey:currentConnName];
        //[cn.qNames addObject:fname];
    }
}


- (IBAction)logAction:(id)sender {
    if([_logSwitch selectedSegment] == 0) {
        ////NSLog(@"Switching log");
        [_logTabView selectTabViewItemAtIndex:0];
    } else {
        ////NSLog(@"Switching dbms");
        [_logTabView selectTabViewItemAtIndex:1]
        ;

    }
}

-(IBAction)bindSheetView:(id)sender {
    
    //////NSLog(@"MODE = %@", mode);
    
    if (!_sheet)
        [NSBundle loadNibNamed:@"BindSheet" owner:self];
    
    [NSApp beginSheet:self.sheet
       modalForWindow:[NSApp mainWindow]
        modalDelegate:self
       didEndSelector:NULL
          contextInfo:NULL];
    
    
    
}


-(IBAction)resetPassView:(id)sender {
    
    //////NSLog(@"MODE = %@", mode);        
        
        if (!_sheet)
            [NSBundle loadNibNamed:@"PasswordSheet" owner:self];
        
        [NSApp beginSheet:self.sheet
           modalForWindow:[NSApp mainWindow]
            modalDelegate:self
           didEndSelector:NULL
              contextInfo:NULL];
        
      
      
}


- (IBAction)addMainAction:(id)sender {
    
    //////NSLog(@"MODE = %@", mode);
    
    [_filterField setStringValue:@""];
    
    if([mode isEqualToString:@"query"]) {
        
        NSMenu * m = [[NSMenu alloc] init];
        [m addItemWithTitle:@"Add new file" action:@selector(addNewQuery:) keyEquivalent:@""];
        [m addItemWithTitle:@"Open file" action:@selector(openFle:) keyEquivalent:@""];

        
        [NSMenu popUpContextMenu:m withEvent:[[NSApplication sharedApplication] currentEvent] forView:(NSButton *)sender];
        
        //[self addNewQuery];
        
        
        
    } else if([mode isEqualToString:@"table"]) {
        
        
        if (!_sheet)
            [NSBundle loadNibNamed:@"Sheet" owner:self];
        
        [NSApp beginSheet:self.sheet
           modalForWindow:[NSApp mainWindow]
            modalDelegate:self
           didEndSelector:NULL
              contextInfo:NULL];
        
        /*
        
        
        if (!acc) {
            acc = [[AddTableController alloc] initWithWindowNibName:@"AddTableController"];
        }
        [acc showWindow:self];

        //  [self addNewTable];
         
         
         */
               
        
    } else if([mode isEqualToString:@"connection"]) {
        [self addNewConnection];
             
    }

}

- (IBAction)removaMainAction:(id)sender {
    
    if([mode isEqualToString:@"query"]) {
        
        [self removeQuery];
        
    } else if([mode isEqualToString:@"table"]) {
        
        [self addObjectToDrop:nil];
        
        
    } else if([mode isEqualToString:@"connection"]) {
        [self removeConnection:nil];
        
    }

}

- (IBAction)changeSQLPass:(id)sender {
    
    if([[_nsPass stringValue] isEqualToString:[_conPass stringValue]]) {
        ////NSLog(@"proceding sql pass ch");
        Connection *nconn = [connections valueForKey:[_cnButt title]];
        
        NSString *pQuery;
        
        if(![nconn->actualUsername length] > 0) {
            pQuery = [NSString stringWithFormat:@"ALTER USER %@ IDENTIFIED BY %@ REPLACE %@", nconn->originalUsername , [_nsPass stringValue], [_curPass stringValue] ];

        } else {
            pQuery = [NSString stringWithFormat:@"ALTER USER %@ IDENTIFIED BY %@ REPLACE %@", nconn->actualUsername , [_nsPass stringValue], [_curPass stringValue] ];
        }
        
        [self executeUpdate:pQuery];
        
        [self closeSheet:nil];


        
    } else {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"Wrong password"];
        [alert setInformativeText:@"Password does not match the confirm password"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert beginSheetModalForWindow:[[NSApplication sharedApplication] keyWindow]
                          modalDelegate:self
         
                         didEndSelector:@selector(DiscardAlertDidEnd:returnCode:
                                                  contextInfo:)
                            contextInfo:nil];
        
        
        
    }
}

- (void)DiscardAlertDidEnd:(NSAlert *)alert
                returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
    ////NSLog (@"Button %d clicked",returnCode);
}


@end
