//
//  CBMCheckboxCard.m
//  CorkboardMapping
//
//  Created by Ashley Patterson on 3/8/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMCheckboxCard.h"

@implementation CBMCheckboxCard
@synthesize checkbox;
@synthesize type;
- (id)initWithFrame:(NSRect)frame andCardType:(CardType *)aType
{
    self = [super initWithFrame:frame];
    if (self) {
        checkbox = [[NSButton alloc]initWithFrame:NSMakeRect(0,0,self.frame.size.width*3/4,0)];
        type = aType; 
    
        [checkbox setButtonType:NSSwitchButton];
        [checkbox setTitle:[aType name]];
        [checkbox setState:NSOnState];
        [self addSubview:checkbox];

    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	NSBezierPath *path = [NSBezierPath bezierPathWithRect:NSMakeRect(self.frame.size.width*3/4-2, 2, self.frame.size.width/6, self.frame.size.height-2)];
    [[type color] setFill];
    [path fill];
}

-(void)setFrameSize:(NSSize)newSize{
    [super setFrameSize:newSize];
    [checkbox setFrameSize:NSMakeSize(newSize.width*3/4, newSize.height)];
}

@end
