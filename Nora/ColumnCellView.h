//
//  ColumnCellView.h
//  Nora
//
//  Created by Paul Smal on 5/27/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ColumnCellView : NSTableCellView <NSTextFieldDelegate> 

@property (retain) IBOutlet NSPopUpButton *popUp;
@property (retain) IBOutlet NSTextField *colName;
@property (retain) IBOutlet NSTextField *colSize;
@property (strong) NSString *cid;

@property (retain) IBOutlet NSButton *isNULL;
@property (retain) IBOutlet NSButton *isPK;


-(NSString*)getColName;
- (IBAction)typeSelected:(id)sender;
- (IBAction)nullableSlect:(id)sender;
- (IBAction)pkSlect:(id)sender;

@end
