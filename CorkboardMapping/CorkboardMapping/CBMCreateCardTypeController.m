//
//  CBMCreateCardController.m
//  CorkboardMapping
//
//  Created by Ashley Patterson on 3/1/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMCreateCardTypeController.h"

@interface CBMCreateCardTypeController ()

@end

@implementation CBMCreateCardTypeController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}
- (IBAction)colorSelection:(NSColorWell *)sender {
}
- (IBAction)textNameChanged:(NSTextField *)sender {
}
- (IBAction)create:(NSButton *)sender {
    
}




- (IBAction)cancel:(NSButton *)sender {
    [[super window] performClose:self]; 
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
