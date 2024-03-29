//
//  SourceListItem.h
//  PXSourceList
//
//  Created by Alex Rozanski on 08/01/2010.
//  Copyright 2010 Alex Rozanski http://perspx.com
//

#import <Cocoa/Cocoa.h>

/*An example of a class that could be used to represent a Source List Item
 
 Provides a title, an identifier, and an icon to be shown, as well as a badge value and a property to determine
 whether the current item has a badge or not (`badgeValue` is set to -1 if no badge is shown)
 
 Used to form a hierarchical model of SourceListItem instances – similar to the Source List tree structure
 and easily accessible by the data source with the "children" property
 
 SourceListItem *parent
  - SourceListItem *child1;
  - SourceListItem *child2;
     - SourceListItem *childOfChild2;
	 - SourceListItem *anotherChildOfChild2;
  - SourceListItem *child3;
 
 */

@interface SourceListItem : NSObject {
	NSString *title;
	NSString *identifier;
	NSImage *icon;
	NSInteger badgeValue;
    NSString *atype;
  //  BOOL *isRemoving;

	NSArray *children;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *atype;
@property (nonatomic, copy) NSNumber *aorder;
@property (nonatomic) BOOL isRemoving;

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) NSImage *icon;
@property NSInteger badgeValue;

@property (nonatomic, copy) NSArray *children;

//Convenience methods
+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier;
+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier icon:(NSImage*)anIcon;
+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier type:(NSString*)aType order:(NSNumber*)ord;
+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier type:(NSString*)aType;
-(void)shallRemove;

- (BOOL)hasBadge;
- (BOOL)hasChildren;
- (BOOL)hasIcon;

@end
