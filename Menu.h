//
//  Menu.h
//  Foodle's
//
//  Created by Thomas Lin on 3/30/13.
//  Copyright (c) 2013 Thomas Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Menu : NSManagedObject

@property (nonatomic, retain) NSString * dishDetail;
@property (nonatomic, retain) NSNumber * dishID;
@property (nonatomic, retain) NSString * dishImage;
@property (nonatomic, retain) NSString * dishImageThumb;
@property (nonatomic, retain) NSString * dishTitle;
@property (nonatomic, retain) NSString * dishType;

@end
