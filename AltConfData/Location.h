//
//  Location.h
//  AltConfData
//
//  Created by Alexander v. Below on 30.05.14.
//  Copyright (c) 2014 Alexander von Below. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Session;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * label_en;
@property (nonatomic, retain) NSSet *sessions;
@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addSessionsObject:(Session *)value;
- (void)removeSessionsObject:(Session *)value;
- (void)addSessions:(NSSet *)values;
- (void)removeSessions:(NSSet *)values;

@end
