//
//  CBMCorkboard.h
//  CorkboardMapping
//
//  Created by Ashley Patterson on 10/8/13.
//  Copyright (c) 2013 Ashley Patterson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBMState.h"
#import "CorkboardDelegate.h"
extern const float VARIES;
@interface CBMCorkboard : NSView{
    
}


/*!
 The current magnification/minification of the view 
 */
@property id  <CorkboardDelegate> delegate;
@property float currentScaleFactor;
@property CBMState *theState;
@property NSPoint currentMouseLoc; 
-(void)addSubviewToBack:(NSView *)view; 
@end
