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

#import "CBMCardManager.h"


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
    if([[self document] isKindOfClass: [NSPersistentDocument class]]){
        NSPersistentDocument *doc = [self document];
        NSManagedObjectContext *myContext = [doc managedObjectContext];
        CBMCardManager *cardManager = [[CBMCardManager alloc]initWithModelContext:myContext];
        NSArray *array = [cardManager getAllCardsAndThreads];
        if(array != nil){
            NSLog(@"Not Nil");
            NSLog(@"Size = %lu", (unsigned long)[array count] );
            for(Card *aCard in [cardManager getAllCardsAndThreads]){
                NSLog(@"Title %@", [aCard title]);
            }
        }
    }
   
    
    [self drawCorkboard];
   
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
-(NSArray *)createCardViews:(NSArray *)array{
    for(Card *aCard in array){
       // CBMCardView cardView = [CBMCardView alloc]initWithFrame:<#(NSRect)#> AndCBMCard:<#(Card *)#>
    }
    return nil;
}

-(void)drawCorkboard{
    CBMCenteringView *centerView = [[CBMCenteringView alloc]initWithFrame:NSMakeRect(0, 0, 3000, 3000)];
    corkboardView  = [[CBMCorkboard alloc]initWithFrame:NSMakeRect(0, 0, 3000, 3000)];
    [centerView addSubview:corkboardView];
    
    
    // create the scroll view so that it fills the entire window
    // to do that we'll grab the frame of the window's contentView
    // theWindow is an outlet connected to a window instance in Interface Builder
    NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:
                                [[[super window] contentView] frame]];
    
    // the scroll view should have both horizontal
    // and vertical scrollers
    [scrollView setHasVerticalScroller:YES];
    [scrollView setHasHorizontalScroller:YES];
    
    // configure the scroller to have no visible border
    [scrollView setBorderType:NSNoBorder];
    //contentRectForFrameRect:
    // set the autoresizing mask so that the scroll view will
    // resize with the window
    [scrollView setAutoresizingMask:NSViewLayerContentsPlacementCenter];
    
    // set theImageView as the documentView of the scroll view
    [scrollView setDocumentView:centerView];
    // [scrollView setAllowsMagnification:YES];
    [scrollView setDrawsBackground:NO];
    
   [[NSNotificationCenter defaultCenter]addObserver:centerView selector:@selector(viewFrameChanged:) name:NSViewFrameDidChangeNotification object:corkboardView];
    [[NSNotificationCenter defaultCenter]addObserver:centerView selector:@selector(viewFrameChanged:) name:NSViewFrameDidChangeNotification object:scrollView];
    [[NSNotificationCenter defaultCenter]addObserver:corkboardView selector:@selector(viewFrameChanged:) name:NSViewFrameDidChangeNotification object:scrollView];

    [[super window] setContentView:scrollView];
 
}



@end
