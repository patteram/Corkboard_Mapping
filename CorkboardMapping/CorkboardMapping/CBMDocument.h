//
//  CBMDocument.h
//  CoreDoc
//
//  Created by Ashley Patterson on 2/20/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBMCardAndThreadManager.h"
#import "CBMTypeManager.h"
@interface CBMDocument : NSPersistentDocument
@property CBMTypeManager * typeManager;
@property CBMCardAndThreadManager * cardAndThreadManager;
@property NSWindowController *corkboard;
@property NSWindowController *searchAndDisplay;
@property NSWindowController *createCardType;
@property NSWindowController *createThreadType; 
@end
