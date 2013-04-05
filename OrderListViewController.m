//
//  OrderListViewController.m
//  Foodle's_Test
//
//  Created by Thomas Lin on 3/29/13.
//  Copyright (c) 2013 Thomas Lin. All rights reserved.
//

#import "OrderListViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "PopupViewController.h"
#import "CustomAlertView.h"
#import "Order.h"

@interface OrderListViewController () <PopupDelegate>

@end

@implementation OrderListViewController

@synthesize context, array;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)receiveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"Test"]) {
        [self getData];
    }
}

- (void)getData
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Order" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setFetchBatchSize:20];
    
    [request setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"created" ascending:YES];
    
    NSArray *newArray = [NSArray arrayWithObject:sort];
    
    [request setSortDescriptors:newArray];
    
    NSError *error;
    NSMutableArray *results = [[context executeFetchRequest:request error:&error] mutableCopy];
    [self setArray:results];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"Test" object:nil];
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.context = [appDelegate managedObjectContext];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sendButtonPressed:)];
    self.navigationItem.rightBarButtonItem = send;
    
    [self getData];
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    UILabel *title = [alertView valueForKey:@"_titleLabel"];
    UIFont *pacifico = [UIFont fontWithName:@"Pacifico" size:20.0];
    title.font = pacifico;
}

- (IBAction)sendButtonPressed:(id)sender
{
    UIAlertView *alertSend = [[UIAlertView alloc] initWithTitle:@"Foodle's" message:@"Are you ready to take the order?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    UIAlertView *alertEmpty = [[UIAlertView alloc] initWithTitle:@"Foodle's" message:@"There's nothing you can do with an empty stomach..." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    
    if (array.count == 0) {
        [alertEmpty show];
    } else {
        [alertSend show];
    }
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Order *order = [array objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [order title];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Order" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSError *error;
        [context deleteObject:[self.array objectAtIndex:indexPath.row]];
        
        NSMutableArray *results = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
        [self setArray:results];
        
        if (![context save:&error]) {
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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
//    switch (indexPath) {
//        case :
//            
//            break;
//            
//        default:
//            break;
//    }
}

@end
