//
//  Connection.m
//  Nora
//
//  Created by Paul Smal on 4/11/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import "Connection.h"
#import "SourceListItem.h"

@implementation Connection

-(void)addTables:(NSMutableArray *)table {
    
    tables = table;//[[NSMutableArray alloc] init];
}

-(void)addUsers:(NSMutableArray *)users {
    
    _users = users;
}
-(void)addTempObjects:(NSMutableDictionary *)objects {
    
    tempObjects = objects;//[[NSMutableArray alloc] init];
}
-(void)addTypes:(NSMutableArray *)typesTab {
    
    types = typesTab;//[[NSMutableArray alloc] init];
}

-(void)addViews:(NSMutableArray *)vi {
    
    views = vi;
}

-(void)addIndexes:(NSMutableArray *)ind {
    
    indexes = ind;
}

-(void)addFunctions:(NSMutableArray *)func {
    
    functions = func;
}

- (void)addObjectToDrop:(NSString *)objName {
    [objToDrop addObject:objName];
    
}
-(NSMutableArray *)getObjectsToDrop {
    return objToDrop;
}

- (void)addObjectToModify:(NSString *)objName {
    [objToModify addObject:objName];
    
}
-(NSMutableArray *)getObjectsToModify {
    return objToModify;
}

-(void)purgeTempObjects {
    [tempObjects removeAllObjects];
}
-(void)purgeObjectsToDrop {
    [objToDrop removeAllObjects];
}
-(void)purgeObjectsToModify {
    [objToModify removeAllObjects];
}


-(NSMutableArray *)getTables {
    return tables;
}

-(NSMutableArray *)getUsers {
    return _users;
}
-(NSMutableArray *)getTypes {
    return types;
}

-(NSMutableArray *)getViews {
    return views;
}

-(NSMutableArray *)getUserIndexes {
    return indexes;
}

-(NSMutableArray *)getUserFuncs {
    return functions;
}
-(id)init
{
    if (self = [super init]) {
        cviews = [[NSMutableDictionary alloc] init];
        qviews = [[NSMutableDictionary alloc] init];
        tviews = [[NSMutableDictionary alloc] init];
        tpviews = [[NSMutableDictionary alloc] init];
        iviews = [[NSMutableDictionary alloc] init];
        fviews = [[NSMutableDictionary alloc] init];
        vviews = [[NSMutableDictionary alloc] init];
        
        tempObjects = [[NSMutableDictionary alloc] init];
        objToDrop = [[NSMutableArray alloc]init];
        objToModify = [[NSMutableArray alloc]init];
        cid = [[NSString alloc]init];
        _qNames = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)setCID:(NSString*)lcid
{
    cid = lcid;
}
- (NSString*)getCID {
    return cid;
}
- (int)getCNID {
    return cnid;
}


- (void)addCView:(NSViewController *)view forID:(NSString*)ident
{
    [cviews setValue:view forKey:ident];
}
- (void)addQView:(NSViewController *)view forID:(NSString*)ident
{
    [qviews setValue:view forKey:ident];
}
- (void)addTView:(NSViewController *)view forID:(NSString*)ident
{
    [tviews setValue:view forKey:ident];
}
- (void)addTPView:(NSViewController *)view forID:(NSString*)ident
{
    [tpviews setValue:view forKey:ident];
}
- (void)addVView:(NSViewController *)view forID:(NSString*)ident
{
    [vviews setValue:view forKey:ident];
}
- (void)addIView:(NSViewController *)view forID:(NSString*)ident
{
    [iviews setValue:view forKey:ident];
}
- (void)addFView:(NSViewController *)view forID:(NSString*)ident
{
    [fviews setValue:view forKey:ident];
}





////
-(NSMutableDictionary *)getCViews
{
    return cviews;
}

-(NSMutableDictionary *)getIViews
{
    return iviews;
}

-(NSMutableDictionary *)getTViews
{
    return tviews;
}

-(NSMutableDictionary *)getFViews
{
    return fviews;
}

-(NSMutableDictionary *)getVViews
{
    return vviews;
}

-(NSMutableDictionary *)getTPViews
{
    return tpviews;
}
-(NSMutableDictionary *)getQViews
{
    return qviews;
}
/////


-(NSMutableDictionary *)getTempObjects
{
    return tempObjects;
}



@end
