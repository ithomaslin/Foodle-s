//
//  FirstViewController.m
//  Foodle's
//
//  Created by Thomas Lin on 3/27/13.
//  Copyright (c) 2013 Thomas Lin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FirstViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "PopupViewController.h"
#import "OrderListViewController.h"
#import "AppDelegate.h"
#import "Menu.h"

@interface FirstViewController () <PopupDelegate>

@end

@implementation FirstViewController

//Main Menu Data
@synthesize mainTableData;
@synthesize mainTableDetail;
@synthesize mainTableThumb;
@synthesize mainTableType;
@synthesize nutrition;
@synthesize mainTableImage;
@synthesize firstTableView;

//UI
@synthesize menuButton, orderListButton;
@synthesize mainViewNavigationBar;
@synthesize mainViewTitle;

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
    //Set entity for fetch request
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Menu" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    //Set predicate to set condition for fetching data
    NSPredicate *initialPredicate = [NSPredicate predicateWithFormat:@"dishType == %@", @"starter"];
    [request setPredicate:initialPredicate];
    
    //Sort fetched data
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"dishID" ascending:NO];
    NSArray *newArray = [NSArray arrayWithObject:sort];
    [request setSortDescriptors:newArray];
    
    NSError *error;
    NSArray *matchingData = [managedObjectContext executeFetchRequest:request error:&error];
    
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
    NSMutableArray *detailArray = [[NSMutableArray alloc] init];
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    NSMutableArray *thumbArray = [[NSMutableArray alloc] init];
    NSMutableArray *typeArray = [[NSMutableArray alloc] init];
    NSString *title;
    NSString *detail;
    NSString *image;
    NSString *thumb;
    NSString *type;
    
    if (matchingData.count == 0)
    {
        NSLog(@"Oops...nothing found, there's something wrong!");
    }
    else
    {
        NSLog(@"Found! %d item", matchingData.count);
        
        for (NSManagedObjectContext *obj in matchingData) {
            
            title = [obj valueForKey:@"dishTitle"];
            detail = [obj valueForKey:@"dishDetail"];
            image = [obj valueForKey:@"dishImage"];
            thumb = [obj valueForKey:@"dishImageThumb"];
            type = [obj valueForKey:@"dishID"];
            
            [titleArray insertObject:title atIndex:0];
            [detailArray insertObject:detail atIndex:0];
            [imageArray insertObject:image atIndex:0];
            [thumbArray insertObject:thumb atIndex:0];
            [typeArray insertObject:type atIndex:0];
        }
        
        mainTableData = [[NSArray alloc] initWithArray:titleArray];
        mainTableDetail = [[NSArray alloc] initWithArray:detailArray];
        mainTableImage = [[NSArray alloc] initWithArray:imageArray];
        mainTableThumb = [[NSArray alloc] initWithArray:thumbArray];
        mainTableType = [[NSArray alloc] initWithArray:typeArray];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Create the shadow of the view
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
    orderListButton.layer.shouldRasterize = YES;
    [self.view addSubview:self.orderListButton];
    
    ////////////////////////////////////////////
    //Set the background image of navigation bar
    [self.mainViewNavigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    self.mainViewTitle.title = @"STARTER";
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    [self search];
    
    nutrition = [[NSArray alloc] initWithObjects:@"Calories:\nCalories from Fat:\nTotal Fat:\nSaturated Fat:\nTotal Cholesterol:\nSodium:\nTotal Carbohydrates:\nDietary Fiber:\nSugars:\nProtein:", @"160\n60\n7g\n1g\n0mg\n540mg\n22g\n4g\n2g\n4g", @"200\n100\n12g\n4g\n20mg\n390mg\n16g\n2g\n2g\n8g", @"220\n100\n11g\n2.5g\n20mg\n280mg\n23g\n1g\n2g\n7g", @"190\n70\n8g\n5g\n35mg\n180mg\n24g\n2g\n1g\n5g", @"260\n120\n13g\n2.5g\n60mg\n810mg\n26g\n1g\n2g\n9g", @"100\n30\n3.5g\n0.5g\n65mg\n930mg\n12g\n1g\n4g\n4g", nil];
    
    UIImage *bgImg = [UIImage imageNamed:@"wood_grain.png"];
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:bgImg];
    bgImgView.frame = firstTableView.bounds;
    firstTableView.backgroundView = bgImgView;
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

- (void)addButtonClicked:(PopupViewController *)popupViewController
{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [orderListButton.layer addAnimation:animation forKey:nil];
    orderListButton.hidden = NO;
}

- (void)closeButtonPressed:(PopupViewController *)popupViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mainTableData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"mainViewCell"];
    UIFont *sketchslab = [UIFont fontWithName:@"Sketchslab" size:25.0f];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"mainViewCell"];
        cell.textLabel.font = sketchslab;
    }
    
    cell.textLabel.text = [mainTableData objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [mainTableDetail objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[mainTableThumb objectAtIndex:indexPath.row]];
    
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
    UIFont *sketchslab17 = [UIFont fontWithName:@"Sketchslab" size:18.0f];
    UIFont *sketchslab25 = [UIFont fontWithName:@"Sketchslab" size:25.0f];
    
    PopupViewController *popupViewController = [[PopupViewController alloc] initWithNibName:@"PopupViewController" bundle:nil];
    popupViewController.delegate = self;
    [self presentPopupViewController:popupViewController animationType:MJPopupViewAnimationFade];
    popupViewController.popupTitle.text = [self.mainTableData objectAtIndex:indexPath.row];
    popupViewController.popupNutritionFact.text = @"Nutrition Facts:";
    popupViewController.popupNutritionFact.textColor = [UIColor redColor];
    popupViewController.popupNutritionTitle.text = nutrition[0];
    
    popupViewController.popupTitle.font = popupViewController.popupNutritionFact.font = sketchslab25;
    popupViewController.popupDetail.font = sketchslab17;
    popupViewController.popupNutritionTitle.font = popupViewController.popupNutritionDetail.font = jamies20;
    
    switch (indexPath.row) {
        case 0: {
            popupViewController.popupImage.image = [UIImage imageNamed:mainTableImage[indexPath.row]];
            popupViewController.popupDetail.text = mainTableDetail[indexPath.row];
            popupViewController.popupNutritionDetail.text = nutrition[indexPath.row + 1];
            popupViewController.type = mainTableType[indexPath.row];
        }
            break;
            
        case 1: {
            popupViewController.popupImage.image = [UIImage imageNamed:mainTableImage[indexPath.row]];
            popupViewController.popupDetail.text = mainTableDetail[indexPath.row];
            popupViewController.popupNutritionDetail.text = nutrition[indexPath.row + 1];
            popupViewController.type = mainTableType[indexPath.row];
        }
            break;
            
        case 2: {
            popupViewController.popupImage.image = [UIImage imageNamed:mainTableImage[indexPath.row]];
            popupViewController.popupDetail.text = mainTableDetail[indexPath.row];
            popupViewController.popupNutritionDetail.text = nutrition[indexPath.row + 1];
            popupViewController.type = mainTableType[indexPath.row];
        }
            break;
     
        case 3: {
            popupViewController.popupImage.image = [UIImage imageNamed:mainTableImage[indexPath.row]];
            popupViewController.popupDetail.text = mainTableDetail[indexPath.row];
            popupViewController.popupNutritionDetail.text = nutrition[indexPath.row + 1];
            popupViewController.type = mainTableType[indexPath.row];
        }
            break;
     
        case 4: {
            popupViewController.popupImage.image = [UIImage imageNamed:mainTableImage[indexPath.row]];
            popupViewController.popupDetail.text = mainTableDetail[indexPath.row];
            popupViewController.popupNutritionDetail.text = nutrition[indexPath.row + 1];
            popupViewController.type = mainTableType[indexPath.row];
        }
            break;
     
        case 5: {
            popupViewController.popupImage.image = [UIImage imageNamed:mainTableImage[indexPath.row]];
            popupViewController.popupDetail.text = mainTableDetail[indexPath.row];
            popupViewController.popupNutritionDetail.text = nutrition[indexPath.row + 1];
            popupViewController.type = mainTableType[indexPath.row];
        }
            break;
     
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
}

@end
