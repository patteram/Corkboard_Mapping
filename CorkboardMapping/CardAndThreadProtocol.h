//
//  CardAndThreadProtocol.h
//  CoreDoc
//
//  Created by Ashley Patterson on 2/21/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "CardType.h"
#import "ThreadType.h"
#import "ThreadType.h"
@protocol CBMCardAndThreadProtocol <NSObject>

@required
/*!
 \returns NSArray of all threads and cards in the managed object context
 */
-(NSArray*)getAllCardsAndThreads;

/*!
 Returns all cards and thread that do not match the criteria. 
 \param criteria: Array of CardType or ThreadType objects
 \returns NSArray of all cards and threads.
 */
-(NSArray*)getAllCardsAndThreadsAndAvoid:(NSArray*)criteria;

/*!
 Returns an array of all cards and threads connected to this card between the thread
 depth 0 to depth. Note: Array includes the original card.
 \param card: the card you wish to search on. 
 \param depth: how many thread connections to follow
 \returns NSArray of all cards and threads that are connected to the original card
 */
-(NSArray*)searchOnCard:(Card *)card WithDepth:(NSInteger) depth;
-(NSArray *)searchOnCard:(Card *)card WithDepth:(NSInteger)depth AndAvoid:(NSArray *)anArray;
/*! Creates a card inside the managed context
 Title of the card will be "Title" and body "Body" by default. To set at creation use other method.
 \param type: the CardType of this card (should be a valid Card Type inside of managed context)
 \returns the managed object card
 */
-(Card *)createCardWithType:(CardType *)cardType AtLocation:(NSPoint)aPoint;

/*! Creates a card inside the managed context
 \param type: the CardType of this card (should be a valid Card Type inside of managed context)
 \param title: the title of the card
 \param body: the body of the card
 \returns the managed object card
 */
-(Card *)createCardWithType:(CardType *)cardType AtLocation:(NSPoint)aPoint AndTitle:(NSString*)title AndBody:(NSString *)body;
/*!
 Deletes the given card
 \param cardToDelete:the card that will be deleted
 */
-(void)deleteCard:(Card *)cardToDelete;
/*!
Deletes the given thread
 \param threadToDelete:thread that will be deleted
*/
-(void)deleteThread:(Thread *)threadToDelete;
/*!
 Creates a thread in the managed context
 \param type: the thread type this thread should be
 \param card: a card that is connected
 \param card2: the other card that is connected
 returns the newly created thread
 */
-(Thread *)createThreadWithType:(ThreadType *)threadType BetweenCard:(Card *)card AndCard:(Card *)card2;

-(void)refresh; 
@end
