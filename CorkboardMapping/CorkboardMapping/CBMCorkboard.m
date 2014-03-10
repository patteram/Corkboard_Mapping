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
    }
    return self;
}


/*
 Draws the corkboard
 */
- (void)drawRect:(NSRect)dirtyRect
{
    NSColor *color = [NSColor colorWithCalibratedRed:.6 green:.4 blue:.3 alpha:1.0];
    [color set];
    NSRectFill([self bounds]);
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

//-(void)mouseDown:(NSEvent *)theEvent{
//   NSLog(@"Mouse Location %lu, %lu", [theEvent mouseLocation] )
//}

-(BOOL)isFlipped{
    return YES; 
}


@end
