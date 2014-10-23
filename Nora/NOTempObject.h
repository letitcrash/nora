//
//  NOTempObject.h
//  Nora
//
//  Created by Paul Smal on 5/23/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOTempObject : NSObject {

   // BOOL isTemp;
  //  NSString *cid;
}

@property (strong) NSMutableArray *cols;
@property (strong) NSString *type;
@property (strong) NSString *kind;
@property (strong) NSString *name;
@property (strong) NSString *action;
@property (strong) NSString *originalname;
@property (strong) NSString *parent;
@property (assign) NSInteger size;
@property (assign) BOOL isNULL;
@property (assign) NSInteger originalState;
@property (assign) BOOL gotOriginalName;
@property (assign) BOOL gotType;
@property (assign) BOOL gotSize;
@property (assign) BOOL isTEMP;
@property (assign) BOOL isPrimaryKey;

@property (strong) NSString *cid;


@end
