//
//  CBMState.h
//  CorkboardMapping
//
//  Created by Ashley Patterson on 3/24/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThreadType.h"
#import "CardType.h"
#import "CBMCardView.h"
@interface CBMState : NSObject
@property BOOL creatingCard;
@property BOOL creatingThread;
@property CardType *cardToCreate;
@property ThreadType *threadToCreate;
@property Card *cardSelected;

@end
