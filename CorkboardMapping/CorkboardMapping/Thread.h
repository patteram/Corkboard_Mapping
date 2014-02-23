//
//  Thread.h
//  CoreDoc
//
//  Created by Ashley Patterson on 2/20/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ThreadType;

@interface Thread : NSManagedObject

@property (nonatomic, retain) ThreadType *myThreadType;
@property (nonatomic, retain) NSSet *cards;
@end

@interface Thread (CoreDataGeneratedAccessors)

- (void)addCardsObject:(NSManagedObject *)value;
- (void)removeCardsObject:(NSManagedObject *)value;
- (void)addCards:(NSSet *)values;
- (void)removeCards:(NSSet *)values;

@end
