//
//  ACSessionViewController.m
//  AltConfData
//
//  Created by Alexander v. Below on 24.05.14.
//  Copyright (c) 2014 Alexander von Below. All rights reserved.
//

#import "ACSessionViewController.h"
#import "Session.h"

@implementation ACSessionViewController

- (IBAction)exportSession:(id)sender {
    static NSDateFormatter *dateFormatter = nil;
    Session *session = [self.sessionController.selectedObjects firstObject];
    NSMutableDictionary *jsonRep = [NSMutableDictionary new];
    jsonRep[@"id"] = session.id;
    jsonRep[@"title"] = session.title;
    NSTimeInterval interval = [session.begin_raw doubleValue];
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:00.0Z"];
    }
    NSString *dateString = [dateFormatter stringFromDate:startDate];
    jsonRep[@"begin"] = dateString;
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonRep options:NSJSONWritingPrettyPrinted
                                                          error:&error];
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [pasteboard writeObjects:@[ jsonString ] ];


}

@end
