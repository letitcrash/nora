//
//  PSTableView.h
//  Nora
//
//  Created by Paul Smal on 5/7/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PSTableView : NSTableView
{
    IBOutlet NSArrayController * relatedArrayController;
}

@end
