//
//  SocialFBViewController.m
//  Foodle's
//
//  Created by Thomas Lin on 3/27/13.
//  Copyright (c) 2013 Thomas Lin. All rights reserved.
//

#import "SocialFBViewController.h"
#import "AppDelegate.h"
#import "PopupViewController.h"
#import "CustomAlertView.h"
#import <CoreLocation/CoreLocation.h>
#import <FacebookSDK/FacebookSDK.h>

NSString *const kPlaceholderPostMessage = @"Say something about it...";

@interface SocialFBViewController () <FBLoginViewDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *postImageView;
@property (strong, nonatomic) IBOutlet UILabel *postNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *postCaptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *postDescriptionLabel;
@property (strong, nonatomic) NSMutableDictionary *postParams;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *imageConnection;
@property (strong, nonatomic) UIAlertView *alertPost;

- (IBAction)shareButtonAction:(id)sender;
- (IBAction)authButtonAction:(id)sender;

@end

@implementation SocialFBViewController

@synthesize delegate = _delegate;
@synthesize postCaptionLabel = _postCaptionLabel;
@synthesize postDescriptionLabel = _postDescriptionLabel;
@synthesize postNameLabel = _postNameLabel;
@synthesize postMessageTextView;
@synthesize postImageView = _postImageView;
@synthesize postParams = _postParams;
@synthesize imageConnection = _imageConnection;
@synthesize imageData = _imageData;
@synthesize authButton = _authButton;
@synthesize alertPost;

#pragma mark - View

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.postParams =
        [[NSMutableDictionary alloc] initWithObjectsAndKeys:
         @"https://www.facebook.com/pages/Foodles-Community/177062199110893", @"link",
         @"https://fbcdn-sphotos-a-a.akamaihd.net/hphotos-ak-ash4/429536_178814222269024_1572372691_n.png", @"picture",
         @"Foodle's", @"name",
         @"The best Chinese restaurant ever!", @"caption",
         @"Foodle's is the best Chinese restaurant that fits everyone, no matter you are on diet, a health concious person, or even a vegetarian, you can always enjoy the best Chinese cuisine at here.", @"description",
         nil];
    }
    return self;
}

- (void)viewDidLoad
{
    imageController = [[UIImagePickerController alloc] init];
    
    [super viewDidLoad];
    [self.authButton setBackgroundImage:[UIImage imageNamed:@"fb_login_button_highlighted.png"] forState:UIControlStateHighlighted];
    UIFont *sketchslab17 = [UIFont fontWithName:@"Sketchslab" size:20.0f];
    self.postNameLabel.font = sketchslab17;
    
    // Show placeholder text
    [self resetPostMessage];
    // Set up the post information, hard-coded for this sample
    self.postNameLabel.text = [self.postParams objectForKey:@"name"];
    self.postCaptionLabel.text = [self.postParams
                                  objectForKey:@"caption"];
    [self.postCaptionLabel sizeToFit];
    self.postDescriptionLabel.text = [self.postParams
                                      objectForKey:@"description"];
    [self.postDescriptionLabel sizeToFit];
    
    // Kick off loading of image data asynchronously so as not
    // to block the UI.
    self.imageData = [[NSMutableData alloc] init];
    NSURLRequest *imageRequest = [NSURLRequest
                                  requestWithURL:
                                  [NSURL URLWithString:
                                   [self.postParams objectForKey:@"picture"]]];
    self.imageConnection = [[NSURLConnection alloc] initWithRequest:
                            imageRequest delegate:self];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:NO];
}

- (IBAction)cancelButtonPressed:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(socialFBPopupCloseButtonPressed:)]) {
        [self.delegate socialFBPopupCloseButtonPressed:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Dismissing the keyboard before the view disappears.
    [self.postMessageTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///*
// * A simple way to dismiss the message text view:
// * whenever the user clicks outside the view.
// */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.postMessageTextView isFirstResponder] && (self.postMessageTextView != touch.view)) {
        [self.postMessageTextView resignFirstResponder];
    }
}

#pragma mark -

#pragma mark - TextView

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // Clear the message text when the user starts editing
    if ([textView.text isEqualToString:kPlaceholderPostMessage]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)resetPostMessage
{
    self.postMessageTextView.text = kPlaceholderPostMessage;
    self.postMessageTextView.textColor = [UIColor lightGrayColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // Reset to placeholder text if the user is done
    // editing and no message has been entered.
    if ([textView.text isEqualToString:@""]) {
        [self resetPostMessage];
    }
}

#pragma mark -

#pragma mark - Facebook connection

- (void)connection:(NSURLConnection*)connection
    didReceiveData:(NSData*)data
{
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    // Load the image
    self.postImageView.image = [UIImage imageWithData:
                                [NSData dataWithData:self.imageData]];
    self.imageConnection = nil;
    self.imageData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    self.imageConnection = nil;
    self.imageData = nil;
}

#pragma mark -

#pragma mark - Camera initialization

//- (IBAction)cameraLaunch:(id)sender
//{
//    [self startCameraControllerFromViewController: self usingDelegate: self];
//}
//
//- (BOOL)startCameraControllerFromViewController:(UIViewController*)controller
//                                  usingDelegate:(id <UIImagePickerControllerDelegate,
//                                                 UINavigationControllerDelegate>)delegate {
//    
//    if (([UIImagePickerController isSourceTypeAvailable:
//          UIImagePickerControllerSourceTypeCamera] == NO)
//        || (delegate == nil)
//        || (controller == nil))
//        return NO;
//    
//    
//    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
//    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
//    
//    // Displays a control that allows the user to choose picture or
//    // movie capture, if both are available:
//    cameraUI.mediaTypes =
//    [UIImagePickerController availableMediaTypesForSourceType:
//     UIImagePickerControllerSourceTypeCamera];
//    
//    // Hides the controls for moving & scaling pictures, or for
//    // trimming movies. To instead show the controls, use YES.
//    cameraUI.allowsEditing = YES;
//    
//    cameraUI.delegate = delegate;
//    
//    [controller presentViewController:cameraUI animated:YES completion:nil];
//    return YES;
//}

#pragma mark -

#pragma mark - Authentication

- (IBAction)authButtonAction:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    if (FBSession.activeSession.isOpen) {
        [appDelegate closeSession];
    } else {
        // The person has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        [self.authButton setTitle:@"Logout" forState:UIControlStateNormal];
    } else {
        [self.authButton setTitle:@"Login" forState:UIControlStateNormal];
    }
}

#pragma mark -

#pragma mark - Facebook post action

- (IBAction)shareButtonAction:(id)sender
{
    
    if (!FBSession.activeSession.isOpen) {
        [[[UIAlertView alloc] initWithTitle:@"Oops..."
                                    message:@"You haven't logged in to Facebook."
                                   delegate:self
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil, nil] show];
    } else {
        // Hide keyboard if showing when button clicked
        if ([self.postMessageTextView isFirstResponder]) {
            [self.postMessageTextView resignFirstResponder];
        }
        
        // Add user message parameter if user filled it in
        if (![self.postMessageTextView.text isEqualToString:kPlaceholderPostMessage] && ![self.postMessageTextView.text isEqualToString:@""]) {
            [self.postParams setObject:self.postMessageTextView.text forKey:@"message"];
        }
        
        // Ask for publish_actions permissions in context
        if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
            // No permissions found in session, ask for it
            [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                  defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
                                                      if (!error) {
                                                          // If permissions granted, publish the story
                                                          [self publishStory];
                                                      }
                                                  }];
        } else {
            // If permissions present, publish the story
            [self publishStory];
        }
    }
}

- (void)publishStory
{
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:self.postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         
         NSString *alertText;
         
         if (error) {
             alertText = [NSString stringWithFormat:@"Sorry, some error occurs, please try again"
                          /*@"error: domain = %@, code = %d",
                           error.domain, error.code*/];
         } else {
             alertText = [NSString stringWithFormat:
                          @"Post Successful!"
                          /*[result objectForKey:@"id"]*/];
         }
         
         // Show the result in an alert
         alertPost = [[UIAlertView alloc] initWithTitle:@"Facebook"
                                    message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OKay!"
                           otherButtonTitles:nil, nil];
         
         [alertPost show];
         [self.delegate socialFBPopupCloseButtonPressed:self];
     }];
}

#pragma mark -

@end
