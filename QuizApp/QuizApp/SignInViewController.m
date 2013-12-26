//
//  SignInViewController.m
//  QuizApp
//
//  Created by B's Mac on 25/12/13.
//  Copyright (c) 2013 iphonedeveloper9. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

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

#pragma mark - textfield delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - private

-(BOOL)validateEmail: (NSString *) email{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	
    return [emailTest evaluateWithObject:email];
	//	return TRUE;
}

-(void)requestSignIn
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *postStr = [NSString stringWithFormat:@"username=%@&password=%@&email=%@&parentemail=%@", self.txtUserName.text, self.txtPassword.text, self.txtEmail.text, self.txtParentEmail.text];
    
    signinData = [[NSMutableData alloc]init];
    
    //if there is a connection going on just cancel it.
    [signinCon cancel];
    
    //initialize new mutable data
    
    //initialize url that is going to be fetched.
    NSURL *url = [NSURL URLWithString:@"http://boilingstocks.com/dubzinc/public_html/signup.php"];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    signinCon = connection;
    
    //start the connection
    [connection start];
    
}

-(void)dismissKeyboard
{
    [self.txtUserName resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtParentEmail resignFirstResponder];
}

-(void)clearFields
{
    self.txtUserName.text = @"";
    self.txtPassword.text = @"";
    self.txtEmail.text = @"";
    self.txtParentEmail.text = @"";
}

-(BOOL)validateFields
{
    if (self.txtUserName.text.length == 0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"CollegePrepExpress" message:@"Please enter your Username!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    else if (self.txtPassword.text.length == 0){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"CollegePrepExpress" message:@"Please enter your password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    else if (self.txtEmail.text.length == 0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"CollegePrepExpress" message:@"Please enter your E-mail address!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    else if(![self validateEmail:self.txtEmail.text]){
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"CollegePrepExpress" message:@"Please enter your valid E-mail address!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    else if (self.txtParentEmail.text.length == 0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"CollegePrepExpress" message:@"Please enter your parent E-mail address!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    else if(![self validateEmail:self.txtParentEmail.text]){
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"CollegePrepExpress" message:@"Please enter your valid parent E-mail address!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}

#pragma mark - connections

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    if(connection == signinCon)
    {
        [signinData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if(connection == signinCon)
    {
        [signinData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if(connection == signinCon)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"CollegePrepExpress" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if(connection == signinCon)
    {
        NSError *myError = nil;
        NSDictionary *dictReceivedData = [[NSDictionary alloc]init];
        dictReceivedData = [NSJSONSerialization JSONObjectWithData:signinData options:NSJSONReadingMutableLeaves error:&myError];
        
        
        int errorcode = [[dictReceivedData objectForKey:@"errorcode"]integerValue];
        if (errorcode == 0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"CollegePrepExpress" message:@"Registered Successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        NSLog(@"%@", dictReceivedData);
    }
}

#pragma mark - button clicks

- (IBAction)btnSign_Click:(id)sender {
    
    if ([self validateFields]) {
        [self dismissKeyboard];
        [self requestSignIn];
    }
    
}
@end
