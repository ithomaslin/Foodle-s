//
//  PopupViewController.m
//  Foodle's
//
//  Created by Thomas Lin on 3/27/13.
//  Copyright (c) 2013 Thomas Lin. All rights reserved.
//

#import "PopupViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "SocialFBViewController.h"
#import "AppDelegate.h"
#import "Order.h"
#import "Toast+UIView.h"

@interface PopupViewController () <SocialFBPopupDelegate>
@property (nonatomic, assign) BOOL isShowingActivity;
@end

@implementation PopupViewController

@synthesize delegate;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize type;

//Synthesize the UI outlet
@synthesize popupAddToOrderButton,
            popupCloseButtonStyle,
            popupDetail,
            popupFBShareButton,
            popupImage,
            popupNutritionFact,
            popupTitle,
            priceTag; //The price tag of the dish, don't forget!!!!!

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sub_view_background.png"]];
        [popupAddToOrderButton setBackgroundImage:[UIImage imageNamed:@"texture_button.png"] forState:UIControlStateNormal];
        [popupCloseButtonStyle setBackgroundImage:[UIImage imageNamed:@"close_ribbon_normal.png"] forState:UIControlStateNormal];
        [popupCloseButtonStyle setBackgroundImage:[UIImage imageNamed:@"close_ribbon_highlighted.png"] forState:UIControlStateHighlighted];
        [popupFBShareButton setBackgroundImage:[UIImage imageNamed:@"fbButton.png"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    id appDelegate = (id)[[UIApplication sharedApplication] delegate]; self.managedObjectContext = [appDelegate managedObjectContext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popupCloseButtonPressed:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeButtonPressed:)]) {
        [self.delegate closeButtonPressed:self];
    }
}

- (IBAction)popupFBShareButtonPressed:(id)sender
{
    SocialFBViewController *socialFBPopover = [[SocialFBViewController alloc] initWithNibName:@"SocialFBViewController" bundle:nil];
    socialFBPopover.delegate = self;
    [self presentPopupViewController:socialFBPopover animationType:MJPopupViewAnimationSlideTopTop];
    
}

- (IBAction)popupAddToOrderButtonPressed:(id)sender
{
    NSManagedObjectContext *context = [self managedObjectContext];
    Order *order = [NSEntityDescription insertNewObjectForEntityForName:@"Order" inManagedObjectContext:context];
    
    order.title = popupTitle.text;
    order.created = [NSDate date];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Oops...");
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Test" object:self];
    
    [self.view makeToast:@"Dish Added!" duration:0.7 position:@"center" image:[UIImage imageNamed:@"tick.png"]];
}

- (void)socialFBPopupCloseButtonPressed:(SocialFBViewController *)socialFBPopupViewController
{
    [socialFBPopupViewController.postMessageTextView resignFirstResponder];
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
}
@end
