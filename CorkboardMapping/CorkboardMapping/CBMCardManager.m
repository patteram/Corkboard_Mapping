//
//  CBMCardManager.m
//  CoreDoc
//
//  Created by Ashley Patterson on 2/21/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMCardManager.h"
#import "CardType.h"
#import "Card.h"
#import "Thread.h"

@implementation CBMCardManager
@synthesize myContext;

-(id)initWithModelContext:(NSManagedObjectContext*)context{
    self = [super init];
    if(self){
        myContext = context;
        
    }
    return self;
}
-(NSArray*)getAllCardsAndThreads{
    NSMutableArray *combinedArray = [[NSMutableArray alloc]init];
    [combinedArray addObjectsFromArray:[self getAllCards]];
    [combinedArray addObjectsFromArray:[self getAllThreads]];
    return combinedArray;
}

-(NSArray *)getAllCards{
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Card" inManagedObjectContext: myContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:description];
    NSError *error;
    NSArray *array = [myContext executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"There was an error %@", [error description]);
    }
    return array;
}

-(NSArray *)getAllCardsAndAvoid:(NSArray *)criteria{
    //first get array of all cards
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Card" inManagedObjectContext: myContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:description];
    NSError *error;
    NSArray *array = [myContext executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"There was an error %@", [error description]);
    }
    //now get cards that are not in avoiding criteria
    NSMutableArray *filteredArray = [[NSMutableArray alloc]init];
    for(Card *aCard in array){
        if(![criteria containsObject:[aCard myCardType]]){
            [filteredArray addObject:aCard];
        }
    }
    return filteredArray;
}

-(NSArray *)getAllThreads{
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Thread" inManagedObjectContext:myContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:description];
    NSError *error;
    NSArray *array = [myContext executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"There was an error in retrieving Cards%@", [error description]);
    }
    return array;
}

-(NSArray *)getAllThreadsAndAvoid:(NSArray *)criteria{
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Thread" inManagedObjectContext:myContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:description];
    NSError *error;
    NSArray *array = [myContext executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"There was an error in retrieving Threads%@", [error description]);
    }

    NSMutableArray *filteredArray = [[NSMutableArray alloc]init];
    for(Thread *aThread in array){
        if(![criteria containsObject:[aThread myThreadType]]){
            [filteredArray addObject:aThread];
        }
    }
    return filteredArray;
}

-(NSArray*)getAllCardsAndThreadsAndAvoid:(NSArray *)criteria{
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[self getAllCardsAndAvoid:criteria]];
    [array addObjectsFromArray:[self getAllThreadsAndAvoid:criteria]];
    return array;
}
-(NSArray*)searchOnCard:(Card *)card AndWithDepth:(NSInteger)depth{
    return nil;
}


-(Card *)createCardWithType:(CardType *)type{
    return [self createCardWithType:type andTitle:@"Title" andBody:@"Body"];
}

-(Card *)createCardWithType:(CardType *)type andTitle:(NSString *) title andBody:(NSString *)body{
    NSEntityDescription *cardEntity = [NSEntityDescription
                                           entityForName:@"Card"
                                           inManagedObjectContext:myContext];
   Card *card = [[Card alloc]
                 initWithEntity:cardEntity insertIntoManagedObjectContext:myContext];
    [card setTitle:title];
    [card setBody:body];
    [card setMyCardType:type];
    return card;
}


-(CardType *)createCardType:(NSString *)string AndColor:(NSColor *)color{
    NSEntityDescription *cardType = [NSEntityDescription
                                       entityForName:@"CardType"
                                       inManagedObjectContext:myContext];
    CardType *type = [[CardType alloc]
                  initWithEntity:cardType insertIntoManagedObjectContext:myContext];

    [type setName:string];
    [type setColor:color];
 
    return type;
}


@end
