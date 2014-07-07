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
@synthesize mousePoint;
@synthesize oldCursor;
@synthesize deleteDelegate;
@synthesize cardTypeManager;
@synthesize cardDelegate;
@synthesize resizing;
const int BUFFER_SPACE = 4;
const float MIN_LENGTH = 150;
const float MIN_WIDTH = 250;
const float MAX_WIDTH = 450;
const float MAX_HEIGHT = 400;
const float DEFAULT_CARD_HEIGHT = 150;
const float DEFAULT_CARD_WIDTH = 280;
NSString *string = @"cardClicked:";
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
            [card addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
            [card addObserver:self forKeyPath:@"myCardType.color" options:NSKeyValueObservingOptionNew context:nil];
            [card addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
            [card addObserver:self forKeyPath:@"body" options:NSKeyValueObservingOptionNew context:nil];
            [card addObserver:self forKeyPath:@"myCardType.visible" options:NSKeyValueObservingOptionNew context:nil];
            [card addObserver:self forKeyPath:@"visible" options:NSKeyValueObservingOptionNew context:nil];
            [card addObserver:self forKeyPath:@"rect" options:NSKeyValueObservingOptionNew context:nil];
            cardObject = card; 
        }
    }
    return self;
    
}


-(void)dealloc{
    [cardObject removeObserver:self forKeyPath:@"selected"];
    [cardObject removeObserver:self forKeyPath:@"myCardType.color"];
    [cardObject removeObserver:self forKeyPath:@"title"];
    [cardObject removeObserver:self forKeyPath:@"body"];
    [cardObject removeObserver:self forKeyPath:@"myCardType.visible"];
    [cardObject removeObserver:self forKeyPath:@"visible"];
    [cardObject removeObserver:self forKeyPath:@"rect"];
}



/**
 Draws a white border around card
 */
- (void)drawHighlight
{
    NSColor *color = [cardObject selectedColor];
    NSBezierPath *cardPath2 = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(self.bounds.origin.x + 1, self.bounds.origin.y +1, self.bounds.size.width - 2, self.bounds.size.height - 2) xRadius:5 yRadius:5];
    [cardPath2 setLineWidth:4];
    [color setStroke];
    [cardPath2 stroke];
    NSBezierPath *cardPathInner = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(self.bounds.origin.x + 3, self.bounds.origin.y + 3, self.bounds.size.width - 6, self.bounds.size.height - 6) xRadius:5 yRadius:5];
    [cardPathInner setLineWidth:1];
    color = [NSColor blackColor];
    [color set];
    [cardPathInner stroke];
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSBezierPath *cardPath = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:5 yRadius:5];
    [cardColor setFill];
    [cardPath fill];
    if(dragging){
        NSColor *color = [NSColor whiteColor];
        [cardPath setLineWidth:3];
        [color setStroke];
    }else{
        NSColor *color = [NSColor blackColor];
        [color setStroke];
    }
    [cardPath stroke];
    NSColor *color = [NSColor blackColor];
    [color set];
    NSBezierPath *breakPoint = [NSBezierPath bezierPathWithRect:NSMakeRect(self.bounds.origin.x+BUFFER_SPACE, self.frame.size.height - 54, self.bounds.size.width-BUFFER_SPACE*2, BUFFER_SPACE)];
    [breakPoint fill];
    
    if([cardObject selected]){
        [self drawHighlight];
    }
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

/*! 
 Resizes view based on mouse point
 @param theNewPoint - superview converted mouse location that will be used to determine new size of view
 */
- (void)resizeView:(NSPoint)theNewPoint {
    float diffx = -1*((self.frame.origin.x +self.frame.size.width) - theNewPoint.x);
    float diffy = -1*((self.frame.origin.y+self.frame.size.height)-theNewPoint.y);
    float newWidth = self.frame.size.width+diffx;
    float newHeight = self.frame.size.height+diffy;
    if(newWidth > MAX_WIDTH){
        newWidth = MAX_WIDTH;
    }
    if(newHeight > MAX_HEIGHT){
        newHeight = MAX_HEIGHT;
    }
    if(newWidth < MIN_WIDTH){
        newWidth = MIN_WIDTH;
    }
    if(newHeight < MIN_LENGTH){
        newHeight = MIN_LENGTH;
    }
    [cardDelegate sizeChange:NSMakeSize(newWidth, newHeight) onCard:cardObject];
   // [self setFrame:NSMakeRect(self.frame.origin.x, self.frame.origin.y, newWidth, newHeight)];
    //[title setFrameOrigin:NSMakePoint(title.frame.origin.x, self.frame.size.height - 54)];
}

- (void)mouseDragged:(NSEvent *)theEvent{
    dragging = YES;
       NSPoint theNewPoint = [[self superview] convertPoint:[theEvent locationInWindow] fromView:nil];
    if(!resizing){
    if(theNewPoint.x > 0 && theNewPoint.y > 0){
        if(theNewPoint.x < [self superview].bounds.size.width&& theNewPoint.y < [self superview].bounds.size.height){
//        [self setFrameOrigin:NSMakePoint(theNewPoint.x - mousePoint.x, theNewPoint.y - self.frame.size.height + mousePoint.y )];
            [cardDelegate originChange:NSMakePoint(theNewPoint.x - mousePoint.x, theNewPoint.y - self.frame.size.height + mousePoint.y ) onCard:cardObject];
//        [cardDelegate originChange:NSMakePoint((theNewPoint.x - mousePoint.x)+self.bounds.size.width/2, (theNewPoint.y - self.frame.size.height + mousePoint.y )+self.bounds.size.height/2) onCard:cardObject  ];
            //TODO - Change Card Object Location to by MVC
        }
    }
    }else{
        [self resizeView:theNewPoint];
    }
    
    [self setNeedsDisplay:YES];
}



- (BOOL)checkIsPointSpecial:(NSPoint) point{
    NSBezierPath *rect = [NSBezierPath bezierPathWithRect:NSMakeRect(self.frame.size.width-10, 0, self.frame.size.width, 10)];
    if([rect containsPoint:point]){
        return YES;
    }else{
        return NO;
    }
}
-(void)mouseUp:(NSEvent *)theEvent{
    //NSLog(@"Mouse up Dragging NO");
    dragging = NO;
    [[NSCursor openHandCursor]set];
    [self resetCursorRects];
    resizing = NO;
   }


- (void) mouseEntered:(NSEvent *)theEvent{
    highlight = YES;
  //  NSLog(@"Mouse Entered Dragging No");
    dragging = NO;
    [[NSCursor openHandCursor]set];
    [self resetCursorRects];
}

-(void) mouseExited:(NSEvent *)theEvent{
    highlight = NO;
   
    [self setNeedsDisplay:YES];
    [[self superview] resetCursorRects];
  
}
-(void)mouseDown:(NSEvent *)theEvent{
    if(!dragging){
        mousePoint = [self  convertPoint:[theEvent locationInWindow] fromView:nil];
        if([self checkIsPointSpecial:mousePoint]){
            resizing = YES;
        }
    }
    if([cardDelegate respondsToSelector:@selector(clicked:)]){
        [self.cardDelegate clicked:self];
    }
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
    if(text == nil){
        text = @" ";
    }
    CGFloat x = self.bounds.origin.x+BUFFER_SPACE;
    CGFloat y = self.bounds.origin.y+BUFFER_SPACE;
    // buffer is *2 for width because
    CGFloat width = DEFAULT_CARD_WIDTH-BUFFER_SPACE*2;
    CGFloat height =  DEFAULT_CARD_HEIGHT/2;
    body = [[CBMTextView alloc]initWithFrame:NSMakeRect(x, y, width, height)];
    [body setMinSize:NSMakeSize(width, height)];
    [body setMaxSize:NSMakeSize(width, height*9)];
    [body setBackgroundColor:[NSColor clearColor]];
    [body setVerticallyResizable:YES];
    [[body textContainer] setContainerSize:NSMakeSize(width, height*9)];
    [[body textContainer] setHeightTracksTextView:NO];
    [body setString:text];
    [body setDelegate:self];
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
    if(text == nil){
        text = @" ";
    }
    CGFloat x = self.bounds.origin.x+BUFFER_SPACE;
    CGFloat y = self.frame.size.height - 54; //self.bounds.origin.y+(DEFAULT_CARD_HEIGHT/3)*2-BUFFER_SPACE;
    CGFloat width = self.bounds.size.width-BUFFER_SPACE*2;
    CGFloat height = DEFAULT_CARD_HEIGHT/4; //- BUFFER_SPACE*1;
    //set up title
    title = [[CBMTextView alloc] initWithFrame:NSMakeRect(x,y,width, height)];
    [title setMinSize:NSMakeSize(width, height)];
    [title setMaxSize:NSMakeSize(width, height*2)];
    [title setVerticallyResizable:NO];
    [title setHorizontallyResizable:YES];
    [title setBackgroundColor:[NSColor clearColor]];
    [title setString:text];
    [title alignCenter:self];
    //text container is nessart for controlling size
    [[title textContainer] setContainerSize:NSMakeSize(width, height*2)];
    [[title textContainer] setWidthTracksTextView:NO];
    [[title textStorage ]setFont:[NSFont boldSystemFontOfSize:16]];
    [title setDelegate:self]; 
    
    return title;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
 //   NSLog(@"key path: %@", keyPath);
 
    if([keyPath isEqualToString:@"myCardType.color"]){
      //  NSLog(@"string right");
        cardColor = [object valueForKeyPath:keyPath];
        for (NSScrollView *view in [self subviews]){
            [view setBackgroundColor:cardColor];
        }
    }else if ([keyPath isEqualToString:@"title"]){
        [title setString:[object valueForKey:keyPath]];
    }else if([keyPath isEqualToString:@"body"]){
        [body setString:[object valueForKey:keyPath]];
    }else if([keyPath isEqualToString:@"myCardType.visible"]){
        if(cardObject.myCardType.visible){
            [self setHidden:NO];
            [cardObject setVisible:YES];
        }else{
            [self setHidden:YES];
            [cardObject setVisible:NO];
        }
    }else if([keyPath isEqualToString:@"visible"]){
        if(cardObject.visible){
            [self setHidden:NO];
        }else{
            [self setHidden:YES];
        }
    }else if([keyPath isEqualToString:@"rect"]){
        [self setFrame:[cardObject getRectangle]];
        //[title setFrameOrigin:NSMakePoint(title.frame.origin.x, self.frame.size.height - 54)];
        //[title setFrameSize:NSMakeSize(self.frame.size.width - BUFFER_SPACE, title.frame.size.height)];

    }
    
    [self setNeedsDisplay:YES];
    
}

-(void)textDidChange:(NSNotification *)notification{
    if( notification.object == title){
        [cardDelegate titleTextChange:[title string] onCard:cardObject];
    }else if(notification.object == body){
        [cardDelegate bodyTextChange:[body string] onCard:cardObject];
    }
}


-(void)delete:(id)sender{
    if([deleteDelegate respondsToSelector:@selector(askToDelete:)]){
        [self.deleteDelegate askToDelete:self];
        // [self tryToPerform:@selector(mouseDownInCorkboard:) with:theEvent];
    }

}
-(void)rightMouseDown:(NSEvent *)theEvent{
    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Card PopUp Menu"];
    [theMenu insertItemWithTitle:@"Delete" action:@selector(delete:) keyEquivalent:@"" atIndex:0];
    NSMenuItem *cardTypeList = [[NSMenuItem alloc]initWithTitle:@"Change Card Type:" action:nil keyEquivalent:@""];
    NSMenu *subMenu = [[NSMenu alloc]initWithTitle:@"Card Type Selector"];
    NSArray *cardList = [cardTypeManager getAllCardTypes];
    if(cardList != nil){
        for(int i = 0; i < [cardList count]; i++){
            [subMenu insertItemWithTitle:[[cardList objectAtIndex:i]name] action:@selector(changeType:) keyEquivalent:@"" atIndex:i];
            }
    }
    [cardTypeList setSubmenu:subMenu];
    [theMenu addItem:cardTypeList];
    [NSMenu popUpContextMenu:theMenu withEvent:theEvent forView:self];
}

-(void)changeType:(id)sender{
   NSString *title =  [(NSMenuItem *)sender title];
    NSArray *cardList = [cardTypeManager getAllCardTypes];
    if(cardList != nil){
        for(int i = 0; i < [cardList count]; i++){
            if([[[cardList objectAtIndex:i]name]isEqualToString:title]){
                [cardDelegate typeChange:[cardList objectAtIndex:i] onCard:cardObject];
            }
        }
    }
    
}

-(void)resetCursorRects{
    [super resetCursorRects];
    if(dragging){
        [self addCursorRect:self.bounds cursor:[NSCursor closedHandCursor]];
    }else{
        [self addCursorRect:self.bounds cursor:[NSCursor openHandCursor]];
    }
    
}

-(void)cursorUpdate:(NSEvent *)event{
   // NSLog(@"update called?");
    [super cursorUpdate:event];
   // NSLog(@"NSCursor is %@", [NSCursor currentCursor]);
}

@end

