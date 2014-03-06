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
        CBMCardAndThreadManager *cardManager = [[CBMCardAndThreadManager alloc]initWithModelContext:myContext];
       // CardType *one = [cardManager createCardType:@"Character" AndColor:[NSColor blueColor]];
       // CardType *two =[cardManager createCardType:@"Scene" AndColor: [NSColor greenColor]];
       // [cardManager createCardWithType:one andTitle:@"Bilbo Baggins" andBody:@"Hobbit from the shire"];
       // [cardManager createCardWithType:two andTitle:@"Game of Riddles" andBody:@"Where Bilbo and Golumn face Off"];
        NSArray *array = [cardManager getAllCardsAndThreads];
        if(array != nil){
//            NSLog(@"Not Nil");
//            NSLog(@"Size = %lu", (unsigned long)[array count] );
            [self createCardViews:array];
                }
    }
   
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
/**
 Stops window from closings and asks the document to handle a save and stop document
 */
-(BOOL)windowShouldClose:(id)sender{
[[self document]canCloseDocumentWithDelegate:[self document] shouldCloseSelector:@selector(close) contextInfo:nil];
    return NO;
}
-(NSArray *)createCardViews:(NSArray *)array{
    CGFloat x = 30;
    CGFloat y = 30;
    for(Card *aCard in array){
        CBMCardView *cardView = [[CBMCardView alloc]initWithFrame:NSMakeRect(x, y, 190, 120) AndCBMCard:aCard];
        x = x + 100;
        y = y + 100;
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



@end
