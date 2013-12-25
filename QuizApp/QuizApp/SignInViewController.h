//
//  SignInViewController.h
//  QuizApp
//
//  Created by B's Mac on 25/12/13.
//  Copyright (c) 2013 iphonedeveloper9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SignInViewController : UIViewController<UITextFieldDelegate>
{
    NSURLConnection *signinCon;
    NSMutableData *signinData;
}
@property (strong, nonatomic) IBOutlet UITextField *txtUserName;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;

@property (strong, nonatomic) IBOutlet UITextField *txtParentEmail;
- (IBAction)btnSign_Click:(id)sender;
@end
