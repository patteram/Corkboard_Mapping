//
//  CBMDeletionDelegate.h
//  CorkboardMapping
//
//  Created by Ashley Patterson on 5/12/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CBMDeletionDelegate <NSObject>
-(void)askToDelete: (id) itemThatAskedForDeletion;
@end
