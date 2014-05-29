//
//  ACSessionViewController.m
//  AltConfData
//
//  Created by Alexander v. Below on 24.05.14.
//  Copyright (c) 2014 Alexander von Below. All rights reserved.
//

#import "ACSessionViewController.h"
#import "Session.h"
#import "Speaker.h"
#import "Location.h"

@implementation ACSessionViewController

- (void)awakeFromNib {
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"America/Los_Angeles"];
    timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    self.datePicker.timeZone = timeZone;
    self.endDatePicker.timeZone = timeZone;
}

- (IBAction)exportSession:(id)sender {
    static NSDateFormatter *dateFormatter = nil;
    
    NSMutableArray *jsonArray = [[NSMutableArray alloc] initWithCapacity:self.sessionController.selectedObjects.count];
    for (Session *session in self.sessionController.selectedObjects) {
        NSMutableDictionary *jsonRep = [NSMutableDictionary new];
        jsonRep[@"id"] = session.id;
        jsonRep[@"title"] = session.title;
        jsonRep[@"url"] = @"http://altconf.com/speakers";
        
        NSTimeInterval interval = [session.begin_raw doubleValue];
        NSDate *startDate = [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
            dateFormatter.timeZone = timeZone;
            NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
            [dateFormatter setLocale:enUSPOSIXLocale];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        }
        NSString *startString = [dateFormatter stringFromDate:startDate];
        jsonRep[@"begin"] = startString;
        
        NSDate *endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[session.end_raw doubleValue]];
        NSString *endString = [dateFormatter stringFromDate:endDate];
        jsonRep[@"end"] = endString;
        
        NSNumber *duration = session.duration;
        jsonRep[@"duration"] = duration;
        
        NSString *abstract = session.abstract;
        if (abstract != nil)
            jsonRep[@"abstract"] = abstract;
        
        NSDictionary *trackDevelopment = @{@"id":@"development",@"label_en":@"Development"};
        
        Location *location = (Location *)session.location;
        
        jsonRep[@"location"] = @{@"id":location.id,@"label_en":location.label_en};;
        jsonRep[@"track"] = trackDevelopment;
        
        NSSet *speakers = session.speaker;
        NSMutableArray *speakerArray = nil;
        for (Speaker * speaker in speakers) {
            NSDictionary * speakerRep = @{@"id": speaker.id, @"name": speaker.name};
            if (speakerArray == nil)
                speakerArray = [[NSMutableArray alloc] initWithCapacity:speakers.count];
            [speakerArray addObject:speakerRep];
        }
        if (speakerArray != nil) {
            jsonRep[@"speakers"] = speakerArray;
        }
        [jsonArray addObject:jsonRep];
    }
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted
                                                          error:&error];
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    [pasteboard writeObjects:@[ jsonString ] ];


}

- (IBAction) setLocation:(id)sender {
    NSManagedObject *location = [self.locationSelectionController.selectedObjects firstObject];
    for (Session *session in self.sessionController.selectedObjects) {
        session.location = location;
    }
}

@end
