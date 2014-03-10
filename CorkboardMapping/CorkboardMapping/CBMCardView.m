//
//  CBMCardView.m
//  //  CorkboardMapping//
//  Created by Ashley Patterson on 2/5/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMCardView.h"

@implementation CBMCardView
@synthesize highlight;
@synthesize dragging;
@synthesize cardColor;
@synthesize cardObject;
@synthesize title;
@synthesize body;

const int BUFFER_SPACE = 4;

- (id)initWithFrame:(NSRect)frame
{
    self = [self initWithFrame:frame AndCBMCard:nil];
    
    return self;
}

-(id) initWithFrame:(NSRect)frame AndCBMCard:(Card*)card{
    self = [super initWithFrame:frame];
    
    if(self){
        
        if(card != nil){
            cardColor = [card valueForKeyPath:@"myCardType.color"];
            [self CBMsetUpTrackingAreaOnSelf];
            [self addSubview:[self CBMsetUpBodyTextAreaWithText:[card body]]];
            [self addSubview:[self CBMsetUpTitleTextAreaWithText:[card title]]];
            
            highlight = NO;
            dragging = NO;
            [card addObserver:self forKeyPath:@"myCardType.color" options:NSKeyValueObservingOptionNew context:nil];
            [card addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
            [card addObserver:self forKeyPath:@"body" options:NSKeyValueObservingOptionNew context:nil];
            cardObject = card; 
        }
    }
    return self;
    
}


-(void)dealloc{
    [cardObject removeObserver:self forKeyPath:@"myCardType.color"];
    [cardObject removeObserver:self forKeyPath:@"title"];
    [cardObject removeObserver:self forKeyPath:@"body"]; 
}




- (void)drawRect:(NSRect)dirtyRect
{
    NSBezierPath *cardPath = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:5 yRadius:5];
    [cardColor set];
    [cardPath fill];
    if(highlight | dragging){
        NSColor *color = [NSColor blueColor];
        [cardPath setLineWidth:3];
        [color set];
    }else{
        NSColor *color = [NSColor blackColor];
        [color set];
    }
    [cardPath stroke];
    NSColor *color = [NSColor blackColor];
    [color set];
    NSBezierPath *breakPoint = [NSBezierPath bezierPathWithRect:NSMakeRect(self.bounds.origin.x+BUFFER_SPACE, self.bounds.origin.y+self.bounds.size.height/2+BUFFER_SPACE*2, self.bounds.size.width-BUFFER_SPACE*2, BUFFER_SPACE)];
    [breakPoint fill];
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

- (void)mouseDragged:(NSEvent *)theEvent{ 
    CGFloat x = self.frame.origin.x + theEvent.deltaX;
    CGFloat y = self.frame.origin.y + theEvent.deltaY;
    [self setFrameOrigin: NSMakePoint(x, y) ];
    dragging = YES;
    [self setNeedsDisplay:YES];
}

-(void)mouseUp:(NSEvent *)theEvent{
    dragging = NO;
    highlight = YES; //takes a while for tracking area to catch up. it believes we've left but we know that it hasn't
    [self setNeedsDisplay:YES];
}
- (void) mouseEntered:(NSEvent *)theEvent{
    highlight = YES;
    [self setNeedsDisplay:YES];
}

-(void) mouseExited:(NSEvent *)theEvent{
    highlight = NO;
    [self setNeedsDisplay:YES];
}

/**
 Sets up the tracking area so if you go over card you can see the selectable icon.
 */
-(void) CBMsetUpTrackingAreaOnSelf{
    NSTrackingArea *areaToTrack = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                               options:(NSTrackingMouseEnteredAndExited | NSTrackingInVisibleRect | NSTrackingActiveInKeyWindow) owner:self userInfo:nil];
    [self addTrackingArea:areaToTrack];
}

/*!
 Sets up the body text area of the card view. Text view is on lower half of card and should have a space between the outer edges of card
 \param text: the text to put on the body of the card
 \returns a view that contains the body text area
 */
-(NSView*) CBMsetUpBodyTextAreaWithText:(NSString*)text{
    CGFloat x = self.bounds.origin.x+BUFFER_SPACE;
    CGFloat y = self.bounds.origin.y+BUFFER_SPACE;
    // buffer is *2 for width because
    CGFloat width = self.bounds.size.width-BUFFER_SPACE*2;
    CGFloat height =  self.bounds.size.height/2;
    body = [[NSTextView alloc]initWithFrame:NSMakeRect(x, y, width, height)];
    [body setMinSize:NSMakeSize(width, height)];
    [body setMaxSize:NSMakeSize(width, height*9)];
    [body setBackgroundColor:[NSColor clearColor]];
    [body setVerticallyResizable:YES];
    [[body textContainer] setContainerSize:NSMakeSize(width, height*9)];
    [[body textContainer] setHeightTracksTextView:NO];
    [body setString:text];
    
    NSScrollView *scrollview = [[NSScrollView alloc]initWithFrame:NSMakeRect(x, y, width, height)];
    [scrollview setHasVerticalScroller:YES];
    [scrollview setAutoresizingMask:NSViewWidthSizable |
     NSViewHeightSizable];
    [scrollview setDocumentView:body];
    [scrollview setBackgroundColor:cardColor];
    
    return scrollview;
}

/*!
 Sets up the title text area of the card view. Title is at the top of the card.
 \param text: the text to put as the title of the card
 \returns a view that contains the title area
 */
-(NSView*) CBMsetUpTitleTextAreaWithText:(NSString*)text{
    CGFloat x = self.bounds.origin.x+BUFFER_SPACE;
    CGFloat y =self.bounds.origin.y+(self.bounds.size.height/3)*2-BUFFER_SPACE;
    CGFloat width = self.bounds.size.width-BUFFER_SPACE*2;
    CGFloat height = self.bounds.size.height/4;
    //set up title
    title = [[NSTextView alloc] initWithFrame:NSMakeRect(x,y,width, height)];
    [title setMinSize:NSMakeSize(width, height)];
    [title setMaxSize:NSMakeSize(width*2, height)];
    [title setVerticallyResizable:NO];
    [title setHorizontallyResizable:YES];
    [title setBackgroundColor:[NSColor clearColor]];
    [title setString:text];
    [title alignCenter:self];
    //text container is nessart for controlling size
    [[title textContainer] setContainerSize:NSMakeSize(width*2, height)];
    [[title textContainer] setWidthTracksTextView:NO];
    [title setDelegate:self]; 
    //set up scroll view soif text gets to large
    NSScrollView *scrollview = [[NSScrollView alloc]initWithFrame:NSMakeRect(x, y, width, height-BUFFER_SPACE)];
    [scrollview setHasHorizontalScroller:YES];
    [scrollview setAutoresizingMask:NSViewWidthSizable |
     NSViewHeightSizable];
    [scrollview setDocumentView:title];
    [scrollview setBackgroundColor:cardColor];
    return scrollview;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@"key path: %@", keyPath);
    if([keyPath isEqualToString:@"cardType.color"]){
        NSLog(@"string right");
        cardColor = [object valueForKeyPath:keyPath];
        for (NSScrollView *view in [self subviews]){
            [view setBackgroundColor:cardColor];
        }
    }else if ([keyPath isEqualToString:@"title"]){
        [title setString:[object valueForKey:keyPath]];
    }else if([keyPath isEqualToString:@"body"]){
        [body setString:[object valueForKey:keyPath]];
    }
    
    [self setNeedsDisplay:YES];
    
}

-(void)textDidChange:(NSNotification *)notification{
    if( notification.object == title){
        [cardObject setValue:[title string] forKey:@"title"]; 
    }else if(notification.object == body){
        [cardObject setValue:[body string] forKey:@"body"];
    }
}

@end

