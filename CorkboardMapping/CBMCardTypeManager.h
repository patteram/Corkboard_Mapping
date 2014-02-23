//
//  CBMCardTypeManager.h
//  CoreDoc
//
//  Created by Ashley Patterson on 2/22/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardType.h";
@interface CBMCardTypeManager : NSObject
@property NSManagedObjectContext* myContext;

-(id) initWithModelContext:(NSManagedObjectContext *)context;
-(CardType *)createCardType:(NSString *)string AndColor:(NSColor *)color;
@end
