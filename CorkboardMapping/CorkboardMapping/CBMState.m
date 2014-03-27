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
CBMCardView *cardSelected;
@synthesize creatingCard;
@synthesize creatingThread;
@synthesize cardOne; 

-(void)setCardToCreate:(CardType*)type{
    if(cardToCreate != nil){
        [cardToCreate setToCreate:NO];
    }
    if(type == nil){
         creatingCard = NO;
    }else{
        creatingCard = YES;
        cardToCreate = type;
        [cardToCreate setToCreate:YES];
    }
    [self setCreatingThread:NO];

    
}

-(CardType*)cardToCreate{
    return cardToCreate;
}

-(void)setCardSelected:(CBMCardView *)newCardSelected{
    if(cardSelected != nil){
        
    }
}
-(void)setThreadToCreate:(ThreadType *)athreadToCreate {
    NSLog(@"CBM State - thread to create"); 
    [self setCreatingCard:NO];
    threadToCreate = athreadToCreate;
    [self setCreatingThread: YES];
    cardOne = nil;
}

-(ThreadType *)threadToCreate{
    return threadToCreate;
}


@end
