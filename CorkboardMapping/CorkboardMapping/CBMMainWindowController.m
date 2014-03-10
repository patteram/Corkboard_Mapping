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
#import "CardAndThreadProtocol.h"
#import "CBMCardView.h"

#import "CBMCardAndThreadManager.h"


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
       if([[self document] isKindOfClass: [NSPersistentDocument class]]){
        NSPersistentDocument *doc = [self document];
        NSManagedObjectContext *myContext = [doc managedObjectContext];
        cardManager = [[CBMCardAndThreadManager alloc]initWithModelContext:myContext];
        one = [cardManager createCardType:@"Character" AndColor:[NSColor greenColor]];
           CardType *two =[cardManager createCardType:@"Scene" AndColor: [NSColor blueColor]];
          
          [cardManager createCardWithType:one AtLocation:NSMakePoint(20, 20) AndTitle:@"Wick Lamplighter" AndBody:@"3rd level libriarian"];
         
           [cardManager createCardWithType:two AtLocation:NSMakePoint(150,180) AndTitle:@"The One-Eyes Peggy" AndBody:@"Where Wick awakes shaighaied"];
        NSArray *array = [cardManager getAllCardsAndThreads];
        if(array != nil){
//            NSLog(@"Not Nil");
//            NSLog(@"Size = %lu", (unsigned long)[array count] );
            [self createCardViews:array];
                }
    }
}


-(BOOL)shouldCloseDocument{
    return YES;
}

-(IBAction)mouseDown:(NSEvent *)theEvent{
   
//    if(createCard){
//  NSPoint p =  [corkboardView convertPoint:[theEvent locationInWindow] fromView:nil];
//        Card *acard = [cardManager createCardWithType:one AtLocation:NSMakePoint(p.x, p.y)];
//    CBMCardView *cardView = [[CBMCardView alloc]initWithFrame:NSMakeRect(p.x-(190/2),p.y-(120/2), 190, 120) AndCBMCard:acard];
//    [corkboardView addSubview:cardView];
//        createCard = NO;
//    }
}

-(NSArray *)createCardViews:(NSArray *)array{
  
 
    for(Card *aCard in array){
        NSValue *j = [aCard rect];
        NSPoint point = j.pointValue;
        CBMCardView *cardView = [[CBMCardView alloc]initWithFrame:NSMakeRect(point.x, point.y, 190, 120) AndCBMCard:aCard];
       
        [corkboardView addSubview:cardView];
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
