//
//  CBMWindowController.h
//  CoreDoc
//
//  Created by Ashley Patterson on 2/20/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBMState.h"
#import "CBMCorkboard.h"
#import "CBMGrowingView.h"
#import "CBMTypeManager.h"
@interface CBMMainWindowController : NSWindowController

@property (weak) IBOutlet NSScrollView *mainScroller;
@property (weak) IBOutlet NSScrollView *cardDisplayScrollView;
@property (weak) IBOutlet NSScrollView *threadDisplayScrollView;

@property CBMGrowingView * cardDisplayHolder;
@property CBMGrowingView * threadDisplayHolder;
@property CBMGrowingView * cardSearchHolder;
@property CBMGrowingView * threadSearchHolder;
@property CBMTypeManager * typeManager;

@property (weak) IBOutlet NSStepper *stepper;
@property (weak) IBOutlet NSTextField *textForStepper;
@property (weak) IBOutlet NSButton *searchButton;


@property CBMCorkboard *corkboardView;
@property CBMState *state;
@property NSManagedObjectContext *myManagedObjectContext;
-(void)avoidSearchCriteria:(NSArray*)criteria;
-(void)avoidDisplay:(NSArray *)critieria; 
-(void)avoidSearchCriteria:(NSArray *)criteria WithDepth:(NSInteger)integer;
-(void)askToDelete:(id)sender; 
@end
