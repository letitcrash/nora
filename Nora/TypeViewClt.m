//
//  TypeViewClt.m
//  Nora
//
//  Created by Paul on 9/17/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import "TypeViewClt.h"
#import "ocilib.h"
#import "AppDelegate.h"
#import "ColumnCellView.h"
#import "ConnectionManager.h"
#import "TypeCellView.h"
@interface TypeViewClt ()

@end

@implementation TypeViewClt


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
    
    
    [_codeButton setState:0];
    [_propButton setState:0];
      

    
}


- (IBAction)codeAction:(id)sender {
    
    [_tableTabsView selectTabViewItemAtIndex:1];
    
    [_colButton setState:0];
    [_propButton setState:0];
        

}

- (IBAction)propAction:(id)sender {
    
    [_tableTabsView selectTabViewItemAtIndex:2];
    
    
    [_colButton setState:0];
    [_codeButton setState:0];
     

    
    
    
}




- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    

        NSMutableDictionary *dc = [list objectAtIndex:row];
        NSString *identifier = [tableColumn identifier];
        
        //    //NSLog(@"returning col  %@" , [dc valueForKey:identifier]);
        
        return [dc valueForKey:identifier];

}

- (NSView *)tableView:(NSTableView *)tableViewLoc viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

        
        TypeCellView *tableCellView = [tableViewLoc makeViewWithIdentifier:[tableColumn identifier] owner:nil];
        
        NSMutableDictionary *dc = [list objectAtIndex:row];
        //  //NSLog(@"setting cid %@", [dc valueForKey:@"CID"]);
        //tableCellView.cid = [dc valueForKey:@"CID"];
        
        ///
    
        
       // return [dc valueForKey:identifier];
        
    [[tableCellView colName] setStringValue:[dc valueForKey:@"ATTR_NAME"]];
    [[tableCellView colType] setStringValue:[dc valueForKey:@"ATTR_TYPE_NAME"]];
    [[tableCellView colNum] setStringValue:[dc valueForKey:@"ATTR_NO"]];
    [[tableCellView colLen] setStringValue:[dc valueForKey:@"LENGTH"]];

    
           
     
     return tableCellView;

}




-(void)refresh
{

    
}






- (void)awakeFromNib
{
    colCountIndex = 1; //start adding columns from 1
    dCountIndex = 1; //start data rows from 1
    
    list = [[NSMutableArray alloc] init];

    
    [_tableTabsView selectTabViewItemAtIndex:0];
    
    [_codeButton setState:0];
    [_propButton setState:0];
        
       
    [_colButton setState:1];
    
    
       
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    //  Connection *cnn = [[appDelegate connections] valueForKey:cname];
    // NSMutableDictionary *dc = [cnn getTempObjects];
    
    NSString *objName = [appDelegate selectedItem];
    
    
    
    if ([appDelegate ifObjectInTemp:objName]) {
        //temp
        
        
        
        //colList = [appDelegate getTempTableColumns:objName];
        
        
        
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
            
            query = [NSString stringWithFormat:@"select * from user_type_attrs where type_name like '%@'", [appDelegate selectedItem]];
            
            
        } else {
            // //NSLog(@"using user %@ " , [_username stringValue]);
            
            query = [NSString stringWithFormat:@"select * from all_type_attrs where type_name like '%@'", [appDelegate selectedItem]];
            
        }
        
        //NSString *query = [NSString stringWithFormat:@"select * from user_type_attrs where type_name like '%@'", objName];
        
        
        OCI_ExecuteStmt(st, [query UTF8String] );
        
        OCI_Resultset *rs = OCI_GetResultset(st);
        
        int n = OCI_GetColumnCount(rs);
        //data
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
                
                OCI_Column *col = OCI_GetColumn(rs, p);
                NSString *conName= [NSString stringWithUTF8String:OCI_ColumnGetName(col)];
                
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
        
        //getting type code and options
              
        
        OCI_Statement *sti = OCI_StatementCreate(cn);
        
        
        NSString *indexQ = [NSString stringWithFormat:@"select text from user_source where name like '%@'", [appDelegate selectedItem]];
        
        
        
        OCI_ExecuteStmt(sti, [indexQ UTF8String] );
        
        OCI_Resultset *rsi = OCI_GetResultset(sti);
        
        
        while (OCI_FetchNext(rsi)) {
            
            NSString *objText = [NSString stringWithUTF8String:OCI_GetString(rsi, 1)];
            
            [_codeView setString:objText];
        }
        

        
        OCI_Statement *stc = OCI_StatementCreate(cn);
        
        
        NSString *indexC = [NSString stringWithFormat:@"select typecode from user_types where type_name like '%@'", objName];
        
        
        
        OCI_ExecuteStmt(stc, [indexC UTF8String] );
        
        OCI_Resultset *rsc = OCI_GetResultset(stc);
        
        
              
        while (OCI_FetchNext(rsc)) {
            if(OCI_GetString(rsc, 1) != nil) {
                [_type setStringValue:[NSString stringWithUTF8String:OCI_GetString(rsc, 1)]];
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
    
    // [appDelegate reload];
    [appDelegate loadSourceList];
}





- (IBAction)commitAction:(id)sender {
    
       
}

- (IBAction)rollBackAction:(id)sender {
    [self awakeFromNib];
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];

    [appDelegate loadSourceList];
}

@end
