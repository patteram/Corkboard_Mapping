//
//  CBMCreateCardController.h
//  CorkboardMapping
//
//  Created by Ashley Patterson on 3/1/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBMTypeManager.h"
@interface CBMCreateCardTypeController : NSWindowController
@property (weak) IBOutlet NSButton *createButton;
@property (weak) IBOutlet NSColorWell *colorWell;
@property (weak) IBOutlet NSTextField *text;
@property (weak) IBOutlet NSTextField *nameLabel;
@property (weak) IBOutlet NSTextField *colorLabel;

@property CBMTypeManager *manager;
@property NSTextView *aLabel;
@property (strong) IBOutlet NSWindow *currentWindow;
@end
