//
//  CBMThreadView.h
//  CorkboardMapping
//
//  Created by Ashley Patterson on 3/14/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Thread.h"
#import "Card.h"
#import "CBMTypeManager.h"
@interface CBMThreadView : NSView <NSMenuDelegate>
@property Thread *threadObject;
@property NSPoint startPoint;
@property NSPoint endPoint;
@property NSBezierPath *thePath;
@property Card *card1;
@property Card *card2;
@property CBMTypeManager *threadTypeManager;
@property BOOL isHighlighted;
@property NSBezierPath *clickPath;

-(id)initWithFrame:(NSRect)frameRect AndThread:(Thread *)thread;
@end
