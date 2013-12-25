//
//  LoginViewController.m
//  QuizApp
//
//  Created by B's Mac on 25/12/13.
//  Copyright (c) 2013 iphonedeveloper9. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self clearFields];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Private

-(void)clearFields
{
    self.txtPassword.text = @"";
    self.txtEmail.text = @"";
}
-(BOOL)validateEmail: (NSString *) email{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	
    return [emailTest evaluateWithObject:email];
	//	return TRUE;
}

#pragma mark button clicks

- (IBAction)btnLogin_Click:(id)sender {
    
    if (self.txtEmail.text.length == 0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Quiz App" message:@"Please enter your E-mail address!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(![self validateEmail:self.txtEmail.text]){
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Quiz App" message:@"Please enter your valid E-mail address!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (self.txtPassword.text.length == 0){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Quiz App" message:@"Please enter your password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    

    else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.txtEmail resignFirstResponder];
        [self.txtPassword resignFirstResponder];
        //http://boilingstocks.com/dubzinc/public_html/signup.php?username=testuser&password=123&email='test@test.com'&parentemail='test@parent.com'
        
        NSString *postStr = [NSString stringWithFormat:@"email=%@&password=%@", self.txtEmail.text, self.txtPassword.text];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://boilingstocks.com/dubzinc/public_html/login.php?%@", postStr]];
        
        
        NSMutableURLRequest *categoryRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
        
        loginCon = [NSURLConnection connectionWithRequest:categoryRequest delegate:self];
        LoginData = [[NSMutableData alloc]init];
    }
}

- (IBAction)btnSignIn_Click:(id)sender {
    
    [self performSegueWithIdentifier:@"signInSegue" sender:nil];
}

#pragma mark - textfield Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - connections

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    if(connection == loginCon)
    {
        [LoginData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if(connection == loginCon)
    {
        [LoginData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if(connection == loginCon)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Quiz App" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if(connection == loginCon)
    {
        NSError *myError = nil;
        NSDictionary *dictReceivedData = [[NSDictionary alloc]init];
        dictReceivedData = [NSJSONSerialization JSONObjectWithData:LoginData options:NSJSONReadingMutableLeaves error:&myError];
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Quiz App" message:[NSString stringWithFormat:@"%@", dictReceivedData] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        if ([[dictReceivedData objectForKey:@"errorcode"]integerValue] == 0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Quiz App" message:@"Logged in Successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        NSLog(@"%@", dictReceivedData);
    }
}

@end
