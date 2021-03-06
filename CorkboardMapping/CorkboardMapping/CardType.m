//
//  CardType.m
//  CorkboardMapping
//
//  Created by Ashley Patterson on 2/24/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CardType.h"
#import "Card.h"


@implementation CardType

@dynamic color;
@dynamic name;
@dynamic cardsOfType;
@synthesize toCreate;
@synthesize visible;
-(id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    if(self){
        visible = YES;
    }
    return self;
}

@end
