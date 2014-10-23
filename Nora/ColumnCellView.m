//
//  ColumnCellView.m
//  Nora
//
//  Created by Paul Smal on 5/27/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import "ColumnCellView.h"
#import "AppDelegate.h"

@implementation ColumnCellView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
        NSString *uuidString = [[NSUUID UUID] UUIDString];

        _cid = [[NSString alloc]initWithString:uuidString];
        
        


    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    
}


-(void)controlTextDidBeginEditing:(NSNotification *)obj {
    NSString *colName = [_colName stringValue];
    
    
    //create instance in for edit?
    NOTempObject *ty = [[NOTempObject alloc]init];
    ty.name = colName;
    ty.cid = _cid;
    ty.kind = @"column";
    ty.action = @"init";
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];

    [appDelegate insertColumn:ty];


}



- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
    
    NSInteger heTag = [aNotification.object tag];
    
    NOTempObject *temo = [[NOTempObject alloc]init];

    
    if(heTag == 0) {
        //name changed
        
        
    } else if (heTag == 1){
        //size changed

        temo.gotSize = YES;
    } else {
        //unknown
    }

    
    NSString *colName = [_colName stringValue];
    NSString *dataType = [_popUp titleOfSelectedItem];
    NSInteger colSize = [_colSize integerValue];

    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    temo.name = colName;
    temo.size = *(&(colSize));
    temo.type = dataType;
    temo.kind = @"column";
    temo.parent = [appDelegate selectedItem];
    temo.action = @"modify_2";
    temo.cid = _cid;
    

    
    [appDelegate insertColumn:temo];
    
    
    
}

- (IBAction)nullableSlect:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    NOTempObject *temo = [[NOTempObject alloc]init];
    NSString *type = [_popUp titleOfSelectedItem];
    NSString *colName = [_colName stringValue];
    NSInteger colSize = [_colSize integerValue];

    if([_isNULL state] == 1) {
        temo.name = colName;
        temo.size = *(&(colSize));
        temo.type = type;

        temo.kind = @"column";
        temo.parent = [appDelegate selectedItem];
        temo.action = @"modify";
        temo.cid = _cid;
        //temo.gotType = YES;
        temo.isNULL = YES;
    } else {
        temo.name = colName;
        temo.size = *(&(colSize));
        temo.type = type;

        temo.kind = @"column";
        temo.parent = [appDelegate selectedItem];
        temo.action = @"modify";
        temo.cid = _cid;
        //temo.gotType = YES;
        temo.isNULL = NO;

    }
    
    [appDelegate insertColumn:temo];


}
- (IBAction)typeSelected:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];

    NSString *type = [_popUp titleOfSelectedItem];
    NSString *colName = [_colName stringValue];
    NSInteger colSize = [_colSize integerValue];
    
    
    NOTempObject *temo = [[NOTempObject alloc]init];
    temo.name = colName;
    temo.size = *(&(colSize));
    temo.type = type;
    temo.kind = @"column";
    temo.parent = [appDelegate selectedItem];
    temo.action = @"modify";
    temo.cid = _cid;
    temo.gotType = YES;

    [appDelegate insertColumn:temo];
    

    
}


- (IBAction)pkSlect:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    NOTempObject *temo = [[NOTempObject alloc]init];
    NSString *type = [_popUp titleOfSelectedItem];
    NSString *colName = [_colName stringValue];
    NSInteger colSize = [_colSize integerValue];
    
    if([_isPK state] == 1) {
        temo.name = colName;
        temo.size = *(&(colSize));
        temo.type = type;
        
        temo.kind = @"column";
        temo.parent = [appDelegate selectedItem];
        temo.action = @"modify";
        temo.cid = _cid;
        //temo.gotType = YES;
        temo.isPrimaryKey = YES;
    } else {
        temo.name = colName;
        temo.size = *(&(colSize));
        temo.type = type;
        
        temo.kind = @"column";
        temo.parent = [appDelegate selectedItem];
        temo.action = @"modify";
        temo.cid = _cid;
        //temo.gotType = YES;
        temo.isPrimaryKey = NO;
        
    }
    
    [appDelegate insertColumn:temo];
    
    
}

-(NSString*)getColName {
    return [_colName stringValue];
}

-(void)awakeFromNib {
    //query to get all supportted data dypes TO_DO
    
    
    [_colName setDelegate:(id)self];
    
    [ _popUp addItemWithTitle:@"VARCHAR2"];
    [ _popUp addItemWithTitle:@"NUMBER"];
    [ _popUp addItemWithTitle:@"CLOB"];
    [ _popUp addItemWithTitle:@"DATE"];
    [ _popUp addItemWithTitle:@"BLOB"];
    
    [ _popUp addItemWithTitle:@"CHAR"];
    [ _popUp addItemWithTitle:@"NCHAR"];
    [ _popUp addItemWithTitle:@"NVARCHAR2"];
    [ _popUp addItemWithTitle:@"DATE"];
    [ _popUp addItemWithTitle:@"TIMESTAMP"];
    [ _popUp addItemWithTitle:@"INTERVAL YEAR"];
    [ _popUp addItemWithTitle:@"INTERVAL DAY"];
    
    [ _popUp addItemWithTitle:@"NCLOB"];
    [ _popUp addItemWithTitle:@"BFILE"];
    
    [ _popUp addItemWithTitle:@"LONG"];
    [ _popUp addItemWithTitle:@"LONG RAW"];
    [ _popUp addItemWithTitle:@"RAW"];
    
    [ _popUp addItemWithTitle:@"FLOAT"];
    [ _popUp addItemWithTitle:@"BINARY FLOAT"];
    [ _popUp addItemWithTitle:@"BINARY DOUBLE"];

    [ _popUp addItemWithTitle:@"ROWID"];
    [ _popUp addItemWithTitle:@"UROWID"];
    
    /*

    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    NSArray *types = [appDelegate getAllTypes];
    
    int a;
    for (a=0;a<[types count];a++)
    {
       // //NSLog(@"adding type %@",[types objectAtIndex:a] );
        [ _popUp addItemWithTitle:[types objectAtIndex:a]];
    }
*/
    

}

@end
