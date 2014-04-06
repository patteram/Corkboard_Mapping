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
@synthesize path;


- (id)initWithFrame:(NSRect)frame andCardType:(CardType *)aType
{
    self = [super initWithFrame:frame];
    if (self) {
        checkbox = [[NSButton alloc]initWithFrame:NSMakeRect(0,0,self.frame.size.width*3/4,0)];
        type = aType; 
        [type addObserver:self forKeyPath:@"toCreate" options:NSKeyValueObservingOptionNew context:nil];
        [checkbox setButtonType:NSSwitchButton];
        [checkbox setTitle:[aType name]];
        [checkbox setState:NSOnState];
        [self addSubview:checkbox];
        [self resetThePath];

    }
    return self;
}
-(void)dealloc{
    [type removeObserver:self forKeyPath:@"toCreate"];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    [[type color] setFill];
    [path fill];
    if([type toCreate]){
        NSShadow* theShadow = [[NSShadow alloc] init];
        [theShadow setShadowOffset:NSMakeSize(4.0, -2.0)];
        [theShadow setShadowBlurRadius:1.0];
        [theShadow setShadowColor:[[NSColor blackColor]
                                   colorWithAlphaComponent:0.3]];
        
        [theShadow set];
       // NSLog(@"is red");
        NSColor *c = [NSColor highlightColor];
        [c setStroke];
        [path setLineWidth:2.0];
    }else{
       // NSLog(@"is black");
        [[NSColor blackColor] setStroke];
        [path setLineWidth:1.0];
    }
    [path stroke]; 
}



-(void)mouseDown:(NSEvent *)event{
    if([path containsPoint:[self convertPoint:[event locationInWindow] fromView:nil]]){
       // NSLog(@"hit it");
         [self tryToPerform:@selector(cardTypeClicked:) with:self];
    }else{
        NSLog(@"No hit");
        [super mouseDown:event];
    }
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"toCreate"]){
        NSLog(@"Alert went out");
        [self setNeedsDisplay:YES];
    }
}
-(void)setFrameSize:(NSSize)newSize{
    [super setFrameSize:newSize];
    [checkbox setFrameSize:NSMakeSize(newSize.width*3/4, newSize.height)];
    [self resetThePath];
}

-(void)resetThePath{
    path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(self.frame.size.width*3/4-2, 5, self.frame.size.width/6, self.frame.size.height-5) xRadius:3 yRadius:3];
}
-(void)delete:(id)sender{
    [self tryToPerform:@selector(askToDelete:) with:self];
}
-(void)rightMouseDown:(NSEvent *)theEvent{
    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];
    [theMenu insertItemWithTitle:@"Delete" action:@selector(delete:) keyEquivalent:@"" atIndex:0];
    [NSMenu popUpContextMenu:theMenu withEvent:theEvent forView:self];
}
@end
