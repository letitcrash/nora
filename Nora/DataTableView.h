//
//  DataTableView.h
//  Nora
//
//  Created by Paul Smal on 6/3/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DataTableView : NSTableView <NSTableViewDataSource, NSTableViewDelegate> {
    NSMutableArray *list;
}

@end
