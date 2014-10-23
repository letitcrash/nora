//
//  TypeCellView.h
//  Nora
//
//  Created by Paul on 9/22/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TypeCellView : NSTableCellView


@property (retain) IBOutlet NSTextField *colName;
@property (retain) IBOutlet NSTextField *colType;
@property (retain) IBOutlet NSTextField *colLen;
@property (retain) IBOutlet NSTextField *colNum;

@end
