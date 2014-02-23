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
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Card" inManagedObjectContext: myContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:description];
    NSError *error;
    NSArray *array = [myContext executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"There was an error %@", [error description]); // Deal with error...
    }
    
                                        
    return array;
}

-(NSArray*)getAllCardsAndThreadsAndAvoid:(NSArray *)criteria{
    return nil;
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
//-(BOOL)creatCardWithType:(CardType *)type

@end
