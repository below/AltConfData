//
//  ACDateValueTransformer.m
//  AltConfData
//
//  Created by Alexander v. Below on 24.05.14.
//  Copyright (c) 2014 Alexander von Below. All rights reserved.
//

#import "ACDateValueTransformer.h"

@implementation ACDateValueTransformer
+ (Class)transformedValueClass {
    return [NSDate self];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

- (id)transformedValue:(id)value {
    if ([value respondsToSelector:@selector(doubleValue)]) {
        NSTimeInterval interval = [value doubleValue];
        return [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
    }
    else {
        return nil;
    }
}

- (id)reverseTransformedValue:(NSDate *)value {
    if ([value isKindOfClass:[NSDate self]]) {
        return [NSNumber numberWithDouble:[value timeIntervalSinceReferenceDate]];
    }
    else {
        return nil;
    }
}

@end
