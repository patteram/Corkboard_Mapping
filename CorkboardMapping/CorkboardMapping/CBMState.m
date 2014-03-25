//
//  CBMState.m
//  CorkboardMapping
//
//  Created by Ashley Patterson on 3/24/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMState.h"

@implementation CBMState
CardType *cardToCreate;
ThreadType * threadToCreate;
@synthesize creatingCard;
@synthesize creatingThread;

-(void)setCardToCreate:(CardType*)type{
    [self setCreatingThread:NO];
    creatingCard = YES;
    cardToCreate = type;
}

-(Card*)cardToCreate{
    return cardToCreate;
}

-(void)setThreadToCreate:(ThreadType *)threadToCreate {
    [self setCreatingCard:NO];
    self.threadToCreate = threadToCreate;
    creatingThread = YES;
}

-(ThreadType *)threadToCreate{
    return threadToCreate;
}


@end
