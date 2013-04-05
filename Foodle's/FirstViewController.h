//
//  FirstViewController.h
//  Foodle's
//
//  Created by Thomas Lin on 3/27/13.
//  Copyright (c) 2013 Thomas Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate>
{
    NSArray *mainTableData;
    NSArray *mainTableDetail;
    NSArray *mainTableImage;
    NSArray *mainTableThumb;
    NSArray *mainTableType;
    NSArray *nutrition;
    UIPopoverController *popoverController;
}

@property (nonatomic, retain) NSArray *mainTableData;
@property (nonatomic, retain) NSArray *mainTableDetail;
@property (nonatomic, retain) NSArray *mainTableImage;
@property (nonatomic, retain) NSArray *mainTableThumb;
@property (nonatomic, retain) NSArray *mainTableType;
@property (nonatomic, retain) NSArray *nutrition;
@property (strong, nonatomic) IBOutlet UITableView *firstTableView;

@property (strong, nonatomic) UIButton *menuButton;
@property (strong, nonatomic) UIButton *orderListButton;
@property (nonatomic, retain) UIPopoverController *popoverController;

@property (strong, nonatomic) IBOutlet UINavigationItem *mainViewTitle;
@property (strong, nonatomic) IBOutlet UINavigationBar *mainViewNavigationBar;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


@end
