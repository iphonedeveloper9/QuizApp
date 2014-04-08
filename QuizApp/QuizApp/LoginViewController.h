//
//  LoginViewController.h
//  QuizApp
//
//  Created by B's Mac on 25/12/13.
//  Copyright (c) 2013 iphonedeveloper9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    NSURLConnection *loginCon;
    NSMutableData *LoginData;
}
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)btnLogin_Click:(id)sender;
- (IBAction)btnSignIn_Click:(id)sender;

@end
