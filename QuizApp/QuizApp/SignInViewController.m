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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://boilingstocks.com/dubzinc/public_html/signup.php?%@", postStr]];
    
    NSLog(@"%@", url);
    
    NSMutableURLRequest *categoryRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    
    signinCon = [NSURLConnection connectionWithRequest:categoryRequest delegate:self];
    signinData = [[NSMutableData alloc]init];
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
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Quiz App" message:@"Please enter your Username!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    else if (self.txtPassword.text.length == 0){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Quiz App" message:@"Please enter your password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    else if (self.txtEmail.text.length == 0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Quiz App" message:@"Please enter your E-mail address!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    else if(![self validateEmail:self.txtEmail.text]){
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Quiz App" message:@"Please enter your valid E-mail address!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    else if (self.txtParentEmail.text.length == 0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Quiz App" message:@"Please enter your parent E-mail address!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    else if(![self validateEmail:self.txtParentEmail.text]){
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Quiz App" message:@"Please enter your valid parent E-mail address!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Quiz App" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Quiz App" message:[NSString stringWithFormat:@"%@", dictReceivedData] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        if ([[dictReceivedData objectForKey:@"errorcode"]integerValue] == 0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Quiz App" message:@"Registered Successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
