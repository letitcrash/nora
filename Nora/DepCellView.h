//
//  DepCellView.h
//  Nora
//
//  Created by Paul on 9/27/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DepCellView : NSTableCellView

@property (retain) IBOutlet NSTextField *rName;
@property (retain) IBOutlet NSTextField *rType;
@property (retain) IBOutlet NSTextField *owner;
@property (retain) IBOutlet NSTextField *name;
@property (retain) IBOutlet NSTextField *type;


@end
