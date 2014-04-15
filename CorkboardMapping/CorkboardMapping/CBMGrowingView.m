//
//  CBMCheckbox.m
//  CorkboardMapping
//
//  Created by Ashley Patterson on 2/23/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMGrowingView.h"

@implementation CBMGrowingView
const int ROW_HEIGHT = 30;
- (id)initWithFrame:(NSRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}
-(void)addSubview:(NSView *) view{
    CGFloat height = self.frame.size.height;
    NSPoint point = NSMakePoint(0, height + ROW_HEIGHT/4);
    height = height + ROW_HEIGHT;
    [view setFrameOrigin:point];
    [view setFrameSize:NSMakeSize(view.frame.size.width, ROW_HEIGHT+0.0)];
    [super addSubview:view];
    [self setFrameSize:NSMakeSize(self.frame.size.width, height+ROW_HEIGHT/4)];
}



-(void)willRemoveSubview:(NSView *)view{
    NSUInteger i = [[self subviews]indexOfObject:view];
    if(i != NSNotFound){
        CGFloat heightBeforeI = (i) * (ROW_HEIGHT + ROW_HEIGHT/4);
        for(i = i+1; i < [[self subviews]count]; i++){
            [[[self subviews]objectAtIndex:i]setFrameOrigin:NSMakePoint(0, heightBeforeI + ROW_HEIGHT/4)];
            heightBeforeI = heightBeforeI + ROW_HEIGHT + ROW_HEIGHT/4;
        }
    
        [self setFrameSize:NSMakeSize(self.frame.size.width, heightBeforeI)];
    }
       [super willRemoveSubview:view];
}
-(BOOL)isFlipped{
    return YES;
}

-(void) viewFrameChanged:(NSNotification*)notification{
  // NSRect arect =  [[self superview]frame];
    if([[self superview]frame].size.width != self.frame.size.width){
        [self setFrameSize:NSMakeSize([[self superview]frame].size.width, self.frame.size.height)];
        for(NSView *aview in [self subviews]){
            [aview setFrameSize:NSMakeSize(self.frame.size.width, ROW_HEIGHT)];
        }
    }
}
@end
