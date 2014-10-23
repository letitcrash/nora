//
//  IndexViewController.h
//  Nora
//
//  Created by Paul on 9/13/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ColorGradientView.h"
@class MGSFragaria;


@interface IndexViewController : NSViewController {
    IBOutlet NSView *editView;
	MGSFragaria *fragaria;

}


@property (weak) IBOutlet ColorGradientView *topbar;
@property (weak) IBOutlet NSButton *coloutlet;
@property (weak) IBOutlet NSButton *optoutlet;
@property (weak) IBOutlet NSTabView *tabv;
@property (unsafe_unretained) IBOutlet NSTextView *codeTextView;
@property (weak) IBOutlet NSTextField *dateCreated;
@property (weak) IBOutlet NSTextField *dateDDL;
@property (weak) IBOutlet NSTextField *status;
@property (weak) IBOutlet NSTextField *name;

@property (weak) IBOutlet NSTableView *coltb;
- (IBAction)colaction:(id)sender;
- (IBAction)optAction:(id)sender;
- (IBAction)refresh:(id)sender;

@end
