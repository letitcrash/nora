//
//  NOColumn.h
//  Nora
//
//  Created by Paul Smal on 5/23/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOColumn : NSObject {

    NSInteger *size;
    BOOL isNull;
    BOOL isPK;
    
}
@property (strong) NSString *name;
@property (strong) NSString *type;
@property (assign) long *size;
@property (assign) BOOL *isNULL;


@end
