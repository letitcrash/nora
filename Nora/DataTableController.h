//
//  DataTableController.h
//  Nora
//
//  Created by Paul Smal on 6/3/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataTableController : NSObject  <NSTableViewDataSource, NSTableViewDelegate>{
    NSMutableArray *list;
}

@end
