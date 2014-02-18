//
//  CardType.h
//  CorkboardMapping
//
//  Created by Ashley Patterson on 2/9/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBMCardType : NSObject{
    NSString *name;
}

@property NSString *name;
@property (nonatomic, assign) NSColor  *color;

@end
