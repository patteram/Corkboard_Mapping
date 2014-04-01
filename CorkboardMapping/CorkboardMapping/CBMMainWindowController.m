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
#import "CBMTypeManager.h"
#import "CBMCardAndThreadManager.h"
#import "CBMDocument.h"

@interface CBMMainWindowController ()

@end

@implementation CBMMainWindowController

@synthesize corkboardView;
@synthesize state;
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
    [self setUpViews];
       if([[self document] isKindOfClass: [CBMDocument class]]){
        CBMDocument *doc = [self document];
        NSManagedObjectContext *myContext = [doc managedObjectContext];
        state = [doc theState];
        cardManager = [[CBMCardAndThreadManager alloc]initWithModelContext:myContext];
       [self setUpViews:[cardManager getAllCardsAndThreads]];
    }
  
    
   
}

-(void)setUpViews:(NSArray *)array{
    
    if(array != nil){
        //            NSLog(@"Not Nil");
        //            NSLog(@"Size = %lu", (unsigned long)[array count] );
       [corkboardView setSubviews:[[NSArray alloc]initWithObjects:nil]];
        [self createThreadViews:array];
        [self createCardViews:array];
        
    }
}
-(void)cardClicked:(id)sender{
    if([state creatingThread]){
        NSLog(@"Main Window - creating thread state");
        if([state cardOne] != nil && [state cardOne] != [(CBMCardView *)sender cardObject]){
            NSLog(@"Main Window - cardOne is not nil");
            
            //then create thread connecting this card and last card
            [cardManager createThreadWithType:[state threadToCreate] BetweenCard:[state cardOne] AndCard:[(CBMCardView *)sender cardObject]];
            [self setUpViews:[cardManager getAllCardsAndThreads]];
            [state setThreadToCreate:nil];
        }else{
            NSLog(@"Main Window - cardOne is nil");
            [state setCardOne:[(CBMCardView *)sender cardObject]];
        }
        
    }else{
        NSLog(@"Main Window - not creating thread"); 
    }
    NSLog(@"A CARD WAS CLICKED");
}
-(void)askToDelete:(id)sender{
    if([sender isKindOfClass:[CBMCardView class] ]){
        NSLog(@"Working");
        [sender removeFromSuperview];
        [cardManager deleteCard:[sender cardObject]];
    }else if([sender isKindOfClass:[CBMThreadView class]]){
        [sender removeFromSuperview];
        [cardManager deleteThread:[sender threadObject]];
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
            [state setCardOne:Nil];
        }
}

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
-(void)setUpViews{
    CBMCenteringView *centerView = [[CBMCenteringView alloc]initWithFrame:NSMakeRect(0, 0, 3000, 3000)];
    corkboardView  = [[CBMCorkboard alloc]initWithFrame:NSMakeRect(0, 0, 3000, 3000)];
    [centerView addSubview:corkboardView];
    
    //create scrollView
    NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:
                                [[[super window] contentView] frame]];
    [scrollView setHasVerticalScroller:YES];
    [scrollView setHasHorizontalScroller:YES];
    [scrollView setAutoresizingMask:NSViewLayerContentsPlacementCenter];
  
    [scrollView setDocumentView:centerView];
       [scrollView setDrawsBackground:NO];

   [[NSNotificationCenter defaultCenter]addObserver:centerView selector:@selector(viewFrameChanged:) name:NSViewFrameDidChangeNotification object:corkboardView];
    [[NSNotificationCenter defaultCenter]addObserver:centerView selector:@selector(viewFrameChanged:) name:NSViewFrameDidChangeNotification object:scrollView];
    [[NSNotificationCenter defaultCenter]addObserver:corkboardView selector:@selector(viewFrameChanged:) name:NSViewFrameDidChangeNotification object:scrollView];

    [[super window] setContentView:scrollView];
 
}

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
-(void)avoidSearchDisplayCritieria:(NSArray *)criteria andDepth:(NSInteger)integer{
    
}

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




@end
