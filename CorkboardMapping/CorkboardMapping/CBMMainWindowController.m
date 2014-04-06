//
//  CBMWindowController.m
//  CoreDoc
//
//  Created by Ashley Patterson on 2/20/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMMainWindowController.h"
#import "CBMCenteringView.h"
#import "Card.h"
#import "CardType.h"
#import "ThreadType.h"
#import "Thread.h"
#import "CBMThreadView.h"
#import "CardAndThreadProtocol.h"
#import "CBMCardView.h"


#import "CBMDocument.h"
#import "CBMCheckboxCard.h"
#import "CBMCheckboxThread.h"

@interface CBMMainWindowController ()

@end

@implementation CBMMainWindowController

@synthesize corkboardView;
@synthesize state;
@synthesize mainScroller;
@synthesize cardDisplayHolder;
@synthesize threadDisplayHolder;
@synthesize cardDisplayScrollView, threadDisplayScrollView;
@synthesize typeManager;
@synthesize stepper;
@synthesize searchButton, textForStepper;
NSString *CARD_TYPE_ARRAY = @"cardTypes";
NSString *THREAD_SET = @"threadTypes";
NSMutableArray * displayArray;
CardType *one;
CBMCardAndThreadManager * cardManager;
BOOL createCard = YES;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    if([[self document] isKindOfClass: [CBMDocument class]]){
        CBMDocument *doc = [self document];
        NSManagedObjectContext *myContext = [doc managedObjectContext];
        state = [doc theState];
        cardManager = [[CBMCardAndThreadManager alloc]initWithModelContext:myContext];
        self.typeManager = [doc typeManager];
        [typeManager addObserver:self forKeyPath:CARD_TYPE_ARRAY options:NSKeyValueChangeInsertion|NSKeyValueChangeRemoval context:nil];
        [typeManager addObserver:self forKeyPath:THREAD_SET options:NSKeyValueChangeInsertion|NSKeyValueChangeRemoval context:nil];

    }
    [self setUpMainCorkboardViews];
    [self setUpViews:[cardManager getAllCardsAndThreads]];
    [self setUpSideScrollViews];
    [[super window] makeKeyAndOrderFront:self];
    
   
}

-(void)setUpViews:(NSArray *)array{
    if(array != nil){
       [corkboardView setSubviews:[[NSArray alloc]initWithObjects:nil]];
        [self createThreadViews:array];
        [self createCardViews:array];
        
    }
}
-(void)cardClicked:(id)sender{
    if([state creatingThread]){
        if([state cardSelected] != nil && [state cardSelected] != [(CBMCardView *)sender cardObject]){
            [cardManager createThreadWithType:[state threadToCreate] BetweenCard:[state cardSelected] AndCard:[(CBMCardView *)sender cardObject]];
            [self setUpViews:[cardManager getAllCardsAndThreads]];
            [state setThreadToCreate:nil];
            
        }
       [state setCardSelected:[(CBMCardView *)sender cardObject]];
    }else{
            [state setCardSelected:[(CBMCardView *)sender cardObject]];
    }
 }

-(void)askToDelete:(id)sender{
    if([sender isKindOfClass:[CBMCardView class] ]){
        NSLog(@"Working");
        [sender removeFromSuperview];
        [cardManager deleteCard:[sender cardObject]];
    }else if([sender isKindOfClass:[CBMThreadView class]]){
        [sender removeFromSuperview];
        [cardManager deleteThread:[sender threadObject]];
    }else if([sender isKindOfClass:[CBMCheckboxCard class]]){
             [sender removeFromSuperview];
        [typeManager deleteCardType:[(CBMCheckboxCard *)sender type]];
        [self refreshManagerAndUI];
    }else if ([sender isKindOfClass:[CBMCheckboxThread class]]){
        [sender removeFromSuperview];
        [typeManager deleteThreadType:[(CBMCheckboxThread *)sender type]];
        [self refreshManagerAndUI];
    }
}

-(BOOL)shouldCloseDocument{
    return YES;
}

-(IBAction)mouseDownInCorkboard:(NSEvent *)theEvent{
        if([[self state]creatingCard]){
            NSPoint p =  [corkboardView convertPoint:[theEvent locationInWindow] fromView:nil];
            Card *acard = [cardManager createCardWithType:[state cardToCreate] AtLocation:NSMakePoint(p.x, p.y)];
            CBMCardView *cardView = [[CBMCardView alloc]initWithFrame:NSMakeRect(p.x-(190/2),p.y-(120/2), 190, 120) AndCBMCard:acard];
                        [corkboardView addSubview:cardView];
            [state setCardToCreate:nil];
        }else if ([state creatingThread]){
            [state setCardSelected:Nil];
        }
}

-(void)refreshManagerAndUI{
    [cardManager refresh];
    //if display
    [self avoidDisplay:displayArray]; 
}

/*!
 Creates card views and places them on board
 @param array can be filled with any objects, there is a check for card
 */
-(NSArray *)createCardViews:(NSArray *)array{
    for(Card *aCard in array){
        if([aCard isKindOfClass:[Card class]]){
        NSValue *j = [aCard rect];
        NSPoint point = j.pointValue;
        CBMCardView *cardView = [[CBMCardView alloc]initWithFrame:NSMakeRect(point.x-(190/2), point.y-(120/2), 190, 120) AndCBMCard:aCard];
        [corkboardView addSubview:cardView];
        }
    }
    return nil;
}

/*!
 Creates thread views and puts them on board
 @param array can be filled with any objects, there is a check for threads
 */
-(NSArray *)createThreadViews:(NSArray *)array{
    NSLog(@"createThreadViews");
    for(Thread *aThread in array){
        if([aThread isKindOfClass:[Thread class]]){
            NSLog(@"thread found");
        NSArray *anArray = [[aThread cards]allObjects];
            NSLog(@"Thread - %lu", [anArray count]); 
        NSPoint startPoint = [(Card *)[anArray objectAtIndex:0] getLocation];
        NSPoint endPoint = [(Card *)[anArray objectAtIndex:1]getLocation];
        NSPoint origin = NSMakePoint(MIN(startPoint.x, endPoint.x), MIN(startPoint.y, endPoint.y));
        NSSize size = NSMakeSize(MAX(startPoint.x, endPoint.x)-MIN(startPoint.x, endPoint.x), MAX(startPoint.x, endPoint.x)-MIN(startPoint.x, endPoint.x));
        NSRect newFrame = NSMakeRect(origin.x, origin.y, size.width, size.height);
        CBMThreadView *aView = [[CBMThreadView alloc]initWithFrame:newFrame AndThread:aThread];
        [corkboardView addSubview:aView];
        }
    }
    return nil;
}

/*! 
 Sets up the Main Corkboard, right hand side of the application. 
 Creates the centering and corkboard view, modifys main scroller, and then sets up notifications
 */
-(void)setUpMainCorkboardViews{
    CBMCenteringView *centerView = [[CBMCenteringView alloc]initWithFrame:NSMakeRect(0, 0, 3000, 3000)];
    corkboardView  = [[CBMCorkboard alloc]initWithFrame:NSMakeRect(0, 0, 3000, 3000)];
    [centerView addSubview:corkboardView];

    [mainScroller setHasVerticalScroller:YES];
    [mainScroller setHasHorizontalScroller:YES];
    [mainScroller setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable ];
    [mainScroller setDocumentView:centerView];
       [mainScroller setDrawsBackground:NO];

   [[NSNotificationCenter defaultCenter]addObserver:centerView selector:@selector(viewFrameChanged:) name:NSViewFrameDidChangeNotification object:corkboardView];
    [[NSNotificationCenter defaultCenter]addObserver:centerView selector:@selector(viewFrameChanged:) name:NSViewFrameDidChangeNotification object:mainScroller];
    [[NSNotificationCenter defaultCenter]addObserver:corkboardView selector:@selector(viewFrameChanged:) name:NSViewFrameDidChangeNotification object:mainScroller];
}

/*!
 Method to call when avoid Search Criteria Changes
 */
-(void)avoidSearchCriteria:(NSArray *)criteria{
    NSArray *anArray;
    [corkboardView setSubviews:[[NSArray alloc]initWithObjects:nil]];
    if([criteria count] == 0){
        NSLog(@"Search Criteria - criteria count is 0");
        anArray = [cardManager getAllCardsAndThreads];
    }else{
        NSLog(@"Search Criteria - criteria count is more than one");
        anArray = [cardManager getAllCardsAndThreadsAndAvoid:criteria];
    }
    
    [self createThreadViews:anArray];
    [self createCardViews:anArray];
    
}

-(void)avoidSearchCriteria:(NSArray *)criteria WithDepth:(NSInteger)integer{
    if([state cardSelected] != nil){
     
        NSArray *anArray = [cardManager searchOnCard:[state cardSelected] WithDepth:integer AndAvoid:displayArray];
        [corkboardView setSubviews:[[NSArray alloc]initWithObjects: nil]];
        [self createThreadViews:anArray];
        [self createCardViews:anArray];
        NSLog(@"searchCriteria - %lu", [anArray count]); 
    }
}
/*!
 Method to call when display has changed
 */
-(void)avoidDisplay:(NSArray *)criteria{
    NSArray *anArray;
    [corkboardView setSubviews:[[NSArray alloc]initWithObjects:nil]];
    if([criteria count] == 0){
        anArray = [cardManager getAllCardsAndThreads];
    }else{
        anArray = [cardManager getAllCardsAndThreadsAndAvoid:criteria];
    }
     [self createThreadViews:anArray];
    [self createCardViews:anArray];
}

/*! Sets up all the card and thread type scrollers */
-(void)setUpSideScrollViews{
    displayArray = [[NSMutableArray alloc]init];
    cardDisplayHolder =[[CBMGrowingView alloc]initWithFrame:NSMakeRect(0,0,cardDisplayScrollView.frame.size.width, 0.0)];
    [cardDisplayScrollView setDocumentView:cardDisplayHolder];
    [self generateCardTypeButtons:cardDisplayHolder withSelector:@selector(actionDisplayCard:)];
    
    threadDisplayHolder = [[CBMGrowingView alloc]initWithFrame:NSMakeRect(0,0,threadDisplayScrollView.frame.size.width, 0)];
    [threadDisplayScrollView setDocumentView:threadDisplayHolder];
    [self generateThreadTypeButtons:threadDisplayHolder withSelector:@selector(actionDisplayThread:)];
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
        [self redrawCorkboard];
    }
}

-(void)cardTypeClicked:(id)sender{
    NSLog(@"Search and Display - card clicked");
    if([sender isKindOfClass: [CBMCheckboxCard class]]){
        CBMCheckboxCard *c = (CBMCheckboxCard * )sender;
        //NSLog(@"Color %@ and Name %@", [[c type] color], [[c type] name]);
        if([[self document] isKindOfClass: [CBMDocument class]]){
            CBMDocument *doc = [self document];
            [[doc theState]setCardToCreate:[c type]];
        }
        
    }
}

-(void)threadTypeClicked:(id)sender{
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


-(void)actionDisplayThread:(id)sender{
    if([sender isKindOfClass: [NSButton class]]){
        NSButton *box = sender;
        if([[box superview] isKindOfClass: [CBMCheckboxThread class]]){
            CBMCheckboxThread *c = (CBMCheckboxThread * )[box superview];
            if([displayArray containsObject:[c type]]){
                [displayArray removeObject:[c type]];
            }else{
                [displayArray addObject:[c type]];
            }
        }
        [self redrawCorkboard];
    }
    
    
}

-(void)redrawCorkboard{
    if([searchButton state] == NSOnState){
        [self avoidSearchCriteria:displayArray WithDepth:[stepper intValue]];
    }else{
        [self avoidDisplay:displayArray];
    }
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
    return cardSection;
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
            }
    }
}
- (IBAction)searchButtonPressed:(NSButton *)sender {
    
    if ([sender state] == NSOnState){
        [self avoidSearchCriteria:displayArray WithDepth:[stepper intValue]];
    }else{
        [self avoidDisplay:displayArray]; 
    }
}
- (IBAction)stepper:(NSStepper *)sender {
    [textForStepper setStringValue:[NSString stringWithFormat:@"%li",[sender integerValue] ]];
    if([searchButton state] == NSOnState){
        [self avoidSearchCriteria:displayArray WithDepth:[stepper intValue]];
    }
}

-(void)dealloc{
    [typeManager removeObserver:self forKeyPath:CARD_TYPE_ARRAY];
    [typeManager removeObserver:self forKeyPath:THREAD_SET];
    
    [[NSNotificationCenter defaultCenter]removeObserver:corkboardView];
    [[NSNotificationCenter defaultCenter]removeObserver:corkboardView.superview];
    
}



@end
