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
 const float DEFAULT_CARD_HEIGHT = 150;
 const float DEFAULT_CARD_WIDTH = 280;
-(void)setLocation:(NSPoint)aPoint{
     NSRect r = [[self rect]rectValue];
    [self setRect: [NSValue valueWithRect:(NSMakeRect(aPoint.x, aPoint.y,r.size.width, r.size.height))]];
}
-(NSPoint)getLocation{
   return [[self rect]rectValue].origin;
}

-(NSSize)getSize{
    NSRect r = [[self rect]rectValue];
    return r.size;
}
-(void)setSize:(NSSize)aSize{
    NSRect r = [[self rect]rectValue];
    [self setRect: [NSValue valueWithRect:(NSMakeRect(r.origin.x, r.origin.y, aSize.width, aSize.height))]];
}

-(id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    if(self){
        visible = YES;
        selected = NO;
    }
    return self; 
}

-(NSRect)getRectangle{
    return [[self rect]rectValue];
}
-(void)setRectangle:(NSRect)rectangle{
    [self setRect: [NSValue valueWithRect:rectangle]]; 
}
@end
