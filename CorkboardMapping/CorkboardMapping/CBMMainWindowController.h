//
//  CBMWindowController.h
//  CoreDoc
//
//  Created by Ashley Patterson on 2/20/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBMCorkboard.h"

@interface CBMMainWindowController : NSWindowController

@property CBMCorkboard *corkboardView;

-(void)avoidSearchCriteria:(NSArray*)criteria;
-(void)avoidDisplay:(NSArray *)critieria; 
-(void)avoidSearchDisplayCritieria:(NSArray *)criteria andDepth:(NSInteger)integer;
-(void)askToDelete:(id)sender; 
@end
