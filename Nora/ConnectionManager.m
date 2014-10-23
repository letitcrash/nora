//
//  ConnectionManager.m
//  Nora
//
//  Created by Paul Smal on 4/27/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import "ConnectionManager.h"

@implementation ConnectionManager



#pragma mark Singleton Methods

+ (id)sharedManager {
    static ConnectionManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
       // [sharedMyManager setConnectionInstance:nil];
        sharedMyManager->cnarray[0] = nil;

        
    });
    return sharedMyManager;
}


- (id)init {
    if (self = [super init]) {
       // someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
      // table = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end