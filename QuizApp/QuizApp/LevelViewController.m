//
//  LevelViewController.m
//  CollegePrepExpress
//
//  Created by B's Mac on 09/04/14.
//  Copyright (c) 2014 iphonedeveloper9. All rights reserved.
//

#import "LevelViewController.h"

@interface LevelViewController ()

@end

@implementation LevelViewController

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
    self.navigationController.navigationBar.hidden = YES;
    [self customButton:btnGrammer];
    [self customButton:btnVocab];
    [self customButton:btnMath];
    [self customButton:btnEasy];
    [self customButton:btnMedium];
    [self customButton:btnHard];
    
    contentScroll.contentSize = CGSizeMake(320, btnStart.frame.origin.y + btnStart.frame.size.height + 10);
	// Do any additional setup after loading the view.
}

-(void)customButton:(UIButton *)btn
{
    [btn setBackgroundColor:[UIColor clearColor]];
    btn.layer.cornerRadius = 10.0;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 1.0;
}

-(void)didChangeSubject:(id)sender
{
    [btnGrammer setBackgroundColor:[UIColor clearColor]];
    [btnVocab setBackgroundColor:[UIColor clearColor]];
    [btnMath setBackgroundColor:[UIColor clearColor]];
    
    UIButton *btn = (UIButton *)sender;
    [btn setBackgroundColor:[UIColor lightGrayColor]];
}

-(void)didChangeLevel:(id)sender
{
    [btnEasy setBackgroundColor:[UIColor clearColor]];
    [btnMedium setBackgroundColor:[UIColor clearColor]];
    [btnHard setBackgroundColor:[UIColor clearColor]];
    
    UIButton *btn = (UIButton *)sender;
    [btn setBackgroundColor:[UIColor lightGrayColor]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnStart_Click:(id)sender {
    
}

- (IBAction)btnGrammer_Click:(id)sender {
    
    [self didChangeSubject:sender];
}

- (IBAction)btnVocab_Click:(id)sender {
    [self didChangeSubject:sender];
}

- (IBAction)btnMath_click:(id)sender {
     [self didChangeSubject:sender];
}

- (IBAction)btnEasy_click:(id)sender {
    
    [self didChangeLevel:sender];
}

- (IBAction)btnMedium_Click:(id)sender {
    [self didChangeLevel:sender];
}

- (IBAction)btnHard_Click:(id)sender {
   [self didChangeLevel:sender];
}
@end
