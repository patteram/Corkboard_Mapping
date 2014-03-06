//
//  CBMDocument.m
//  CoreDoc
//
//  Created by Ashley Patterson on 2/20/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMDocument.h"
#import "CBMMainWindowController.h"
#import "CBMSearchAndDisplayController.h"

@implementation CBMDocument
@synthesize cardAndThreadManager;
@synthesize typeManager;
@synthesize corkboard;
@synthesize createCardType;
@synthesize createThreadType;
@synthesize searchAndDisplay;
- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"CBMDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

-(void)makeWindowControllers{
   corkboard = [[CBMMainWindowController alloc]initWithWindowNibName:@"CBMDocument"];
   searchAndDisplay = [[CBMSearchAndDisplayController alloc]initWithWindowNibName:@"CBMSearchAndDisplayController"];
   [searchAndDisplay windowTitleForDocumentDisplayName:[self displayName]];
    cardAndThreadManager = [[CBMCardAndThreadManager alloc] initWithModelContext:[self managedObjectContext]];
    typeManager = [[CBMTypeManager alloc]initWithModelContext:[self managedObjectContext]]; 
    [self addWindowController:corkboard];
    [self addWindowController:searchAndDisplay];
}

-(void)close{
    
    [super close];
}
-(IBAction)showSearchAndDisplay:(id)sender{
    NSLog(@"SearchAndDisplay");
    
    if([searchAndDisplay isWindowVisible]){
        NSLog(@"Is Visible");
        [ searchAndDisplay setIsVisible:NO];
    }else{
        NSLog(@"Is Not Visible");
        [searchAndDisplay setIsVisible:YES];
    }
}
-(IBAction)createThreadType:(id)sender{
    
    
}
-(IBAction)createCardType:(id)sender{
    
}
@end
