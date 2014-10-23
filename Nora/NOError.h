//
//  NOError.h
//  Nora
//
//  Created by Paul Smal on 5/14/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOError : NSObject



@property (copy) NSString *title;
@property (readonly, copy) NSMutableArray *children;

- (id)initWithName:(NSString *)name;
- (void)addChild:(NOError *)e;

@end
