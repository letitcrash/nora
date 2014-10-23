//
//  SourceListItem.m
//  PXSourceList
//
//  Created by Alex Rozanski on 08/01/2010.
//  Copyright 2010 Alex Rozanski http://perspx.com
//
//  GC-enabled code revised by Stefan Vogt http://byteproject.net
//

#import "SourceListItem.h"


@implementation SourceListItem

@synthesize title;
@synthesize identifier;
@synthesize icon;
@synthesize badgeValue;
@synthesize children;
@synthesize atype;

#pragma mark -
#pragma mark Init/Dealloc/Finalize

- (id)init
{
	if(self=[super init])
	{
		badgeValue = -1;	//We don't want a badge value by default
	}
	
	return self;
}


+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier
{	
	SourceListItem *item = [SourceListItem itemWithTitle:aTitle identifier:anIdentifier icon:nil];
	
	return item;
}



+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier type:(NSString*)aType  {
	SourceListItem *item = [[SourceListItem alloc] init];// autorelease];
	
	[item setTitle:aTitle];
	[item setIdentifier:anIdentifier];
	//[item setIcon:anIcon];
    [item setAtype:aType];
	
	return item;
}

+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier type:(NSString*)aType order:(NSNumber *)ord {
	SourceListItem *item = [[SourceListItem alloc] init];// autorelease];
	
	[item setTitle:aTitle];
	[item setIdentifier:anIdentifier];
	//[item setIcon:anIcon];
    [item setAtype:aType];
    [item setAorder:ord];
	return item;
}

+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier icon:(NSImage*)anIcon
{
	SourceListItem *item = [[SourceListItem alloc] init];
	
	[item setTitle:aTitle];
	[item setIdentifier:anIdentifier];
	[item setIcon:anIcon];
	
	return item;
}



#pragma mark -
#pragma mark Custom Accessors

- (BOOL)hasBadge
{
	return badgeValue!=-1;
}

-(void)shallRemove {
    self.isRemoving = YES;
}

- (BOOL)hasChildren
{
	return [children count]>0;
}

- (BOOL)hasIcon
{
	return icon!=nil;
}





#pragma mark -
#pragma mark Custom Accessors

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p | identifier = %@ | title = %@ >", [self class], self, self.identifier, self.title];
}
@end
