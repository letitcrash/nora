//
//  IndexViewController.m
//  Nora
//
//  Created by Paul on 9/13/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import "IndexViewController.h"
#import "ocilib.h"
#import "ConnectionManager.h"
#import "AppDelegate.h"
#import "MGSFragaria/MGSFragaria.h"


@interface IndexViewController ()

@end

@implementation IndexViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)setSyntaxDefinition:(NSString *)name
{
	[fragaria setObject:name forKey:MGSFOSyntaxDefinitionName];
}



-(void)awakeFromNib {
    
    
    // create an instance
	fragaria = [[MGSFragaria alloc] init];
	
	[fragaria setObject:self forKey:MGSFODelegate];
	
	// define our syntax definition
	[self setSyntaxDefinition:@"SQL"];
	
	// embed editor in editView
	[fragaria embedInView:editView];
	
    //
	// assign user defaults.
	// a number of properties are derived from the user defaults system rather than the doc spec.
	//
	// see MGSFragariaPreferences.h for details
	//
    
	
	// define initial document configuration
	//
	// see MGSFragaria.h for details
	//
    if (YES) {
        [fragaria setObject:[NSNumber numberWithBool:YES] forKey:MGSFOIsSyntaxColoured];
        [fragaria setObject:[NSNumber numberWithBool:YES] forKey:MGSFOShowLineNumberGutter];
    }
    
    // set text
	//[fragaria setString:@"select * from EMP"];
	
    
	// access the NSTextView
	NSTextView *textView = [fragaria objectForKey:ro_MGSFOTextView];
	
    
    
    [textView setFont:[NSFont fontWithName:@"Menlo" size:11]];

    
    [_tabv selectTabViewItemAtIndex:0];

    [_topbar setStartingColor:
     [NSColor colorWithCalibratedWhite:0.98 alpha:1.0]]; //64-88
    [_topbar setEndingColor:
     [NSColor colorWithCalibratedWhite:0.88 alpha:1.0]];
    [_topbar setAngle:270];
    [_coltb setBackgroundColor:[NSColor colorWithCalibratedWhite:0.96 alpha:1.0]];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    OCI_Connection *cn;
    ConnectionManager *cm = [ConnectionManager sharedManager];
    NSString *cname = [[appDelegate cnButt] title];
    
    int cnid = [[appDelegate->connections objectForKey:cname] getCNID];
    
    cn = cm->cnarray[cnid];
    
    
    OCI_Statement *st = OCI_StatementCreate(cn);
    
    NSString *objName = [appDelegate selectedItem];
    NSString *query = [NSString stringWithFormat:@"select text from user_source where name like '%@'", objName];
    
    
    OCI_ExecuteStmt(st, [query UTF8String] );
    
    OCI_Resultset *rsi = OCI_GetResultset(st);

    NSMutableString *text = [NSMutableString stringWithString:@"\n"];
    
    while (OCI_FetchNext(rsi)) {
        
        NSString *objText = [NSString stringWithUTF8String:OCI_GetString(rsi, 1)];
        
        [text appendString:objText];
    }
    
    [textView setString:text];
    
    
    
    //populating properties
    
    NSDictionary *props = [appDelegate getObjectProperties: objName];
    [_status setStringValue:[props objectForKey:@"STATUS"]];
    [_dateCreated setStringValue:[props objectForKey:@"DATECREATED"]];
    [_dateDDL setStringValue:[props objectForKey:@"LASTDDL"]];
    [_name setStringValue:objName];

}
- (IBAction)refresh:(id)sender {
    //TO_DO
}

- (IBAction)colaction:(id)sender {
    [_tabv selectTabViewItemAtIndex:0];
    
    [_optoutlet setState:0];
}

- (IBAction)optAction:(id)sender {
    [_tabv selectTabViewItemAtIndex:1];
    
    [_coloutlet setState:0];
}
@end
