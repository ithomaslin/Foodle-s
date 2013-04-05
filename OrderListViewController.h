//
//  OrderListViewController.h
//  Foodle's_Test
//
//  Created by Thomas Lin on 3/29/13.
//  Copyright (c) 2013 Thomas Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListViewController : UITableViewController <UIAlertViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSMutableArray *array;
- (void)getData;

@end
