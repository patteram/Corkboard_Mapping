//
//  CBMCardView.h
//  CorkboardMapping
//
//  Created by Ashley Patterson on 2/5/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBMCard.h"

@interface CBMCardView : NSView{
    BOOL higlight;
    BOOL dragging;
}

@property BOOL highlight;
@property BOOL dragging;
@property NSColor *cardColor;
@property CBMCard *cardObject;
@property NSTextView *title;
@property NSTextView *body;

- (id) initWithFrame:(NSRect)frameRect AndCBMCard:(CBMCard*)card;

@end
