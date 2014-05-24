//
//  Speaker.m
//  AltConfData
//
//  Created by Alexander v. Below on 24.05.14.
//  Copyright (c) 2014 Alexander von Below. All rights reserved.
//

#import "Speaker.h"
#import "Speaker.h"


@implementation Speaker

@dynamic id;
@dynamic name;
@dynamic photo;
@dynamic url;
@dynamic organization;
@dynamic position;
@dynamic biography;
@dynamic sessions;

- (NSString *) event {
    return @"alt";
}

- (NSString *) type {
    return @"speaker";
}
@end
