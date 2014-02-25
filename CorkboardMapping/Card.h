//
//  Card.h
//  CorkboardMapping
//
//  Created by Ashley Patterson on 2/24/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CardType, Thread;

@interface Card : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSString * rect;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *connections;
@property (nonatomic, retain) CardType *myCardType;
@end

@interface Card (CoreDataGeneratedAccessors)

- (void)addConnectionsObject:(Thread *)value;
- (void)removeConnectionsObject:(Thread *)value;
- (void)addConnections:(NSSet *)values;
- (void)removeConnections:(NSSet *)values;

@end
