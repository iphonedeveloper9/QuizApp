//
//  ResultsViewController.m
//  CollegePrepExpress
//
//  Created by B's Mac on 10/04/14.
//  Copyright (c) 2014 iphonedeveloper9. All rights reserved.
//

#import "ResultsViewController.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController
@synthesize total, correct;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    lblTotQues.text = [NSString stringWithFormat:@"%d", total];
    lblAns.text = [NSString stringWithFormat:@"%d", correct];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack_Click:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
