//
//  ViewCellView.h
//  Nora
//
//  Created by Paul on 9/17/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewCellView :  NSTableCellView <NSTextFieldDelegate>

@property (retain) IBOutlet NSPopUpButton *popUp;
@property (retain) IBOutlet NSTextField *colName;
@property (retain) IBOutlet NSTextField *colSize;
@property (strong) NSString *cid;

@property (retain) IBOutlet NSButton *isNULL;
@property (retain) IBOutlet NSButton *isPK;

@end
