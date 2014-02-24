//
//  CBMSearchAndDisplayController.h
//  CoreDoc
//
//  Created by Ashley Patterson on 2/22/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBMGrowingView.h"

@interface CBMSearchAndDisplayController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate>
@property NSManagedObjectContext *context; 
@property (weak) IBOutlet NSScrollView *scrollView;


@property (weak) IBOutlet NSSlider *threadSlider;
@property (weak) IBOutlet NSTextField *sliderLabel;
@property (weak) IBOutlet NSTableView *cardTable;
@property CBMGrowingView * boxHolder;
@end
