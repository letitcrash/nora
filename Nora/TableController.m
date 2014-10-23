//
//  QueryController.m
//  Nora
//
//  Created by Paul Smal on 3/27/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import "TableController.h"
#import "ocilib.h"
#import "AppDelegate.h"
#import "ConnectionManager.h"
#import "ColumnCellView.h"
#import "IndexCellView.h"
#import "ConstraintCellView.h"


#define SIZE_BUF 1512000


@interface TableController ()

@end

@implementation TableController
@synthesize topBar;
@synthesize colList;

@synthesize colButton, constrainsButton, dataButton, othersButt, funcButt, indexButt;

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withConn:(OCI_Connection *)conn
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    

    
    return self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if([mode isEqual: @"structure"]) {
        return [colList count];
    }
    else if([mode isEqual: @"data"]) {
        return [list count];
    }
    else if([mode isEqual: @"indexes"]) {
        return [indexList count];
    }
    else if([mode isEqual: @"constrains"]) {
        ////NSLog(@"IN CONS Md %lu", (unsigned long)[constrList count]);
        return [constrList count];
    }
    else if([mode isEqual: @"triggers"]) {
        return [triggersList count];
    }
    return 0;
}


- (void)remove {
    
    NSIndexSet *selectedIndexes = [tableView selectedRowIndexes];
    //NSString *rowid = [[NSString alloc] init];

    
    NSUInteger index=[selectedIndexes firstIndex];
    
    while(index != NSNotFound)
    {
        NSString *rowid = [[list objectAtIndex:index] valueForKey:@"ROWID"];
        NSString *rowscn = [[list objectAtIndex:index] valueForKey:@"ORA_ROWSCN"];
        NSString *query = [NSString stringWithFormat:@"DELETE FROM DEPT WHERE ROWID = '%@' AND ORA_ROWSCN = '%@' and ( 'DEPTNO' is null or 'DEPTNO' is not null )", rowid, rowscn];
        ////NSLog(@" %@",[[list objectAtIndex:index] valueForKey:@"ROWID"]);
        [self performSelectorInBackground:@selector(runQuery:) withObject:query];
        index=[selectedIndexes indexGreaterThanIndex: index];
    }
    
	if([selectedIndexes count]>1) {
        //[tableView abortEditing];
        
     //   NSUInteger index=[selectedIndexes firstIndex];
        
        [list removeObjectsAtIndexes:selectedIndexes];

        [tableView reloadData];

    }
	else if([selectedIndexes count]==1) {
        
        NSInteger row = [tableView selectedRow];
        [tableView abortEditing];
        
        [list removeObjectAtIndex:row];
        [tableView reloadData];

    }
    else {
        //
    }
    
}



- (IBAction)colButtAction:(id)sender {
    
    mode = @"structure";

    [_tableTabsView selectTabViewItemAtIndex:0];

    
    [dataButton setState:0];
    [indexButt setState:0];
    [funcButt setState:0];
    [constrainsButton setState:0];
    [othersButt setState:0];
    
   // [tableView deselectAll:nil];

    
    while([[tableView tableColumns] count] > 0) {
        [tableView removeTableColumn:[[tableView tableColumns] lastObject]];
    }
    
    
    


}


- (IBAction)dataButtonAction:(id)sender {
    mode = @"data";

    [_tableTabsView selectTabViewItemAtIndex:1];
    
    [colButton setState:0];
    [indexButt setState:0];
    [funcButt setState:0];
    [constrainsButton setState:0];
    [othersButt setState:0];
    [dataButton setState:1];
    
    [tableView deselectAll:nil];
    
    //remember

   
    while([[tableView tableColumns] count] > 0) {
        [tableView removeTableColumn:[[tableView tableColumns] lastObject]];
    }
    
    
    
    
  for (NSUInteger i = 0, countInt = [dataCols count]; i < countInt; i++)
  {
      [tableView addTableColumn:[dataCols objectAtIndex:i]];
  }
    [tableView reloadData];
    
    [_removeButt setEnabled:YES];
}

- (IBAction)constrainButtAct:(id)sender {
    
    [_tableTabsView selectTabViewItemAtIndex:5];

    
    [colButton setState:0];
    [indexButt setState:0];
    [funcButt setState:0];
    [constrainsButton setState:1];
    [othersButt setState:0];
    [dataButton setState:0];
    while([[tableView tableColumns] count] > 0) {
        [tableView removeTableColumn:[[tableView tableColumns] lastObject]];
    }
    
        
    mode = @"constrains";
    [_consTableView reloadData];
}

- (IBAction)indexesButtAction:(id)sender {
    
    [_tableTabsView selectTabViewItemAtIndex:3];
    
    
    [colButton setState:0];
    [indexButt setState:1];
    [funcButt setState:0];
    [constrainsButton setState:0];
    [othersButt setState:0];
    [dataButton setState:0];
    while([[tableView tableColumns] count] > 0) {
        [tableView removeTableColumn:[[tableView tableColumns] lastObject]];
    }

    NSTableColumn *cCol = [[NSTableColumn alloc] initWithIdentifier:@"IndexName"];
    [[cCol headerCell] setStringValue:@"INDEX NAME"];
    [[cCol dataCell] setControlSize:NSSmallControlSize]; // only thing that doesn't show change
    [[cCol dataCell] setFont:[NSFont labelFontOfSize:[NSFont smallSystemFontSize]]];
    [cCol setWidth:100];
    
    //[colCols addObject:cCol];
    
    [tableView addTableColumn:cCol];

    mode = @"indexes";
    
    
    [_indexTableView reloadData];
}

- (IBAction)otherButtAction:(id)sender {
    [_tableTabsView selectTabViewItemAtIndex:2];
    
    [colButton setState:0];
    [indexButt setState:0];
    [funcButt setState:0];
    [constrainsButton setState:0];
    [othersButt setState:1];
    [dataButton setState:0];

    
    
    

}
- (IBAction)funcButtAction:(id)sender {
    
    [_tableTabsView selectTabViewItemAtIndex:4];
    
    
    [colButton setState:0];
    [indexButt setState:0];
    [funcButt setState:1];
    [constrainsButton setState:0];
    [othersButt setState:0];
    [dataButton setState:0];

    /* deselect
    while([[tableView tableColumns] count] > 0) {
        [tableView removeTableColumn:[[tableView tableColumns] lastObject]];
    }

    */
    mode = @"triggers";
    


    [_triggersTableView reloadData];
}



//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if([mode isEqual: @"structure"]) {
        BOOL value = YES;
        return [NSNumber numberWithInteger:(value ? NSOnState : NSOffState)];
    }
    if([mode isEqual: @"data"]) {
        
        NSMutableDictionary *dc = [list objectAtIndex:row];
        NSString *identifier = [tableColumn identifier];
        
    //    ////NSLog(@"returning col  %@" , [dc valueForKey:identifier]);

        return [dc valueForKey:identifier];
    }
    return nil;
}

- (NSView *)tableView:(NSTableView *)tableViewLoc viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
 //   ////NSLog(@"VIEW FOTR TABLE CALLED!!!!!!");
    
    if([mode isEqual: @"data"]) {
        [self tableView:tableViewLoc objectValueForTableColumn:tableColumn row:row];

      //  NSMutableDictionary *dc = [list objectAtIndex:row];
      //  NSString *identifier = [tableColumn identifier];
       // return nil;//[dc valueForKey:identifier];

    }
    else if([mode isEqual: @"structure"]) {
        ColumnCellView *tableCellView = [tableViewLoc makeViewWithIdentifier:[tableColumn identifier] owner:nil];
        
        NSMutableDictionary *dc = [colList objectAtIndex:row];
        //  ////NSLog(@"setting cid %@", [dc valueForKey:@"CID"]);
        tableCellView.cid = [dc valueForKey:@"CID"];
        
        
        [[tableCellView colName] setStringValue:[dc valueForKey:@"ColName"]];
        
        
        
        NSNumber *colSz = [dc valueForKey:@"ColSize"];
        
        [[tableCellView colSize] setStringValue:[colSz stringValue]];
        
        //NSLog(@"Oracle datatype %@" ,[dc valueForKey:@"DataType"] );
        
            
        for (NSString* str in [[tableCellView popUp] itemTitles]) {
            if(![str isEqualToString:[dc valueForKey:@"DataType"]]) {
                [[tableCellView popUp] addItemWithTitle:[dc valueForKey:@"DataType"]];
            }
        }
        [[tableCellView popUp] selectItemWithTitle:[dc valueForKey:@"DataType"]];


        
        if([[dc valueForKey:@"Nullable"] isEqualToString:@"YES"]) {
            [[tableCellView isNULL] setState:1];
        }
        else {
            [[tableCellView isNULL] setState:0];
            
        }
        
        if([[dc valueForKey:@"isPK"] isEqualToString:@"YES"]) {
            
            ////NSLog(@" PKPKPKPKPKKPKPK");
            [[tableCellView isPK] setState:1];
        }
        else {
            [[tableCellView isPK] setState:0];
            
        }
        
        
        
        
        return tableCellView;
        
    }
    else if([mode isEqual: @"constrains"]) {
        ////NSLog(@"ROW REQ %lu mode %@", row, mode);
        ConstraintCellView *tableCellView = [tableViewLoc makeViewWithIdentifier:[tableColumn identifier] owner:nil];
        
        NSMutableDictionary *dc = [constrList objectAtIndex:row];
        [[tableCellView conName] setStringValue:[dc valueForKey:@"CONSTRAINTNAME"]];

        
        
        return tableCellView;
        
    }
    
    else if([mode isEqual: @"indexes"]) {
        IndexCellView *tableCellView = [tableViewLoc makeViewWithIdentifier:[tableColumn identifier] owner:nil];
        
        NSMutableDictionary *dc = [indexList objectAtIndex:row];
        [[tableCellView colName] setStringValue:[dc valueForKey:@"INDEXNAME"]];
        
        
        
        return tableCellView;
        
    }
    else if([mode isEqual: @"triggers"]) {
        IndexCellView *tableCellView = [tableViewLoc makeViewWithIdentifier:[tableColumn identifier] owner:nil];
        
        NSMutableDictionary *dc = [triggersList objectAtIndex:row];
        [[tableCellView colName] setStringValue:[dc valueForKey:@"TRIGGERNAME"]];
        
        
        
        return tableCellView;
        
    }
    

    /*
    ColumnCellView *tableCellView = [tableViewLoc makeViewWithIdentifier:[tableColumn identifier] owner:nil];
    
    NSMutableDictionary *dc = [colList objectAtIndex:row];
  //  ////NSLog(@"setting cid %@", [dc valueForKey:@"CID"]);
    tableCellView.cid = [dc valueForKey:@"CID"];


    [[tableCellView colName] setStringValue:[dc valueForKey:@"ColName"]];
    
    

    NSNumber *colSz = [dc valueForKey:@"ColSize"];

    [[tableCellView colSize] setStringValue:[colSz stringValue]];

    
    [[tableCellView popUp] selectItemWithTitle:[dc valueForKey:@"DataType"]];
    
   
    if([[dc valueForKey:@"Nullable"] isEqualToString:@"YES"]) {
        [[tableCellView isNULL] setState:1];
    }
    else {
        [[tableCellView isNULL] setState:0];

    }
    [[tableCellView isPK] setState:0];
    
    
    

    return tableCellView;
     */
    return nil;
}





- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

    [_CommitButton setEnabled:YES];
    
    
    NSNumber *rownum = [NSNumber numberWithLong:row];

    NSString *ident = [tableColumn identifier];
    NSMutableDictionary *dc = [list objectAtIndex:row];
    
    NSMutableDictionary *od = [[NSMutableDictionary alloc] init];

    [od setValue:[dc objectForKey:ident] forKey:ident];
        
    [dataSaveArray addObject:od];

    [dataSaveList setObject:dataSaveArray forKey:rownum];

    ////NSLog(@"edit call for obj %@ id = %@ row = %ld", object, ident, row);
    
    //if row state = C - not chenge it
    if(![[dc valueForKey:@"__RowState"] isEqualToString:@"C"]) {
        [dc setValue:@"M" forKey:@"__RowState"];
    }
  
    [dc setValue:object forKey:ident];
    
    
    //save old value for row and ident
    

   // NSInteger *u = [dc
   // ////NSLog(@"idex %ld", tt);
   // [tableView editColumn:tt row:row withEvent:nil select:YES];
   // [[tableView cell] setBackgroundColor:[NSColor blackColor]];
}

-(void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    ////NSLog(@"clicked");
 
}

- (void)boundsDidChangeNotification:(NSNotification *)aNotification
{
    

    NSScrollView *scrollView = [aNotification object];
    int currentPosition = CGRectGetMaxY([scrollView visibleRect]);
    int tableViewHeight = [tableView bounds].size.height - 100;
    
    
    
    if ([aNotification object] == [[tableView enclosingScrollView] contentView]) {
        
        
        
        if (currentPosition > tableViewHeight + 100)
        {
            if(rs != nil) {
                ////NSLog(@"Getting more");
                // [self performSelectorInBackground:@selector(runAdditionalRows:) withObject:nil];
                //perform in ui thread
                [self runAdditionalRows:nil];
            }
            
        }
        
    }
    
}


-(void)runAdditionalRows: (NSObject *)obj{
    int n = OCI_GetColumnCount(rs);
    
    int p;
    
    int curProc = uploaded + 30;
    
    while ((OCI_GetCurrentRow(rs) < curProc) && OCI_FetchNext(rs)) {
        count++;
        
        NSMutableDictionary *dc = [[NSMutableDictionary alloc] init];
        // [dc removeAllObjects];
        NSNumber *num = [NSNumber numberWithInt:count];
        [dc setValue:num forKey:@"First"];
        
        for(p = 1; p <= n; p++)
        {
            OCI_Column *col = OCI_GetColumn(rs, p);
            NSString *type = [NSString stringWithUTF8String:OCI_GetColumnSQLType(col)];
            
            // //NSLog(@" COL TYPE : %@", type);
            NSString *obj ;
            if(OCI_IsNull(rs, p) )
            {
                
                obj = [NSString stringWithFormat:@"NULL"];
            }
            else
            {
                
                @try {
                    //  //NSLog(@" try ok");
                    
                    if([type isEqualToString:@"BLOB"]) {
                        obj = @"(BLOB)";
                    } else {
                        obj = [NSString stringWithUTF8String:OCI_GetString(rs,p)];
                    }
                    
                }
                @catch (NSException *exception) {
                    
                    obj = [NSString stringWithFormat:@"[%@]", type];
                    
                    /*
                     if([type isEqualToString:@"XMLTYPE"]) {
                     obj = @"XML";//[NSString stringWithUTF8String:OCI_GetString(rs,p)];
                     } else if([type isEqualToString:@"BLOB"]) {
                     
                     obj = @"BLOB";
                     
                     } else {
                     obj = @"UNSUPPORTED TYPE";//[NSString stringWithUTF8String:OCI_GetString(rs,p)];
                     
                     }
                     */
                }
                
            }
            
            // printf("data row %s\n", OCI_GetString(rs, p));
            // OCI_Column *col = OCI_GetColumn(rs, p);
            NSString *conName;
            
            if(OCI_ColumnGetName(col)) {
                conName= [NSString stringWithUTF8String:OCI_ColumnGetName(col)];
            } else {
                conName = @"NULL";
            }
            
            // printf("col %s\n", OCI_ColumnGetName(col));
            if([obj length] >0)
            {
                
                [dc setValue:obj forKey:conName];
            }
            else{
                [dc setValue:[NSString stringWithFormat:@"NULL"] forKey:conName];
            }
            
        }
        
        
        [list addObject:dc];
    }
    
    ////NSLog(@" Upl = %i", count);
    
    uploaded = count;
    
    
    
    [tableView reloadData];
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    ////NSLog(@"changed");
	NSIndexSet *selectedIndexes = [_colTableView selectedRowIndexes];

    
	if([selectedIndexes count]==1) {
        //get current item name
        [_removeButt setEnabled:YES];
        
        /*
        
        //create instance in for edit?
        NOTempObject *ty = [[NOTempObject alloc]init];
        ty.name = [[colList objectAtIndex:[selectedIndexes firstIndex] ] valueForKey:@"ColName"];
        ty.cid = [[colList objectAtIndex:[selectedIndexes firstIndex] ] valueForKey:@"CID"];
        ty.kind = @"column";
        ty.action = @"init";
        
        
        [appDelegate insertColumn:ty];
         
         */
        
    }
    else {
        [_removeButt setEnabled:NO];
        
    }
}



//////////////////////////
//////////////////////////
//////////////////////////
//////////////////////////


-(void)nextColumn
{


    
    NSInteger *n = [tableView selectedColumn] + 1;
    
    NSMutableDictionary *dc = [[NSMutableDictionary alloc] init];
    [dc setValue:@"" forKey:@"TEST"];
    [list addObject:dc];
    NSBeep();
    [tableView reloadData];

    NSMutableIndexSet *mutableIndexSet = [[NSMutableIndexSet alloc] init];
    [mutableIndexSet addIndex:[list count]];
    [tableView selectRowIndexes:mutableIndexSet byExtendingSelection:NO];
    
    [tableView editColumn:0 row:[list count] withEvent:nil select:YES];
}

- (void)doubleClick:(id)object {
    // This gets called after following steps 1-3.
    long rowNumber = [tableView clickedRow];
    
    NSInteger colNumber  = [tableView clickedColumn];
    
    NSTableCellView *cell = [[tableView selectedCell] viewAtColumn:colNumber];
    
    NSMutableDictionary *dc = [list objectAtIndex:rowNumber];
    NSString *identifier = [[[tableView tableColumns] objectAtIndex:[tableView clickedColumn]] identifier];
    
    NSString *title = [dc valueForKey:identifier];
    //NSLog(@"Row clicked %li val %@", (long)rowNumber, title);
    
    if([title isEqualToString:@"(BLOB)"]) {
        //got blob - need to open external viewver and pass parameters
        
        //obj = @"BLOB";
        char temp[SIZE_BUF+1];
        OCI_Lob *lob1;
        
         OCI_FetchSeek(rs, OCI_SFD_ABSOLUTE, rowNumber + 1);
        
        lob1= OCI_GetLob(rs, 4);
        //OCI_LobRead(blob, temp, SIZE_BUF);
        //NSData *data = [[NSData alloc] initWithBytes:blob length:10120];
        
        //////NSLog(@" DATA %@", data);
        //NSImage *image = [[NSImage alloc] initWithData:data];
        //NSImage *image =[[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://cs405524.vk.me/v405524896/65e3/-ANTK_vON84.jpg"]];
        
        //////NSLog(@" IMG %@", image);
        
        int n;
        
        
        //while ((n = OCI_LobRead(lob1, temp, sizeof(temp)))) {}
        
        //printf("\n%d bytes read\n", OCI_LongGetSize(lg));
        //long size = OCI_LobGetLength(lob1);//OCI_GetDataLength
        
        n = OCI_LobRead(lob1, temp, SIZE_BUF);
        temp[n] = 0;
        
        NSData *data = [[NSData alloc] initWithBytes:temp length:SIZE_BUF];
        
       // printf("code: %i, action : %s\n",p, temp);
        //////NSLog(@" DATA %@", data);
       // NSImage *image = [[NSImage alloc] initWithData:data];
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *uuidString = [[NSUUID UUID] UUIDString];
        
        NSString *foldname = [NSString stringWithFormat:@"Nora/%@.png", uuidString];

        NSString *config = [documentsDirectory stringByAppendingPathComponent:foldname];
        //NSString *configDir = [documentsDirectory stringByAppendingPathComponent:@"Nora"];
        //NSFileManager *fileManager = [NSFileManager defaultManager];

        
        
        [data writeToFile: config atomically: NO];
        
        [[NSWorkspace sharedWorkspace] openFile:config
                                withApplication:@"Preview.app"];
        
        //[_imagebox setImage:image];
        
        OCI_LobFree(lob1);
        

        
    } else if([title isEqualToString:@"XML"]) {
        //open textedit?
        
        /* xml type not supported by ocilib so far
         roadmap plan - 5.0 early 2013
         
         
         
        char temp[SIZE_BUF+1];
        OCI_Lob *lob1;

        OCI_FetchSeek(rs, OCI_SFD_ABSOLUTE, rowNumber + 1);

        // *lg;
        int n;
        char buffer[SIZE_BUF];
        
        long size = OCI_LobGetLength(lob1);//OCI_GetDataLength
        
        n = OCI_LobRead(lob1, temp, SIZE_BUF);
        temp[n] = 0;
        
        NSData *data = [[NSData alloc] initWithBytes:temp length:SIZE_BUF];
        
        // printf("code: %i, action : %s\n",p, temp);
        ////NSLog(@" DATA %@", data);
        //NSImage *image = [[NSImage alloc] initWithData:data];
        
        //[data writeToFile: @"/Users/paul/test.png" atomically: NO];
        
        //[[NSWorkspace sharedWorkspace] openFile:@"/Users/paul/test.png"
          //                      withApplication:@"Preview.app"];
        
        //[_imagebox setImage:image];
        


         printf("code: %i, action : %s\n",n, temp);
        */

    } else {
        [tableView editColumn:colNumber row:[tableView selectedRow] withEvent:nil select:YES];
    }
    
}

-(void)refresh
{
    ////NSLog(@"Refresh from tc");
    NSMutableDictionary *dc = [[NSMutableDictionary alloc] init];
    long count = [list count] + 1;
    NSNumber *num = [NSNumber numberWithLong:count];

    [dc setValue:num forKey:@"First"];
    [list addObject:dc];
    NSBeep();
    [tableView reloadData];

}






- (void)awakeFromNib
{
    [_CommitButton setToolTip:@"Commit"];
    [_removeButt setToolTip:@"Remove"];
    [_insertButton setToolTip:@"Insert"];
    [_rollbackButton setToolTip:@"Rollback"];
    
    [[_scrollView contentView] setPostsBoundsChangedNotifications: YES];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter] ;
    [center addObserver: self
               selector: @selector(boundsDidChangeNotification:)
                   name: NSViewBoundsDidChangeNotification
                 object: [_scrollView contentView]];
    
    colCountIndex = 1; //start adding columns from 1
    dCountIndex = 1; //start data rows from 1
    
    colList = [[NSMutableArray alloc]init];
    indexList = [[NSMutableArray alloc]init];
    constrList = [[NSMutableArray alloc]init];
    triggersList = [[NSMutableArray alloc]init];
    _colNames = [[NSMutableArray alloc]init];
    list = [[NSMutableArray alloc]init];
    dataSaveArray = [[NSMutableArray alloc]init];
    dataSaveList = [[NSMutableDictionary alloc]init];
    listToRemove = [[NSMutableArray alloc]init];
    
    //[_tableTabsView setba]
    ////NSLog(@"awaking from Table CL NIB");
    
    //init tab 0
    
    
    
    [tableView setTarget:self];
    [tableView setDoubleAction:@selector(doubleClick:)];

    
    [dataButton setState:0];
    [colButton setState:0];
    [indexButt setState:0];
    [othersButt setState:0];
    
    
    while([[tableView tableColumns] count] > 0) {
        [tableView removeTableColumn:[[tableView tableColumns] lastObject]];
    }
    //start mode
    
    [colButton setState:1];
    mode = @"structure";
    
    
    //structure columns
    colCols = [[NSMutableArray alloc] init];
    dataCols  = [[NSMutableArray alloc] init];

    

    [list removeAllObjects];
    [colList removeAllObjects];
    
    [tableView reloadData];

    
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
       // long tag = (long)[[[appDelegate connbutton] selectedItem] tag];
    ////NSLog(@"TAG =  %ld", (long)[[[appDelegate connbutton] selectedItem] tag]);
    
    
    NSString *cname = [[appDelegate cnButt] title];
    int cnid = [[appDelegate->connections objectForKey:cname] getCNID];
   
    NSString *tname = [appDelegate selectedItem];
    
    if ([appDelegate ifObjectInTemp:tname]) {
        //temp
        
        ////NSLog(@"TEMP TWBLE");
        
        
    
        colList = [appDelegate getTempTableColumns:tname];
        _colNames = [appDelegate getTempColNames:tname];


    }
    else {
        
        ////NSLog(@"CHEMA TWBLE");

        

        
        
        //NSLog(@"Connection getting name %@ tag %d ", cname , cnid);

        
        OCI_Connection *cn;
        
        
        ConnectionManager *cm = [ConnectionManager sharedManager];

        cn = cm->cnarray[cnid];

                    
        
        
        
        OCI_Statement *st = OCI_StatementCreate(cn);
        OCI_SetFetchMode(st, OCI_SFM_SCROLLABLE);
        NSString *query;
        Connection *nconn = [appDelegate->connections valueForKey:cname];
        //NSLog(@"c name/ l: %@ " , nconn);

        
        if([nconn->actualUsername length] == 0) {
            // def user
            
            
            query = [NSString stringWithFormat:@"select ROWID,ORA_ROWSCN, a.* from %@ a order by rownum", [appDelegate selectedItem]];

            
            //NSLog(@"original/ l: %@ " , nconn->originalUsername);
            //NSLog(@"actual %@ " , nconn->actualUsername);

            
        } else {
            //NSLog(@"using user %@ " , nconn->actualUsername);
            

            query = [NSString stringWithFormat:@"select ROWID,ORA_ROWSCN, a.* from %@.%@ a order by rownum" ,nconn->actualUsername,[appDelegate selectedItem]];

            //OCI_ExecuteStmt(st, [query UTF8String]);
            
        }


        

        OCI_ExecuteStmt(st, [query UTF8String] );
        
        rs = OCI_GetResultset(st);
        
        int n = OCI_GetColumnCount(rs);
        int i;
        int colSize;
        
        
        NSTableColumn *tFirstCol = [[NSTableColumn alloc] initWithIdentifier:@"First"];
        [[tFirstCol dataCell] setControlSize:NSSmallControlSize]; // only thing that doesn't show change
        [[tFirstCol dataCell] setFont:[NSFont labelFontOfSize:[NSFont smallSystemFontSize]]];
        [[tFirstCol headerCell] setStringValue:@""];
        [tFirstCol setEditable:NO];
        [tFirstCol setWidth:30];
        [tableView addTableColumn:tFirstCol];
        [dataCols addObject:tFirstCol];

        //NSLog(@" metadata");

        //metadata
        for(i = 1; i <= n; i++)
        {
            OCI_Column *col = OCI_GetColumn(rs, i);
            // printf("name %s\n", OCI_ColumnGetName(col));
            colSize = OCI_ColumnGetSize(col);
            
            //NSLog(@" getting col names");

            
            NSString *columnName= [NSString stringWithUTF8String:OCI_ColumnGetName(col)];
            NSString *columnType= [NSString stringWithUTF8String:OCI_ColumnGetSQLType(col)];
            NSNumber *columnSize = [NSNumber numberWithUnsignedInt:OCI_ColumnGetSize(col)];
            
            ////NSLog(@" passed");

            
            //  printf("type %s\n", OCI_ColumnGetSQLType(col));
            //  printf("is nullable %d\n", OCI_ColumnGetNullable(col));
            //  printf("size %d\n", OCI_ColumnGetSize(col));
            
            NSMutableDictionary *sd = [[NSMutableDictionary alloc] init];
            NSString *uuidString = [[NSUUID UUID] UUIDString];

            [sd setValue:uuidString forKey:@"CID"];
            [sd setValue:columnName forKey:@"ColName"];
            [sd setValue:columnType forKey:@"DataType"];
            [sd setValue:columnSize forKey:@"ColSize"];
            if(OCI_ColumnGetNullable(col)) {
                
                ////NSLog(@"Column %@ is nullable", columnName);
                [sd setValue:@"YES" forKey:@"Nullable"];
            }
            else {
                ////NSLog(@"Column %@ is NOT nullable", columnName);

                [sd setValue:@"NO" forKey:@"Nullable"];
                
            }
            
            
            if(!([columnName isEqualToString:@"ROWID"] || [columnName isEqualToString:@"ORA_ROWSCN"]))
            {
                [colList addObject:sd];
                [_colNames addObject:columnName];
            }
            if(!([columnName isEqualToString:@"ROWID"] || [columnName isEqualToString:@"ORA_ROWSCN"]))
            {
                
                
                NSTableColumn *tCol = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithUTF8String:OCI_ColumnGetName(col)]];
                [[tCol headerCell] setStringValue:columnName];
                [[tCol dataCell] setControlSize:NSSmallControlSize]; // only thing that doesn't show change
                [[tCol dataCell] setFont:[NSFont labelFontOfSize:[NSFont smallSystemFontSize]]];
                [tCol setWidth:100];
                
                [dataCols addObject:tCol];
                
            }
            
            
            // [tableView addTableColumn:tCol];
            
            
        }
        
        ////NSLog(@" data");

        //data
        int p;
        count = 0;
        
            while ((OCI_GetCurrentRow(rs) < 60) && OCI_FetchNext(rs)) {
                count++;
                
                
                //////NSLog(@"COUNT // %i", count);
                NSMutableDictionary *dc = [[NSMutableDictionary alloc] init];
                // [dc removeAllObjects];
                NSNumber *num = [NSNumber numberWithInt:count];
                [dc setValue:num forKey:@"First"];
                
                for(p = 1; p <= n; p++)
                {
                    OCI_Column *col = OCI_GetColumn(rs, p);
                    NSString *type = [NSString stringWithUTF8String:OCI_GetColumnSQLType(col)];
                    
                   // //NSLog(@" COL TYPE : %@", type);
                    NSString *obj ;
                    if(OCI_IsNull(rs, p) )
                    {

                        obj = [NSString stringWithFormat:@"NULL"];
                    }
                    else
                    {

                        @try {
                          //  //NSLog(@" try ok");
                            
                            if([type isEqualToString:@"BLOB"]) {
                                obj = @"(BLOB)";
                            } else {
                                obj = [NSString stringWithUTF8String:OCI_GetString(rs,p)];   
                            }

                        }
                        @catch (NSException *exception) {

                            obj = [NSString stringWithFormat:@"[%@]", type];

                            /*
                            if([type isEqualToString:@"XMLTYPE"]) {
                                obj = @"XML";//[NSString stringWithUTF8String:OCI_GetString(rs,p)];
                            } else if([type isEqualToString:@"BLOB"]) {
                                
                                obj = @"BLOB";
                                                              
                            } else {
                                obj = @"UNSUPPORTED TYPE";//[NSString stringWithUTF8String:OCI_GetString(rs,p)];
                                
                            }
                             */
                        }
                                                               
                    }
                    
                    // printf("data row %s\n", OCI_GetString(rs, p));
                   // OCI_Column *col = OCI_GetColumn(rs, p);
                    NSString *conName;
                    
                    if(OCI_ColumnGetName(col)) {
                        conName= [NSString stringWithUTF8String:OCI_ColumnGetName(col)];
                    } else {
                        conName = @"NULL";
                    }
                    
                    // printf("col %s\n", OCI_ColumnGetName(col));
                    if([obj length] >0)
                    {
                        
                        [dc setValue:obj forKey:conName];
                    }
                    else{
                        [dc setValue:[NSString stringWithFormat:@"NULL"] forKey:conName];
                    }
                    
                }
                [list addObject:dc];
            }
            
            ////NSLog(@" Upl = %i", count);
            
            
            uploaded = count;
            
            
            [tableView reloadData];
            
            ////NSLog(@" log");
            
            
            [appDelegate logEntry:[NSString stringWithFormat:@"%d row(s) fetched", OCI_GetRowCount(rs)] sql:[NSString stringWithUTF8String:OCI_GetSql(st)]];
            
            
            

        ////NSLog(@" indexes");
        
        

        
                
                //ndexes
        
       OCI_Statement *sti = OCI_StatementCreate(cn);
        
        
        NSString *indexQ =
        [NSString stringWithFormat:@"select USER_INDEXES.INDEX_NAME,USER_INDEXES.INDEX_TYPE,user_ind_columns.COLUMN_NAME from USER_INDEXES, user_ind_columns where USER_INDEXES.table_name like '%@' and user_ind_columns.index_name like USER_INDEXES.index_name", [appDelegate selectedItem]];
        
        
        
        OCI_ExecuteStmt(sti, [indexQ UTF8String] );
        
        OCI_Resultset *rsi = OCI_GetResultset(sti);

        
        
        while (OCI_FetchNext(rsi)) {
            
            
            NSString *indexName = [NSString stringWithUTF8String:OCI_GetString(rsi, 1)];
            NSString *indexType = [NSString stringWithUTF8String:OCI_GetString(rsi, 2)];
            NSString *colName = [NSString stringWithUTF8String:OCI_GetString(rsi, 3)];
            
            //set pk true
            
           // [[colList valueForKey:colName] setValue:@"YES" forKey:@"isPK"];
            
            for (NSMutableDictionary *item in colList)
            {
                if([[item valueForKey:@"ColName"] isEqualToString:colName]) {

                    [item setValue:@"YES" forKey:@"isPK"];
                }
            }
            
            
            
            NSMutableDictionary *df = [[NSMutableDictionary alloc]init];
            
            [df setValue:indexName forKey:@"INDEXNAME"];
            [df setValue:indexType forKey:@"INDEXTYPE"];
           // [df setValue:indexType forKey:@"INDEXTYPE"];
            //////NSLog(@" TS %@", indexType);
            [indexList addObject:df];
            
        }
            //printf("code: %i, name %s\n", OCI_GetInt(rs, 1)  , OCI_GetString(rs, 2));
        
        
        OCI_StatementFree(sti);

        //constraints
        
        OCI_Statement *stc = OCI_StatementCreate(cn);
        
        
        NSString *indexC = [NSString stringWithFormat:@"select CONSTRAINT_NAME,CONSTRAINT_TYPE from user_constraints where TABLE_NAME like '%@'", [appDelegate selectedItem]];
        
        
        
        OCI_ExecuteStmt(stc, [indexC UTF8String] );
        
        OCI_Resultset *rsc = OCI_GetResultset(stc);
        ////NSLog(@"constraints");

        
        while (OCI_FetchNext(rsc)) {
            NSString *indexName = [NSString stringWithUTF8String:OCI_GetString(rsc, 1)];
            NSString *indexType = [NSString stringWithUTF8String:OCI_GetString(rsc, 2)];
            
            NSMutableDictionary *df = [[NSMutableDictionary alloc]init];
            
            [df setValue:indexName forKey:@"CONSTRAINTNAME"];
            [df setValue:indexType forKey:@"CONSTRAINTTYPE"];
            //////NSLog(@" TS %@", indexName);
            [constrList addObject:df];
            
        }
        OCI_StatementFree(stc);


        //triggers
        
        OCI_Statement *stt = OCI_StatementCreate(cn);
        
        
        NSString *indexT = [NSString stringWithFormat:@"select TRIGGER_NAME,TRIGGER_TYPE from user_triggers where TABLE_NAME like '%@'", [appDelegate selectedItem]];
        
        
        
        OCI_ExecuteStmt(stt, [indexT UTF8String] );
        
        OCI_Resultset *rst = OCI_GetResultset(stt);
        NSMutableDictionary *df = [[NSMutableDictionary alloc]init];

        
        while (OCI_FetchNext(rst)) {
            if(OCI_GetString(rst, 1) != nil) {
                //[_optTBSpace setStringValue:[NSString stringWithUTF8String:OCI_GetString(rso, 1)]];
                [df setValue:[NSString stringWithUTF8String:OCI_GetString(rst, 1)] forKey:@"TRIGGERNAME"];

            }
            if(OCI_GetString(rst, 2) != nil) {
                //[_optTBSpace setStringValue:[NSString stringWithUTF8String:OCI_GetString(rso, 1)]];
                [df setValue:[NSString stringWithUTF8String:OCI_GetString(rst, 2)] forKey:@"TRIGGERTYPE"];

            }
            
            /*
            NSString *indexName = [NSString stringWithUTF8String:OCI_GetString(rst, 1)];
            NSString *indexType = [NSString stringWithUTF8String:OCI_GetString(rst, 2)];
            
            [df setValue:indexName forKey:@"TRIGGERNAME"];
            [df setValue:indexType forKey:@"TRIGGERTYPE"];
            ////NSLog(@" TS %@", indexType);
             
             */
            [triggersList addObject:df];
            
        }
        
        OCI_StatementFree(stt);
        
        if([triggersList count] == 0) {
            //////NSLog(@"Got no trigers");
            
            //disable labels
            [_trigerown setHidden:YES];
            [_triggerstatus setHidden:YES];
            [_triggertype setHidden:YES];
            [_triggerName setHidden:YES];
            
            [_triggerStatus setHidden:NO];
            
                    
        }
        
        
        
        [_optTableName setStringValue:tname];
        
        /* test
        
        OCI_Statement *sto = OCI_StatementCreate(cn);
        
        
        NSString *indexO = [NSString stringWithFormat:@"select TABLESPACE_NAME, STATUS, PCT_FREE,PCT_USED, CACHE, INSTANCES, LAST_ANALYZED, SAMPLE_SIZE, INI_TRANS, MAX_TRANS, NUM_ROWS, BLOCKS, AVG_ROW_LEN from user_tables where TABLE_NAME like '%@'", [appDelegate selectedItem]];
        
        
        
        OCI_ExecuteStmt(sto, [indexO UTF8String] );
        
        OCI_Resultset *rso = OCI_GetResultset(sto);
        
        
        while (OCI_FetchNext(rso)) {
            if(OCI_GetString(rso, 1) != nil) {
                [_optTBSpace setStringValue:[NSString stringWithUTF8String:OCI_GetString(rso, 1)]];
            }
            if(OCI_GetString(rso, 2) != nil) {
                [_optStatus setStringValue:[NSString stringWithUTF8String:OCI_GetString(rso, 2)]];
            }
            if(OCI_GetString(rso, 3) != nil) {
                [_optPCTFree setStringValue:[NSString stringWithUTF8String:OCI_GetString(rso, 3)]];
            }
            if(OCI_GetString(rso, 4) != nil) {
                [_optPCTUsed setStringValue:[NSString stringWithUTF8String:OCI_GetString(rso, 4)]];
            }
            if(OCI_GetString(rso, 5) != nil) {
                [_optCache setStringValue:[NSString stringWithUTF8String:OCI_GetString(rso, 5)]];
            }
            if(OCI_GetString(rso, 6) != nil) {
                [_optInstances setStringValue:[NSString stringWithUTF8String:OCI_GetString(rso, 6)]];
            }
            if(OCI_GetString(rso, 7) != nil) {
                [_optLAnalyzed setStringValue:[NSString stringWithUTF8String:OCI_GetString(rso, 7)]];
            }
            if(OCI_GetString(rso, 8) != nil) {
                [_optSampleSize setStringValue:[NSString stringWithUTF8String:OCI_GetString(rso, 8)]];
            }
            if(OCI_GetString(rso, 9) != nil) {
                [_optIniTrans setStringValue:[NSString stringWithUTF8String:OCI_GetString(rso, 9)]];
            }
            if(OCI_GetString(rso, 10) != nil) {
                [_optMaxTarns setStringValue:[NSString stringWithUTF8String:OCI_GetString(rso, 10)]];
            }
            if(OCI_GetString(rso, 11) != nil) {
                [_optRows setStringValue:[NSString stringWithUTF8String:OCI_GetString(rso, 11)]];
            }
            if(OCI_GetString(rso, 12) != nil) {
                [_optBlocks setStringValue:[NSString stringWithUTF8String:OCI_GetString(rso, 12)]];
            }
            if(OCI_GetString(rso, 13) != nil) {
                [_optAVGRowLen setStringValue:[NSString stringWithUTF8String:OCI_GetString(rso, 13)]];
            }
            
          
         
        }
        */


    }
    


    
    
    
    [topBar setStartingColor:
     [NSColor colorWithCalibratedWhite:0.98 alpha:1.0]]; //64-88
    [topBar setEndingColor:
     [NSColor colorWithCalibratedWhite:0.88 alpha:1.0]];
    [topBar setAngle:270];
    
    [_propView setStartingColor:
     [NSColor colorWithCalibratedWhite:0.96 alpha:1.0]]; //64-88
    [_propView setEndingColor:
     [NSColor colorWithCalibratedWhite:0.98 alpha:1.0]];
    [_propView setAngle:270];

    [_colTableView setBackgroundColor:[NSColor colorWithCalibratedWhite:0.96 alpha:1.0]];
    [_indexTableView setBackgroundColor:[NSColor colorWithCalibratedWhite:0.96 alpha:1.0]];
    [_triggersTableView setBackgroundColor:[NSColor colorWithCalibratedWhite:0.96 alpha:1.0]];
    [_consTableView setBackgroundColor:[NSColor colorWithCalibratedWhite:0.96 alpha:1.0]];
    
    ////NSLog(@"Reloadting table ?? ");

    [tableView reloadData];
    
    if([[appDelegate tableMode] isEqualToString:@"data"]) {
        
        ////NSLog(@"Table data mode on");
        [self dataButtonAction:nil];
    } else {
        ////NSLog(@"table col mode on");

        [self colButtAction:nil];
    }
    
    [_refreshButton setEnabled:YES];
    

}


- (void)controlTextDidChange:(NSNotification *)notification {
    NSTextField *textField = [notification object];
   // //NSLog(@"controlTextDidChange: stringValue == %@", [textField stringValue]);
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    NSString *tname = [appDelegate selectedItem];
    
    [appDelegate renameTable:tname to:[textField stringValue]];

    
}

- (IBAction)closeSheet:(id)sender {
    [NSApp endSheet:self.sheet];
    [self.sheet close];
    self.sheet = nil;
}



- (IBAction)refreshAction:(id)sender {
    
    
    [_refreshButton setEnabled:NO];
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    //long tag = (long)[[[appDelegate connbutton] selectedItem] tag];
    ////NSLog(@"TAG =  %ld", (long)[[[appDelegate connbutton] selectedItem] tag]);
    NSString *tname = [appDelegate selectedItem];

    NSString *identifier = [[appDelegate cnButt] title];
    
    //self awakeFromNib];
    //AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    ////NSLog(@"Going to reload %@" , identifier);
    [appDelegate reload:identifier mode:mode];
     //[appDelegate loadSourceList];
    //[self awakeFromNib];
    
    ////NSLog(@"selecting table %@" , tname);

   // mode = @"data";

    [appDelegate selectSidebarItem:tname];
    //////NSLog(@"mode = %@", mode);
    //[_tableTabsView selectTabViewItemAtIndex:index];

}



- (IBAction)insertAction:(id)sender {
    
    [_CommitButton setEnabled:YES];

    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    NSString *tableName = [appDelegate selectedItem];

    
    if([mode isEqual: @"structure"]) {
        
        
        ////NSLog(@" CC = %i",colCountIndex);
        NSString *coName = [NSString stringWithFormat:@"COLUMN1"];
        
        while(TRUE) {
            
            ////NSLog(@"COL = %i", colCountIndex);
            
            int t = colCountIndex;
            
            for (NSString *object in _colNames) {
                coName = [NSString stringWithFormat:@"COLUMN%d", colCountIndex];
                
                if ([object isEqualToString:coName]) {
                    
                    //////NSLog(@"equel");
                    t = colCountIndex;
                    colCountIndex++;
                }
                
                
            }
            if(t == colCountIndex) {
                
                break;
            }
            
            
            
            
        }
        
        //get current index
       // colCountIndex = 5;
        
        NSString *uuidString = [[NSUUID UUID] UUIDString];


    //    ////NSLog(coName);

        NSDictionary *obj = @{@"CID": uuidString,@"ColName": coName,@"DataType": @"VARCHAR2",@"ColSize": @20, @"Nullable": @"YES"};

        NSInteger index = [colList count];

        index++;
        
        [colList addObject:obj];
        [_colNames addObject:coName];
         //[colList insertObject:obj atIndex:index];
        
        
        [_colTableView beginUpdates];
        [_colTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationSlideDown];
        [_colTableView scrollRowToVisible:index];
        [_colTableView endUpdates];
        

        NOTempObject *col = [[NOTempObject alloc] init];
        
        col.name = coName;
        col.type = @"VARCHAR2";
        col.size = (long)20;
        col.isNULL = YES;
        col.kind = @"column";
        col.parent = tableName;
        col.cid = uuidString;
        col.isTEMP = YES;

        
        
        [appDelegate insertColumn:col];
        

    
    }
    else if([mode isEqual: @"data"]) {
                  
            
        for(int i = 0; i < [list count];i++) {
            NSDictionary *dc = [list objectAtIndex:i];
            NSNumber *idn = [dc valueForKey:@"First"];
            dCountIndex = [idn integerValue] + 1;
            //////NSLog();
            
               // ////NSLog([list objectAtIndex:i]);
            }
        
        NSNumber *t = [NSNumber numberWithInt:dCountIndex ];
        NSMutableDictionary *obj = [[NSMutableDictionary alloc] init];//@{@"First": t, @"DNAME":@"FROMAC"};
        [obj setValue:t forKey:@"First"];
        [obj setValue:@"C" forKey:@"__RowState"];
        [obj setValue:tableName forKey:@"__TableName"];

       // [obj setValue:@"TSTTTT!" forKey:@"DNAME"];
        NSInteger index = [list count];// [tableView selectedRow];
        index++;
        
        //[list insertObject:obj atIndex:dCountIndex];
        
        [list addObject:obj];
        [tableView beginUpdates];
        [tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationEffectFade];
        [tableView scrollRowToVisible:index];
        [tableView endUpdates];
        
    } else if([mode isEqual: @"indexes"]) {
    
    
    ////NSLog(@" CC = %i",colCountIndex);
    NSString *coName = [NSString stringWithFormat:@"INDEX1"];
    
    while(TRUE) {
        
        ////NSLog(@"COL = %i", colCountIndex);
        
        int t = colCountIndex;
        
        for (NSString *object in _colNames) {
            coName = [NSString stringWithFormat:@"INDEX%d", colCountIndex];
            
            // do something with object
            //  NSString *cname = object;
            
            
            // ////NSLog(coName);
            // ////NSLog(cname);
            
            if ([object isEqualToString:coName]) {
                
                //////NSLog(@"equel");
                t = colCountIndex;
                colCountIndex++;
            }
            
            
        }
        if(t == colCountIndex) {
            
            ////NSLog(@"T = %i , COL = %i", t, colCountIndex);
            break;
        }
        
        
        
        
    }
    
    //get current index
    // colCountIndex = 5;
    
    NSString *uuidString = [[NSUUID UUID] UUIDString];
    
    
    //    ////NSLog(coName);
    
    NSMutableDictionary *obj = @{@"CID": uuidString,@"INDEXNAME": coName,@"INDEXTYPE": @"NORMAL"};
    
    NSInteger index = [indexList count];
    
    index++;
    
    [indexList addObject:obj];
    [_colNames addObject:coName];
    //[colList insertObject:obj atIndex:index];
    
    
    [_indexTableView beginUpdates];
    [_indexTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationSlideDown];
    [_indexTableView scrollRowToVisible:index];
    [_indexTableView endUpdates];
    
    
    NOTempObject *col = [[NOTempObject alloc] init];
    
    col.name = coName;
    col.type = @"VARCHAR2";
    col.size = (long)20;
    col.isNULL = NO;
    col.kind = @"column";
    col.parent = tableName;
    col.cid = uuidString;
    col.isTEMP = YES;
    
    
    
    [appDelegate insertColumn:col];
    
    
    
}





}
- (IBAction)removeAction:(id)sender {
    

    if([mode isEqual: @"structure"]) {

    NSIndexSet *selectedIndexes = [_colTableView selectedRowIndexes];
    //NSString *rowid = [[NSString alloc] init];
    
    
    NSUInteger index=[selectedIndexes firstIndex];
    
    while(index != NSNotFound)
    {
        NSString *cname = [[colList objectAtIndex:index] valueForKey:@"ColName"];
        NSString *cid = [[colList objectAtIndex:index] valueForKey:@"CID"];


        
        NOTempObject *temp = [[NOTempObject alloc]init];
        temp.name = cname;
        temp.type = @"column";
        temp.kind = @"column";
        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        temp.parent = [appDelegate selectedItem];
        
        temp.cid = cid;

    
        

        [appDelegate removeColumn:temp];

     //   NSString *rowscn = [[list objectAtIndex:index] valueForKey:@"ORA_ROWSCN"];
       /// NSString *query = [NSString stringWithFormat:@"DELETE FROM DEPT WHERE ROWID = '%@' AND ORA_ROWSCN = '%@' and ( 'DEPTNO' is null or 'DEPTNO' is not null )", rowid, rowscn];
      //  ////NSLog(@" %@",[[list objectAtIndex:index] valueForKey:@"ROWID"]);
       // [self performSelectorInBackground:@selector(runQuery:) withObject:query];
        index=[selectedIndexes indexGreaterThanIndex: index];
    }
    
	if([selectedIndexes count]>1) {
        //[tableView abortEditing];
        
        //   NSUInteger index=[selectedIndexes firstIndex];
        
        [colList removeObjectsAtIndexes:selectedIndexes];
        
        [_colTableView reloadData];
        
    }
	else if([selectedIndexes count]==1) {
        
        NSInteger row = [_colTableView selectedRow];
        [_colTableView abortEditing];
        
        [colList removeObjectAtIndex:row];
       // [_colTableView reloadData];
        
    }
    else {
        //
    }
    
       
    [_colTableView reloadData];
    
    } else if([mode isEqual: @"data"]) {
        
        NSIndexSet *selectedIndexes = [tableView selectedRowIndexes];
        //NSString *rowid = [[NSString alloc] init];
        
        
        NSUInteger index=[selectedIndexes firstIndex];
        
        ////NSLog(@"TO DELETE ");
        
        ////NSLog([[list objectAtIndex:index] valueForKey:@"ROWID"]);
        
        [listToRemove addObject:[list objectAtIndex:index]];
        
        /*
        while(index != NSNotFound)
        {
            NSString *cname = [[colList objectAtIndex:index] valueForKey:@"ColName"];
            NSString *cid = [[colList objectAtIndex:index] valueForKey:@"CID"];
            
            
            
            NOTempObject *temp = [[NOTempObject alloc]init];
            temp.name = cname;
            temp.type = @"column";
            temp.kind = @"column";
            AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
            temp.parent = [appDelegate selectedItem];
            
            temp.cid = cid;
            
            
            
            
            [appDelegate removeColumn:temp];
            
            //   NSString *rowscn = [[list objectAtIndex:index] valueForKey:@"ORA_ROWSCN"];
            /// NSString *query = [NSString stringWithFormat:@"DELETE FROM DEPT WHERE ROWID = '%@' AND ORA_ROWSCN = '%@' and ( 'DEPTNO' is null or 'DEPTNO' is not null )", rowid, rowscn];
            //  ////NSLog(@" %@",[[list objectAtIndex:index] valueForKey:@"ROWID"]);
            // [self performSelectorInBackground:@selector(runQuery:) withObject:query];
            index=[selectedIndexes indexGreaterThanIndex: index];
        }
        */
        if([selectedIndexes count]>1) {
            //[tableView abortEditing];
            
            //   NSUInteger index=[selectedIndexes firstIndex];
            
            [list removeObjectsAtIndexes:selectedIndexes];
            
            [tableView reloadData];
            
        }
        else if([selectedIndexes count]==1) {
            
            NSInteger row = [tableView selectedRow];
            [tableView abortEditing];
            
            [list removeObjectAtIndex:row];
            
        }

        [tableView reloadData];
    
    }
    [_CommitButton setEnabled:YES];

    
}







- (IBAction)commitAction:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    NSString *connName = [[appDelegate cnButt]title];
    Connection *nc = [appDelegate->connections valueForKey:connName];
    
    //get table name
    NSString *tname = [appDelegate selectedItem];
    
    
    
    //getting data rows to insert
    
    for(long i = 0; i < [list count]; i++) {
        ////NSLog([[[list objectAtIndex:i]valueForKey:@"First"] stringValue]);
        NSMutableDictionary *dc = [list objectAtIndex:i];
        NSString *tableName = [[NSString alloc]init];
        
        
        if([[dc valueForKey:@"__RowState"] isEqualToString:@"D"]) {
            ////NSLog(@"TO DEL ROW");
        } else if([[dc valueForKey:@"__RowState"] isEqualToString:@"C"]) {
            ////NSLog(@"SESSION ROW TO INSERT");
            NSMutableString *columns = [[NSMutableString alloc]init];
            NSMutableString *values = [[NSMutableString alloc]init];
            
            for (NSString* key in dc) {
                
                if([key isEqualToString:@"First"]) {
                    //skip
                }
                else if([key isEqualToString:@"__RowState"]) {
                    //skip
                }
                else if([key isEqualToString:@"ROWID"]) {
                    //skip
                }
                else if([key isEqualToString:@"ORA_ROWSCN"]) {
                    //skip
                }
                else if([key isEqualToString:@"__TableName"]) {
                    tableName     = [dc objectForKey:key];            }
                else {
                    id value = [dc objectForKey:key];
                    
                    if([value length] > 0){
                        
                        //NSLog(@" value for key %@ is %@", key, value);

                        [columns appendFormat:@",%@",key];
                        [values appendFormat:@",'%@'",value];

                    } else {
                        //NSLog(@"null value for key %@", key);

                        [columns appendFormat:@",%@",key];
                        [values appendFormat:@",'%@'",@"NULL"];

                    }
                  //  ////NSLog(key);
                   //// ////NSLog(value);
                   // ////NSLog(tableName);
                }

            }
            
            //NSLog(@"cols ar %@" , columns);
            //NSLog(@"vals ar %@" , values);
            
            NSString *query;
            
            if(![columns length] == 0) {
                
                if([nc->actualUsername length] == 0) {
                   query = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", tableName, [columns substringFromIndex:1] , [values substringFromIndex:1]];

                } else {
                    query = [NSString stringWithFormat:@"INSERT INTO %@.%@ (%@) VALUES (%@)",nc->actualUsername, tableName, [columns substringFromIndex:1] , [values substringFromIndex:1]];

                }
                
                
                
                //NSLog(@"QUERY TO RUN %@", query);
                //INSERT INTO "SCOTT"."DEPT" (DEPTNO, DNAME) VALUES ('22', '22')
                //[self performSelectorInBackground:@selector(runQuery:) withObject:query];
                
                int status = [appDelegate executeUpdate:query];

                
            }

            
            
        } else if([[dc valueForKey:@"__RowState"] isEqualToString:@"M"]) {
            ////NSLog(@" ROW %ld HAS VALUES TO MODIFY ",i);
           
            NSNumber *rownum = [NSNumber numberWithLong:i];
            
            NSArray *od = [dataSaveList objectForKey:rownum];

            NSMutableString *colvals = [[NSMutableString alloc]init];
            //NSMutableString *oldcolvals = [[NSMutableString alloc]init];
            NSMutableString *rowstring = [dc valueForKey:@"ROWID"];

            
            ////NSLog(@"old vals %@", od);
            
            
            
            for (id object in od) {
                for (NSString* key in object) {
                    //id value = [object objectForKey:key];
                    ////NSLog(@"KEY TO MOD %@ WITH VAL %@ and ROWID is %@", key, [dc valueForKey:key] , [dc valueForKey:@"ROWID"]);
                    [colvals appendFormat:@",%@='%@'",key, [dc valueForKey:key]];

                }
            }

            
            
            for (NSString* key in dc) {
                
                if([key isEqualToString:@"First"]) {
                    //skip
                }
                else if([key isEqualToString:@"__RowState"]) {
                    //skip
                }
                else if([key isEqualToString:@"ROWID"]) {
                    rowstring = [dc objectForKey:key];
                }
                else if([key isEqualToString:@"ORA_ROWSCN"]) {
                    //skip
                }
                else if([key isEqualToString:@"__TableName"]) {
                    //tableName     = [dc objectForKey:key];
                } else {
                                       
                    /*
                    id value = [dc objectForKey:key];
                    id oldvalue = [od objectForKey:key];
                    
                    ////NSLog(@"got vals to compare %@ and %@", value, oldvalue);
                    
                    if(value != nil && oldvalue != nil) {
                        if(![value isEqual:oldvalue]) {
                            
                            ////NSLog(@"got row to update value %@ with value %@", value, oldvalue);
                            
                            //not equal -> update
                            [colvals appendFormat:@",%@='%@'",key, value];
                           // [oldcolvals appendFormat:@",%@='%@'",key, oldvalue];
                            
                        }
                        
                    }
                     */
                    
                }
                
            }
            
            ////NSLog(@"TNAME = %@", tname);
            
            if(![colvals length] == 0) {
                
                NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE ROWID = '%@'", tname,  [colvals substringFromIndex:1],  rowstring];
                
                int status = [appDelegate executeUpdate:query];


            }
            
            
        } else {
            ////NSLog(@"UNTOCHED ROW");

        }
        
    }
    

    
    
    
    
    //to remove data rows
    
    
    for(int i = 0; i < [listToRemove count]; i++) {
        //
        ////NSLog(@"GOT TO DEL");
       // ////NSLog([[[listToRemove objectAtIndex:i]valueForKey:@"First"] stringValue]);
     //   NSMutableDictionary *dc = [listToRemove objectAtIndex:i];
        
        NSString *rowid = [[listToRemove objectAtIndex:i] valueForKey:@"ROWID"];
        NSString *rowscn = [[listToRemove objectAtIndex:i] valueForKey:@"ORA_ROWSCN"];
        //NSString *tableName = [[listToRemove objectAtIndex:i] valueForKey:@"__TableName"];
        
        ////NSLog(@" GOING TO delete ROW %@ %@ and i = %i", rowid, rowscn, i);
        
        //TO_DO Create query
        /*
         
         DELETE FROM "SCOTT"."DEPT" WHERE ROWID = 'AAAR3bAAEAAAACHAAC' AND ORA_ROWSCN = '16193534' and ( "DEPTNO" is null or "DEPTNO" is not null )
         ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found

         */
        
        NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ROWID = '%@' AND ORA_ROWSCN = '%@'", tname, rowid, rowscn];
        
        ////NSLog(query);
        
        if(rowid != nil) {
            int status = [appDelegate executeUpdate:query];
        }
        ////NSLog(@"Rowid nil");



    }

    
    
    //check objects valid for db
    
    
    //create temp objects
     
    
    //create query from temp objects
    
    
    NSString *identifier = [[appDelegate cnButt] title];

   // NSIndexSet *sind = [appDelegate selectedItemIndex];
    
   // ////NSLog(@"Sh sel %@", sind);

    [appDelegate insertTempObjectsToDB];
    [appDelegate dropObjectsToRemove];
    [appDelegate performModificationForTempObjects];
    
    //rename objects
    
    [appDelegate renameObjects];

    
    //reload views
    [appDelegate reload:identifier mode:mode];
    [appDelegate loadSourceList];
    

    [appDelegate selectSidebarItem:tname];
    
    [appDelegate->newnames removeAllObjects];
    
    

    
    //[colList removeAllObjects];
  //  NSString *tname = [appDelegate selectedItem];

    //colList = [appDelegate getTableColumns:tname];
    
    //[tableView reloadData];

    //[_colTableView deselectAll:nil];
   // [_CommitButton setEnabled:NO];
    
    
    

}

- (IBAction)rollBackAction:(id)sender {
    [self awakeFromNib];

    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    NSString *identifier = [[appDelegate cnButt] title];

    [appDelegate reload:identifier mode:mode];
    [appDelegate loadSourceList];
}
- (IBAction)typeSelected:(id)sender {
    
    ////NSLog(@"Test");
}
@end
