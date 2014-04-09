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
    //self.automaticallyAdjustsScrollViewInsets = NO;

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
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"CollegePrepExpress" message:@"Please enter your E-mail address!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(![self validateEmail:self.txtEmail.text]){
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"CollegePrepExpress" message:@"Please enter your valid E-mail address!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (self.txtPassword.text.length == 0){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"CollegePrepExpress" message:@"Please enter your password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.txtEmail resignFirstResponder];
        [self.txtPassword resignFirstResponder];
        
        NSString *postStr = [NSString stringWithFormat:@"email=%@&password=%@", self.txtEmail.text, self.txtPassword.text];
        
        LoginData = [[NSMutableData alloc]init];
        
        //if there is a connection going on just cancel it.
        [loginCon cancel];
        
        //initialize new mutable data
        
        //initialize url that is going to be fetched.
        NSURL *url = [NSURL URLWithString:@"http://boilingstocks.com/dubzinc/public_html/login.php"];
        
        //initialize a request from url
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
        
        //set http method
        [request setHTTPMethod:@"POST"];
        
        [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        //set post data of request
        [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        //initialize a connection from request
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        loginCon = connection;
        
        //start the connection
        [connection start];
        
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
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"CollegePrepExpress" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
        
        int errorcode = [[dictReceivedData objectForKey:@"errorcode"]integerValue];
        
        //NSDictionary *data = [dictReceivedData objectForKey:@"data"];
        
        int loginSuccess;
        if ([dictReceivedData objectForKey:@"data"] != [NSNull null]) {
            loginSuccess = [[[dictReceivedData objectForKey:@"data"] objectForKey:@"loginSuccess"]integerValue];
            
        }
        else
        {
            errorcode = 1;
        }
        
        
        if (errorcode == 0 && loginSuccess == 0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"CollegePrepExpress" message:@"Incorrect Password!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        if (errorcode == 2 && loginSuccess == 0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"CollegePrepExpress" message:@"You haven,t verified you E-mail address yet. Please check your E-mail and verify it!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        if (errorcode == 0 && loginSuccess == 1) {
            //UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"CollegePrepExpress" message:@"Logged in Successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //[alert show];
            
            [self performSegueWithIdentifier:@"levelSegue" sender:nil];
        }
        
        if (errorcode == 1) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"CollegePrepExpress" message:@"No such user!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
                    }
        NSLog(@"%@", dictReceivedData);
    }
}

@end
