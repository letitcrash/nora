//
//  QueryController.m
//  Nora
//
//  Created by Paul Smal on 3/27/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import "QueryController.h"
#import "ocilib.h"
#import "AppDelegate.h"
#import "AddTableController.h"
#import "MGSFragaria/MGSFragaria.h"


//#import "ConnectionManager.m"

@interface QueryController ()

@end

@implementation QueryController
@synthesize topBar;
@synthesize tableView;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        ////NSLog(@"init query");

    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSQL:(NSString *)sql
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        ////NSLog(@"init query with text %@", sql);
        //[textView setString:@"test"];
        sqlode = [NSString stringWithString:sql];
        
    }
    
    return self;
}

- (IBAction)enableDBMS:(id)sender {
    
    
    
}





- (IBAction)runButton:(id)sender {
    [self runQueries];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {

        return [list count];

}

- (IBAction)saveFile:(NSString*)content ext:(NSString*)ext name:(NSString*)fname{
    
    //AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    
    NSSavePanel *save = [NSSavePanel savePanel];
    [save setAllowedFileTypes:[NSArray arrayWithObject:ext]];
    [save setAllowsOtherFileTypes:NO];
    //NSString *name = [NSString stringWithFormat:@"%@(1-5)",fname ];
    [save setNameFieldStringValue:fname];
    
    NSInteger result = [save runModal];
    NSError *error = nil;
    
    
    if (result == NSOKButton)
    {
        NSString *selectedFile = [[save URL] path];
        //NSString *arrayCompleto = [textView string];
        
        [content writeToFile:selectedFile
                        atomically:NO
                          encoding:NSUTF8StringEncoding
                             error:&error];
    }
    
    if (error) {
        // This is one way to handle the error, as an example
        [NSApp presentError:error];
    }
    
}

- (IBAction)saveQuery:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    

    NSSavePanel *save = [NSSavePanel savePanel];
    [save setAllowedFileTypes:[NSArray arrayWithObject:@"sql"]];
    [save setAllowsOtherFileTypes:NO];
    [save setNameFieldStringValue:[appDelegate selectedItem]];
    
    NSInteger result = [save runModal];
    NSError *error = nil;

    
    if (result == NSOKButton)
    {
        NSString *selectedFile = [[save URL] path];
        NSString *arrayCompleto = [fragaria string];
        
        [arrayCompleto writeToFile:selectedFile
                        atomically:NO
                          encoding:NSUTF8StringEncoding
                             error:&error];
    }
    
    if (error) {
        // This is one way to handle the error, as an example
        [NSApp presentError:error];
    }
    
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

        NSMutableDictionary *dc = [list objectAtIndex:row];
        NSString *identifier = [tableColumn identifier];
        return [dc valueForKey:identifier];

}

- (void)boundsDidChange:(NSNotification *)aNotification
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

- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    //    //NSLog(@"called datacell");
    
    //  [tableColumn setWidth:40];
    
    NSTextFieldCell *cell = [tableColumn dataCell];
    
    // //NSLog(@"ID =  %@", [tableColumn identifier]);
    if([[tableColumn identifier] isEqualToString:@"First"]) {
        [cell setTextColor: [NSColor blackColor]];
        //[cell setBackgroundColor:[NSColor blackColor]];
        //[tableColumn setWidth:30];
        NSFont *mainTitleFont = [NSFont systemFontOfSize:11.0];
        [cell setFont:mainTitleFont];
        [cell setAlignment:NSCenterTextAlignment];
        
        
        [cell setDrawsBackground: YES];
        [cell setBackgroundColor: [NSColor colorWithCalibratedRed: 227.0 / 255.0
                                                            green: 233.0 / 255.0
                                                             blue: 254.0 / 255.0
                                                            alpha: 1.0]];
        
    } else {
        [cell setTextColor: [NSColor blackColor]];
        [cell setBackgroundColor:[NSColor whiteColor]];
        
    }
    return cell;
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
- (void)setSyntaxDefinition:(NSString *)name
{
	[fragaria setObject:name forKey:MGSFOSyntaxDefinitionName];
}

- (void)awakeFromNib
{
//    [[textView textStorage] setFont:[NSFont fontWithName:@"Menlo" size:12]];
    
    
    // create an instance
	fragaria = [[MGSFragaria alloc] init];
	
	[fragaria setObject:self forKey:MGSFODelegate];
	
	// define our syntax definition
	[self setSyntaxDefinition:@"SQL"];
	
	// embed editor in editView
	[fragaria embedInView:editView];
	
    //
	// assign user defaults.
	// a number of properties are derived from the user defaults system rather than the doc spec.
	//
	// see MGSFragariaPreferences.h for details
	//

	
	// define initial document configuration
	//
	// see MGSFragaria.h for details
	//
    if (YES) {
        [fragaria setObject:[NSNumber numberWithBool:YES] forKey:MGSFOIsSyntaxColoured];
        [fragaria setObject:[NSNumber numberWithBool:YES] forKey:MGSFOShowLineNumberGutter];
    }
    
    // set text
	//[fragaria setString:@"select * from EMP"];
	
    
	// access the NSTextView
	NSTextView *textView = [fragaria objectForKey:ro_MGSFOTextView];
	
    

    [textView setFont:[NSFont fontWithName:@"Menlo" size:11]];
    [_exportButton setToolTip: @"Export results to CSV file"];
    [_runButton setToolTip:@"Run statement"];
    [_saveCodeButton setToolTip:@"Save SQL code"];
    [_refreshButton setToolTip:@"Refresh"];
    [_runScriptButton setToolTip:@"Run script"];

    if([sqlode length] > 0) {
        [textView setString:sqlode];
    }
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    ////NSLog(@"TAG =  %ld", (long)[[[appDelegate connbutton] selectedItem] tag]);

   
    
    [[[tableView enclosingScrollView] contentView] setPostsBoundsChangedNotifications:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boundsDidChange:) name:NSViewBoundsDidChangeNotification object:[[tableView enclosingScrollView] contentView]];
    
    
  
    [topBar setStartingColor:
     [NSColor colorWithCalibratedWhite:0.98 alpha:1.0]]; //64-88
    [topBar setEndingColor:
     [NSColor colorWithCalibratedWhite:0.88 alpha:1.0]];
    [topBar setAngle:270];
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex {
    return proposedMinimumPosition + 100;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex {
    return proposedMaximumPosition - 100;
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview {
    NSView *left = [[splitView subviews] objectAtIndex:0];
    NSView *right = [[splitView subviews] objectAtIndex:2];
    
    if ([subview isEqual:left] || [subview isEqual:right]) {
        return YES;
    }
    return NO;
}


- (IBAction)runScript:(id)sender{
    ////NSLog(@"Running query");
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    NSString *cname = [[appDelegate cnButt] title];
    int cnid = [[appDelegate->connections objectForKey:cname] getCNID];
    
    ConnectionManager *cm = [ConnectionManager sharedManager];
    
    cn = cm->cnarray[cnid];
    
    OCI_Statement *st = OCI_StatementCreate(cn);
    
    // OCI_SetFetchMode(st, OCI_SFM_SCROLLABLE);
    
    while([[tableView tableColumns] count] > 0) {
        [tableView removeTableColumn:[[tableView tableColumns] lastObject]];
    }
    
    
    
    list = [[NSMutableArray alloc]init];
    metalist = [[NSMutableArray alloc]init];
    
    [list removeAllObjects];
    
    [tableView reloadData];

    
    NSString *query = [fragaria string];
    
    NSArray *queries = [query componentsSeparatedByString:@";"];
    
    int a;
    
    for (a=0;a<[queries count];a++)
    {
        
        NSString *item = [queries objectAtIndex:a];
        
        
        if([item length] > 1) {
            ////NSLog(@"Running qu %@", item);

            OCI_Prepare(st, [item UTF8String]);
            
            if(OCI_Execute(st)) {
                
                [appDelegate logEntry:[NSString stringWithFormat:@"Statement executed"] sql:[NSString stringWithUTF8String:OCI_GetSql(st)]];
            }


        }
        
        
    }
    
    OCI_Commit(cn);


}




- (void)runQueries {
    ////NSLog(@"Running query");
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    NSString *cname = [[appDelegate cnButt] title];
    int cnid = [[appDelegate->connections objectForKey:cname] getCNID];
    
    ConnectionManager *cm = [ConnectionManager sharedManager];
    
    cn = cm->cnarray[cnid];
    
    OCI_Statement *st = OCI_StatementCreate(cn);
   // OCI_SetFetchMode(st, OCI_SFM_SCROLLABLE);
    
    NSString *query = [fragaria string]; //[[textView textStorage] string];
    
  
    /*
    NSArray *components = [query componentsSeparatedByString:@" "];
    
    for(NSString *cmp in components) {
        if([cmp hasPrefix:@":"]){
            //NSLog(@"Found var to bind %@", cmp);
        }
    }
     */
    
    OCI_Prepare(st, [query UTF8String]);
    ////NSLog(@"Passed prepare");
    int code = 123;
   // OCI_BindInt(st, ":res", &code);

    int test = OCI_BindArrayGetSize(st);
    //NSLog(@"Passed prepare bind %i", test);

    if(OCI_Execute(st)) {
        
        ////NSLog(@"Passed oci exec");

        
        rs = OCI_GetResultset(st);
        
        if(rs != NULL){
            
            
            while([[tableView tableColumns] count] > 0) {
                [tableView removeTableColumn:[[tableView tableColumns] lastObject]];
            }
            
            
            
            list = [[NSMutableArray alloc]init];
            metalist = [[NSMutableArray alloc]init];

            [list removeAllObjects];
            
            [tableView reloadData];
            
                        
            int n = OCI_GetColumnCount(rs);
            int i;
            int colSize;
            
            
            NSTableColumn *tFirstCol = [[NSTableColumn alloc] initWithIdentifier:@"First"];
            [[tFirstCol dataCell] setControlSize:NSSmallControlSize]; // only thing that doesn't show change
            [[tFirstCol dataCell] setFont:[NSFont labelFontOfSize:[NSFont smallSystemFontSize]]];
            [[tFirstCol headerCell] setStringValue:@" "];
            
            [tFirstCol setWidth:38];
            [tableView addTableColumn:tFirstCol];
            // printf("number of rows is %s\n", n);
            
            //metadata
            for(i = 1; i <= n; i++)
            {
                OCI_Column *col = OCI_GetColumn(rs, i);
                colSize = OCI_ColumnGetSize(col);
                
                NSString *columnName= [NSString stringWithUTF8String:OCI_ColumnGetName(col)];
                // NSString *columnName= [NSString stringWithUTF8String:OCI_ColumnGetName(col)];
                
                
                
                NSTableColumn *tCol = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithUTF8String:OCI_ColumnGetName(col)]];
                [[tCol headerCell] setStringValue:columnName];
                [[tCol dataCell] setControlSize:NSSmallControlSize]; // only thing that doesn't show change
                [[tCol dataCell] setFont:[NSFont labelFontOfSize:[NSFont smallSystemFontSize]]];
                [tCol setWidth:100];
                
                [tableView addTableColumn:tCol];
                [metalist addObject:columnName];
                
            }
            
            ////NSLog(@"Passed meta");
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
            
            
            
            [appDelegate logEntry:[NSString stringWithFormat:@"%d row(s) fetched", OCI_GetRowCount(rs)] sql:[NSString stringWithUTF8String:OCI_GetSql(st)]];
            
            
                      
            
            
            
        } else {
            OCI_Commit(cn);
            [appDelegate logEntry:[NSString stringWithFormat:@"Statement executed"] sql:[NSString stringWithUTF8String:OCI_GetSql(st)]];
           
            
            //NSLog(@" log DBMS");

            const dtext *ap;
            
            while ((ap = OCI_ServerGetOutput(cn)))
            {
             //   printf(ap);
                
                NSString *str = [[NSString alloc] initWithFormat:@" %s \n", ap];
                
               // printf("\n");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSAttributedString* attr = [[NSAttributedString alloc] initWithString:str];
                                                
                    [[appDelegate.dbmsTextView textStorage] appendAttributedString:attr];
                    [appDelegate.dbmsTextView scrollRangeToVisible:NSMakeRange([[appDelegate.dbmsTextView string] length], 0)];
                });
            }


        }
    }
    
    
    
}


- (void)runQuerie:(NSString *)query {
    ////NSLog(@"Running query");
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    NSString *cname = [[appDelegate cnButt] title];
    int cnid = [[appDelegate->connections objectForKey:cname] getCNID];
    
    ConnectionManager *cm = [ConnectionManager sharedManager];
    
    cn = cm->cnarray[cnid];
    
    OCI_Statement *st = OCI_StatementCreate(cn);
    
    OCI_SetFetchMode(st, OCI_SFM_SCROLLABLE);
    
    
    OCI_Prepare(st, [query UTF8String]);
    
    
    if(OCI_Execute(st)) {
        
        rs = OCI_GetResultset(st);
    
        if(rs != NULL){
        
    
            while([[tableView tableColumns] count] > 0) {
                [tableView removeTableColumn:[[tableView tableColumns] lastObject]];
        }
    

    
    list = [[NSMutableArray alloc]init];
    metalist = [[NSMutableArray alloc]init];

    [list removeAllObjects];
    
    [tableView reloadData];
    
    
//    ////NSLog(@"TAG =  %ld", (long)[[[appDelegate connbutton] selectedItem] tag]);
    

    int n = OCI_GetColumnCount(rs);
    int i;
    int colSize;
    
    
    NSTableColumn *tFirstCol = [[NSTableColumn alloc] initWithIdentifier:@"First"];
    [[tFirstCol dataCell] setControlSize:NSSmallControlSize]; // only thing that doesn't show change
    [[tFirstCol dataCell] setFont:[NSFont labelFontOfSize:[NSFont smallSystemFontSize]]];
    [[tFirstCol headerCell] setStringValue:@" "];
    
    [tFirstCol setWidth:30]; //not work
    [tableView addTableColumn:tFirstCol];
    // printf("number of rows is %s\n", n);
    
    //metadata
    for(i = 1; i <= n; i++)
    {
        OCI_Column *col = OCI_GetColumn(rs, i);
        colSize = OCI_ColumnGetSize(col);
        
        NSString *columnName= [NSString stringWithUTF8String:OCI_ColumnGetName(col)];
        // NSString *columnName= [NSString stringWithUTF8String:OCI_ColumnGetName(col)];
        
        
        
        NSTableColumn *tCol = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithUTF8String:OCI_ColumnGetName(col)]];
        [[tCol headerCell] setStringValue:columnName];
        [[tCol dataCell] setControlSize:NSSmallControlSize]; // only thing that doesn't show change
        [[tCol dataCell] setFont:[NSFont labelFontOfSize:[NSFont smallSystemFontSize]]];
        [tCol setWidth:100];
        
        [tableView addTableColumn:tCol];
        
        //NSLog(@"adding col %@", columnName);
        [metalist addObject:columnName];
        
        
    }
    //data
    int p;
    count = 0;

            
            while ((OCI_GetCurrentRow(rs) < 50) && OCI_FetchNext(rs)) {
                count++;

                NSMutableDictionary *dc = [[NSMutableDictionary alloc] init];
                // [dc removeAllObjects];
                NSNumber *num = [NSNumber numberWithInt:count];
                [dc setValue:num forKey:@"First"];
                
                for(p = 1; p <= n; p++)
                {
                    NSString *obj ;
                    if(OCI_IsNull(rs, p) )
                    {
                        obj = [NSString stringWithFormat:@"NULL"];
                    }
                    else
                    {
                        obj = [NSString stringWithUTF8String:OCI_GetString(rs,p)];
                        
                    }
                    
                    //  printf("data %s\n", OCI_GetString(rs, p));
                    OCI_Column *col = OCI_GetColumn(rs, p);
                    NSString *conName= [NSString stringWithUTF8String:OCI_ColumnGetName(col)];
                    
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
    
        
            //NSLog(@" log DBMS qri");
            
            
            [appDelegate logEntry:[NSString stringWithFormat:@"%d row(s) fetched", OCI_GetRowCount(rs)] sql:[NSString stringWithUTF8String:OCI_GetSql(st)]];
            
            
            const dtext *ap;
            
            while ((ap = OCI_ServerGetOutput(cn)))
            {
              //  printf(ap);
                //printf("\n");
                
                NSString *username = [NSString stringWithUTF8String:ap];
                
                

            }

       
        [appDelegate logEntry:[NSString stringWithFormat:@"%d row(s) fetched", OCI_GetRowCount(rs)] sql:[NSString stringWithUTF8String:OCI_GetSql(st)]];
        

    }
    }
    
    

}




- (IBAction) exportHTML:(id)sender {
    //NSLog(@"html export");
}

- (IBAction)exportAction:(id)sender {

    /*
    NSMenu * m = [[NSMenu alloc] init];
    [m addItemWithTitle:@"Export results to CSV file" action:@selector(exportCSV:) keyEquivalent:@""];
    [m addItemWithTitle:@"Export results to HTML file" action:@selector(exportHTML:) keyEquivalent:@""];
    
    
    //[NSMenu popUpContextMenu:m withEvent:[[NSApplication sharedApplication] currentEvent] forView:(NSButton *)sender];
    
    //
    NSPoint mouseLocation = [NSEvent mouseLocation];

    
    NSRect frame = NSMakeRect(mouseLocation.x, mouseLocation.y, 200, 200);
    NSWindow* newWindow  = [[NSWindow alloc] initWithContentRect:frame
                                                       styleMask:NSBorderlessWindowMask
                                                         backing:NSBackingStoreBuffered
                                                           defer:NO];
    [newWindow setAlphaValue:0];
    [newWindow makeKeyAndOrderFront:NSApp];
    
    NSPoint locationInWindow = [newWindow convertScreenToBase: mouseLocation];
    
    // 2. Construct fake event.
    
    int eventType = NSLeftMouseDown;
    
    NSEvent *fakeMouseEvent = [NSEvent mouseEventWithType:eventType
                                                 location:locationInWindow
                                            modifierFlags:0
                                                timestamp:0
                                             windowNumber:[newWindow windowNumber]
                                                  context:nil
                                              eventNumber:0
                                               clickCount:0
                                                 pressure:0];
   
    [NSMenu popUpContextMenu:m withEvent:fakeMouseEvent forView:(NSButton *)sender];
     
     */
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    NSMutableString *fname = [NSMutableString stringWithFormat:@"%@(%d-%ld)",[appDelegate selectedItem], 1,(unsigned long)[list count]];
    NSMutableString *content = [[NSMutableString alloc] init];
    
    //meta
    int i;
    for (i=0;i<[metalist count];i++)
    {
        NSString *identifier = [metalist objectAtIndex:i];
        [content appendString:[NSString stringWithFormat:@"%@,", identifier]];
    }
    
    NSRange range = NSMakeRange([content length]-1,1);
    [content replaceCharactersInRange:range withString:@"\n"];

    int a;
    ////NSLog(@"rr33 %ld",[list count]);

    for (a=0;a<[list count];a++)
    {
        ////NSLog(@"rr5");

        NSMutableDictionary *dc = [list objectAtIndex:a];
        
        int b;
        ////NSLog(@"mm33 %ld",[metalist count]);

        
        for (b=0;b<[metalist count];b++)
        {
            NSString *identifier = [metalist objectAtIndex:b];

            NSString *item = [dc valueForKey:identifier];
            [content appendString:[NSString stringWithFormat:@"%@,", item]];
        }
        //remove comma
        //[content deleteCharactersInRange:NSMakeRange([content length]-1, 1)];
        ////NSLog(content);
        NSRange range = NSMakeRange([content length]-1,1);
        [content replaceCharactersInRange:range withString:@"\n"];
       // //NSLog(content);

    }
    
    
    ////NSLog(content);
    
    [self saveFile:content ext:@"csv" name:fname];
    
    //NSMutableDictionary *dc = [list objectAtIndex:row];
   // NSString *identifier = [tableColumn identifier];
    //return [dc valueForKey:identifier];


}
@end
