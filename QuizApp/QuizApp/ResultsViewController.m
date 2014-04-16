//
//  ResultsViewController.m
//  CollegePrepExpress
//
//  Created by B's Mac on 10/04/14.
//  Copyright (c) 2014 iphonedeveloper9. All rights reserved.
//

#import "SDImageCache.h"
#import "ResultsViewController.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController
@synthesize total, correct, arrAns, diff;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)sendSendMarksRequest
{
    NSString *str = @"";
    for (int i = 0; i < arrAns.count; i++) {
        
        str = [str stringByAppendingFormat:@"q%d=%@&", i + 1, [arrAns objectAtIndex:i]];
        
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://boilingstocks.com/dubzinc/public_html/sendReport.php?%@name=%@&email=%@&dif=%@", str, [defaults objectForKey:@"name"], [defaults objectForKey:@"email"], diff]];
    
    NSLog(@"%@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    
    resultCon = [NSURLConnection connectionWithRequest:request delegate:self];
    
    resultData = [[NSMutableData alloc]init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    lblTotQues.text = [NSString stringWithFormat:@"%d", total];
    lblAns.text = [NSString stringWithFormat:@"%d", correct];
    
    //[self sendSendMarksRequest];
	// Do any additional setup after loading the view.
}

#pragma mark - connections

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    if(connection == resultCon)
    {
        [resultData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if(connection == resultCon)
    {
        [resultData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if(connection == resultCon)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"CollegePrepExpress" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if(connection == resultCon)
    {
        NSError *myError = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"%@", response);
        
        if ([[response objectForKey:@"sent"] isEqualToString:@"true"]) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"CollegePrepExpress" message:@"Result Sent!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = -1;
            [alert show];
        }
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == -1) {
        NSArray *array = [self.navigationController viewControllers];
        
        [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack_Click:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSend_Click:(id)sender {
    
    [self sendSendMarksRequest];
}
@end
