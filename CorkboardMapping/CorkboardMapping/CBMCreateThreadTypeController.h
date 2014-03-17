//
//  CBMCreateThreadTypeController.h
//  CorkboardMapping
//
//  Created by Ashley Patterson on 3/14/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBMTypeManager.h"
@interface CBMCreateThreadTypeController : NSWindowController
@property CBMTypeManager *manager;
@property (weak) IBOutlet NSTextField *threadNameField;
@property (weak) IBOutlet NSColorWell *threadColor;


@end
