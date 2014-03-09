//
//  CBMCheckboxCard.h
//  CorkboardMapping
//
//  Created by Ashley Patterson on 3/8/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CardType.h"
@interface CBMCheckboxCard : NSView
@property NSButton *checkbox;
@property CardType *type;
-(id)initWithFrame:(NSRect)frameRect andCardType:(CardType *)type; 
@end
