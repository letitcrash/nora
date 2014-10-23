//
//  ConnectionViewViewController.m
//  Nora
//
//  Created by Paul Smal on 3/27/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import "ConnectionViewViewController.h"
#import "AppDelegate.h"
#import "ocilib.h"

//@class AppDelegate;
@interface ConnectionViewViewController ()


@end

@implementation ConnectionViewViewController


@synthesize textField, sidl, passwordl, usernamel, hostl, portl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withIdent:(NSString *)ids withConfig:(NSString*)conf connected:(BOOL)isConnected
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        connName = [[NSString alloc] initWithFormat:@"%@",ids];
        config = [[NSString alloc] initWithFormat:@"%@",conf];
        
        _isConnected = isConnected;
        

    }
    
    return self;
}
- (void)pingResult:(NSNumber*)success {
    if (success.boolValue) {
        //[self log:@"SUCCESS"];
        //////////NSLog(@"SUCCESS");
    } else {
        ////////NSLog(@"FAILURE");
    }
}


- (IBAction)makeConnection:(id)sender {
    
    //TODO pass real connection parameters to appdelegate
    //or save before connect :)
    [self saveConnection:nil];
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    //[appDelegate connect];
    
    Connection *nc = [appDelegate->connections valueForKey:[textField stringValue]];
    
    
    int ver = [appDelegate connect: [passwordl stringValue]];
    if(ver > 0) {
        [_conbutt setTitle:@"Open"];
        [_delbutt setTitle:@"Disconnect"];
        [_delbutt setAction:@selector(disconnect:)];
        
        [_version setHidden:NO];
        
        [_version setStringValue:[NSString stringWithFormat:@"Oracle version %d ", ver]];
        //[_version setStringValue:[NSString stringWithFormat:@"Supported oracle version %d ", nc->actualUsername]];
        

    }
    
}

- (IBAction)disconnect:(id)sender {
    //////NSLog(@"ds c cl");
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    [appDelegate disconnect:[textField stringValue]];
    [_conbutt setTitle:@"Connect"];
    [_delbutt setTitle:@"Delete"];
    [_delbutt setAction:@selector(removeConnection:)];
    
    [_version setHidden:YES];
   // [_version setStringValue:@"Connection version 1120"];



}



- (IBAction)saveConnection:(id)sender
{
    ////////NSLog(@"Saving %@ ::: %ld", [textField stringValue], (long)[[_sidRadio selectedCell]tag]);
    NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile: config];

    NSInteger tag = [[_sidRadio selectedCell]tag];
    if([_issave state]) {
        ////////NSLog(@"SAV WT");
        
        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        [appDelegate saveConnection:connName ord:[[plist objectForKey:connName] objectAtIndex:0] name:[textField stringValue] user:[usernamel stringValue] pass:[passwordl stringValue] host:[hostl stringValue] port:[portl stringValue] sid:[sidl stringValue] tag:tag];

    } else {
        ////////NSLog(@"SAV WTOUT");
        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        [appDelegate saveConnection:connName ord:[[plist objectForKey:connName] objectAtIndex:0] name:[textField stringValue] user:[usernamel stringValue] pass:@"" host:[hostl stringValue] port:[portl stringValue] sid:[sidl stringValue] tag:tag];

        
    }
    
    
}


- (IBAction)removeConnection:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    [appDelegate removaMainAction:nil];
}



- (void)awakeFromNib {
    

    if(_isConnected) {
        [_conbutt setTitle:@"Open"];
        [_delbutt setTitle:@"Disconnect"];
        [_delbutt setAction:@selector(disconnect:)];
        [_version setHidden:NO];
        [_version setStringValue:@"Connection version 1120"];
    }
    else {
        ////////NSLog(@"not connected");
    }

    
  
    [_mainViewC setStartingColor:
     [NSColor colorWithCalibratedWhite:0.91 alpha:1.0]]; //64-88
    [_mainViewC setEndingColor:
     [NSColor colorWithCalibratedWhite:0.91 alpha:1.0]];
    [_mainViewC setAngle:270];

    

    
    // Here for subclasses to override.
    ////////NSLog(@"Awake %@", connName);
    ////////NSLog(@"Awake %@", config);
    

   // NSString *config = @"/Volumes/DATA/MacOra.plist";
   //
    NSMutableDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:config];
    //cid = [[plist objectForKey:connName] objectAtIndex:0];
    
    if(![[[plist objectForKey:connName] objectAtIndex:5] isEqual: @""]) {
        
        ////////NSLog(@"not ef nil");
        [_issave setState:1];
    }

    NSString *name = [[plist objectForKey:connName] objectAtIndex:1];
    NSString *address = [[plist objectForKey:connName] objectAtIndex:2];
    NSString *username = [[plist objectForKey:connName] objectAtIndex:3];
    NSString *password = [[plist objectForKey:connName] objectAtIndex:5];
    NSString *sid = [[plist objectForKey:connName] objectAtIndex:6];
    NSString *port = [[plist objectForKey:connName] objectAtIndex:4];
    NSString *isSID = [[plist objectForKey:connName] objectAtIndex:7];
    
    NSInteger fgg = [isSID integerValue];
    
    [_sidRadio selectCellWithTag:fgg];
    
     [usernamel setStringValue:username];
     [portl setStringValue:port];
     [sidl setStringValue:sid];
     [passwordl setStringValue:password];
     [hostl setStringValue:address];
    [textField setStringValue: name];
    



}


@end
