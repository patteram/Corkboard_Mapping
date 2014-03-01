//
//  CBMCardTypeProtocol.h
//  CorkboardMapping
//
//  Created by Ashley Patterson on 2/23/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardType.h"

@protocol CBMCardTypeProtocol <NSObject>
@required
/*!
 \returns all card types
 */
-(NSArray * )getAllCardTypes;

/*! Creates A CardType
 \param name: the name of the type
 \param color : the color of the card type
 \returns CardType if it was created or nil if there is already a cardType or an error occured.
 */
-(CardType *)createCardTypeWithName:(NSString *)name andColor:(NSColor *)color;

/*!
 Deletes the cardtype from the managed context
 */
-(void)deleteCardType:(CardType *)type;
/*!
 \returns YES if a cardType with name OR string exists, else NO
 */
-(BOOL)cardTypeExistsWithName:(NSString *)name andColor:(NSColor *)color;
@end
