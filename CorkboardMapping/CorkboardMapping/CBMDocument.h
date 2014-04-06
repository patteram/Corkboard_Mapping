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
#import "CBMMainWindowController.h"
#import "CBMCreateCardTypeController.h"
#import "CBMCreateThreadTypeController.h"
#import "CBMState.h"
@interface CBMDocument : NSPersistentDocument
@property CBMTypeManager * typeManager;
@property CBMCardAndThreadManager * cardAndThreadManager;
@property CBMMainWindowController  *corkboard;
@property CBMCreateCardTypeController *createCardType;
@property CBMCreateThreadTypeController *createThreadType;
@property CBMState *theState;
@end
