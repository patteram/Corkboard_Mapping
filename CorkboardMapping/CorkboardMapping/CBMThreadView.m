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
@synthesize isHighlighted;
@synthesize threadTypeManager;
@synthesize clickPath;
- (id)initWithFrame:(NSRect)frame AndThread:(Thread *)aThread
{
    self = [super initWithFrame:frame];
    if (self) {
        self.threadObject = aThread;
        NSArray *anArray = [[threadObject cards]allObjects];
        //NSLog(@"Thread count %lu", [anArray count]);
        card1 = [anArray objectAtIndex:0];
        card2 = [anArray objectAtIndex:1];
        thePath = [NSBezierPath bezierPath];
        [self setFrameBasedOnPoints:[card1 getLocation] and:[card2 getLocation]]; 
        [thePath setLineCapStyle:NSRoundLineCapStyle];
        [card1 addObserver:self forKeyPath:@"rect" options:NSKeyValueObservingOptionNew context:nil];
        [card2 addObserver:self forKeyPath:@"rect" options:NSKeyValueObservingOptionNew context:nil];
        [threadObject addObserver:self forKeyPath:@"cards" options:NSKeyValueObservingOptionNew
                          context:nil];
        [threadObject addObserver:self forKeyPath:@"myThreadType" options:NSKeyValueObservingOptionNew context:nil];
        isHighlighted = NO;
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
    if(isHighlighted){
    // Create the shadow
    NSShadow* theShadow = [[NSShadow alloc] init];
    [theShadow setShadowOffset:NSMakeSize(4.0, -5.0)];
    [theShadow setShadowBlurRadius:1.0];
    [theShadow setShadowColor:[[NSColor blackColor]
                               colorWithAlphaComponent:0.3]];
    
    [theShadow set];
    }
    //[clickPath fill];
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
    clickPath = [NSBezierPath bezierPath];
    [clickPath moveToPoint:NSMakePoint(startPoint.x+6, startPoint.y+6)];
    [clickPath lineToPoint:NSMakePoint(startPoint.x-6, startPoint.y-6)];
    [clickPath lineToPoint:NSMakePoint(endPoint.x  - 6, endPoint.y-6)];
     [clickPath lineToPoint:NSMakePoint(endPoint.x + 6, endPoint.y+6)];
    [clickPath lineToPoint:NSMakePoint(startPoint.x+6, startPoint.y+6)];
    [clickPath closePath];
    
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
    NSPoint loc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
   // NSLog(@" %f, %f", loc.x, loc.y);
    if([clickPath containsPoint:loc]){
        isHighlighted = YES;
     [self setNeedsDisplay:YES];
    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Card Menu"];
    [theMenu insertItemWithTitle:@"Delete" action:@selector(delete:) keyEquivalent:@"" atIndex:0];
    NSMenuItem *item = [[NSMenuItem alloc]initWithTitle:@"Set Thread Type:" action:nil keyEquivalent:@""];
    NSMenu *subMenu = [[NSMenu alloc]initWithTitle:@"Thread Type Selection"];
    NSArray *threadTypes = [threadTypeManager getAllThreadTypes];
    for(int i = 0; i < [threadTypes count]; i++){
        [subMenu addItemWithTitle:[[threadTypes objectAtIndex:i]name] action:@selector(changeType:) keyEquivalent:@""];
    }
    
    [item setSubmenu:subMenu];
    [theMenu addItem:item];
    [theMenu setDelegate:self]; 
    [NSMenu popUpContextMenu:theMenu withEvent:theEvent forView:self];
    }else{
        [super rightMouseDown:theEvent];
    }
   
}
-(void)menuDidClose:(NSMenu *)menu{
    isHighlighted = NO;
    [self setNeedsDisplay:YES];
}


-(void)changeType:(id)sender{
    NSArray *threadTypes = [threadTypeManager getAllThreadTypes];
    NSString *threadClickedName = [(NSMenuItem *)sender title];
    for(ThreadType *athread in threadTypes){
        if([[athread name]isEqualTo: threadClickedName]){
            [threadObject setMyThreadType:athread];
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"rect"]){
        if(card1 == nil || card2 == nil){
            [self removeFromSuperview];
        }
        [self setFrameBasedOnPoints:[card1 getLocation] and:[card2 getLocation]];
    }else if([keyPath isEqualToString:@"cards"]){
        [self removeFromSuperview];
    }else{
        [self setNeedsDisplay:YES]; 
    }
}
-(void)dealloc{
    [card1 removeObserver:self forKeyPath:@"rect"];
    [card2 removeObserver:self forKeyPath:@"rect"];
    [threadObject removeObserver:self forKeyPath:@"cards"];
    [threadObject removeObserver:self forKeyPath:@"myThreadType"];
}



@end
