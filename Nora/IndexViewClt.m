//
//  IndexViewClt.m
//  Nora
//
//  Created by Paul on 9/17/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import "IndexViewClt.h"
#import "ocilib.h"
#import "AppDelegate.h"
#import "ColumnCellView.h"
#import "ConnectionManager.h"

@interface IndexViewClt ()

@end

@implementation IndexViewClt


@synthesize topBar;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withConn:(OCI_Connection *)conn
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
        return [list count];
}




- (IBAction)colButtAction:(id)sender {
    [_tableTabsView selectTabViewItemAtIndex:0];
    
    
    [_propButton setState:0];
    

    
}


- (IBAction)propButtonAction:(id)sender {
        
    [_tableTabsView selectTabViewItemAtIndex:1];
    
    [_colButton setState:0];
      
}



///////////////////////////////////////////
///////////////////////////////////////////
//////////  Table Delegates ////////////////
///////////////////////////////////////////



- (NSView *)tableView:(NSTableView *)tableViewLoc viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    

        IndexCellView *tableCellView = [tableViewLoc makeViewWithIdentifier:[tableColumn identifier] owner:nil];
        
        NSMutableDictionary *dc = [list objectAtIndex:row];
        
        
        [[tableCellView colName] setStringValue:[dc valueForKey:@"COLUMN_NAME"]];
        [[tableCellView position] setStringValue:[dc valueForKey:@"COLUMN_POSITION"]];
        [[tableCellView descend] setStringValue:[dc valueForKey:@"DESCEND"]];
        [[tableCellView tabName] setStringValue:[dc valueForKey:@"TABLE_NAME"]];
    
    return tableCellView;
        
}




- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    //noactions
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    //no actions
}





- (void)awakeFromNib
{
    colCountIndex = 1; //start adding columns from 1
    dCountIndex = 1; //start data rows from 1
    
    [_tableTabsView selectTabViewItemAtIndex:0];


    [_colButton setState:1];
    
    

    list = [[NSMutableArray alloc]init];
    
    [list removeAllObjects];
    
    
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    NSString *objName = [appDelegate selectedItem];
    
    
    
    if ([appDelegate ifObjectInTemp:objName]) {
        
        
        // colList = [appDelegate getTempTableColumns:objName];
        
        
        
    }
    else {
        
        OCI_Connection *cn;
        
        ConnectionManager *cm = [ConnectionManager sharedManager];
        
        NSString *cname = [[appDelegate cnButt] title];
        
        int cnid = [[appDelegate->connections objectForKey:cname] getCNID];
        
        cn = cm->cnarray[cnid];
        
        
        OCI_Statement *st = OCI_StatementCreate(cn);
        
        Connection *nconn = [appDelegate->connections valueForKey:cname];
        
        NSString *query;
        if(![nconn->actualUsername length] > 0) {
            // def user
            
            // //NSLog(@"def user / l: %@ " , [_username stringValue]);
            
            query = [NSString stringWithFormat:@"select * from user_ind_columns where index_name like '%@'", [appDelegate selectedItem]];
            
            
        } else {
            // //NSLog(@"using user %@ " , [_username stringValue]);
            
            query = [NSString stringWithFormat:@"select * from all_ind_columns where index_name like '%@'", [appDelegate selectedItem]];
            
        }
        
        OCI_ExecuteStmt(st, [query UTF8String] );
        
        OCI_Resultset *rs = OCI_GetResultset(st);
        
        int n = OCI_GetColumnCount(rs);
                   
        int p;
        int count = 1;
                
        while (OCI_FetchNext(rs))
        {
            NSMutableDictionary *dc = [[NSMutableDictionary alloc] init];
            // [dc removeAllObjects];
            NSNumber *num = [NSNumber numberWithInt:count];
            [dc setValue:num forKey:@"First"];
            [dc setValue:@"E" forKey:@"__RowState"];
            
            count++;
            
            for(p = 1; p <= n; p++)
            {
                NSString *obj ;
                if(OCI_IsNull(rs, p) )
                {
                    obj = [NSString stringWithFormat:@"(null)"];
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
                    // printf("col %s\n", OCI_ColumnGetName(col));
                    
                    [dc setValue:obj forKey:conName];
                }
                else{
                    [dc setValue:[NSString stringWithFormat:@"NULL"] forKey:conName];
                }
                
            }
            [list addObject:dc];
        }
        
        
        
        
        //зкщзы
        
        
        NSString *query2 = [NSString stringWithFormat:@"select index_type, table_owner, table_name, uniqueness, compression, logging, last_analyzed, num_rows, sample_size from user_indexes where index_name like '%@'", [appDelegate selectedItem]];
        
        
        OCI_ExecuteStmt(st, [query2 UTF8String] );
        
        OCI_Resultset *rs2 = OCI_GetResultset(st);
        

        
        while (OCI_FetchNext(rs2))
        {
            if(OCI_IsNull(rs2, 1))
            {
                [_type setStringValue:[NSString stringWithFormat:@"NULL"]];
            }
            else
            {
                [_type setStringValue:[NSString stringWithUTF8String:OCI_GetString(rs2,1)]];
            }
            if(OCI_IsNull(rs2, 2))
            {
                [_tname setStringValue:[NSString stringWithFormat:@"NULL"]];
            }
            else
            {
                [_tname setStringValue:[NSString stringWithUTF8String:OCI_GetString(rs2,2)]];
            }
            if(OCI_IsNull(rs2, 3))
            {
                [_towner setStringValue:[NSString stringWithFormat:@"NULL"]];
            }
            else
            {
                [_towner setStringValue:[NSString stringWithUTF8String:OCI_GetString(rs2,3)]];
            }
            if(OCI_IsNull(rs2, 4))
            {
                [_uniq setStringValue:[NSString stringWithFormat:@"NULL"]];
            }
            else
            {
                [_uniq setStringValue:[NSString stringWithUTF8String:OCI_GetString(rs2,4)]];
            }
            if(OCI_IsNull(rs2, 5))
            {
                [_compress setStringValue:[NSString stringWithFormat:@"NULL"]];
            }
            else
            {
                [_compress setStringValue:[NSString stringWithUTF8String:OCI_GetString(rs2,5)]];
            }
            if(OCI_IsNull(rs2, 6))
            {
                [_logging setStringValue:[NSString stringWithFormat:@"NULL"]];
            }
            else
            {
                [_logging setStringValue:[NSString stringWithUTF8String:OCI_GetString(rs2,6)]];
            }
            if(OCI_IsNull(rs2, 7))
            {
                [_analyzed setStringValue:[NSString stringWithFormat:@"NULL"]];
            }
            else
            {
                [_analyzed setStringValue:[NSString stringWithUTF8String:OCI_GetString(rs2,7)]];
            }
            if(OCI_IsNull(rs2, 8))
            {
                [_numrows setStringValue:[NSString stringWithFormat:@"NULL"]];
            }
            else
            {
                [_numrows setStringValue:[NSString stringWithUTF8String:OCI_GetString(rs2,8)]];
            }
            if(OCI_IsNull(rs2, 9))
            {
                [_ssize setStringValue:[NSString stringWithFormat:@"NULL"]];
            }
            else
            {
                [_ssize setStringValue:[NSString stringWithUTF8String:OCI_GetString(rs2,9)]];
            }

        }
        
        
    }
    
    
    NSDictionary *props = [appDelegate getObjectProperties: objName];
        
    [_status setStringValue:[props objectForKey:@"STATUS"]];
    [_dateCreated setStringValue:[props objectForKey:@"DATECREATED"]];
    [_lastddl setStringValue:[props objectForKey:@"LASTDDL"]];
    [_name setStringValue:objName];

    
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
    
    
    
}




- (IBAction)refreshAction:(id)sender {
    [self awakeFromNib];
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    [appDelegate loadSourceList];
}



- (IBAction)commitAction:(id)sender {
   //TODO
}

- (IBAction)rollBackAction:(id)sender {
    [self awakeFromNib];
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    NSString *identifier = [[appDelegate cnButt] title];

    [appDelegate loadSourceList];
}


@end
