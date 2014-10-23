//
//  NOError.m
//  Nora
//
//  Created by Paul Smal on 5/14/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import "NOError.h"

@implementation NOError

- (id)init {
    return [self initWithName:@"Test Name"];
}

- (id)initWithName:(NSString *)name{
    self = [super init];
    if (self) {
        _title = [name copy];
        _children = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addChild:(NSError *)e {
    [_children addObject:e];
}


@end
