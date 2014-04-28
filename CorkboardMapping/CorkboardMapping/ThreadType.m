//
//  ThreadType.m
//  CoreDoc
//
//  Created by Ashley Patterson on 2/20/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "ThreadType.h"


@implementation ThreadType

@dynamic name;
@dynamic color;
@dynamic threadsOfType;
@synthesize toCreate;
@synthesize visible;
-(id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    if(self){
        visible = YES;
        toCreate = NO;
    }
    return self;
}
@end
