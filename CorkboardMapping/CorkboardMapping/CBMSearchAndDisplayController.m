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
#import "CBMCheckboxCard.h"
@interface CBMSearchAndDisplayController ()

@end

@implementation CBMSearchAndDisplayController
NSString *CARD_TYPE_ARRAY = @"cardTypes";
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
        [typeManager addObserver:self forKeyPath:CARD_TYPE_ARRAY options:NSKeyValueChangeInsertion|NSKeyValueChangeRemoval context:nil];
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
   // [typeManager createCardTypeWithName:@"Scene" andColor:[NSColor yellowColor]];
   // [typeManager createCardTypeWithName:@"Character" andColor:[NSColor redColor]];
    for(CardType *aType in [typeManager getAllCardTypes]){
    [view addSubview:[self getButton:aType]];
    }
    
}

-(NSView *)getButton:(CardType *)aType{
    CBMCheckboxCard * cardSection = [[CBMCheckboxCard alloc]initWithFrame:NSMakeRect(0,0,cardDisplayHolder.frame.size.width,0) andCardType:aType];
    [[cardSection checkbox] setTarget:self];
    [[cardSection checkbox] setAction:@selector(actionSelectorCard:) ];
  
    
    return cardSection;
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:CARD_TYPE_ARRAY]){
        NSSet *old =  [change objectForKey:NSKeyValueChangeOldKey];
        NSSet *new = [change objectForKey:NSKeyValueChangeNewKey];
        if([old count] > [new count]){
                //remove code
        }else{
            NSSet* changed = [new filteredSetUsingPredicate:
                              [NSPredicate predicateWithFormat:@"NOT objectID IN %@",old]];
            for( CardType *aCard in changed){
                [cardDisplayHolder addSubview:[self getButton:aCard]];
                [cardSearchHolder addSubview:[self getButton:aCard]];
            }
        }
    }
    
}

-(void)close{
    [typeManager removeObserver:self forKeyPath:CARD_TYPE_ARRAY];
    [super close];
}

@end
