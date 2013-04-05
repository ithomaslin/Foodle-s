//
//  CoverViewController.m
//  Foodle's
//
//  Created by Thomas Lin on 3/27/13.
//  Copyright (c) 2013 Thomas Lin. All rights reserved.
//

#import "CoverViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface CoverViewController ()

@end

@implementation CoverViewController

@synthesize menuButton;
@synthesize coverCaption, coverTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIFont *sketchslab35 = [UIFont fontWithName:@"Sketchslab" size:35.0f];
    UIFont *sketchslab80 = [UIFont fontWithName:@"Sketchslab" size:80.0f];
    self.coverTitle.font = sketchslab80;
    self.coverCaption.font = sketchslab35;
    self.coverCaption.textColor = self.coverTitle.textColor = [UIColor whiteColor];

    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cover_background.png"]];
    
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(5, 40, 110, 35);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menub.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuButton];
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

@end
