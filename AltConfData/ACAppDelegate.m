//
//  ACAppDelegate.m
//  AltConfData
//
//  Created by Alexander v. Below on 23.05.14.
//  Copyright (c) 2014 Alexander von Below. All rights reserved.
//

#import "ACAppDelegate.h"
#import "Speaker.h"
#import "Session.h"
#import "ACDateValueTransformer.h"

@implementation ACAppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

+ (void) initialize {
    [NSValueTransformer setValueTransformer:[ACDateValueTransformer new]
                                    forName:@"ACDateValueTransformer"];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.sessionViewController.managedObjectContext = self.managedObjectContext;
}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "com.altconf.data.AltConfData" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.altconf.data.AltConfData"];
}

- (IBAction)export:(id)sender {
    NSMutableArray *jsonArray = nil;
    for (Speaker * speaker in self.speakersController.selectedObjects) {
        
        NSMutableDictionary *jsonRep = [NSMutableDictionary new];
        
        NSString *id = speaker.id;
        jsonRep[@"id"] = id;
        
        jsonRep[@"event"] = @"alt";
        jsonRep[@"type"] = @"speaker";
        
        NSString *name = speaker.name;
        jsonRep[@"name"] = name;
        
        NSString *url = speaker.url;
        jsonRep[@"url"] = url;
        
        NSString *biography = speaker.biography;
        jsonRep[@"biography"] = biography;
        
        NSMutableArray *sessionArray = [NSMutableArray new];
        NSSet *sessions = speaker.sessions;
        for (Session * session in sessions) {
            NSMutableDictionary *sessionRep = [NSMutableDictionary new];
            NSString *sessionId = session.id;
            if (sessionId.length > 0) {
                sessionRep[@"id"] = sessionId;
                NSString *sessionTitle = session.title;
                sessionRep[@"title"] = sessionTitle;
                [sessionArray addObject:sessionRep];
            }
        }
        if (sessionArray != nil)
            jsonRep[@"sessions"] = sessionArray;
        if (jsonArray == nil)
            jsonArray = [NSMutableArray new];
        [jsonArray addObject:jsonRep];
    }
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted
                                      error:&error];
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [pasteboard writeObjects:@[ jsonString ] ];
    
}

- (IBAction) importFromCSV:(id)sender {
    NSOpenPanel *op = [NSOpenPanel openPanel];
    op.allowedFileTypes = @[@"tsv"];
    if ([op runModal] == NSFileHandlingPanelOKButton) {
        NSURL *url = op.URL;
        NSError *error = nil;
        NSString *text = [NSString stringWithContentsOfURL:url
                                              usedEncoding:nil
                                                     error:&error];
        if (error == nil) {
            NSArray *lines = [text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            BOOL gotHeader = NO;
            for (NSString * oneLine in lines) {
                if (gotHeader) {
                    NSArray *components = [oneLine componentsSeparatedByString:@"\t"];
                    if (components.count >= 7) {
                        NSString *name = [components objectAtIndex:0];
                        NSString *bio = [components objectAtIndex:3];
                        NSString *avatar = [components objectAtIndex:4];
                        NSString *sessionTitle = [components objectAtIndex:5];
                        NSString *sessionAbstract = [components objectAtIndex:6];
                        
                        Speaker *speaker = (Speaker *)[[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"Speaker" inManagedObjectContext:self.managedObjectContext]
                                                               insertIntoManagedObjectContext:self.managedObjectContext];
                        speaker.name = name;
                        speaker.biography = bio;
                        speaker.url = avatar;
                        
                        Session *session = (Session *)[[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"Session" inManagedObjectContext:self.managedObjectContext]
                                                               insertIntoManagedObjectContext:self.managedObjectContext];
                        session.title = sessionTitle;
                        session.abstract = sessionAbstract;
                        session.speaker = [NSSet setWithObject:speaker];
                    }
                }
                else {
                    gotHeader = YES;
                }
            }
            [self.managedObjectContext save:nil];
        }
    }
}

- (IBAction)showAddSessionWIndow:(id)sender {
    [self.addSessionWindow makeKeyAndOrderFront:self];
}

- (IBAction)addSessionToSpeaker:(id)sender {
    Speaker *speaker = [self.speakersController.selectedObjects firstObject];
    NSArray *sessions = [self.selectSessionController selectedObjects];
    NSMutableSet *newSessions = [speaker mutableSetValueForKey:@"sessions"];
    [newSessions addObjectsFromArray:sessions];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AltConfData" withExtension:@"momd"];
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
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"AltConfData.storedata"];
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

@end
