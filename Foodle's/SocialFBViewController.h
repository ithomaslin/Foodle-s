//
//  SocialFBViewController.h
//  Foodle's
//
//  Created by Thomas Lin on 3/27/13.
//  Copyright (c) 2013 Thomas Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@protocol SocialFBPopupDelegate;

@interface SocialFBViewController : UIViewController
<UITextViewDelegate, FBLoginViewDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate,
UIAlertViewDelegate, UIPopoverControllerDelegate, FBFriendPickerDelegate,
UIAlertViewDelegate, UISearchBarDelegate>

{
    UIImagePickerController *imageController;
}
@property (assign, nonatomic) id <SocialFBPopupDelegate>delegate;
@property (unsafe_unretained, nonatomic) IBOutlet UITextView *postMessageTextView;
@property (strong, nonatomic) IBOutlet UIButton *authButton;

@end

@protocol SocialFBPopupDelegate <NSObject>
@optional
- (void)socialFBPopupCloseButtonPressed:(SocialFBViewController *)socialFBPopupViewController;
@end