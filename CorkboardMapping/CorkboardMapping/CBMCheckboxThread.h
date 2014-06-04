//
//  CBMCheckboxThread.h
//  CorkboardMapping
//
//  Created by Ashley Patterson on 3/14/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ThreadType.h"
#import "CBMDeletionDelegate.h"
@interface CBMCheckboxThread : NSView
@property NSButton *checkbox;
@property ThreadType *type;
@property NSBezierPath *path;
@property id <CBMDeletionDelegate> deletionDelegate;
-(id)initWithFrame:(NSRect)frameRect andThreadType:(ThreadType *)type;
@end
