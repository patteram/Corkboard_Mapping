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
@synthesize myManagedObjectContext;
NSString *CARD_TYPE_ARRAY = @"cardTypes";
NSString *THREAD_SET = @"threadTypes";
NSMutableArray * displayArray;
CardType *one;
CBMCardAndThreadManager * cardManager;
BOOL createCard = YES;
const CGFloat cardWidth = 250;
const CGFloat cardHeight = 150;
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
        myManagedObjectContext = [doc managedObjectContext]; 
        self.typeManager = [doc typeManager];
        [typeManager addObserver:self forKeyPath:CARD_TYPE_ARRAY options:NSKeyValueChangeInsertion|NSKeyValueChangeRemoval context:nil];
        [typeManager addObserver:self forKeyPath:THREAD_SET options:NSKeyValueChangeInsertion|NSKeyValueChangeRemoval context:nil];

    }
    [self setUpMainCorkboardViews];
    [self setUpViewsOnCorkboard:[cardManager getAllCardsAndThreads]];
    [self setUpSideScrollViews];
    displayArray = [[NSMutableArray alloc]initWithObjects: nil]; 
    [[super window] makeKeyAndOrderFront:self];
    
   
}

-(void)setUpViewsOnCorkboard:(NSArray *)array{
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
            [self setUpViewsOnCorkboard:[cardManager getAllCardsAndThreads]];
            [state setThreadToCreate:nil];
            
        }
       [state setCardSelected:[(CBMCardView *)sender cardObject]];
    }else{
            [state setCardSelected:[(CBMCardView *)sender cardObject]];
    }
 }



-(void)askToDelete:(id)sender{
    if([sender isKindOfClass:[CBMCardView class] ]){
      //  NSLog(@"Working");
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
            CBMCardView *cardView = [[CBMCardView alloc]initWithFrame:NSMakeRect(p.x-(cardWidth/2),p.y-(cardHeight/2), cardWidth, cardHeight) AndCBMCard:acard];
                        [corkboardView addSubview:cardView];
            [cardView setCardTypeManager:typeManager]; 
            [state setCardToCreate:nil];
        }else if ([state creatingThread]){
            [state setCardSelected:Nil];
        }
}

-(void)refreshManagerAndUI{
    [cardManager refresh];
    //if display
    if([searchButton state] == NSOffState){
        [self avoidDisplay:displayArray]; }
    else
        [self avoidSearchCriteria:displayArray WithDepth:[stepper intValue]];
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
        CBMCardView *cardView = [[CBMCardView alloc]initWithFrame:NSMakeRect(point.x-(cardWidth/2), point.y-(cardHeight/2), cardWidth, cardHeight) AndCBMCard:aCard];
        [corkboardView addSubview:cardView];
        [cardView setCardTypeManager:typeManager];
        }
    }
    return nil;
}

/*!
 Creates thread views and puts them on board
 @param array can be filled with any objects, there is a check for threads
 */
-(NSArray *)createThreadViews:(NSArray *)array{
   // NSLog(@"createThreadViews");
    for(Thread *aThread in array){
        if([aThread isKindOfClass:[Thread class]]){
           // NSLog(@"thread found");
        NSArray *anArray = [[aThread cards]allObjects];
          //  NSLog(@"Thread - %lu", [anArray count]);
        NSPoint startPoint = [(Card *)[anArray objectAtIndex:0] getLocation];
        NSPoint endPoint = [(Card *)[anArray objectAtIndex:1]getLocation];
        NSPoint origin = NSMakePoint(MIN(startPoint.x, endPoint.x), MIN(startPoint.y, endPoint.y));
        NSSize size = NSMakeSize(MAX(startPoint.x, endPoint.x)-MIN(startPoint.x, endPoint.x), MAX(startPoint.x, endPoint.x)-MIN(startPoint.x, endPoint.x));
        NSRect newFrame = NSMakeRect(origin.x, origin.y, size.width, size.height);
        CBMThreadView *aView = [[CBMThreadView alloc]initWithFrame:newFrame AndThread:aThread];
            [aView setThreadTypeManager:typeManager]; 
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
    [corkboardView setTheState:state]; 

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
 redraws corkboard by getting model objects accroding to the criteria and with the specific depth. 
 @param criteria - NSArray that contains types (Card or Thread) that should be avoided 
 @param integer - NSInteger depth that should be how deep the BFS should go
 */
-(void)avoidSearchCriteria:(NSArray *)criteria WithDepth:(NSInteger)integer{
    if([state cardSelected] != nil){
     
        NSArray *anArray = [cardManager searchOnCard:[state cardSelected] WithDepth:integer AndAvoid:displayArray];
        [corkboardView setSubviews:[[NSArray alloc]initWithObjects: nil]];
        [self createThreadViews:anArray];
        [self createCardViews:anArray];
        //NSLog(@"searchCriteria - %lu", [anArray count]);
    }
}
/*!
 Method to call when display has changed
 */
-(void)avoidDisplay:(NSArray *)criteria{
    NSArray *anArray;
    [corkboardView setSubviews:[[NSArray alloc]initWithObjects:nil]];
    if([criteria count] == 0){
        NSLog(@"avoid display count is zero");
        anArray = [cardManager getAllCardsAndThreads];
    }else{
        NSLog(@"avoid display - criteria used");
        anArray = [cardManager getAllCardsAndThreadsAndAvoid:criteria];
    }
     [self createThreadViews:anArray];
    [self createCardViews:anArray];
}

/*! Sets up all the card and thread type scrollers */
-(void)setUpSideScrollViews{
    //set up card type display 
    cardDisplayHolder =[[CBMGrowingView alloc]initWithFrame:NSMakeRect(0,0,cardDisplayScrollView.frame.size.width, 0.0)];
       [cardDisplayScrollView setDocumentView:cardDisplayHolder];
    [self generateCardTypeButtons:cardDisplayHolder withSelector:@selector(actionDisplayCard:)];
    
    //set up thread type display
    threadDisplayHolder = [[CBMGrowingView alloc]initWithFrame:NSMakeRect(0,0,threadDisplayScrollView.frame.size.width, 0)];
    [threadDisplayScrollView setDocumentView:threadDisplayHolder];
    [self generateThreadTypeButtons:threadDisplayHolder withSelector:@selector(actionDisplayThread:)];
    
    //set up notifications
    [[NSNotificationCenter defaultCenter]addObserver:cardDisplayHolder selector:@selector(viewFrameChanged:) name:NSViewFrameDidChangeNotification object:cardDisplayScrollView];
    [[NSNotificationCenter defaultCenter]addObserver:threadDisplayHolder selector:@selector(viewFrameChanged:) name:NSViewFrameDidChangeNotification object:threadDisplayScrollView];
   }

/*!action method, if a checkbox for a card is clicked this method should be called. 
 Adds the card type to the display array or removes it (on or off state)
 redraws the corkboard after the change in display
 @param sender - NSButton (checkbox button) 
 */
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
/*! action method, if checkbox card is double clicked it will change the state to
 create a card on the corkboard
 @param sender - CBMCheckboxCard 
 */
-(void)cardTypeClicked:(id)sender{
    //NSLog(@"Search and Display - card clicked");
    if([sender isKindOfClass: [CBMCheckboxCard class]]){
        CBMCheckboxCard *c = (CBMCheckboxCard * )sender;
        //NSLog(@"Color %@ and Name %@", [[c type] color], [[c type] name]);
        if([[self document] isKindOfClass: [CBMDocument class]]){
            CBMDocument *doc = [self document];
            [[doc theState]setCardToCreate:[c type]];
        }
        
    }
}

/*! action method, if checkbox thread is clicked it will change the state to create
 a thread on the corkboard. 
 @param sender - CBMCheckboxThread 
 */
-(void)threadTypeClicked:(id)sender{
    //NSLog(@"Search and Display - thread was clicked");
    if([sender isKindOfClass: [CBMCheckboxThread class]]){
        CBMCheckboxThread *c = (CBMCheckboxThread * )sender;
       // NSLog(@"Color %@ and Name %@", [[c type] color], [[c type] name]);
        if([[self document] isKindOfClass: [CBMDocument class]]){
            CBMDocument *doc = [self document];
            [[doc theState]setThreadToCreate:[c type]];
        }
        
    }
}

/*! action method, if thread types to display changes it will add/remove
 the type to the display array and then redraw the corkboard
 @param sender - NSButton (check box)
 */
-(void)actionDisplayThread:(id)sender{
    if([sender isKindOfClass: [NSButton class]]){
        NSButton *box = sender;
        if([[box superview] isKindOfClass: [CBMCheckboxThread class]]){
            CBMCheckboxThread *c = (CBMCheckboxThread * )[box superview];
            if([displayArray containsObject:[c type]]){
                  NSLog(@"action display thread removed object");
                [displayArray removeObject:[c type]];
            }else{
                   NSLog(@"action display thread added object");
                [displayArray addObject:[c type]];
            }
        }
      
        [self redrawCorkboard];
    }
    
    
}
/*! Redraws the corkboard according to the state
 */
-(void)redrawCorkboard{
    if([searchButton state] == NSOnState){
        NSLog(@"Search Redraw Corkboard");
        [self avoidSearchCriteria:displayArray WithDepth:[stepper intValue]];
    }else{
        NSLog(@"Display Redraw Corkboard"); 
        [self avoidDisplay:displayArray];
    }
}

/*! 
 generates a card type button with a particular selector and puts them into the given growing view
 */
-(void)generateCardTypeButtons:(CBMGrowingView *)view withSelector:(SEL)selector{
    for(CardType *aType in [typeManager getAllCardTypes]){
        [view addSubview:[self getCardButton:aType setAction:selector] ];
    }
}

/*!
generates thread type buttons with a particular selector and puts them into the given
growing view
*/
-(void)generateThreadTypeButtons:(CBMGrowingView *)view withSelector:(SEL)selector{
    for(ThreadType *aType in [typeManager getAllThreadTypes]){
        [view addSubview:[self getThreadButton:aType setAction:selector]];
    }
}
/*!returns a CBMCheckboxThread view that was created from 
 the thread type and selector. Selector is used to set the action of the 
 ns button within the view
 @param aType - thread type used to create view 
 @param selector - selector to set the NSButton inside of the view
 @return NSView - CBMCheckboxThread view. 
 */
-(NSView *)getThreadButton:(ThreadType *)aType setAction:(SEL)selector{
    CBMCheckboxThread *threadSection = [[CBMCheckboxThread alloc]initWithFrame:NSMakeRect(0, 0, threadDisplayHolder.frame.size.width, 0) andThreadType:aType];
    [[threadSection checkbox]setTarget:self];
    [[threadSection checkbox]setAction:selector];
    return threadSection;
}
/*!returns a CBMCheckboxCard view that was created from
 the card type and selector. Selector is used to set the action of the
 ns button within the view
 @param aType - card type used to create view
 @param selector - selector to set the NSButton inside of the view
 @return NSView - CBMCheckboxCard view.
 */
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
/*!
 adds a new CBMCheckboxThread to the thread growing view if the new set has 
 greater count than the old. else it does nothing (implying that a delete occured) and 
 deletion handling happens during the actual even
 @param new - the new NSSet of threads
 @param old - the old NSSet of threads
 */
-(void)threadKeyPathChangedSetNew:(NSSet *)new andOldSet:(NSSet *)old{
    if([old count] > [new count]){
        //removal code is handled when the delete event is called.
    }else{
        NSSet* changed = [new filteredSetUsingPredicate:
                          [NSPredicate predicateWithFormat:@"NOT objectID IN %@",old]];
        for( ThreadType *aType in changed){
            [threadDisplayHolder addSubview:[self getThreadButton:aType setAction:@selector(actionDisplayThread:)]];
            }
    }
}
/*! 
 Action method, the search button was pressed 
 Redraws the corkboard according to the action pressed
 @param sender - NSButton that represents the search button on GUI
 */
- (IBAction)searchButtonPressed:(NSButton *)sender {
    
    if ([sender state] == NSOnState){
        [self avoidSearchCriteria:displayArray WithDepth:[stepper intValue]];
    }else{
        [self avoidDisplay:displayArray]; 
    }
}
/*!
 Action method, the stepper's value changed, redraws the corkbard is the search state is on
 @param sender - NSStepper that's value has changed 
 */
- (IBAction)stepper:(NSStepper *)sender {
    [textForStepper setStringValue:[NSString stringWithFormat:@"%li",[sender integerValue] ]];
    if([searchButton state] == NSOnState){
        [self avoidSearchCriteria:displayArray WithDepth:[stepper intValue]];
    }
}

/*! Code handling deallocation, removing observations and notifications
 */
-(void)dealloc{
    [typeManager removeObserver:self forKeyPath:CARD_TYPE_ARRAY];
    [typeManager removeObserver:self forKeyPath:THREAD_SET];
    
    [[NSNotificationCenter defaultCenter]removeObserver:corkboardView];
    [[NSNotificationCenter defaultCenter]removeObserver:corkboardView.superview];
    [[NSNotificationCenter defaultCenter]removeObserver:threadDisplayHolder];
    [[NSNotificationCenter defaultCenter]removeObserver:cardDisplayHolder];
}



@end
