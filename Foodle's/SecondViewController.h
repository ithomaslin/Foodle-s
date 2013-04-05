//
//  SecondViewController.h
//  Foodle's
//
//  Created by Thomas Lin on 3/27/13.
//  Copyright (c) 2013 Thomas Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate>
{
    NSArray *secondTableData;
    NSArray *secondTableDetal;
    NSArray *secondTableImage;
    NSArray *secondTableThumb;
    NSArray *nutrition;
    UIPopoverController *popoverController;
}

@property (nonatomic, retain) NSArray *secondTableData;
@property (nonatomic, retain) NSArray *secondTableDetail;
@property (nonatomic, retain) NSArray *secondTableImage;
@property (nonatomic, retain) NSArray *secondTableThumb;
@property (nonatomic, retain) NSArray *nutrition;
@property (strong, nonatomic) IBOutlet UITableView *secondTableView;

@property (strong, nonatomic) UIButton *menuButton;
@property (strong, nonatomic) UIButton *orderListButton;
@property (nonatomic, retain) UIPopoverController *popoverController;

@property (strong, nonatomic) IBOutlet UINavigationItem *secondViewTitle;
@property (strong, nonatomic) IBOutlet UINavigationBar *secondViewNavigationBar;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
