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
-(NSArray *) getAllThreadTypes;
-(ThreadType *)createThreadTypeWithName:(NSString *) name andColor:(NSColor *)color;
-(void)deleteThreadType:(ThreadType);
-(BOOL)threadTypeExistsWithName:(NSString *)name andColor:(NSColor *)color;
@end
