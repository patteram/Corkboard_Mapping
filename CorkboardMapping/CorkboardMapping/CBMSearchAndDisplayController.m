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
#import "CBMCheckboxThread.h"
@interface CBMSearchAndDisplayController ()

@end

@implementation CBMSearchAndDisplayController
NSString *CARD_TYPE_ARRAY = @"cardTypes";
NSString *THREAD_SET = @"threadTypes";
@synthesize sliderLabel;
@synthesize context;
@synthesize typeManager;
@synthesize controller;
@synthesize cardDisplayScrollView, cardSearchHolder, cardSearchScrollView, cardDisplayHolder;
@synthesize threadDisplayHolder, threadDisplayScrollView, threadSearchHolder, threadSearchScrollView;
NSMutableArray * displayArray;
@synthesize windowToName;


-(void)windowDidLoad{
    [super windowDidLoad];
    [super showWindow:self]; 
    NSLog(@"TA DA %@", [super window]);
    if([[self document] isKindOfClass: [CBMDocument class]]){
       CBMDocument *doc = [self document];
        self.typeManager = [doc typeManager];
        controller = [doc corkboard];
        [typeManager addObserver:self forKeyPath:CARD_TYPE_ARRAY options:NSKeyValueChangeInsertion|NSKeyValueChangeRemoval context:nil];
        [typeManager addObserver:self forKeyPath:THREAD_SET options:NSKeyValueChangeInsertion|NSKeyValueChangeRemoval context:nil];
        [windowToName setTitle:[doc displayName]];
    }
    [self setUpViews];
}

- (IBAction)getNum:(NSSlider *)sender {
    NSLog(@"Num: %d ",[sender intValue]);
    [sliderLabel setStringValue:[NSString stringWithFormat:@"%i", [sender intValue]]];
   
}

-(void)setUpViews{
    displayArray = [[NSMutableArray alloc]init];
    cardDisplayHolder =[[CBMGrowingView alloc]initWithFrame:NSMakeRect(0,0,cardDisplayScrollView.frame.size.width, 0.0)];
    cardSearchHolder = [[CBMGrowingView alloc]initWithFrame:NSMakeRect(0,0, cardSearchScrollView.frame.size.width, 0.0)];
    [cardSearchScrollView setDocumentView:cardSearchHolder];
    [cardDisplayScrollView setDocumentView:cardDisplayHolder];
    [self generateCardTypeButtons:cardDisplayHolder withSelector:@selector(actionDisplayCard:)];
    [self generateCardTypeButtons:cardSearchHolder withSelector:@selector(actionSearchCard:)];
    
    threadSearchHolder = [[CBMGrowingView alloc]initWithFrame:NSMakeRect(0,0,threadSearchScrollView.frame.size.width, 0.0)];
    threadDisplayHolder = [[CBMGrowingView alloc]initWithFrame:NSMakeRect(0,0,threadDisplayScrollView.frame.size.width, 0)];
    [threadSearchScrollView setDocumentView:threadSearchHolder];
    [threadDisplayScrollView setDocumentView:threadDisplayHolder]; 
    [self generateThreadTypeButtons:threadDisplayHolder withSelector:@selector(actionDisplayThread:)];
    [self generateThreadTypeButtons:threadSearchHolder withSelector:@selector(actionSearchThread:)];
}

-(void)actionDisplayCard:(id)sender{
    if([sender isKindOfClass: [NSButton class]]){
        NSButton *box = sender;
        if([[box superview] isKindOfClass: [CBMCheckboxCard class]]){
            CBMCheckboxCard *c = (CBMCheckboxCard * )[box superview];
            if([displayArray containsObject:[c type]]){
                [displayArray removeObject:[c type]];
            }else{
            [displayArray addObject:[c type]];
            }
        }
        [controller avoidDisplay:displayArray]; 
    }
    NSLog(@"Was hit");
}

-(void)cardClicked:(id)sender{
    NSLog(@"Search and Display - card clicked");
    if([sender isKindOfClass: [CBMCheckboxCard class]]){
        CBMCheckboxCard *c = (CBMCheckboxCard * )sender;
        NSLog(@"Color %@ and Name %@", [[c type] color], [[c type] name]);
        if([[self document] isKindOfClass: [CBMDocument class]]){
            CBMDocument *doc = [self document];
            [[doc theState]setCardToCreate:[c type]]; 
        }

    }
}

-(void)threadClickedXYZ:(id)sender{
    NSLog(@"Search and Display - thread was clicked");
    if([sender isKindOfClass: [CBMCheckboxThread class]]){
        CBMCheckboxThread *c = (CBMCheckboxThread * )sender;
        NSLog(@"Color %@ and Name %@", [[c type] color], [[c type] name]);
        if([[self document] isKindOfClass: [CBMDocument class]]){
            CBMDocument *doc = [self document];
            [[doc theState]setThreadToCreate:[c type]];
        }
        
    }
}
-(void)actionSearchCard:(id)sender{
    
}

-(void)actionSearchThread:(id)sender{
    
}

-(void)actionDisplayThread:(id)sender{
    
}
-(void)generateCardTypeButtons:(CBMGrowingView *)view withSelector:(SEL)selector{
    for(CardType *aType in [typeManager getAllCardTypes]){
        [view addSubview:[self getCardButton:aType setAction:selector] ];
    }
}

-(void)generateThreadTypeButtons:(CBMGrowingView *)view withSelector:(SEL)selector{
    for(ThreadType *aType in [typeManager getAllThreadTypes]){
        [view addSubview:[self getThreadButton:aType setAction:selector]];
    }
}

-(NSView *)getThreadButton:(ThreadType *)aType setAction:(SEL)selector{
    CBMCheckboxThread *threadSection = [[CBMCheckboxThread alloc]initWithFrame:NSMakeRect(0, 0, threadDisplayHolder.frame.size.width, 0) andThreadType:aType];
    [[threadSection checkbox]setTarget:self];
    [[threadSection checkbox]setAction:selector];
    return threadSection;
}
-(NSView *)getCardButton:(CardType *)aType setAction:(SEL)selector{
    CBMCheckboxCard * cardSection = [[CBMCheckboxCard alloc]initWithFrame:NSMakeRect(0,0,cardDisplayHolder.frame.size.width,0) andCardType:aType];
    [[cardSection checkbox] setTarget:self];
    [[cardSection checkbox] setAction:selector ];
    [cardSection setTarget:self];
    [cardSection setSelector:@selector(cardClicked:)]; 
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
                [cardDisplayHolder addSubview:[self getCardButton:aCard setAction:@selector(actionDisplayCard:)]];
                [cardSearchHolder addSubview:[self getCardButton:aCard setAction:@selector(actionSearchCard:)]];
            }
        }
    }else if([keyPath isEqualToString:THREAD_SET]){
        NSSet *old =  [change objectForKey:NSKeyValueChangeOldKey];
        NSSet *new = [change objectForKey:NSKeyValueChangeNewKey];
        [self threadKeyPathChangedSetNew:new andOldSet:old];
      
    }
    
}

-(void)threadKeyPathChangedSetNew:(NSSet *)new andOldSet:(NSSet *)old{
    if([old count] > [new count]){
        //remove code
    }else{
               NSSet* changed = [new filteredSetUsingPredicate:
                          [NSPredicate predicateWithFormat:@"NOT objectID IN %@",old]];
        for( ThreadType *aType in changed){
            [threadDisplayHolder addSubview:[self getThreadButton:aType setAction:@selector(actionDisplayThread:)]];
            [threadSearchHolder addSubview:[self getThreadButton:aType setAction:@selector(actionSearchThread:)]];
        }
    }
}

-(void)close{
    [typeManager removeObserver:self forKeyPath:CARD_TYPE_ARRAY];
    [typeManager removeObserver:self forKeyPath:THREAD_SET];
    [super close];
}

@end
