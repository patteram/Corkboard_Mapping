//
//  CBMSearchAndDisplayController.h
//  CoreDoc
//
//  Created by Ashley Patterson on 2/22/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBMGrowingView.h"
#import "CBMTypeManager.h"
#import "CBMTypeAlert.h"

@interface CBMSearchAndDisplayController : NSWindowController
@property NSManagedObjectContext *context; 

@property (weak) IBOutlet NSScrollView *cardDisplayScrollView;
@property (weak) IBOutlet NSScrollView *threadDisplayScrollView;
@property (weak) IBOutlet NSScrollView *threadSearchScrollView;
@property (weak) IBOutlet NSScrollView *cardSearchScrollView;

@property (strong) IBOutlet NSWindow *windowToName;

@property (weak) IBOutlet NSSlider *threadSlider;
@property (weak) IBOutlet NSTextField *sliderLabel;


@property CBMGrowingView * cardDisplayHolder;
@property CBMGrowingView * threadDisplayHolder;
@property CBMGrowingView * cardSearchHolder;
@property CBMGrowingView * threadSearchHolder;

@property CBMTypeManager * typeManager;

-(BOOL)isWindowVisible;
-(void)setIsVisible:(BOOL)isVisible;

@end
