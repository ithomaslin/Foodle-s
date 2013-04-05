//
//  Order.h
//  Foodle's
//
//  Created by Thomas Lin on 3/30/13.
//  Copyright (c) 2013 Thomas Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Menu;

@interface Order : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *relationship;
@end

@interface Order (CoreDataGeneratedAccessors)

- (void)addRelationshipObject:(Menu *)value;
- (void)removeRelationshipObject:(Menu *)value;
- (void)addRelationship:(NSSet *)values;
- (void)removeRelationship:(NSSet *)values;

@end
