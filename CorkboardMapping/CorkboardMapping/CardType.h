//
//  CardType.h
//  CorkboardMapping
//
//  Created by Ashley Patterson on 2/24/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Card;

@interface CardType : NSManagedObject

@property (nonatomic, retain) id color;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *cardsOfType;

@end

@interface CardType (CoreDataGeneratedAccessors)

- (void)addCardsOfTypeObject:(Card *)value;
- (void)removeCardsOfTypeObject:(Card *)value;
- (void)addCardsOfType:(NSSet *)values;
- (void)removeCardsOfType:(NSSet *)values;

@end
