//
//  FifthViewController.h
//  Foodle's
//
//  Created by Thomas Lin on 3/27/13.
//  Copyright (c) 2013 Thomas Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FifthViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate>
{
    NSArray *fishTableData;
    NSArray *fishTableDetail;
    NSArray *fishTableImage;
    NSArray *fishTableThumb;
    NSArray *nutrition;
    UIPopoverController *popoverController;
}

@property (nonatomic, retain) NSArray *fishTableData;
@property (nonatomic, retain) NSArray *fishTableDetail;
@property (nonatomic, retain) NSArray *fishTableImage;
@property (nonatomic, retain) NSArray *fishTableThumb;
@property (nonatomic, retain) NSArray *nutrition;
@property (strong, nonatomic) IBOutlet UITableView *fifthTableView;

@property (strong, nonatomic) UIButton *menuButton;
@property (strong, nonatomic) UIButton *orderListButton;
@property (nonatomic, retain) UIPopoverController *popoverController;

@property (strong, nonatomic) IBOutlet UINavigationItem *fishViewNavigationBarTitle;
@property (strong, nonatomic) IBOutlet UINavigationBar *fishViewNavigationBar;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
