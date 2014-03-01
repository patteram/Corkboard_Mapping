//
//  CBMThreadTypeProtocol.h
//  CorkboardMapping
//
//  Created by Ashley Patterson on 2/23/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThreadType.h"

@protocol CBMThreadTypeProtocol <NSObject>
@required
/*!
 Returns all thread types
 */
-(NSArray *) getAllThreadTypes;
/*!
 Creates a thread type with the name and color given
 \param name: name of the thread type
 \param color: color the thread type should be
 \returns the managedObject 'ThreadType' of the created thread type
 */
-(ThreadType *)createThreadTypeWithName:(NSString *) name andColor:(NSColor *)color;
/*!
 Deletes a thread type
 \param threadtype: the thread type to delete
 */
-(void)deleteThreadType:(ThreadType *) threadType;
/*!
 Returns whether a thread type already exists with the name or color
 \param name: name of a type
 \param color: color of a type
 returns true if there is a card type that has the name OR color. False otherwise
 */
-(BOOL)threadTypeExistsWithName:(NSString *)name andColor:(NSColor *)color;
@end
