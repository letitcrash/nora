//
//  Connection.h
//  Nora
//
//  Created by Paul Smal on 4/11/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SourceListItem.h"
#import "ocilib.h"
#import "NOTempObject.h"

@interface Connection : NSObject {
    NSMutableArray *tables ;
    NSMutableArray *_users ;
    NSMutableArray *views;
    NSMutableArray *indexes;
    NSMutableArray *functions;
    NSMutableArray *queries;
    NSMutableArray *types;
    @public NSString *viewMode;
    NSString *cid;
    NSString *originalUsername;
    NSString *actualUsername;
    NSMutableDictionary *qviews;
    NSMutableDictionary *cviews;
    NSMutableDictionary *tviews;
    NSMutableDictionary *tpviews;
    NSMutableDictionary *iviews;
    NSMutableDictionary *fviews;
    NSMutableDictionary *vviews;
    NSMutableDictionary *tempObjects;
    NSMutableArray *objToDrop;
    NSMutableArray *objToModify;
    int cnid;

}
@property (strong) NSMutableArray  *qNames;

-(void)addUsers:(NSMutableArray *)users;
- (void)addTables:(NSMutableArray *)table;
- (void)addTempObjects:(NSMutableDictionary *)objects;
- (void)addViews:(NSMutableArray *)view;
- (void)addIndexes:(NSMutableArray *)index;
- (void)addFunctions:(NSMutableArray *)func;
- (void)addTypes:(NSMutableArray *)types;
- (void)addObjectToDrop:(NOTempObject *)objName;
- (void)addObjectToModify:(NOTempObject *)objName;
- (void)setCID:(NSString*)lcid;

-(void)purgeTempObjects;
-(void)purgeObjectsToDrop;
-(void)purgeObjectsToModify;

- (void)addCView:(NSViewController *)view forID:(NSString*)ident;
- (void)addQView:(NSViewController *)view forID:(NSString*)ident;
- (void)addTView:(NSViewController *)view forID:(NSString*)ident;
- (void)addTPView:(NSViewController *)view forID:(NSString*)ident;
- (void)addIView:(NSViewController *)view forID:(NSString*)ident;
- (void)addVView:(NSViewController *)view forID:(NSString*)ident;
- (void)addFView:(NSViewController *)view forID:(NSString*)ident;
- (void)setSavedMode:(NSString *)mode;

-(NSMutableArray *)getTables;
-(NSMutableArray *)getUsers;

-(NSMutableDictionary *)getTempObjects;
-(NSMutableArray *)getTypes;
-(NSMutableArray *)getViews;
-(NSMutableArray *)getUserIndexes;
-(NSMutableArray *)getUserFuncs;
-(NSMutableArray *)getObjectsToDrop;
-(NSMutableArray *)getObjectsToModify;
- (NSString*)getCID;
- (int)getCNID;



-(NSMutableDictionary *)getCViews;
-(NSMutableDictionary *)getQViews;
-(NSMutableDictionary *)getTViews;
-(NSMutableDictionary *)getTPViews;
-(NSMutableDictionary *)getIViews;
-(NSMutableDictionary *)getVViews;
-(NSMutableDictionary *)getFViews;

@end
