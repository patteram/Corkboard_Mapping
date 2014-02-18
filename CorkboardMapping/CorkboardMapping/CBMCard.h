//
//  CBMCard.h
//  TestClassesModelView
//
//  Created by Ashley Patterson on 2/9/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBMCardType.h"

@interface CBMCard : NSObject

@property NSString *title;
@property NSString *body;
@property NSPoint *location;
@property (weak) CBMCardType *cardType;


@end
