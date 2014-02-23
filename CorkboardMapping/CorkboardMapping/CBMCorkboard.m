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

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"View is being created");
        
        self.currentScaleFactor = 1.0f;
    }
    return self;
}


//
- (void)drawRect:(NSRect)dirtyRect
{
    
    NSColor *color = [NSColor colorWithCalibratedRed:.6 green:.4 blue:.3 alpha:1.0];
    
    [color set];
    NSRectFill([self bounds]);
    
    
    [super drawRect:dirtyRect];
    
    
    // Drawing code here.
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
    
    NSLog(@"%@",
          [NSString stringWithFormat:@"ScaleFactor is %f", self.currentScaleFactor]);
    [self resizeAndPositionFrame];
}
-(void)resizeAndPositionFrame{
    NSRect frame = [self frame];
    NSRect bounds = [self bounds];
    frame.size.width = bounds.size.width * self.currentScaleFactor;
    frame.size.height = bounds.size.height * self.currentScaleFactor;
    
    [self setFrameSize: frame.size];    // Change the view's size.
    [self setBoundsSize: bounds.size];  // Restore the view's bounds, which causes the view to be scaled.
    //[self setValue:frame forKeyPath:@"frame.size"];
//    NSLog(@"Corkboard height = %f  and Frame width = %f", frame.size.height, frame.size.width);
//    NSLog(@"Super height = %f and width = %f", [self superview].frame.size.height, [self superview].frame.size.width);
//    NSLog(@"Corkboard x= %f  and Frame y = %f", frame.origin.x, frame.origin.y);
    // NSLog(@"Super height = %f  and Super width = %f", [self superview].frame.size.height,[self superview].frame.size.height );
    CGFloat differenceX = 0;
    CGFloat differenceY = 0;
    if(frame.size.width < [[self superview]superview].frame.size.width | frame.size.height < [[self superview]superview].frame.size.height) {
        
        if(frame.size.width < [self superview].frame.size.width ){
            differenceX =  ([self superview].frame.size.width - frame.size.width)/2;
            
        }
        if(frame.size.height < [self superview].frame.size.height){
            differenceY = ([self superview].frame.size.height - frame.size.height)/2;
        }
        
        //   NSLog(@"Frame changed");
        
        
        [self  setNeedsDisplay:YES];
        
    }
    [self setFrameOrigin: NSMakePoint(differenceX, differenceY)];
    
}







@end
