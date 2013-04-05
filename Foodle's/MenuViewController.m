//
//  MenuViewController.m
//  Foodle's
//
//  Created by Thomas Lin on 3/27/13.
//  Copyright (c) 2013 Thomas Lin. All rights reserved.
//

#import "MenuViewController.h"
#import "ECSlidingViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MenuViewController ()

@property (strong, nonatomic) NSArray *menu;
@property (strong, nonatomic) NSArray *section1;
@property (strong, nonatomic) NSArray *section2;

@end

@implementation MenuViewController

@synthesize menu;
@synthesize section1;
@synthesize section2;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Uncomment the following lines to set the multiple section menu
    //self.section1 = [NSArray arrayWithObjects:@"STARTER", @"RICE & NOODLE", @"CHICKEN", @"BEEF", @"SEAFOOD", nil];
    //self.section2 = [NSArray arrayWithObjects:@"FACEBOOK", @"Two", @"Three", nil];
    //self.menu = [NSArray arrayWithObjects:self.section1, self.section2, nil];
    
    //Delete the following line if the multiple section table is applied
    self.menu = [NSArray arrayWithObjects:@"STARTER", @"RICE & NOODLE", @"CHICKEN", @"BEEF", @"SEAFOOD", nil];
    
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    UIImage *bgImg = [UIImage imageNamed:@"background_table.png"];
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:bgImg];
    bgImgView.frame = self.tableView.bounds;
    self.tableView.backgroundView = bgImgView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
    
    //For multiple sections, apply the following line
    /*
     ***
     ***
     
    */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Uncomment the following lines for multiple section table
    // Return the number of rows in the section.
    /*if (section == 0) {
     return [self.section1 count];
     } else if (section == 1) {
     return [self.section2 count];
     }*/
    return [self.menu count]; //to prevent the control reaches end of non-void function
    //if none of the if conditions are met.
}

/*
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Menu";
    } else if (section == 1) {
        return @"Social Networking";
    }
    return 0;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Menu Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        UIFont *sketchslab = [UIFont fontWithName:@"Sketchslab" size:20];
        cell.textLabel.font = sketchslab;
    }
    
    /*
     if (indexPath.section == 0) {
     cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.section1 objectAtIndex:indexPath.row]];
     } else if (indexPath.section == 1) {
     cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.section2 objectAtIndex:indexPath.row]];
     }*/
    
    cell.textLabel.text = [self.menu objectAtIndex:indexPath.row];
    
    if ([cell.textLabel.text isEqualToString:self.menu[0]]) {
        cell.imageView.image = [UIImage imageNamed:@"icon_appetizer.png"];
    } else if ([cell.textLabel.text isEqualToString:self.menu[1]]) {
        cell.imageView.image = [UIImage imageNamed:@"icon_riceandnoodle.png"];
    } else if ([cell.textLabel.text isEqualToString:self.menu[2]]) {
        cell.imageView.image = [UIImage imageNamed:@"icon_chicken.png"];
    } else if ([cell.textLabel.text isEqualToString:self.menu[3]]) {
        cell.imageView.image = [UIImage imageNamed:@"icon_beef.png"];
    } else if ([cell.textLabel.text isEqualToString:self.menu[4]]) {
        cell.imageView.image = [UIImage imageNamed:@"icon_fish.png"];
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *newTopViewController;
    
    /*Uncomment the following lines for applying the multiple section in table
     if (indexPath.section == 0) {
     NSString *identifier = [NSString stringWithFormat:@"%@", [self.section1 objectAtIndex:indexPath.row]];
     newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
     } else if (indexPath.section == 1) {
     NSString *identifier = [NSString stringWithFormat:@"%@", [self.section2 objectAtIndex:indexPath.row]];
     newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
     }
     */
    NSString *identifier = [NSString stringWithFormat:@"%@", [self.menu objectAtIndex:indexPath.row]];
    newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

@end