//
//  ACAppDelegate.h
//  AltConfData
//
//  Created by Alexander v. Below on 23.05.14.
//  Copyright (c) 2014 Alexander von Below. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ACAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak) IBOutlet NSArrayController *speakersController;
@property (unsafe_unretained) IBOutlet NSWindow *addSessionWindow;
@property (weak) IBOutlet NSArrayController *selectSessionController;

- (IBAction)saveAction:(id)sender;

- (IBAction)export:(id)sender;

@end
