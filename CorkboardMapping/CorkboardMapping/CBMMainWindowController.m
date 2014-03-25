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
        cardManager = [[CBMCardAndThreadManager alloc]initWithModelContext:myContext];
//        one = [cardManager createCardType:@"Character" AndColor:[NSColor greenColor]];
//        CardType *two =[cardManager createCardType:@"Chapter" AndColor: [NSColor redColor]];
//          
//        ThreadType *th1 = [[doc typeManager] createThreadTypeWithName:@"is in" andColor:[NSColor blueColor]];
//         Card *x =  [cardManager createCardWithType:one AtLocation:NSMakePoint(20, 20) AndTitle:@"Alevia Merst" AndBody:@"Knight-Priest of the Elipric Clan"];
//         Card *y = [cardManager createCardWithType:two AtLocation:NSMakePoint(150,180) AndTitle:@"Chapter 1" AndBody:@"Death of the ruler of Elipric Clan, Alevia accused of murder"];
//          [cardManager createThreadWithType:th1 BetweenCard:x AndCard:y];
        NSArray *array = [cardManager getAllCardsAndThreads];
        if(array != nil){
//            NSLog(@"Not Nil");
//            NSLog(@"Size = %lu", (unsigned long)[array count] );
            [self createThreadViews:array];
            [self createCardViews:array];
           
                }
    }
   
}


-(BOOL)shouldCloseDocument{
    return YES;
}

-(IBAction)mouseDown:(NSEvent *)theEvent{
    if([[self document] isKindOfClass: [CBMDocument class]]){
        CBMDocument *doc = [self document];
        if([[doc theState]creatingCard]){
            NSPoint p =  [corkboardView convertPoint:[theEvent locationInWindow] fromView:nil];
            Card *acard = [cardManager createCardWithType:[[doc theState] cardToCreate] AtLocation:NSMakePoint(p.x, p.y)];
            CBMCardView *cardView = [[CBMCardView alloc]initWithFrame:NSMakeRect(p.x-(190/2),p.y-(120/2), 190, 120) AndCBMCard:acard];
            [corkboardView addSubview:cardView];
            [[doc theState]setCreatingCard:NO];
        }
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
    for(Thread *aThread in array){
        if([aThread isKindOfClass:[Thread class]]){
            
        NSArray *anArray = [[aThread cards]allObjects];
        NSPoint startPoint = [(Card *)[anArray objectAtIndex:0] getLocation];
        NSPoint endPoint = [(Card *)[anArray objectAtIndex:1]getLocation];
        NSPoint origin = NSMakePoint(MIN(startPoint.x, endPoint.x), MIN(startPoint.y, endPoint.y));
        NSSize size = NSMakeSize(MAX(startPoint.x, endPoint.x)-MIN(startPoint.x, endPoint.x), MAX(startPoint.x, endPoint.x)-MIN(startPoint.x, endPoint.x));
        NSRect newFrame = NSMakeRect(origin.x, origin.y, size.width, size.height);
        CBMThreadView *aView = [[CBMThreadView alloc]initWithFrame:newFrame AndThread:aThread];
        [corkboardView addSubview:aView];
//            NSLog(@"CARD ONE %f, %f", endPoint.x, endPoint.y);
//            NSLog(@"Card TWO %f, %f", startPoint.x, startPoint.y); 
//            NSLog(@"Thread created %f,%f,%f,%f", newFrame.origin.x, newFrame.origin.y, newFrame.size.width, newFrame.size.height);
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
        anArray = [cardManager getAllCardsAndThreads];
    }else{
        anArray = [cardManager getAllCardsAndThreadsAndAvoid:criteria];
    }
    [self createCardViews:anArray];
}
-(void)avoidSearchDisplayCritieria:(NSArray *)criteria andDepth:(NSInteger)integer{
    
}

-(void)avoidDisplay:(NSArray *)criteria{
    NSArray *anArray;
    NSLog(@"%lu", [criteria count]);
    [corkboardView setSubviews:[[NSArray alloc]initWithObjects:nil]];
    if([criteria count] == 0){
        anArray = [cardManager getAllCardsAndThreads];
    }else{
        anArray = [cardManager getAllCardsAndThreadsAndAvoid:criteria];
    }
    [self createCardViews:anArray];
}

@end
