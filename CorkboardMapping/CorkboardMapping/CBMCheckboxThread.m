//
//  CBMCheckboxThread.m
//  CorkboardMapping
//
//  Created by Ashley Patterson on 3/14/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMCheckboxThread.h"

@implementation CBMCheckboxThread
@synthesize checkbox;
@synthesize type;
@synthesize path;
- (id)initWithFrame:(NSRect)frame andThreadType:(ThreadType *)aType
{

        self = [super initWithFrame:frame];
        if (self) {
            checkbox = [[NSButton alloc]initWithFrame:NSMakeRect(0,0,self.frame.size.width*3/4,0)];
            type = aType;
            
            [checkbox setButtonType:NSSwitchButton];
            [checkbox setTitle:[aType name]];
            [checkbox setState:NSOnState];
            [self addSubview:checkbox];
            path = [NSBezierPath bezierPath];
            [path moveToPoint:NSMakePoint(frame.size.width*3/4, frame.size.height/2)];
            [path lineToPoint:NSMakePoint(frame.size.width, frame.size.height/2)];
            CGFloat lineDash[4];
            lineDash[0] = 2;
            lineDash[1] = 6;
            lineDash[2] = 5.0;
            lineDash[3] = 2;
            [path setLineWidth:5];
            
            [path setLineDash:lineDash count:4 phase:5];
       
        }
        return self;  
   
}

- (void)drawRect:(NSRect)dirtyRect
{
    
	[super drawRect:dirtyRect];
    NSShadow* theShadow = [[NSShadow alloc] init];
    [theShadow setShadowOffset:NSMakeSize(4.0, -2.0)];
    [theShadow setShadowBlurRadius:1.0];
    [theShadow setShadowColor:[[NSColor blackColor]
                               colorWithAlphaComponent:0.3]];
    
    [theShadow set];
	[[type color ] set];
    [path stroke];
    // Drawing code here.
}

-(void)setFrameSize:(NSSize)newSize{
    [super setFrameSize:newSize];
    [checkbox setFrameSize:NSMakeSize(newSize.width*3/4, newSize.height)];
    [path removeAllPoints];
    [path moveToPoint:NSMakePoint([self frame].size.width*3/4, [self frame].size.height/2)];
    [path lineToPoint:NSMakePoint([self frame].size.width, [self frame].size.height/2)];
}
-(void)mouseDown:(NSEvent *)event{
     NSBezierPath *checkPath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(self.frame.size.width*3/4-2, 2, self.frame.size.width/6, self.frame.size.height-2) xRadius:3 yRadius:3];
    if([checkPath containsPoint:[self convertPoint:[event locationInWindow] fromView:nil]]){
        NSLog(@"hit it");
        [self tryToPerform:@selector(threadClickedXYZ:) with:self];

    }else{
        NSLog(@"No hit");
        [super mouseDown:event];
    }
    
}

@end
