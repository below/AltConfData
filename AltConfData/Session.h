//
//  Session.h
//  AltConfData
//
//  Created by Alexander v. Below on 24.05.14.
//  Copyright (c) 2014 Alexander von Below. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Session;

@interface Session : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * abstract;
@property (nonatomic, retain) NSString * session_description;
@property (nonatomic, retain) NSNumber * begin_raw;
@property (readonly) NSNumber * duration;
@property (nonatomic, retain) NSNumber * end_raw;
@property (nonatomic, retain) NSSet *speaker;
@end

@interface Session (CoreDataGeneratedAccessors)

- (void)addSpeakerObject:(Session *)value;
- (void)removeSpeakerObject:(Session *)value;
- (void)addSpeaker:(NSSet *)values;
- (void)removeSpeaker:(NSSet *)values;

@end
