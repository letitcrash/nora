//
//  ConnectionViewViewController.h
//  Nora
//
//  Created by Paul Smal on 3/27/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PXSourceList.h"
#import "AppDelegate.h"
#import "ColorGradWithShadow.h"

@interface ConnectionViewViewController : NSViewController
{
    NSString *connName;
    NSString *config;
	NSString *cid;
	NSMutableArray *sourceListItems;
    BOOL _isConnected;

}
@property (strong) IBOutlet ColorGradWithShadow *mainViewC;
@property (weak) IBOutlet NSButton *issave;

@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSTextField *version;
@property (weak) IBOutlet NSTextField *usernamel;
@property (weak) IBOutlet NSTextField *passwordl;
@property (weak) IBOutlet NSTextField *hostl;
@property (weak) IBOutlet NSTextField *portl;
@property (weak) IBOutlet NSTextField *sidl;
@property (weak) IBOutlet NSBox *box;
@property (weak) IBOutlet NSMatrix *sidRadio;
@property (weak) IBOutlet NSButton *conbutt;
@property (weak) IBOutlet NSButton *delbutt;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withIdent:(NSString *)ids withConfig:(NSString*)conf connected:(BOOL)isConnected;


- (IBAction)removeConnection:(id)sender;
- (IBAction)makeConnection:(id)sender;
- (IBAction)saveConnection:(id)sender;

@end
