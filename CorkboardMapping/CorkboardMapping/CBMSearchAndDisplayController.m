//
//  CBMSearchAndDisplayController.m
//  CoreDoc
//
//  Created by Ashley Patterson on 2/22/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMSearchAndDisplayController.h"

@interface CBMSearchAndDisplayController ()

@end

@implementation CBMSearchAndDisplayController
@synthesize sliderLabel;
@synthesize context;
@synthesize cardTable;
-(void)windowDidLoad{
    [super windowDidLoad];
    [cardTable setDataSource:self];
    [cardTable setDelegate:self];
    //[CardTable setNumberOfColumns: 1];
  
}
- (IBAction)getNum:(NSSlider *)sender {
    NSLog(@"Num: %d ",[sender intValue]);
    [sliderLabel setStringValue:[NSString stringWithFormat:@"%i", [sender intValue]]];
    
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return 5;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSButton * button = [[NSButton alloc]initWithFrame:NSMakeRect(0,0,tableView.frame.size.width,0)];

  
       [button setButtonType:NSSwitchButton];
    [button setTarget:self];
    [button setAction:@selector(actionSelectorCard:) ];
    [button setTitle:@"This is title"];
    [button setState:NSOnState];
    
    return button;
}

-(void)actionSelectorCard:(id)sender{
    NSLog(@"Was hit");
}
@end
