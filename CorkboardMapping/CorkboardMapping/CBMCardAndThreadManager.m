//
//  CBMCardManager.m
//  CoreDoc
//
//  Created by Ashley Patterson on 2/21/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMCardAndThreadManager.h"
#import "CardType.h"
#import "Card.h"
#import "Thread.h"
#import "ThreadType.h"
#import "CBMTypeAlert.h"
#import "CBMMutableDistinctArray.h"

@implementation CBMCardAndThreadManager
@synthesize myContext;
@synthesize cards;
@synthesize threads;
-(id)initWithModelContext:(NSManagedObjectContext*)context{
    self = [super init];
    if(self){
        myContext = context;
        
    }
    return self;
}

-(void)deleteCard:(Card *)cardToDelete{
    [cards removeObject:cardToDelete];
    [ [self myContext] deleteObject:cardToDelete];

}
-(void)deleteThread:(Thread *)threadToDelete{
    [threads removeObject:threadToDelete];
    [ [self myContext] deleteObject:threadToDelete];

}

-(Thread *)createThreadWithType:(ThreadType *)threadType BetweenCard:(Card *)card AndCard:(Card *)card2{
    NSEntityDescription *threadEntity = [NSEntityDescription
                                       entityForName:@"Thread"
                                       inManagedObjectContext:myContext];
     Thread *thread = [[Thread alloc]
                  initWithEntity:threadEntity insertIntoManagedObjectContext:myContext];
    NSSet *set = [[NSSet alloc]initWithObjects:card,card2, nil];
    [thread setCards:set];
    [thread setMyThreadType: threadType];
    [threads addObject:thread];
    return thread;
}

-(NSArray*)getAllCardsAndThreads{
    NSMutableArray *combinedArray = [[NSMutableArray alloc]init];
    [combinedArray addObjectsFromArray:[self getAllCards]];
    [combinedArray addObjectsFromArray:[self getAllThreads]];
    return combinedArray;
}

-(NSArray *)getAllCards{
    if(cards == nil){
        NSEntityDescription *description = [NSEntityDescription entityForName:@"Card" inManagedObjectContext: myContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:description];
        NSError *error;
        NSArray *array = [myContext executeFetchRequest:request error:&error];
        if (array == nil)
        {
            NSLog(@"There was an error %@", [error description]);
        }
        cards = [[NSMutableArray alloc]initWithArray:array];
        return array;
    }else
        return cards;
}

-(NSArray *)getAllCardsAndAvoid:(NSArray *)criteria{
    if(cards == nil){
        [self getAllCards];
    }
    //now get cards that are not in avoiding criteria
    NSMutableArray *filteredArray = [[NSMutableArray alloc]init];
    for(Card *aCard in cards){
        if(![criteria containsObject:[aCard myCardType]]){
            [filteredArray addObject:aCard];
        }
    }
    return filteredArray;
}

-(NSArray *)getAllThreads{
    if(threads == nil){
        NSEntityDescription *description = [NSEntityDescription entityForName:@"Thread" inManagedObjectContext:myContext];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        [request setEntity:description];
        NSError *error;
        NSArray *array = [myContext executeFetchRequest:request error:&error];
        if (array == nil)
        {
            NSLog(@"There was an error in retrieving Cards%@", [error description]);
        }
        threads = [[NSMutableArray alloc]initWithArray:array];
        return array;
        }
    return threads;
}

-(NSArray *)getAllThreadsAndAvoid:(NSArray *)criteria{
    if (threads == nil)
    {
        [self getAllThreads];
    }

    NSMutableArray *filteredArray = [[NSMutableArray alloc]init];
    for(Thread *aThread in threads){
        if(![criteria containsObject:[aThread myThreadType]]){
            [filteredArray addObject:aThread];
        }
    }
    return filteredArray;
}

-(NSArray*)getAllCardsAndThreadsAndAvoid:(NSArray *)criteria{
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[self getAllCardsAndAvoid:criteria]];
    NSArray *array2 = [[NSArray alloc]initWithArray:[self getAllThreadsAndAvoid:criteria]];

    NSMutableArray *holdThreads = [[NSMutableArray alloc]init];
    for(Thread *thread in array2){
        NSArray *cardHolder = [[thread cards]allObjects];
        if([array containsObject:[cardHolder objectAtIndex:0]] && [array containsObject:[cardHolder objectAtIndex:1]]){
            [holdThreads addObject:thread];
        }
    }
    [array addObjectsFromArray:holdThreads];
    return array;
}

-(NSArray*)searchOnCard:(Card *)card WithDepth:(NSInteger)depth AndAvoid:(NSArray *)criteria{
    int currentIndex = 0;
    int numAtLastLevel = 0;
    int numAtNewLevel = 0;
    NSMutableArray *foundItems = [[NSMutableArray alloc]initWithObjects:card, nil];
    for (int currentLevel = 1; currentLevel <= depth; currentLevel++){
       NSLog(@"Search On Card - for loop level %i", currentLevel);
        for( int j = 0; j <= numAtLastLevel; j++){
            NSObject *o = [foundItems objectAtIndex:(j+currentIndex)];
            if([o isKindOfClass:[Card class]]){
                NSLog(@"in j for loop - %@", o);
                NSArray *connectedThreads = [[(Card *)o connections]allObjects];
                for(Thread *thread in connectedThreads){
                    NSArray *cardsOfThread = [[thread cards]allObjects];
                    //if the cards connected are the card being searched on, or are not the
                    //avoiding criteria AND the thread is not the avoiding criteria add them in
                    if((![criteria containsObject:[[cardsOfThread objectAtIndex:0]myCardType]] || [cardsOfThread objectAtIndex:0] == card) && (![criteria containsObject:[[cardsOfThread objectAtIndex:1]myCardType]] || [cardsOfThread objectAtIndex:1] == card) && ![criteria containsObject:[thread myThreadType]]){
                            NSInteger count = [foundItems count];
                        [self addObject:[cardsOfThread objectAtIndex:0] ToDistinctArray:foundItems];
                        [self addObject:thread ToDistinctArray:foundItems];
                        [self addObject:[cardsOfThread objectAtIndex:1] ToDistinctArray:foundItems];
                            NSInteger newCount = [foundItems count];
                            NSInteger itemsAdded = newCount - count;
                            numAtNewLevel += itemsAdded;
                    }//end if for adding items to found
                }//end for loop of all connections of a card
            }//end if for if object in array is a card
        }//for loop of items at last level
        currentIndex += numAtLastLevel;
        numAtLastLevel = numAtNewLevel;
        numAtNewLevel = 0;
    }//for loop for depth
    return foundItems;
}


-(Card *)createCardWithType:(CardType *)type AtLocation:(NSPoint)aPoint{
    return [self createCardWithType:type AtLocation:aPoint AndTitle:@"Title" AndBody:@"Body"];
}

-(Card *)createCardWithType:(CardType *)type AtLocation:(NSPoint)aPoint AndTitle:(NSString *) title AndBody:(NSString *)body{
    NSEntityDescription *cardEntity = [NSEntityDescription
                                           entityForName:@"Card"
                                           inManagedObjectContext:myContext];
   Card *card = [[Card alloc]
                 initWithEntity:cardEntity insertIntoManagedObjectContext:myContext];
    [card setTitle:title];
    [card setBody:body];
    [card setMyCardType:type];
    [card setRect:[NSValue valueWithPoint:aPoint]];
    [cards addObject:card];
    return card;
}

/*!
Sets up so that next calls to get cards or thread will recheck the 
actual model
 */
-(void)refresh{
    cards = nil;
    threads =nil;
}

-(void)addObject:(NSObject *)object ToDistinctArray:(NSMutableArray *)array{
    if(![array containsObject:object]){
        [array addObject:object];
    }
}

@end
