//
//  IndexCellView.h
//  Nora
//
//  Created by Paul Smal on 6/28/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IndexCellView : NSTableCellView <NSTextFieldDelegate>

@property (retain) IBOutlet NSTextField *colName;
@property (retain) IBOutlet NSTextField *tabName;
@property (retain) IBOutlet NSTextField *position;
@property (retain) IBOutlet NSTextField *descend;

@property (strong) NSString *cid;




@end