//
// CBMCorkboard.m
//  CorkboardMapping
//
//  Created by Ashley Patterson on 10/8/13.
//  Copyright (c) 2013 Ashley Patterson. All rights reserved.
//

#import "CBMCorkboard.h"
@implementation CBMCorkboard
@synthesize currentScaleFactor;
@synthesize theState = _theState;
@synthesize currentMouseLoc;
const float VARIES = 5;
const float MAX_ZOOM = 3;
const float MIN_ZOOM = .23;

/**
 initializes the frame and sets the scalefactor to 1
 returns itself.
 **/
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"View is being created");
        self.currentScaleFactor = 1.0f;
        [self CBMsetUpTrackingAreaOnSelf];
    }
    return self;
}

-(CBMState *)theState{
    return _theState;
}


-(void)setTheState:(CBMState *)theState{
    _theState = theState;
    [_theState addObserver:self forKeyPath:@"creatingThread" options:NSKeyValueObservingOptionNew context:nil];
    [_theState addObserver:self forKeyPath:@"creatingCard" options:NSKeyValueObservingOptionNew context:nil];
    [_theState addObserver:self forKeyPath:@"cardSelected" options:
     
     NSKeyValueObservingOptionNew context:nil];
}

-(void)dealloc{
    [_theState removeObserver:self forKeyPath:@"creatingThread"];
    [_theState removeObserver:self forKeyPath:@"creatingCard"];
    [_theState removeObserver:self forKeyPath:@"cardSelected"];
}
/*
 Draws the corkboard
 */
- (void)drawRect:(NSRect)dirtyRect
{
    NSColor *color = [NSColor colorWithCalibratedRed:.6 green:.4 blue:.3 alpha:1.0];
    [color set];
    NSRectFill([self bounds]);
    if(_theState && [_theState creatingThread] && [_theState cardSelected]){
        NSLog(@" should be making point");
      NSPoint thePoint = [[_theState cardSelected]getLocation];
        NSBezierPath *aPath = [NSBezierPath bezierPath];
        [aPath moveToPoint:thePoint];
        [aPath lineToPoint:currentMouseLoc];
        [[[_theState threadToCreate]color]setStroke];
        [aPath setLineWidth:4];
        [aPath stroke];
    }
    [super drawRect:dirtyRect];
}


-(void)viewFrameChanged:(NSNotificationCenter*)notification{
    [self resizeAndPositionFrame]; 
}


- (void) magnifyWithEvent:(NSEvent *)event{
    
    if([event magnification] > 0){
        if(self.currentScaleFactor < MAX_ZOOM){
            self.currentScaleFactor += .05;
        }
    }else{
        if(self.currentScaleFactor > MIN_ZOOM){
            self.currentScaleFactor += -.05;
        }
    }
    [self resizeAndPositionFrame];
}
/*!
 resizes the view based on current scale factor and centers the view within the the super view.
 */
-(void)resizeAndPositionFrame{
    NSRect frame = [self frame];
    NSRect bounds = [self bounds];
    frame.size.width = bounds.size.width * self.currentScaleFactor;
    frame.size.height = bounds.size.height * self.currentScaleFactor;
    [self setFrameSize: frame.size];
    [self setBoundsSize: bounds.size];  
    
    CGFloat differenceX = 0;
    CGFloat differenceY = 0; //change position of view, so that if it is smaller than view it will need to got to center of view
    if(frame.size.width < [[self superview]superview].frame.size.width | frame.size.height < [[self superview]superview].frame.size.height) {
        if(frame.size.width < [self superview].frame.size.width ){
            differenceX =  ([self superview].frame.size.width - frame.size.width)/2;
        }
        if(frame.size.height < [self superview].frame.size.height){
            differenceY = ([self superview].frame.size.height - frame.size.height)/2;
        }
    }
    [self setFrameOrigin: NSMakePoint(differenceX, differenceY)];
    [self  setNeedsDisplay:YES];
    
}


-(void)rightMouseDown:(NSEvent *)theEvent{
    //plan would be to have a pop up menu
}

-(void)mouseDown:(NSEvent *)theEvent{
    [self tryToPerform:@selector(mouseDownInCorkboard:) with:theEvent]; 
}

-(BOOL)isFlipped{
    return YES; 
}

/**
 Sets up the tracking area so when crusor enters it can change
 */
-(void) CBMsetUpTrackingAreaOnSelf{
    NSTrackingArea *areaToTrack = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                               options:(NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved |NSTrackingInVisibleRect | NSTrackingActiveInKeyWindow) owner:self userInfo:nil];
    [self addTrackingArea:areaToTrack];
}

//-(void)cursorUpdate:(NSEvent *)event{
//    
//}

-(void)mouseMoved:(NSEvent *)theEvent{
    currentMouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    //NSLog(@"Mouse Moved");
    if(_theState && [_theState creatingThread]){
         //  NSLog(@"Mouse Moved & creating thread");
        [self setNeedsDisplay:YES]; 
    }
}
-(void)mouseEntered:(NSEvent *)theEvent{
    //if state is to create card or thread
  //  [[NSCursor crosshairCursor] push];
    [self resetCursorRects];
    
}
-(void)mouseExited:(NSEvent *)theEvent{
  //  [NSCursor pop];
}

-(void)resetCursorRects{
    [super resetCursorRects];
    if([_theState creatingCard]){
        NSImage *aImage = [[NSImage alloc]initWithSize:NSMakeSize(50, 50)];
        [aImage lockFocus];
        NSBezierPath *aPath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(0,0, 45, 30) xRadius:5 yRadius:5];
        [[[_theState cardToCreate]color]setFill];
        [aPath fill]; 
        [aPath stroke];
        [aImage unlockFocus];
        NSCursor *cardCursor = [[NSCursor alloc]initWithImage:aImage hotSpot:NSMakePoint(25, 25)];
        [cardCursor set];
    } else if([_theState creatingThread]){
        NSImage *aImage = [[NSImage alloc]initWithSize:NSMakeSize(25, 25)];
        [aImage lockFocus];
        NSBezierPath *aPath = [NSBezierPath bezierPath];
        [aPath moveToPoint:NSMakePoint(0, 25)];
        [aPath lineToPoint:NSMakePoint(25,0)];
        [[[_theState threadToCreate]color]setStroke];
        [aPath stroke];
        [aImage unlockFocus];
        NSCursor *cardCursor = [[NSCursor alloc]initWithImage:aImage hotSpot:NSMakePoint(0, 0)];
        [cardCursor set];
    }
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self setNeedsDisplay:YES];
    [self resetCursorRects];
}

@end
