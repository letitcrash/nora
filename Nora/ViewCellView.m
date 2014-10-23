//
//  ViewCellView.m
//  Nora
//
//  Created by Paul on 9/17/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import "ViewCellView.h"

@implementation ViewCellView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}



-(void)awakeFromNib {
    //query to get all supportted data dypes TO_DO
    
    
    
    
    [_colName setDelegate:(id)self];
    
    [ _popUp addItemWithTitle:@"VARCHAR2"];
    [ _popUp addItemWithTitle:@"BLOB"];
    [ _popUp addItemWithTitle:@"CLOB"];
    [ _popUp addItemWithTitle:@"DATE"];
    [ _popUp addItemWithTitle:@"NUMBER"];
    [ _popUp addItemWithTitle:@"CHAR"];
    [ _popUp addItemWithTitle:@"RAW"];
    [ _popUp addItemWithTitle:@"LONG"];
    
}
@end
