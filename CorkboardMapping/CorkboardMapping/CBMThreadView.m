//
//  CBMThreadView.m
//  CorkboardMapping
//
//  Created by Ashley Patterson on 3/14/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMThreadView.h"
#import "Card.h"
#import "Thread.h"
@implementation CBMThreadView
@synthesize thread;
@synthesize thePath;
@synthesize card1;
@synthesize card2;
- (id)initWithFrame:(NSRect)frame AndThread:(Thread *)aThread
{
    self = [super initWithFrame:frame];
    if (self) {
        self.thread = aThread;
        NSArray *anArray = [[thread cards]allObjects];
        card1 = [anArray objectAtIndex:0];
        card2 = [anArray objectAtIndex:1];
        thePath = [NSBezierPath bezierPath];
        [thePath moveToPoint:frame.origin];
        [thePath lineToPoint:NSMakePoint(frame.size.width-5, frame.size.height - 5)];
        [thePath setLineWidth:5.0];
        [thePath setLineCapStyle:NSRoundLineCapStyle];
        [card1 addObserver:self forKeyPath:@"rect" options:NSKeyValueObservingOptionNew context:nil];
        [card2 addObserver:self forKeyPath:@"rect" options:NSKeyValueObservingOptionNew context:nil];
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	NSColor *aColor = [NSColor blueColor];
    [aColor setStroke];
	[super drawRect:dirtyRect];
//    // Create the shadow
    NSShadow* theShadow = [[NSShadow alloc] init];
    [theShadow setShadowOffset:NSMakeSize(4.0, -5.0)];
    [theShadow setShadowBlurRadius:1.0];
    [theShadow setShadowColor:[[NSColor blackColor]
                               colorWithAlphaComponent:0.3]];
    
    [theShadow set];
    
    [thePath stroke];
    // Drawing code here.
}

-(void) setFrameBasedOnPoints:(NSPoint)startPoint and:(NSPoint)endPoint{
    NSPoint origin = NSMakePoint(MIN(startPoint.x, endPoint.x), MIN(startPoint.y, endPoint.y));
    NSSize size = NSMakeSize(MAX(startPoint.x, endPoint.x)-MIN(startPoint.x, endPoint.x), MAX(startPoint.y, endPoint.y)-MIN(startPoint.y, endPoint.y));
    NSRect newFrame = NSMakeRect(origin.x, origin.y, size.width, size.height);
    [self setFrame:newFrame];
    thePath = [NSBezierPath bezierPath];
    startPoint.x = startPoint.x - origin.x;
    startPoint.y = startPoint.y - origin.y;
    endPoint.x = endPoint.x - origin.x;
    endPoint.y = endPoint.y - origin.y; 
    [thePath moveToPoint:startPoint];
    [thePath lineToPoint:endPoint];
    [thePath setLineWidth:5.0];
    [thePath setLineCapStyle:NSRoundLineCapStyle];
    [[NSColor blueColor] set];
    NSLog(@"CARD ONE %f, %f", endPoint.x, endPoint.y);
    NSLog(@"Card TWO %f, %f", startPoint.x, startPoint.y);
    NSLog(@"Thread created %f,%f,%f,%f", newFrame.origin.x, newFrame.origin.y, newFrame.size.width, newFrame.size.height);

}

-(BOOL)isFlipped{
    return YES; 
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"rect"]){
        [self setFrameBasedOnPoints:[card1 getLocation] and:[card2 getLocation]];
    }
}
-(void)dealloc{
    [card1 removeObserver:self forKeyPath:@"rect"];
    [card2 removeObserver:self forKeyPath:@"rect"];
}
@end
