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
@synthesize cardSelected = _cardSelected;
@synthesize creatingCard;
@synthesize creatingThread;
 
/*!
 Changes the state to creating a card. Accepts nil parameter.
 Modifies the old card to create's parameters to no and modifies the new 
 if valid type is past in. 
 thread creation state will be turned off (if it was on)
 if nil, creatingCard is set to no.
 \param type: the type of card you wish to create (can be nil)
*/
-(void)setCardToCreate:(CardType*)type{
    if(cardToCreate != nil){
        [cardToCreate setToCreate:NO];
    }
    if(cardToCreate == type){ //turn off 
        type = nil;
    }
    cardToCreate = type;
    if(type == nil){
        [self setCreatingCard:NO]; 
    }else{
        [self setThreadToCreate:nil];
        [self setCreatingCard:YES];
        [cardToCreate setToCreate:YES];
    }
    

    
}
/*!
 Returns the type of card to be created. 
 \return the card type to create or nil
 */
-(CardType*)cardToCreate{
    return cardToCreate;
}

-(void)setCardSelected:(Card *)newCardSelected{
    if(_cardSelected != nil){
        [_cardSelected setSelected:NO];
    }
    
    if(newCardSelected != nil){
        if(creatingThread){
            [newCardSelected setSelectedColor:[threadToCreate color]];
        }else{
            [newCardSelected setSelectedColor:[NSColor highlightColor]];
        }
        [newCardSelected setSelected:YES];
    }
    _cardSelected = newCardSelected; 
}

-(Card *)cardSelected{
    return _cardSelected;
}

/*!
 Changes the state to creating a thread. Accepts nil parameter.
 Modifies the old thread to create's parameters to no and modifies the new
 if valid type is past in.
 card creation state will be turned off (if it was on and type is not nil)
 if nil, creatingThread is set to no.
 \param type: the type of thread you wish to create (can be nil)
 */
-(void)setThreadToCreate:(ThreadType *)athreadToCreate {
    if(threadToCreate!= nil){//old value set to no
        [threadToCreate setToCreate:NO];
    }
    if(threadToCreate == athreadToCreate){ //if same item then reset
        athreadToCreate = nil;
    }
    threadToCreate = athreadToCreate;
    
    if(athreadToCreate != nil){ //need to set new value to yes
        //change pointers, booleans, etc.
       // NSLog(@"CBM State - thread to create");
      
    
       [self setCreatingThread: YES];
       [ self setCardToCreate:nil];
       [athreadToCreate setToCreate:YES];

    }else{//just not creating thread
        creatingThread = NO;
    }
    //always set cardOne to nil and threadToCreate to the passed in value
    [self setCardSelected:nil];
    
    
}

/*!
 Returns the type of thread to create
 \return the type of thread to be created 
 */
-(ThreadType *)threadToCreate{
    return threadToCreate;
}


@end
