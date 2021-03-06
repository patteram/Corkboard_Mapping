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
@synthesize deletionDelegate; 
- (id)initWithFrame:(NSRect)frame andThreadType:(ThreadType *)aType
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
            path = [NSBezierPath bezierPath];
            [path moveToPoint:NSMakePoint(frame.size.width*3/4, frame.size.height/2)];
            [path lineToPoint:NSMakePoint(frame.size.width, frame.size.height/2)];
//            CGFloat lineDash[4];
//            lineDash[0] = 2;
//            lineDash[1] = 3;
//            lineDash[2] = 5.0;
//            lineDash[3] = 1;
            [path setLineWidth:5];
//            
//            [path setLineDash:lineDash count:4 phase:5];
       
        }
        return self;  
   
}
-(void)dealloc{
    [type removeObserver:self forKeyPath:@"toCreate"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self setNeedsDisplay:YES];
}
- (void)drawRect:(NSRect)dirtyRect
{
    
	[super drawRect:dirtyRect];
   // NSLog(@"Checkbox Thread - dirty rect");
    if([type toCreate]){
       // NSLog(@"Checkbox Thread - creating shadow");
        NSShadow* theShadow = [[NSShadow alloc] init];
        [theShadow setShadowOffset:NSMakeSize(4.0, -2.0)];
        [theShadow setShadowBlurRadius:1.0];
        [theShadow setShadowColor:[[NSColor blackColor]
                               colorWithAlphaComponent:0.5]];
    
        [theShadow set];
    }
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
     NSBezierPath *checkPath = [NSBezierPath bezierPathWithRect:NSMakeRect(self.frame.size.width*3/4-2, 2, self.frame.size.width, self.frame.size.height-2)];
    if([checkPath containsPoint:[self convertPoint:[event locationInWindow] fromView:nil]]){
       // NSLog(@"hit it");
        [self tryToPerform:@selector(threadTypeClicked:) with:self];
    }else{
       // NSLog(@"No hit");
        [super mouseDown:event];
    }
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
