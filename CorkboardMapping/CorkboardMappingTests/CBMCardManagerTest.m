//
//  CBMCardManagerTest.m
//  CorkboardMapping
//
//  Created by Ashley Patterson on 2/28/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Cocoa/Cocoa.h"
#import "CBMCardManager.h"
#import "CBMCardTypeManager.h"

@interface CBMCardManagerTest : XCTestCase

@end

@implementation CBMCardManagerTest
NSManagedObjectContext* context;
CBMCardManager * cardManager;
CBMCardTypeManager *cardTypeManager;

- (void)setUp
{
    NSString *STORE_TYPE = NSXMLStoreType;
    NSString *STORE_FILENAME = @"CBMCardManagerTestXML.xml";
    NSError *error;
    NSURL *url = [NSURL URLWithString:STORE_FILENAME];
    //NSURL *url = [applicationLogDirectory()
          //        URLByAppendingPathComponent:STORE_FILENAME];
    [super setUp];
    NSArray *bundles = [NSArray arrayWithObject:[NSBundle bundleForClass:[self class]]];
    NSManagedObjectModel *objectModel = [NSManagedObjectModel mergedModelFromBundles:bundles];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:objectModel];
    [psc addPersistentStoreWithType:NSXMLStoreType configuration:STORE_TYPE URL:url options:nil error:nil];
    if(objectModel == nil || psc == nil){
        NSLog(@"\n\nModel or store is nil\n\n");
    }else{
        NSLog(@"\n\nModel or store is not nil\n\n");
    }
    context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = psc;
    cardManager = [[CBMCardManager alloc]initWithModelContext:context];
    cardTypeManager = [[CBMCardTypeManager alloc]initWithModelContext:context];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}



- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
}

- (void)testExample
{
    [cardTypeManager createCardTypeWithName:@"Character" andColor:[NSColor greenColor]];
   // NSArray *array = [cardTypeManager getAllCardTypes];
  //  NSLog(@"%@", array);
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
