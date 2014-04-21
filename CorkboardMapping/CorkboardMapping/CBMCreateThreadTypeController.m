//
//  CBMCreateThreadTypeController.m
//  CorkboardMapping
//
//  Created by Ashley Patterson on 3/14/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMCreateThreadTypeController.h"
#import "CBMDocument.h"
@interface CBMCreateThreadTypeController ()

@end

@implementation CBMCreateThreadTypeController
@synthesize threadColor;
@synthesize threadNameField;
@synthesize manager;
@synthesize warningCell;
@synthesize colorLabel;
@synthesize nameLabel;
- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}
- (IBAction)createCard:(NSButton *)sender {
    NSString * typeName = [threadNameField stringValue];
    NSColor * color = [threadColor color];
    if(![manager threadTypeExistsWithName:typeName OrColor:color]){
        //NSLog(@"Type created");
        [manager createThreadTypeWithName:typeName andColor:color];
        [[self window] performClose:self];
    }else{
        int count = 0;
        if([manager threadTypeExistsWithName:typeName]){
            [nameLabel setTextColor:[NSColor redColor]];
            count ++;
        }else{
             [nameLabel setTextColor:[NSColor blackColor]];
        }
        
        if([manager threadTypeExistsWithColor:color]){
             [colorLabel setTextColor:[NSColor redColor]];
            count++;
        }else{
             [colorLabel setTextColor:[NSColor blackColor]];
        }
        if(count < 2){
        [warningCell setTextColor:[NSColor redColor]];
        [warningCell setStringValue:@"*Value must be unique*"];
        }else{
            [warningCell setTextColor:[NSColor redColor]];
            [warningCell setStringValue:@"*Both values must be unique*"];
        }
       // [warningCell setStringValue:@"Color and Thread must both be unique"];
        //[warningCell setTextColor:[NSColor redColor]];
    }
    
}

-(void)windowWillClose:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[self document]removeWindowController:self];
    
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    if([[self document] isKindOfClass: [CBMDocument class]]){
        CBMDocument *doc = [self document];
        manager = [doc typeManager];
    }
    
    [[ NSNotificationCenter defaultCenter]addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:[self window]];
   // NSLog(@" Window loaded %@ ",[ [self window] title]);
    [[self window]setTitle: [ NSString stringWithFormat:@"%@ - Create Card Type", [[self window]title] ]];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}


@end
