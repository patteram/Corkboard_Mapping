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
#import "CBMCreateCardTypeController.h"

@implementation CBMDocument
@synthesize cardAndThreadManager;
@synthesize typeManager;
@synthesize corkboard;
@synthesize createThreadType;
@synthesize searchAndDisplay;
@synthesize createCardType;
@synthesize theState;
- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        theState = [[CBMState alloc]init]; 
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
    createCardType = nil;
   corkboard = [[CBMMainWindowController alloc]initWithWindowNibName:@"CBMDocument"];
   searchAndDisplay = [[CBMSearchAndDisplayController alloc]initWithWindowNibName:@"CBMSearchAndDisplayController"];
   [searchAndDisplay windowTitleForDocumentDisplayName:[self displayName]];
    cardAndThreadManager = [[CBMCardAndThreadManager alloc] initWithModelContext:[self managedObjectContext]];
    typeManager = [[CBMTypeManager alloc]initWithModelContext:[self managedObjectContext]]; 
    [self addWindowController:corkboard];
    [self addWindowController:searchAndDisplay];
}

-(IBAction)showSearchAndDisplay:(id)sender{
    if([searchAndDisplay isWindowVisible]){
        [ searchAndDisplay setIsVisible:NO];
    }else{
        [searchAndDisplay setIsVisible:YES];
    }
}
-(IBAction)createThreadType:(id)sender{
    NSLog(@"create Thread Type");
    if(createThreadType != nil){
        if([[self windowControllers] containsObject:createThreadType]){
            [[createThreadType window] orderFrontRegardless];
        }else{
            createThreadType = [[CBMCreateThreadTypeController alloc]initWithWindowNibName:@"CBMCreateThreadTypeController"];
            [self addWindowController:createThreadType];
            [[createThreadType window] orderFront:self];
        }
    }else{
        createThreadType = [[CBMCreateThreadTypeController alloc]initWithWindowNibName:@"CBMCreateThreadTypeController"];
        [self addWindowController:createThreadType];
        [[createThreadType window] orderFront:self];
    }

    
}
-(void)close{
    searchAndDisplay = nil;
    corkboard = nil;
    createCardType = nil;
    [super close];
}
-(IBAction)createCardType:(id)sender{
    NSLog(@"createCardType");
    if(createCardType != nil && [[self windowControllers] containsObject:createCardType]){
            [[createCardType window] orderFrontRegardless];
    }else{
        createCardType = [[CBMCreateCardTypeController alloc]initWithWindowNibName:@"CreateCardType"];
        NSLog(@"creating window");
        [self addWindowController:createCardType];
        [[createCardType window] orderFront:self];
    }
}


@end
