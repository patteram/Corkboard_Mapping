//
//  CBMAppDelegate.m
//  CorkboardMapping
//
//  Created by Ashley Patterson on 2/17/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import "CBMAppDelegate.h"
#import "CBMCenteringView.h"

@implementation CBMAppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize shapesArray;
@synthesize numberOfShapes;
@synthesize color;
@synthesize card;
@synthesize cardType;
@synthesize window; 


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self codeFromApple];
    [window addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "com.ash.CorkboardMapping" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.ash.CorkboardMapping"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CorkboardMapping" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"CorkboardMapping.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}


//  AppDelegate.m
//  TestClassesModelView
//  Users/ash/WorkSpaces/ObjectiveCStuff/TestClassesModelView/TestClassesModelView/AppDelegate.m
//  Created by Ashley Patterson on 10/4/13.
//  Copyright (c) 2013 Ashley Patterson. All rights reserved.








- (IBAction)colorWell:(NSColorWell *)sender {
    [card setValue:[sender color] forKeyPath:@"cardType.color"];
    [card setValue:@"IT CHANGED" forKeyPath:@"title"];
    
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"size"]){
        NSLog(@"The frame has changed");
    }else{
        NSLog(@"The size has changed");
    }
}

-(void) codeFromApple{
    CBMCenteringView *centerView = [[CBMCenteringView alloc]initWithFrame:NSMakeRect(0, 0, 3000, 3000)];
    CBMCorkboard *myCustomView = [[CBMCorkboard alloc]initWithFrame:NSMakeRect(0, 0, 3000, 3000)];
    [myCustomView setBounds:NSMakeRect(0,0, 3000, 3000)];
    
    cardType = [[CBMCardType alloc]init];
    card = [[CBMCard alloc]init];
    [cardType setValue:[NSColor redColor] forKey:@"color"];
    [card setValue:cardType forKey:@"cardType"];
    [card setTitle:@"Title"];
    [card setBody:@"Body"];
    CBMCardView *cardView = [[CBMCardView alloc]initWithFrame:NSMakeRect(0, 3000-120,190, 120) AndCBMCard:card];
    [myCustomView addObserver:centerView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [myCustomView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [myCustomView addSubview:cardView];
    
    [centerView addSubview:myCustomView];
    
    // create the scroll view so that it fills the entire window
    // to do that we'll grab the frame of the window's contentView
    // theWindow is an outlet connected to a window instance in Interface Builder
    NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:
                                [[window contentView] frame]];
    
    // the scroll view should have both horizontal
    // and vertical scrollers
    [scrollView setHasVerticalScroller:YES];
    [scrollView setHasHorizontalScroller:YES];
    
    // configure the scroller to have no visible border
    [scrollView setBorderType:NSNoBorder];
    //contentRectForFrameRect:
    // set the autoresizing mask so that the scroll view will
    // resize with the window
    [scrollView setAutoresizingMask:NSViewLayerContentsPlacementCenter];
    
    // set theImageView as the documentView of the scroll view
    [scrollView setDocumentView:centerView];
    // [scrollView setAllowsMagnification:YES];
    [scrollView setDrawsBackground:NO];
    
    [[NSNotificationCenter defaultCenter]addObserver:centerView selector:@selector(viewFrameChanged:) name:NSViewFrameDidChangeNotification object:myCustomView];
    
    
    // set the scrollView as the window's contentView
    // this replaces the existing contentView and retains
    // the scrollView, so we can release it now
    [window setContentView:scrollView];
    
    
}



@end
