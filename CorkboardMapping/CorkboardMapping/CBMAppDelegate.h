//
//  CBMAppDelegate.h
//  CorkboardMapping
//
//  Created by Ashley Patterson on 2/17/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBMCardView.h"
#import "CBMCard.h"
#import "CBMCardType.h"
#import "CBMCorkboard.h"

@interface CBMAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property float numberOfShapes;
@property CBMCardType *cardType;
@property CBMCard *card;
@property NSColor *color;
@property NSArray *shapesArray;
@property (weak) IBOutlet NSView *window2;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
