//
//  FourthViewController.h
//  Foodle's
//
//  Created by Thomas Lin on 3/27/13.
//  Copyright (c) 2013 Thomas Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FourthViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate>
{
    NSArray *beefTableData;
    NSArray *beefTableDetail;
    NSArray *beefTableImage;
    NSArray *beefTableThumb;
    NSArray *nutrition;
    UIPopoverController *popoverController;
}

@property (nonatomic, retain) NSArray *beefTableData;
@property (nonatomic, retain) NSArray *beefTableDetail;
@property (nonatomic, retain) NSArray *beefTableImage;
@property (nonatomic, retain) NSArray *beefTableThumb;
@property (nonatomic, retain) NSArray *nutrition;
@property (strong, nonatomic) IBOutlet UITableView *fourthTableView;

@property (strong, nonatomic) UIButton *menuButton;
@property (strong, nonatomic) UIButton *orderListButton;
@property (nonatomic, retain) UIPopoverController *popoverController;

@property (strong, nonatomic) IBOutlet UINavigationItem *beefViewNavigationBarTitle;
@property (strong, nonatomic) IBOutlet UINavigationBar *beefViewNavigationBar;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
