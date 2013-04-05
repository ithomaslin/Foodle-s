//
//  SecondViewController.m
//  Foodle's
//
//  Created by Thomas Lin on 3/27/13.
//  Copyright (c) 2013 Thomas Lin. All rights reserved.
//

#import "SecondViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "PopupViewController.h"
#import "OrderListViewController.h"
#import "AppDelegate.h"
#import "Menu.h"

@interface SecondViewController () <PopupDelegate>

@end

@implementation SecondViewController

@synthesize secondTableData, secondTableDetail, secondTableImage, secondTableThumb, nutrition;

@synthesize menuButton;
@synthesize orderListButton;
@synthesize secondViewTitle;
@synthesize secondViewNavigationBar;
@synthesize secondTableView;

@synthesize popoverController;
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)search
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Menu" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *initialPredicate = [NSPredicate predicateWithFormat:@"dishType == %@", @"rice and noodle"];
    [request setPredicate:initialPredicate];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"dishID" ascending:NO];
    NSArray *newArray = [NSArray arrayWithObject:sort];
    [request setSortDescriptors:newArray];
    
    NSError *error;
    NSArray *matchingData = [managedObjectContext executeFetchRequest:request error:&error];
    
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
    NSMutableArray *detailArray = [[NSMutableArray alloc] init];
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    NSMutableArray *thumbArray = [[NSMutableArray alloc] init];
    NSString *title;
    NSString *detail;
    NSString *image;
    NSString *thumb;
    
    if (matchingData.count == 0)
    {
        NSLog(@"Oops...nothing found");
    }
    else
    {
        NSLog(@"Found! %d item", matchingData.count);
        
        for (NSManagedObjectContext *obj in matchingData) {
            
            title = [obj valueForKey:@"dishTitle"];
            detail = [obj valueForKey:@"dishDetail"];
            image = [obj valueForKey:@"dishImage"];
            thumb = [obj valueForKey:@"dishImageThumb"];
            
            [titleArray insertObject:title atIndex:0];
            [detailArray insertObject:detail atIndex:0];
            [imageArray insertObject:image atIndex:0];
            [thumbArray insertObject:thumb atIndex:0];
        }
        
        secondTableData = [[NSArray alloc] initWithArray:titleArray];
        secondTableDetail = [[NSArray alloc] initWithArray:detailArray];
        secondTableImage = [[NSArray alloc] initWithArray:imageArray];
        secondTableThumb = [[NSArray alloc] initWithArray:thumbArray];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    /////////////////////////////////////////////////////////////////////
    //Tells which view should be shown when user is doing the pen gesture
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    ////////////////////////////////////////////
    //Adding custom button on the navigation bar
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(8, 10, 34, 24);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"mbutton.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuButton];
    
    ////////////////////////////////////////////
    //Adding custom button on the navigation bar
    self.orderListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    orderListButton.frame = CGRectMake(700, 0, 50, 80);
    [orderListButton setBackgroundImage:[UIImage imageNamed:@"ribbon_button_order_normal.png"] forState:UIControlStateNormal];
    [orderListButton setBackgroundImage:[UIImage imageNamed:@"ribbon_button_order_highlighted.png"] forState:UIControlStateHighlighted];
    [orderListButton addTarget:self action:@selector(openPopoverButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.orderListButton];
    
    [self.secondViewNavigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    self.secondViewTitle.title = @"RICE & NOODLE";
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    [self search];
    
    nutrition = [[NSArray alloc] initWithObjects:@"Calories:\nCalories from Fat:\nTotal Fat:\nSaturated Fat:\nTotal Cholesterol:\nSodium:\nTotal Carbohydrates:\nDietary Fiber:\nSugars:\nProtein:", @"490\n200\n22g\n4g\n0mg\n1060mg\n65g\n4g\n8g\n13g", @"530\n140\n16g\n3g\n150mg\n820mg\n82g\n1g\n3g\n12g", @"380\n0\n0g\n0g\n0mg\n0mg\n86g\n0g\n0g\n7g", nil];
    
    UIImage *bgImg = [UIImage imageNamed:@"wood_grain.png"];
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:bgImg];
    bgImgView.frame = secondTableView.bounds;
    secondTableView.backgroundView = bgImgView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)openPopoverButtonPressed:(id)sender
{
    if (self.popoverController == nil) {
        OrderListViewController *orderView = [[OrderListViewController alloc] initWithNibName:@"OrderListViewController" bundle:nil];
        orderView.navigationItem.title = @"Your Order List";
        UINavigationController *popoverNavController = [[UINavigationController alloc] initWithRootViewController:orderView];
        
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:popoverNavController];
        popover.delegate = self;
        popover.popoverContentSize = CGSizeMake(400.0, 500.0);
        self.popoverController = popover;
    }
    
    if (![self.popoverController isPopoverVisible]) {
        [self.popoverController presentPopoverFromRect:CGRectMake(700, 0, 50, 80) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self.popoverController dismissPopoverAnimated:YES];
    }
}

- (void)closeButtonPressed:(PopupViewController *)popupViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [secondTableData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"secondViewCell"];
    UIFont *sketchslab = [UIFont fontWithName:@"Sketchslab" size:25.0f];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"secondViewCell"];
        cell.textLabel.font = sketchslab;
    }
    
    cell.textLabel.text = [secondTableData objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [secondTableDetail objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[secondTableThumb objectAtIndex:indexPath.row]];
    
    UIImage *star0;
    UIImageView *star0View;
    UIImage *star1;
    UIImageView *star1View;
    UIImage *star2;
    UIImageView *star2View;
    UIImage *star3;
    UIImageView *star3View;
    UIImage *star4;
    UIImageView *star4View;
    UIImage *star5;
    UIImageView *star5View;
    
    star0 = [UIImage imageNamed:@"star_0.png"];
    star0View = [[UIImageView alloc] initWithImage:star0];
    star0View.frame = CGRectMake(0, 0, star0.size.width, star0.size.height);
    
    star1 = [UIImage imageNamed:@"star_1.png"];
    star1View = [[UIImageView alloc] initWithImage:star1];
    star1View.frame = CGRectMake(0, 0, star1.size.width, star1.size.height);
    
    star2 = [UIImage imageNamed:@"star_2.png"];
    star2View = [[UIImageView alloc] initWithImage:star2];
    star2View.frame = CGRectMake(0, 0, star2.size.width, star2.size.height);
    
    star3 = [UIImage imageNamed:@"star_3.png"];
    star3View = [[UIImageView alloc] initWithImage:star3];
    star3View.frame = CGRectMake(0, 0, star3.size.width, star3.size.height);
    
    star4 = [UIImage imageNamed:@"star_4.png"];
    star4View = [[UIImageView alloc] initWithImage:star4];
    star4View.frame = CGRectMake(0, 0, star4.size.width, star4.size.height);
    
    star5 = [UIImage imageNamed:@"star_5.png"];
    star5View = [[UIImageView alloc] initWithImage:star5];
    star5View.frame = CGRectMake(0, 0, star5.size.width, star5.size.height);
    
    if (indexPath.row == 0) {
        cell.accessoryView = star3View;
    } else if (indexPath.row == 1) {
        cell.accessoryView = star5View;
    } else if (indexPath.row == 2) {
        cell.accessoryView = star3View;
    } else if (indexPath.row == 3) {
        cell.accessoryView = star4View;
    } else if (indexPath.row == 4) {
        cell.accessoryView = star1View;
    } else if (indexPath.row == 5) {
        cell.accessoryView = star3View;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipad-list-item-selected.png"]];
    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    [[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIFont *jamies20 = [UIFont fontWithName:@"Jamies Hand" size:20.0f];
    UIFont *sketchslab18 = [UIFont fontWithName:@"Sketchslab" size:18.0f];
    UIFont *sketchslab25 = [UIFont fontWithName:@"Sketchslab" size:25.0f];
    
    PopupViewController *popupViewController = [[PopupViewController alloc] initWithNibName:@"PopupViewController" bundle:nil];
    popupViewController.delegate = self;
    [self presentPopupViewController:popupViewController animationType:MJPopupViewAnimationFade];
    popupViewController.popupTitle.text = [self.secondTableData objectAtIndex:indexPath.row];
    popupViewController.popupNutritionFact.text = @"Nutrition Facts:";
    popupViewController.popupNutritionFact.textColor = [UIColor redColor];
    popupViewController.popupNutritionTitle.text = nutrition[0];
    
    popupViewController.popupTitle.font = popupViewController.popupNutritionFact.font = sketchslab25;
    popupViewController.popupDetail.font = sketchslab18;
    popupViewController.popupNutritionTitle.font = popupViewController.popupNutritionDetail.font = jamies20;
    
    switch (indexPath.row) {
        case 0: {
            popupViewController.popupImage.image = [UIImage imageNamed:secondTableImage[indexPath.row]];
            popupViewController.popupDetail.text = secondTableDetail[indexPath.row];
            popupViewController.popupNutritionDetail.text = nutrition[indexPath.row + 1];
        }
            break;
            
        case 1: {
            popupViewController.popupImage.image = [UIImage imageNamed:secondTableImage[indexPath.row]];
            popupViewController.popupDetail.text = secondTableDetail[indexPath.row];
            popupViewController.popupNutritionDetail.text = nutrition[indexPath.row + 1];
        }
            break;
            
        case 2: {
            popupViewController.popupImage.image = [UIImage imageNamed:secondTableImage[indexPath.row]];
            popupViewController.popupDetail.text = secondTableDetail[indexPath.row];
            popupViewController.popupNutritionDetail.text = nutrition[indexPath.row + 1];
        }
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
}

@end
