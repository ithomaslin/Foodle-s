//
//  ThirdViewController.h
//  Foodle's
//
//  Created by Thomas Lin on 3/27/13.
//  Copyright (c) 2013 Thomas Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate>
{
    NSArray *chickenTableData;
    NSArray *chickenTableDetal;
    NSArray *chickenTableImage;
    NSArray *chickenTableThumb;
    NSArray *nutrition;
    UIPopoverController *popoverController;
}

@property (nonatomic, retain) NSArray *chickenTableData;
@property (nonatomic, retain) NSArray *chickenTableDetail;
@property (nonatomic, retain) NSArray *chickenTableImage;
@property (nonatomic, retain) NSArray *chickenTableThumb;
@property (nonatomic, retain) NSArray *nutrition;
@property (strong, nonatomic) IBOutlet UITableView *thirdTableView;

@property (strong, nonatomic) UIButton *menuButton;
@property (strong, nonatomic) UIButton *orderListButton;
@property (nonatomic, retain) UIPopoverController *popoverController;

@property (strong, nonatomic) IBOutlet UINavigationItem *chickenViewNavigationBarTitle;
@property (strong, nonatomic) IBOutlet UINavigationBar *chickenViewNavigationBar;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
