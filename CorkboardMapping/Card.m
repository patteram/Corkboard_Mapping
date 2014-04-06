//
//  Card.m
//  CorkboardMapping
//
//  Created by Ashley Patterson on 2/24/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "Card.h"
#import "CardType.h"
#import "Thread.h"


@implementation Card

@dynamic body;
@dynamic rect;
@dynamic title;
@dynamic connections;
@dynamic myCardType;
@synthesize selected;
@synthesize selectedColor; 
-(void)setLocation:(NSPoint)aPoint{
    [self setRect:[NSValue valueWithPoint:aPoint]];
}
-(NSPoint)getLocation{
    return [[self rect] pointValue];
}

@end
