//
//  CBMCardTypeManager.m
//  CoreDoc
//
//  Created by Ashley Patterson on 2/22/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMTypeManager.h"

@implementation CBMTypeManager

-(id)initWithModelContext:(NSManagedObjectContext *)context{
    self = [super init];
    if(self){
        self.myContext = context;
    }
    return self;
}

-(CardType *)createCardTypeWithName:(NSString *)string andColor:(NSColor *)color{
    NSEntityDescription *cardEntity = [NSEntityDescription
                                       entityForName:@"CardType"
                                       inManagedObjectContext:[self myContext]];
    if(cardEntity == nil){
        NSLog(@"Is nil");
    }
    CardType *cardType = [[CardType alloc]initWithEntity:cardEntity insertIntoManagedObjectContext:[self myContext]];
    [cardType setName:string];
    [cardType setColor:color];

    return cardType;
}

-(NSArray *)getAllCardTypes{
    NSEntityDescription *description = [NSEntityDescription entityForName:@"CardType" inManagedObjectContext: [self myContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:description];
    NSError *error;
    NSArray *array = [[self myContext] executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"There was an error %@", [error description]); // Deal with error...
    }
    return array;
}

-(BOOL)cardTypeExistsWithName:(id)name andColor:(NSColor *)color{
    return NO;
}

-(void)deleteCardType:(CardType *)type{
    [ [self myContext] deleteObject:type];
}

-(BOOL)threadTypeExistsWithName:(NSString *)name andColor:(NSColor *)color{
    return NO;
}

-(void)deleteThreadType:(ThreadType *)type{
    [ [self myContext] deleteObject:type];
}

-(ThreadType *)createThreadTypeWithName:(NSString *)name andColor:(NSColor *)color{
    NSEntityDescription *threadEntity = [NSEntityDescription
                                       entityForName:@"ThreadType"
                                       inManagedObjectContext:[self myContext]];
    if(threadEntity == nil){
        NSLog(@"Is nil");
    }
    ThreadType *threadT = [[ThreadType alloc]initWithEntity:threadEntity insertIntoManagedObjectContext:[self myContext]];
    [threadT setName:name];
    [threadT setColor:color];
    return threadT;
}
@end