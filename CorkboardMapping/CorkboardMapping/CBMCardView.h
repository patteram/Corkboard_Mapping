//
//  CBMCardView.h
//  CorkboardMapping
//
//  Created by Ashley Patterson on 2/5/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Card.h"
#import "CBMTypeManager.h"
#import "CBMTextView.h"
#import "CBMDeletionDelegate.h"
#import "CBMClickedDelegate.h"
@interface CBMCardView : NSView <NSTextViewDelegate>{
    BOOL higlight;
    BOOL dragging;
}
@property NSPoint oldPoint; 
@property BOOL highlight;
@property BOOL dragging;
@property NSColor *cardColor;
@property Card *cardObject;
@property NSTextView *title;
@property NSTextView *body;
@property NSCursor *oldCursor; 
@property CBMTypeManager *cardTypeManager;
@property id <CBMDeletionDelegate> deleteDelegate;
@property id <CBMCardViewDelegate> clickDelegate;
- (id) initWithFrame:(NSRect)frameRect AndCBMCard:(Card*)card;

@end
