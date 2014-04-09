//
//  QuizViewController.m
//  CollegePrepExpress
//
//  Created by B's Mac on 09/04/14.
//  Copyright (c) 2014 iphonedeveloper9. All rights reserved.
//

#import "QuizViewController.h"

@interface QuizViewController ()

@end

@implementation QuizViewController
@synthesize diff;

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
    
    queNo = 0;
    
    arrQuiz = [[NSArray alloc]init];
    arrAns = [[NSMutableArray alloc]init];
    
    [self customButton:btnOpt1];
    [self customButton:btnOpt2];
    [self customButton:btnOpt3];
    [self customButton:btnOpt4];
    [self customButton:btnOpt5];
    
    [self sendQuizRequest];
	// Do any additional setup after loading the view.
}

-(void)sendQuizRequest
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://boilingstocks.com/dubzinc/public_html/createTest.php?dif=%@", diff]];
    
    NSLog(@"%@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    
    quizCon = [NSURLConnection connectionWithRequest:request delegate:self];
    
    quizData = [[NSMutableData alloc]init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)customButton:(UIButton *)btn
{
    [btn setBackgroundColor:[UIColor clearColor]];
    btn.layer.cornerRadius = 10.0;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 1.0;
}

#pragma mark - connections

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    if(connection == quizCon)
    {
        [quizData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if(connection == quizCon)
    {
        [quizData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if(connection == quizCon)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"CollegePrepExpress" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if(connection == quizCon)
    {
        NSError *myError = nil;
        arrQuiz = [NSJSONSerialization JSONObjectWithData:quizData options:NSJSONReadingMutableLeaves error:&myError];
        
        if (arrQuiz) {
            for (int i = 0; i < arrQuiz.count; i++) {
                [arrAns addObject:@""];
            }
            [self setQuestionData];
        }
        else
        {
            for (UIView *view in self.view.subviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton * btn = (UIButton *)view;
                    [btn setUserInteractionEnabled:NO];
                    btn.hidden = YES;
                    lblQuest.text = @"No questions found";
                }
            }
        }
       
        
    }
}

-(void)setQuestionData
{
    lblQuest.text = [[arrQuiz objectAtIndex:queNo]objectForKey:@"text"];
    [btnOpt1 setTitle:[[arrQuiz objectAtIndex:queNo]objectForKey:@"option1"] forState:UIControlStateNormal];
     [btnOpt2 setTitle:[[arrQuiz objectAtIndex:queNo]objectForKey:@"option2"] forState:UIControlStateNormal];
     [btnOpt3 setTitle:[[arrQuiz objectAtIndex:queNo]objectForKey:@"option3"] forState:UIControlStateNormal];
     [btnOpt4 setTitle:[[arrQuiz objectAtIndex:queNo]objectForKey:@"option4"] forState:UIControlStateNormal];
    [btnOpt5 setTitle:[[arrQuiz objectAtIndex:queNo]objectForKey:@"option5"] forState:UIControlStateNormal];
    
    if ([[arrAns objectAtIndex:queNo] isKindOfClass:[NSNumber class]]) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:[[arrAns objectAtIndex:queNo]integerValue]];
        [btn setBackgroundColor:[UIColor lightGrayColor]];
    }
}

-(void)resetAllButtons
{
    [btnOpt1 setBackgroundColor:[UIColor clearColor]];
    [btnOpt2 setBackgroundColor:[UIColor clearColor]];
    [btnOpt3 setBackgroundColor:[UIColor clearColor]];
    [btnOpt4 setBackgroundColor:[UIColor clearColor]];
    [btnOpt5 setBackgroundColor:[UIColor clearColor]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnOpt_Click:(id)sender {
    
    [btnOpt1 setBackgroundColor:[UIColor clearColor]];
    [btnOpt2 setBackgroundColor:[UIColor clearColor]];
    [btnOpt3 setBackgroundColor:[UIColor clearColor]];
    [btnOpt4 setBackgroundColor:[UIColor clearColor]];
    [btnOpt5 setBackgroundColor:[UIColor clearColor]];
    
    UIButton *btn = (UIButton *)sender;
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    
    [arrAns replaceObjectAtIndex:queNo withObject:[NSNumber numberWithInt:btn.tag]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"resultSegue"])
    {
        ResultsViewController *vc = [segue destinationViewController];
        
        vc.total = arrQuiz.count;
        
        NSLog(@"%@", arrQuiz);
        int correct = 0;
        
        for (int i = 0; i < arrQuiz.count; i++) {
            int ans = [[[arrQuiz objectAtIndex:i]objectForKey:@"answer"]integerValue];
            if ([[arrAns objectAtIndex:i] isKindOfClass:[NSNumber class]]) {
                if ([[arrAns objectAtIndex:i]integerValue] == ans) {
                    correct ++;
                }
            }
            
        }
        vc.correct = correct;
    }
}

- (IBAction)btnBack_click:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnPrev_Click:(id)sender {
    
    queNo --;
    if (queNo < 0) {
        queNo = 0;
        return;
    }
    [self resetAllButtons];
    [self setQuestionData];
    
}

- (IBAction)btnNext_Click:(id)sender {
    
    queNo ++;
    if (queNo > arrQuiz.count - 1) {
        queNo = arrQuiz.count - 1;
        [self performSegueWithIdentifier:@"resultSegue" sender:nil];
        return;
    }
    [self resetAllButtons];
    [self setQuestionData];
}

@end
