//
//  ACSessionViewController.h
//  AltConfData
//
//  Created by Alexander v. Below on 24.05.14.
//  Copyright (c) 2014 Alexander von Below. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACSessionViewController : NSObject
@property (weak) NSManagedObjectContext *managedObjectContext;
@property (weak) IBOutlet NSDatePicker *datePicker;
@property (weak) IBOutlet NSDatePicker *endDatePicker;
@property (weak) IBOutlet NSArrayController *sessionController;
@end
