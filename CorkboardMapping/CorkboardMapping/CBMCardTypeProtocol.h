//
//  CBMCardTypeProtocol.h
//  CorkboardMapping
//
//  Created by Ashley Patterson on 2/23/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardType.h"

@protocol CBMCardTypeProtocol <NSObject>
@required
-(NSArray * )getAllCardTypes;
-(CardType *)createCardTypeWithName:(NSString *)name andColor:(NSColor *)color;
-(void)deleteCardType:(CardType *)type;
-(BOOL)cardTypeExistsWithName:(NSString *)name andColor:(NSColor *)color;
@end
