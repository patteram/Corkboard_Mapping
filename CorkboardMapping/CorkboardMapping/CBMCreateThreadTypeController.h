//
//  CBMCreateThreadTypeController.h
//  CorkboardMapping
//
//  Created by Ashley Patterson on 3/14/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBMThreadTypeProtocol.h"
@interface CBMCreateThreadTypeController : NSWindowController
@property id <CBMThreadTypeProtocol> manager;
@property (weak) IBOutlet NSTextField *threadNameField;
@property (weak) IBOutlet NSColorWell *threadColor;
@property (weak) IBOutlet NSTextFieldCell *warningCell;

@property (weak) IBOutlet NSTextField *colorLabel;
@property (weak) IBOutlet NSTextField *nameLabel;

@end
