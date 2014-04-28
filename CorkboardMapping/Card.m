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
@synthesize visible;
-(void)setLocation:(NSPoint)aPoint{
    [self setRect:[NSValue valueWithPoint:aPoint]];
}
-(NSPoint)getLocation{
    return [[self rect] pointValue];
}

-(id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    if(self){
        visible = YES;
        selected = NO;
    }
    return self; 
}
@end
