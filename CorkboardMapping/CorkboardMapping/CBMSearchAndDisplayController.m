//
//  CBMSearchAndDisplayController.m
//  CoreDoc
//
//  Created by Ashley Patterson on 2/22/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMSearchAndDisplayController.h"
#import "CBMGrowingView.h"
#import "CardType.h"
#import "CBMTypeManager.h"
@interface CBMSearchAndDisplayController ()

@end

@implementation CBMSearchAndDisplayController
@synthesize sliderLabel;
@synthesize context;
@synthesize cardTable;
@synthesize scrollView;
@synthesize boxHolder;
-(void)windowDidLoad{
    [super windowDidLoad];
    if([[self document] isKindOfClass: [NSPersistentDocument class]]){
        NSPersistentDocument *doc = [self document];
        self.context = [doc managedObjectContext];
    }
    [cardTable setDataSource:self];
    [cardTable setDelegate:self];
    boxHolder = [[CBMGrowingView alloc] initWithFrame:NSMakeRect(0.0, 0.0, scrollView.frame.size.width, 0.0)];
    [scrollView setDocumentView:boxHolder];
    [self generateCardTypeButtons];
    
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

-(void)generateCardTypeButtons{
    CBMTypeManager * generator = [[CBMTypeManager alloc]initWithModelContext:context];
    [generator createCardTypeWithName:@"Title" andColor:[NSColor yellowColor] ];
    [generator createCardTypeWithName:@"Character" andColor:[NSColor blueColor]];
    [generator createCardTypeWithName:@"Scene" andColor:[NSColor redColor]];
    for(CardType *aType in [generator getAllCardTypes]){
    [boxHolder addSubview:[self getButton:aType]];
    }
    
}

-(NSView *)getButton:(CardType *)aType{
    NSButton * button = [[NSButton alloc]initWithFrame:NSMakeRect(0,0,boxHolder.frame.size.width,0)];
    
    
    [button setButtonType:NSSwitchButton];
    [button setTarget:self];
    [button setAction:@selector(actionSelectorCard:) ];
    [button setTitle:[aType name]];
    [button setState:NSOnState];
    
    return button;
}

@end
