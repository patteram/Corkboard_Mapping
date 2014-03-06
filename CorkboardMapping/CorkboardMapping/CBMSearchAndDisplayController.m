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
#import "CBMDocument.h"
@interface CBMSearchAndDisplayController ()

@end

@implementation CBMSearchAndDisplayController
@synthesize sliderLabel;
@synthesize context;
@synthesize typeManager;
@synthesize cardDisplayScrollView, cardSearchHolder, cardSearchScrollView, cardDisplayHolder;
@synthesize threadDisplayHolder, threadDisplayScrollView, threadSearchHolder, threadSearchScrollView;

@synthesize windowToName;


-(void)windowDidLoad{
    [super windowDidLoad];
    if([[self document] isKindOfClass: [CBMDocument class]]){
       CBMDocument *doc = [self document];
        self.typeManager = [doc typeManager];
        [windowToName setTitle:[doc displayName]];
    }
    cardDisplayHolder =[[CBMGrowingView alloc]initWithFrame:NSMakeRect(0,0,cardDisplayScrollView.frame.size.width, 0.0)];
    cardSearchHolder = [[CBMGrowingView alloc]initWithFrame:NSMakeRect(0,0, cardSearchScrollView.frame.size.width, 0.0)];
    [cardSearchScrollView setDocumentView:cardSearchHolder];
    [cardDisplayScrollView setDocumentView:cardDisplayHolder];
    [self generateCardTypeButtons:cardDisplayHolder];
    [self generateCardTypeButtons:cardSearchHolder];
    
}
- (IBAction)getNum:(NSSlider *)sender {
    NSLog(@"Num: %d ",[sender intValue]);
    [sliderLabel setStringValue:[NSString stringWithFormat:@"%i", [sender intValue]]];
}


-(void)actionSelectorCard:(id)sender{
    NSLog(@"Was hit");
}

-(void)generateCardTypeButtons:(CBMGrowingView *)view{
    [typeManager createCardTypeWithName:@"Scene" andColor:[NSColor yellowColor]];
    [typeManager createCardTypeWithName:@"Character" andColor:[NSColor redColor]]; 
    for(CardType *aType in [typeManager getAllCardTypes]){
    [view addSubview:[self getButton:aType]];
    }
    
}

-(NSView *)getButton:(CardType *)aType{
    NSButton * button = [[NSButton alloc]initWithFrame:NSMakeRect(0,0,cardDisplayHolder.frame.size.width,0)];
    [button setButtonType:NSSwitchButton];
    [button setTarget:self];
    [button setAction:@selector(actionSelectorCard:) ];
    [button setTitle:[aType name]];
    [button setState:NSOnState];
    
    return button;
}

-(BOOL)isWindowVisible{
   return [windowToName isVisible];
}

-(void)setIsVisible:(BOOL)isVisible{
    //strange bug, have to use super window to orderfront is it isn't visible
    //else you have to use the windowToName 
    //but self connection to order out x.x 
    if(isVisible){
        [windowToName orderFront:self];
        NSLog(@"Make visible");
        [[super window] orderFront:self];
    }else{
        [windowToName orderOut:self]; 
    }
}


@end
