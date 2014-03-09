//
//  CBMCreateCardController.m
//  CorkboardMapping
//
//  Created by Ashley Patterson on 3/1/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMCreateCardTypeController.h"
#import "CBMDocument.h"
@interface CBMCreateCardTypeController ()

@end

@implementation CBMCreateCardTypeController
@synthesize colorWell;
@synthesize text;
@synthesize manager;
- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        
        NSLog(@"Should be on screen");
    }
    return self;
}


- (IBAction)colorSelection:(NSColorWell *)sender {
}
- (IBAction)textNameChanged:(NSTextField *)sender {
}
- (IBAction)create:(NSButton *)sender {
    NSString * typeName = [text stringValue];
    NSColor * color = [colorWell color];
    if(![manager cardTypeExistsWithName:typeName andColor:color]){
        NSLog(@"Type created");
        [manager createCardTypeWithName:typeName andColor:color]; 
    }
    
}




- (IBAction)cancel:(NSButton *)sender {
    [[self window] performClose:self];
    [[self document] removeWindowController:self];

}

-(BOOL)windowShouldClose:(id)sender{
    return NO; 
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    if([[self document] isKindOfClass: [CBMDocument class]]){
         CBMDocument *doc = [self document];
         manager = [doc typeManager];
    }
     NSLog(@"Window did Load");
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
