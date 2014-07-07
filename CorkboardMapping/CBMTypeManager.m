//
//  CBMCardTypeManager.m
//  CoreDoc
//
//  Created by Ashley Patterson on 2/22/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMTypeManager.h"

@implementation CBMTypeManager
@synthesize cardTypes;
@synthesize threadTypes;

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
  
    CardType *cardType = [[CardType alloc]initWithEntity:cardEntity insertIntoManagedObjectContext:[self myContext]];
    [cardType setName:string];
    [cardType setColor:color];

    [self addCardTypesObject:cardType];
    return cardType;
}

-(NSArray *)getAllCardTypes{
    if(cardTypes == nil){
        NSEntityDescription *description = [NSEntityDescription entityForName:@"CardType" inManagedObjectContext: [self myContext]];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:description];
        NSError *error;
        NSArray *array = [[self myContext] executeFetchRequest:request error:&error];
        if (array == nil)
        {
            NSLog(@"There was an error %@", [error description]); // Deal with error...
        }
        cardTypes = [[NSMutableSet alloc]initWithArray:array];
    }
    return [cardTypes allObjects];
}

-(NSArray *)getAllThreadTypes{
    if(threadTypes == nil){
    NSEntityDescription *description = [NSEntityDescription entityForName:@"ThreadType" inManagedObjectContext: [self myContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:description];
    NSError *error;
    NSArray *array = [[self myContext] executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"There was an error %@", [error description]); // Deal with error...
    }
    threadTypes = [[NSMutableSet alloc]initWithArray:array];
    }
    return [threadTypes allObjects];
}

-(BOOL)cardTypeExistsWithName:(id)name andColor:(NSColor *)color{
    return ([self cardTypeExistsWithName:name] || [self cardTypeExistsWithColor:color]);
}

-(BOOL)cardTypeExistsWithName:(NSString *)name{
    NSArray *cardTypesArray = [self getAllCardTypes];
    for(CardType *aType in cardTypesArray){
        if([[aType name] isEqualToString:name]){
            return YES;
        } }
    return NO;
}
-(BOOL)cardTypeExistsWithColor:(NSColor*)aColor{
    NSArray *cardTypesArray = [self getAllCardTypes];
    for(CardType *aType in cardTypesArray){
        if([[aType color] isEqualTo:aColor]){
            return YES;
        } }
    return NO;
}

-(void)deleteCardType:(CardType *)type{
    [ [self myContext] deleteObject:type];
    [self removeCardTypesObject:type];
}

-(BOOL)threadTypeExistsWithName:(NSString *)name OrColor:(NSColor *)color{
    NSArray *threadTypesArray = [self getAllThreadTypes];
    for(ThreadType *aType in threadTypesArray){
        if([[aType name] isEqualToString:name]){
                       return YES;
            }
        else if([[aType color]isEqualTo:color]){
            return YES;
        }
    }

    return NO;
}

-(BOOL)threadTypeExistsWithName:(NSString *)name{
    NSArray *threadTypesArray = [self getAllThreadTypes];
    for(ThreadType *aType in threadTypesArray){
        if([[aType name] isEqualToString:name]){
            return YES;
        }
    }
    
    return NO;
}
-(BOOL)threadTypeExistsWithColor:(NSColor *)color{
    NSArray *threadTypesArray = [self getAllThreadTypes];
    for(ThreadType *aType in threadTypesArray){
         if([[aType color]isEqualTo:color]){
            return YES;
        }
    }
    
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
    
    
    [self addThreadTypesObject:threadT];
    return threadT;
}


-(void)addCardTypesObject:(CardType *)object{
    [[self cardTypes]addObject:object];
}

-(void)removeCardTypesObject:(CardType *)object{
    [[self cardTypes]removeObject:object]; 
}

- (void)intersectCardTypes:(NSSet *)otherObjects {
    [self.cardTypes intersectSet:otherObjects]; 
}

-(void)addThreadTypesObject:(ThreadType *)object{
    [[self threadTypes]addObject:object];
}

-(void)removeThreadTypesObject:(ThreadType *)object{
    [[self threadTypes]removeObject:object];
}
-(void)intersectThreadTypes:(NSSet *)objects{
    [self.threadTypes intersectSet:objects];
}



@end
