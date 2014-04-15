//
//  CBMThreadView.m
//  CorkboardMapping
//
//  Created by Ashley Patterson on 3/14/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMThreadView.h"
#import "Card.h"
#import "Thread.h"
#import "ThreadType.h"
@implementation CBMThreadView
@synthesize threadObject;
@synthesize thePath;
@synthesize card1;
@synthesize card2;
- (id)initWithFrame:(NSRect)frame AndThread:(Thread *)aThread
{
    self = [super initWithFrame:frame];
    if (self) {
        self.threadObject = aThread;
        NSArray *anArray = [[threadObject cards]allObjects];
        NSLog(@"Thread count %lu", [anArray count]); 
        card1 = [anArray objectAtIndex:0];
        card2 = [anArray objectAtIndex:1];
        thePath = [NSBezierPath bezierPath];
        [self setFrameBasedOnPoints:[card1 getLocation] and:[card2 getLocation]]; 
        [thePath setLineCapStyle:NSRoundLineCapStyle];
        [card1 addObserver:self forKeyPath:@"rect" options:NSKeyValueObservingOptionNew context:nil];
        [card2 addObserver:self forKeyPath:@"rect" options:NSKeyValueObservingOptionNew context:nil];
        [threadObject addObserver:self forKeyPath:@"cards" options:NSKeyValueObservingOptionNew
                          context:nil];
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	NSColor *aColor = [[threadObject myThreadType] color];
    [aColor setStroke];
	[super drawRect:dirtyRect];
//    // Create the shadow
//    NSShadow* theShadow = [[NSShadow alloc] init];
//    [theShadow setShadowOffset:NSMakeSize(4.0, -5.0)];
//    [theShadow setShadowBlurRadius:1.0];
//    [theShadow setShadowColor:[[NSColor blackColor]
//                               colorWithAlphaComponent:0.3]];
//    
//    [theShadow set];
    
    [thePath stroke];
    // Drawing code here.
}

-(void) setFrameBasedOnPoints:(NSPoint)startPoint and:(NSPoint)endPoint{
    NSPoint origin = NSMakePoint(MIN(startPoint.x, endPoint.x), MIN(startPoint.y, endPoint.y));
    NSSize size = NSMakeSize(MAX(startPoint.x, endPoint.x)-MIN(startPoint.x, endPoint.x), MAX(startPoint.y, endPoint.y)-MIN(startPoint.y, endPoint.y));
    NSRect newFrame = NSMakeRect(origin.x, origin.y, size.width, size.height);
    [self setFrame:newFrame];
    thePath = [NSBezierPath bezierPath];
    startPoint.x = startPoint.x - origin.x;
    startPoint.y = startPoint.y - origin.y;
    endPoint.x = endPoint.x - origin.x;
    endPoint.y = endPoint.y - origin.y; 
    [thePath moveToPoint:startPoint];
    [thePath lineToPoint:endPoint];
    [thePath setLineWidth:5.0];
    [thePath setLineCapStyle:NSRoundLineCapStyle];
}

-(BOOL)isFlipped{
    return YES; 
}

-(void)edit:(id)sender{
    [self tryToPerform:@selector(editType:) with:self]; 
}
-(void)delete:(id)sender{
    [self tryToPerform:@selector(askToDelete:) with:self];
}
-(void)rightMouseDown:(NSEvent *)theEvent{
    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];
    [theMenu insertItemWithTitle:@"Delete" action:@selector(delete:) keyEquivalent:@"" atIndex:0];
    [theMenu insertItemWithTitle:@"Edit" action:@selector(edit:) keyEquivalent:@"" atIndex:1];
    [NSMenu popUpContextMenu:theMenu withEvent:theEvent forView:self];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"rect"]){
        if(card1 == nil || card2 == nil){
            [self removeFromSuperview];
        }
        [self setFrameBasedOnPoints:[card1 getLocation] and:[card2 getLocation]];
    }else if([keyPath isEqualToString:@"cards"]){
        [self removeFromSuperview];
    }
}
-(void)dealloc{
    [card1 removeObserver:self forKeyPath:@"rect"];
    [card2 removeObserver:self forKeyPath:@"rect"];
    [threadObject removeObserver:self forKeyPath:@"cards"];
}

-(void)resetCursorRects{
    NSLog(@"Thread View - reset Cursors"); 
    [[self superview]resetCursorRects];
}


@end
