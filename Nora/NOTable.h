//
//  NOTable.h
//  Nora
//
//  Created by Paul Smal on 5/23/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOTable : NSObject {
    NSMutableArray *cols;
    NSString *type;
    NSString *name;
    BOOL isTemp;
}

@property (strong) NSMutableArray *cols;
@property (strong) NSString *type;
@property (strong) NSString *name;

@end
