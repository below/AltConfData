//
//  ACOrderedSetValueTransformer.m
//  AltConfData
//
//  Created by Alexander v. Below on 26.05.14.
//  Copyright (c) 2014 Alexander von Below. All rights reserved.
//

#import "ACOrderedSetValueTransformer.h"

@implementation ACOrderedSetValueTransformer
+ (Class)transformedValueClass {
    return [NSOrderedSet self];
}

- (id)transformedValue:(id)value {
    
    if ([value respondsToSelector:@selector(allObjects)]) {
        NSArray *result = [value allObjects];
        return result;
    }
    else {
        return nil;
    }
}

@end
