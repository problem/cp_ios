//
//  FaceToFaceInviteController.h
//  candpiosapp
//
//  Created by Alexi (Love Machine) on 2012/02/14.
//  Copyright (c) 2012 Coffee and Power Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UserProfileCheckedInViewController.h"

@interface FaceToFaceAcceptDeclineViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UIView *actionBar;
@property (weak, nonatomic) IBOutlet UILabel *actionBarHeader;
@property (weak, nonatomic) IBOutlet UIButton *f2fAcceptButton;
@property (weak, nonatomic) IBOutlet UIButton *f2fDeclineButton;
@property (weak, nonatomic) IBOutlet UIView *viewUnderToolbar;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UserProfileCheckedInViewController *userProfile;

- (IBAction)acceptF2F;
- (IBAction)declineF2F;
- (void)cancelPasswordEntry:(id)sender;

@end