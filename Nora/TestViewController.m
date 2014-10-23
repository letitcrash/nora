//
//  QueryController.m
//  Nora
//
//  Created by Paul Smal on 3/27/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import "TestViewController.h"
#import "ocilib.h"
#import "AppDelegate.h"
#import "ConnectionManager.h"
#import "ColumnCellView.h"
#import "DepCellView.h"
#import "ConstraintCellView.h"


@interface TestViewController ()

@end

@implementation TestViewController
@synthesize topBar;
@synthesize colList;

@synthesize colButton, dataButton, othersButt;

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
    else if([mode isEqual: @"deps"]) {
        return [depList count];
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
    
    [colButton setState:1];
    [dataButton setState:0];
    [_trigButt setState:0];
    [_depButt setState:0];
    [othersButt setState:0];
    
    [tableView deselectAll:nil];
    

}


- (IBAction)dataButtonAction:(id)sender {
    
    ////NSLog(@"DAAT");
    mode = @"data";

    [_tableTabsView selectTabViewItemAtIndex:1];
    
    [colButton setState:0];
    [_trigButt setState:0];
    [_depButt setState:0];
    [othersButt setState:0];
    [dataButton setState:1];
    
    [tableView deselectAll:nil];
    
    //remember
    
    
    while([[tableView tableColumns] count] > 0) {
        [tableView removeTableColumn:[[tableView tableColumns] lastObject]];
    }
    
    
    
    
    for (NSUInteger i = 0; i < [dataCols count]; i++)
    {
        [tableView addTableColumn:[dataCols objectAtIndex:i]];
    }
    [tableView reloadData];
}

- (IBAction)otherButtAction:(id)sender {
    ////NSLog(@"PROP BUT");

    [_tableTabsView selectTabViewItemAtIndex:2];
    
    [colButton setState:0];
    [_trigButt setState:0];
    [_depButt setState:0];
    [othersButt setState:1];
    [dataButton setState:0];
    
    
}


- (IBAction)depButtAct:(id)sender {
    
    mode = @"deps";

    ////NSLog(@"DEP BUT");
    
    [_tableTabsView selectTabViewItemAtIndex:3];
    
    [colButton setState:0];
    [_trigButt setState:0];
    [_depButt setState:1];
    [othersButt setState:0];
    [dataButton setState:0];
    


}
- (IBAction)trigButtAction:(id)sender {
    mode = @"triggers";

    ////NSLog(@"TRIG BUT");

    [_tableTabsView selectTabViewItemAtIndex:4];
    
    [colButton setState:0];
    [_trigButt setState:1];
    [_depButt setState:0];
    [othersButt setState:0];
    [dataButton setState:0];
    


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
                
        return [dc valueForKey:identifier];
    }
    return nil;
}

- (NSView *)tableView:(NSTableView *)tableViewLoc viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    
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
        
        
        [[tableCellView popUp] selectItemWithTitle:[dc valueForKey:@"DataType"]];
        
        
        if([[dc valueForKey:@"Nullable"] isEqualToString:@"YES"]) {
            [[tableCellView isNULL] setState:1];
        }
        else {
            [[tableCellView isNULL] setState:0];
            
        }        
        
        
        
        return tableCellView;
        
    }    else if([mode isEqual: @"deps"]) {
        

        DepCellView *tableCellView = [tableViewLoc makeViewWithIdentifier:[tableColumn identifier] owner:nil];
        
        NSMutableDictionary *dc = [depList objectAtIndex:row];
        [[tableCellView rName] setStringValue:[dc valueForKey:@"RNAME"]];
        [[tableCellView rType] setStringValue:[dc valueForKey:@"RTYPE"]];
        [[tableCellView name] setStringValue:[dc valueForKey:@"NAME"]];
        [[tableCellView type] setStringValue:[dc valueForKey:@"TYPE"]];
        [[tableCellView owner] setStringValue:[dc valueForKey:@"OWNER"]];
        
        
        
        return tableCellView;
        
    }

    
    return nil;
}





- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    // ////NSLog(object);
    //  ////NSLog([tableColumn identifier]);
    NSString *ident = [tableColumn identifier];
    NSMutableDictionary *dc = [list objectAtIndex:row];
    
    
    ////NSLog(@"edit call for obj %@ id = %@ row = %ld", object, ident, row);
    
    // ////NSLog([dc valueForKey:@"DNAME"]);
    // ////NSLog([dc valueForKey:@"First"]);
    
    // NSString *test = [object stringValue];
    
    // ////NSLog(test);
    
    [dc setValue:object forKey:ident];
    
    
    // NSInteger *u = [dc
    // ////NSLog(@"idex %ld", tt);
    // [tableView editColumn:tt row:row withEvent:nil select:YES];
    // [[tableView cell] setBackgroundColor:[NSColor blackColor]];
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    ////NSLog(@"changed");
	NSIndexSet *selectedIndexes = [_colTableView selectedRowIndexes];
    
    
	if([selectedIndexes count]==1) {
        //get current item name
       // [_removeButt setEnabled:YES];
        
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
       // [_removeButt setEnabled:NO];
        
    }
}





-(void)nextColumn
{
    
    

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





/*


- (void)awakeFromNib
{
    colCountIndex = 1; //start adding columns from 1
    dCountIndex = 1; //start data rows from 1
    
    
    //[_tableTabsView setba]
    ////NSLog(@"awaking from Table CL NIB");
    
    //init tab 0
    
    [_tableTabsView selectTabViewItemAtIndex:0];
    

    
    
    while([[tableView tableColumns] count] > 0) {
        [tableView removeTableColumn:[[tableView tableColumns] lastObject]];
    }
    //start mode
    
    [colButton setState:1];
    mode = @"structure";
    
    
    //structure columns
    colCols = [[NSMutableArray alloc] init];
    dataCols  = [[NSMutableArray alloc] init];
    
    
    NSTableColumn *cCol = [[NSTableColumn alloc] initWithIdentifier:@"ColName"];
    [[cCol headerCell] setStringValue:@"COLLUMN NAME"];
    [[cCol dataCell] setControlSize:NSSmallControlSize]; // only thing that doesn't show change
    [[cCol dataCell] setFont:[NSFont labelFontOfSize:[NSFont smallSystemFontSize]]];
    [cCol setWidth:100];
    
    [colCols addObject:cCol];
    
    [tableView addTableColumn:cCol];
    
    
    NSTableColumn *cCol2 = [[NSTableColumn alloc] initWithIdentifier:@"DataType"];
    [[cCol2 headerCell] setStringValue:@"DATA TYPE"];
    [[cCol2 dataCell] setControlSize:NSSmallControlSize]; // only thing that doesn't show change
    [[cCol2 dataCell] setFont:[NSFont labelFontOfSize:[NSFont smallSystemFontSize]]];
    [cCol2 setWidth:100];
    
    [colCols addObject:cCol2];
    
    [tableView addTableColumn:cCol2];
    
    NSTableColumn *cCol3 = [[NSTableColumn alloc] initWithIdentifier:@"Nullable"];
    [[cCol3 headerCell] setStringValue:@"NULLABLE"];
    [[cCol3 dataCell] setControlSize:NSSmallControlSize]; // only thing that doesn't show change
    [[cCol3 dataCell] setFont:[NSFont labelFontOfSize:[NSFont smallSystemFontSize]]];
    [cCol3 setWidth:100];
    
    [colCols addObject:cCol3];
    
    [tableView addTableColumn:cCol3];
    
    
    NSTableColumn *cCol4 = [[NSTableColumn alloc] initWithIdentifier:@"ColSize"];
    [[cCol4 headerCell] setStringValue:@"COLLUMN SIZE"];
    [[cCol4 dataCell] setControlSize:NSSmallControlSize]; // only thing that doesn't show change
    [[cCol4 dataCell] setFont:[NSFont labelFontOfSize:[NSFont smallSystemFontSize]]];
    [cCol4 setWidth:100];
    
    [colCols addObject:cCol4];
    
    [tableView addTableColumn:cCol4];
    
    
    
    colList = [[NSMutableArray alloc]init];
    depList = [[NSMutableArray alloc]init];
    constrList = [[NSMutableArray alloc]init];
    triggersList = [[NSMutableArray alloc]init];
    _colNames = [[NSMutableArray alloc]init];
    list = [[NSMutableArray alloc]init];
    listToRemove = [[NSMutableArray alloc]init];
    
    [list removeAllObjects];
    [colList removeAllObjects];
    
    [tableView reloadData];
    
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    long tag = (long)[[[appDelegate connbutton] selectedItem] tag];
    ////NSLog(@"TAG =  %ld", (long)[[[appDelegate connbutton] selectedItem] tag]);
    
    NSString *tname = [appDelegate selectedItem];
    
    
    
    if ([appDelegate ifObjectInTemp:tname]) {
        //temp
        
        ////NSLog(@"TEMP TWBLE");
        
        
        
        colList = [appDelegate getTempTableColumns:tname];
        
        
        
    }
    else {
        
        
        
        
        //TO_DO memory leak
        
        
        OCI_Connection *cn;
        
        
        ConnectionManager *cm = [ConnectionManager sharedManager];
        
        cn = cm->cnarray[tag];
        
        
        
        
        OCI_Statement *st = OCI_StatementCreate(cn);
        //scrollable opt
        //OCI_SetFetchMode(st, OCI_SFM_SCROLLABLE);
        NSString *query;
        
        
        if(![[[appDelegate username] stringValue] length] > 0) {
            // def user
            
            // //NSLog(@"def user / l: %@ " , [_username stringValue]);
            
            query = [NSString stringWithFormat:@"select * from %@", [appDelegate selectedItem]];
            
        } else {
            // //NSLog(@"using user %@ " , [_username stringValue]);
            
            query = [NSString stringWithFormat:@"select * from %@.%@",[[appDelegate username] stringValue], [appDelegate selectedItem]];
            //OCI_ExecuteStmt(st, [query UTF8String]);
            
        }

                
        
        
        OCI_ExecuteStmt(st, [query UTF8String] );
        
        OCI_Resultset *rs = OCI_GetResultset(st);
        
        int n = OCI_GetColumnCount(rs);
        int i;
        
        
        NSTableColumn *tFirstCol = [[NSTableColumn alloc] initWithIdentifier:@"First"];
        [[tFirstCol dataCell] setControlSize:NSSmallControlSize]; // only thing that doesn't show change
        [[tFirstCol dataCell] setFont:[NSFont labelFontOfSize:[NSFont smallSystemFontSize]]];
        [[tFirstCol headerCell] setStringValue:@""];
        [tFirstCol setEditable:NO];
        [tFirstCol setWidth:30];
        [tableView addTableColumn:tFirstCol];
        [dataCols addObject:tFirstCol];
        
        // printf("number of rows is %s\n", n);
        
        //metadata
        for(i = 1; i <= n; i++)
        {
            OCI_Column *col = OCI_GetColumn(rs, i);
            // printf("name %s\n", OCI_ColumnGetName(col));
            
            NSString *columnName= [NSString stringWithUTF8String:OCI_ColumnGetName(col)];
            NSString *columnType= [NSString stringWithUTF8String:OCI_ColumnGetSQLType(col)];
            NSNumber *columnSize = [NSNumber numberWithUnsignedInt:OCI_ColumnGetSize(col)];
            
            
            
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
                [sd setValue:@"YES" forKey:@"Nullable"];
            }
            else {
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
        
        
        
        ///
        
        OCI_Statement *sti = OCI_StatementCreate(cn);
        
        
        NSString *indexQ = [NSString stringWithFormat:@"select name, type,referenced_owner,referenced_name, referenced_type from user_dependencies where name like '%@'", [appDelegate selectedItem]];
        
        
        
        OCI_ExecuteStmt(sti, [indexQ UTF8String] );
        
        OCI_Resultset *rsi = OCI_GetResultset(sti);
        
        
        while (OCI_FetchNext(rsi)) {
            NSString *name = [NSString stringWithUTF8String:OCI_GetString(rsi, 1)];
            NSString *type = [NSString stringWithUTF8String:OCI_GetString(rsi, 2)];
            NSString *rowner = [NSString stringWithUTF8String:OCI_GetString(rsi, 3)];
            NSString *rname = [NSString stringWithUTF8String:OCI_GetString(rsi, 4)];
            NSString *rtype = [NSString stringWithUTF8String:OCI_GetString(rsi, 5)];
            
            NSMutableDictionary *df = [[NSMutableDictionary alloc]init];
            
            [df setValue:type forKey:@"TYPE"];
            [df setValue:name forKey:@"NAME"];
            [df setValue:rowner forKey:@"OWNER"];
            [df setValue:rname forKey:@"RNAME"];
            [df setValue:rtype forKey:@"RTYPE"];
            //////NSLog(@" DEP OWN %@", owner);
            [depList addObject:df];
            
        }
        //printf("code: %i, name %s\n", OCI_GetInt(rs, 1)  , OCI_GetString(rs, 2));
        
                
        //triggers
        
        OCI_Statement *stt = OCI_StatementCreate(cn);
        
        
        NSString *indexT = [NSString stringWithFormat:@"select TRIGGER_NAME,TRIGGER_TYPE from user_triggers where TABLE_NAME like '%@'", [appDelegate selectedItem]];
        
        
        
        OCI_ExecuteStmt(stt, [indexT UTF8String] );
        
        OCI_Resultset *rst = OCI_GetResultset(stt);
        
        
        while (OCI_FetchNext(rst)) {
            NSString *indexName = [NSString stringWithUTF8String:OCI_GetString(rst, 1)];
            NSString *indexType = [NSString stringWithUTF8String:OCI_GetString(rst, 2)];
            
            NSMutableDictionary *df = [[NSMutableDictionary alloc]init];
            
            [df setValue:indexName forKey:@"TRIGGERNAME"];
            [df setValue:indexType forKey:@"TRIGGERTYPE"];
            ////NSLog(@" TS %@", indexType);
            [triggersList addObject:df];
            
        }
        
        if([triggersList count] == 0) {
            ////NSLog(@"Got no trigers");
            
            //disable labels
            [_trigerown setHidden:YES];
            [_triggerstatus setHidden:YES];
            [_triggertype setHidden:YES];
            [_triggerName setHidden:YES];
            
            [_triggerStatus setHidden:NO];
            
            
        }
        
        
        
        ////NSLog(@"Adding options");
        
        [_optTableName setStringValue:tname];
        
        
        NSDictionary *props = [appDelegate getObjectProperties: tname];
        
        [_optStatus setStringValue:[props objectForKey:@"STATUS"]];
        [_optCreated setStringValue:[props objectForKey:@"DATECREATED"]];
        [_optDDL setStringValue:[props objectForKey:@"LASTDDL"]];

                        
        
        
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
    [tableView reloadData];
    
    
    
}


*/



//// exp







- (void)awakeFromNib
{
    [_refreshButton setToolTip:@"Refresh"];
    [_CommitButton setToolTip:@"Commit"];
    //[_removeButt setToolTip:@"Remove"];
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
    ////NSLog(@"TAG =  %ld", (long)[[[appDelegate connbutton] selectedItem] tag]);
    
    NSString *cname = [[appDelegate cnButt] title];
    //  Connection *cnn = [[appDelegate connections] valueForKey:cname];
    // NSMutableDictionary *dc = [cnn getTempObjects];
    
    NSString *tname = [appDelegate selectedItem];
    
    ////NSLog(@"Awaking Table %@", tname);
    
    
    if ([appDelegate ifObjectInTemp:tname]) {
        //temp
        
        ////NSLog(@"TEMP TWBLE");
        
        
        
        colList = [appDelegate getTempTableColumns:tname];
        _colNames = [appDelegate getTempColNames:tname];
        
        
    }
    else {
        
        ////NSLog(@"CHEMA TWBLE");
        
        
        
        
        if(rs) {
            ////NSLog(@"Alredy fetched");
        }
        //TO_DO memory leak
        
        
        OCI_Connection *cn;
        
        ConnectionManager *cm = [ConnectionManager sharedManager];
        
        NSString *cname = [[appDelegate cnButt] title];
        
        int cnid = [[appDelegate->connections objectForKey:cname] getCNID];
        
        cn = cm->cnarray[cnid];
        
        
        
        
        
        OCI_Statement *st = OCI_StatementCreate(cn);
        OCI_SetFetchMode(st, OCI_SFM_SCROLLABLE);
        NSString *query;
        
        Connection *nconn = [appDelegate->connections valueForKey:cname];
        
        
        if(![nconn->actualUsername length] > 0) {
            // def user
            
            // //NSLog(@"def user / l: %@ " , [_username stringValue]);
            
            query = [NSString stringWithFormat:@"select * from %@", [appDelegate selectedItem]];
            
        } else {
            // //NSLog(@"using user %@ " , [_username stringValue]);
            
            query = [NSString stringWithFormat:@"select * from %@.%@",nconn->actualUsername, [appDelegate selectedItem]];
            //OCI_ExecuteStmt(st, [query UTF8String]);
            
        }
        //Connection *nconn = [connections valueForKey:connName];
        
        
        // if(![nconn->actualUsername length] > 0) {

        
        
        
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
            //printf("name %s\n", OCI_ColumnGetName(col));
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
        
        
        
        
                
        [_optTableName setStringValue:tname];
        
        ///
        
        OCI_Statement *sti = OCI_StatementCreate(cn);
        
        
        NSString *indexQ = [NSString stringWithFormat:@"select name, type,referenced_owner,referenced_name, referenced_type from user_dependencies where name like '%@'", [appDelegate selectedItem]];
        
        
        
        OCI_ExecuteStmt(sti, [indexQ UTF8String] );
        
        OCI_Resultset *rsi = OCI_GetResultset(sti);
        
        
        while (OCI_FetchNext(rsi)) {
            NSString *name = [NSString stringWithUTF8String:OCI_GetString(rsi, 1)];
            NSString *type = [NSString stringWithUTF8String:OCI_GetString(rsi, 2)];
            NSString *rowner = [NSString stringWithUTF8String:OCI_GetString(rsi, 3)];
            NSString *rname = [NSString stringWithUTF8String:OCI_GetString(rsi, 4)];
            NSString *rtype = [NSString stringWithUTF8String:OCI_GetString(rsi, 5)];
            
            NSMutableDictionary *df = [[NSMutableDictionary alloc]init];
            
            [df setValue:type forKey:@"TYPE"];
            [df setValue:name forKey:@"NAME"];
            [df setValue:rowner forKey:@"OWNER"];
            [df setValue:rname forKey:@"RNAME"];
            [df setValue:rtype forKey:@"RTYPE"];
            //////NSLog(@" DEP OWN %@", owner);
            [depList addObject:df];
            
        }
        //printf("code: %i, name %s\n", OCI_GetInt(rs, 1)  , OCI_GetString(rs, 2));
        
        
        //triggers
        
        OCI_Statement *stt = OCI_StatementCreate(cn);
        
        
        NSString *indexT = [NSString stringWithFormat:@"select TRIGGER_NAME,TRIGGER_TYPE from user_triggers where TABLE_NAME like '%@'", [appDelegate selectedItem]];
        
        
        
        OCI_ExecuteStmt(stt, [indexT UTF8String] );
        
        OCI_Resultset *rst = OCI_GetResultset(stt);
        
        
        while (OCI_FetchNext(rst)) {
            NSString *indexName = [NSString stringWithUTF8String:OCI_GetString(rst, 1)];
            NSString *indexType = [NSString stringWithUTF8String:OCI_GetString(rst, 2)];
            
            NSMutableDictionary *df = [[NSMutableDictionary alloc]init];
            
            [df setValue:indexName forKey:@"TRIGGERNAME"];
            [df setValue:indexType forKey:@"TRIGGERTYPE"];
            ////NSLog(@" TS %@", indexType);
            [triggersList addObject:df];
            
        }
        
        if([triggersList count] == 0) {
            ////NSLog(@"Got no trigers");
            
            //disable labels
            [_trigerown setHidden:YES];
            [_triggerstatus setHidden:YES];
            [_triggertype setHidden:YES];
            [_triggerName setHidden:YES];
            
            [_triggerStatus setHidden:NO];
            
            
        }
        
        
        
        ////NSLog(@"Adding options");
        
        [_optTableName setStringValue:tname];
        
        
        NSDictionary *props = [appDelegate getObjectProperties: tname];
        
        [_optStatus setStringValue:[props objectForKey:@"STATUS"]];
        [_optCreated setStringValue:[props objectForKey:@"DATECREATED"]];
        [_optDDL setStringValue:[props objectForKey:@"LASTDDL"]];
        
        
        

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






//// exp end





- (IBAction)refreshAction:(id)sender {
    [self awakeFromNib];
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    // [appDelegate reload];
    [appDelegate loadSourceList];
}



- (IBAction)insertAction:(id)sender {
      
    
    
    
}
- (IBAction)removeAction:(id)sender {
    
    //
    
    
}

- (IBAction)commitAction:(id)sender {
    
    //getting data rows to isert
    
    
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
