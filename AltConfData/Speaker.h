//
//  Speaker.h
//  AltConfData
//
//  Created by Alexander v. Below on 24.05.14.
//  Copyright (c) 2014 Alexander von Below. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Speaker;

@interface Speaker : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (readonly) NSString *event;
@property (readonly) NSString *type;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * organization;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSString * biography;
@property (nonatomic, retain) NSSet *sessions;
@end

@interface Speaker (CoreDataGeneratedAccessors)

- (void)addSessionsObject:(Speaker *)value;
- (void)removeSessionsObject:(Speaker *)value;
- (void)addSessions:(NSSet *)values;
- (void)removeSessions:(NSSet *)values;

@end
