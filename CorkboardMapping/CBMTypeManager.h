//
//  CBMCardTypeManager.h
//  CoreDoc
//
//  Created by Ashley Patterson on 2/22/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardType.h"
#import "CBMCardTypeProtocol.h"
#import "CBMThreadTypeProtocol.h"
@interface CBMTypeManager : NSObject <CBMCardTypeProtocol, CBMThreadTypeProtocol>
@property NSManagedObjectContext* myContext;

@property NSMutableSet * threadTypes; 
@property NSMutableSet * cardTypes;

-(id) initWithModelContext:(NSManagedObjectContext *)context;

@end
