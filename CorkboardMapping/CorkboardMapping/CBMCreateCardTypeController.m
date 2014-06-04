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
@synthesize currentWindow;
@synthesize colorLabel;
@synthesize nameLabel;
- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        currentWindow = window;
        //NSLog(@"Should be on screen");
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
        //NSLog(@"Type created");
        [manager createCardTypeWithName:typeName andColor:color];
        [colorWell deactivate]; 
        [currentWindow performClose:self];
    }else {
        if([manager cardTypeExistsWithName:typeName]){
            [nameLabel setTextColor:[NSColor redColor]];
        }else{
            [nameLabel setTextColor:[NSColor blackColor]];
        }
        if([manager cardTypeExistsWithColor:color]){
            [colorLabel setTextColor:[NSColor redColor]];
        }else{
            [colorLabel setTextColor:[NSColor blackColor]];
        }
    }
    
}



-(void)windowWillClose:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[self document]removeWindowController:self];

}
-(IBAction)cancel:(id)sender{
    [currentWindow performClose:self];
}



- (void)windowDidLoad
{
    [super windowDidLoad];
    if([[self document] isKindOfClass: [CBMDocument class]]){
         CBMDocument *doc = [self document];
         manager = [doc typeManager];
    }
    
    [[ NSNotificationCenter defaultCenter]addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:currentWindow];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
