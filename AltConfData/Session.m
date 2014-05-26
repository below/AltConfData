//
//  Session.m
//  AltConfData
//
//  Created by Alexander v. Below on 24.05.14.
//  Copyright (c) 2014 Alexander von Below. All rights reserved.
//

#import "Session.h"
#import "Session.h"


@implementation Session

@dynamic id;
@dynamic title;
@dynamic abstract;
@dynamic session_description;
@dynamic begin_raw;
@dynamic end_raw;
@dynamic speaker;

- (NSNumber *) duration {
    return [NSNumber numberWithInteger:(self.end_raw.doubleValue - self.begin_raw.doubleValue) / 60];
}

@end
