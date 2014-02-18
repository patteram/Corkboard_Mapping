//
//  CBMCenteringView.m
//  TestClassesModelView
//
//  Created by Ashley Patterson on 2/16/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMCenteringView.h"

@implementation CBMCenteringView

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
    NSColor *color = [NSColor grayColor];
    [color set];
    NSRectFill([self frame]);
	[super drawRect:dirtyRect];
    
}

-(void) viewFrameChanged:(NSNotification*)notification{
    [self resizeFrame];
}

-(void)resizeFrame{
    NSView *subView =  [[self subviews] objectAtIndex:0];
    NSView *superView = [self superview];
    CGFloat height = superView.frame.size.height;
    CGFloat width = superView.frame.size.width;
    
    if(subView.frame.size.height > superView.frame.size.height){
        height = subView.frame.size.height;
    }
    if(subView.frame.size.width > superView.frame.size.width){
        width = subView.frame.size.width;
    }
    [self setFrameSize:NSMakeSize(width, height)];
    NSLog(@"CenteringView is now %f and %f", [self superview].frame.origin.x, [self superview].frame.origin.y);
    [self setNeedsDisplay:YES];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"frame"]){
        [self resizeFrame];
    }
}
@end

