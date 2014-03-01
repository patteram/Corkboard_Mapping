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
@interface CBMCardTypeManager : NSObject <CBMCardTypeProtocol>
@property NSManagedObjectContext* myContext;

-(id) initWithModelContext:(NSManagedObjectContext *)context;

@end
