//
//  PopupViewController.h
//  Foodle's
//
//  Created by Thomas Lin on 3/27/13.
//  Copyright (c) 2013 Thomas Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Order.h"

@protocol PopupDelegate;

@interface PopupViewController : UIViewController

@property (assign, nonatomic) id <PopupDelegate>delegate;

@property (strong, nonatomic) IBOutlet UILabel *popupTitle;
@property (strong, nonatomic) IBOutlet UITextView *popupDetail;
@property (strong, nonatomic) IBOutlet UILabel *popupNutritionFact;
@property (strong, nonatomic) IBOutlet UITextView *popupNutritionTitle;
@property (strong, nonatomic) IBOutlet UITextView *popupNutritionDetail;
@property (strong, nonatomic) IBOutlet UIButton *popupCloseButtonStyle;
@property (strong, nonatomic) IBOutlet UIButton *popupFBShareButton;
@property (strong, nonatomic) IBOutlet UIImageView *popupImage;
@property (strong, nonatomic) IBOutlet UIButton *popupAddToOrderButton;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UILabel *priceTag;

@property (nonatomic, retain) NSString *type;

- (IBAction)popupCloseButtonPressed:(id)sender;
- (IBAction)popupFBShareButtonPressed:(id)sender;
- (IBAction)popupAddToOrderButtonPressed:(id)sender;

@end

@protocol PopupDelegate <NSObject>
@optional
- (void)closeButtonPressed:(PopupViewController *)popupViewController;
@end