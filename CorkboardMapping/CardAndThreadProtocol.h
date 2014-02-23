//
//  CardAndThreadProtocol.h
//  CoreDoc
//
//  Created by Ashley Patterson on 2/21/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "CardType.h"
@protocol CardAndThreadProtocol <NSObject>

@required
-(NSArray*)getAllCardsAndThreads;
-(NSArray*)getAllCardsAndThreadsAndAvoid:(NSArray*)criteria;
-(NSArray*)searchOnCard:(Card *)card AndWithDepth:(NSInteger) depth;
-(Card *)createCardWithType:(CardType *)cardType;
-(Card *)createCardWithType:(CardType *)cardType andTitle:(NSString*)title andBody:(NSString *)body;
@end
