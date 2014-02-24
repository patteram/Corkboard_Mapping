//
//  CBMCheckbox.m
//  CorkboardMapping
//
//  Created by Ashley Patterson on 2/23/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMGrowingView.h"

@implementation CBMGrowingView
const int ROW_HEIGHT = 25;
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
    [self setFrameSize:NSMakeSize(self.frame.size.width, height)];
}

-(BOOL)isFlipped{
    return YES;
}
@end
