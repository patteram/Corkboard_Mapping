//
//  ThreadType.h
//  CoreDoc
//
//  Created by Ashley Patterson on 2/20/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ThreadType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSColor *color;
@property (nonatomic, retain) NSSet *threadsOfType;
@end

@interface ThreadType (CoreDataGeneratedAccessors)

- (void)addThreadsOfTypeObject:(NSManagedObject *)value;
- (void)removeThreadsOfTypeObject:(NSManagedObject *)value;
- (void)addThreadsOfType:(NSSet *)values;
- (void)removeThreadsOfType:(NSSet *)values;

@end
