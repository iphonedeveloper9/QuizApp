//
//  QuizViewController.h
//  CollegePrepExpress
//
//  Created by B's Mac on 09/04/14.
//  Copyright (c) 2014 iphonedeveloper9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ResultsViewController.h"

@interface QuizViewController : UIViewController
{
    NSURLConnection *quizCon;
    NSMutableData *quizData;
    IBOutlet UIButton *btnNext;
    IBOutlet UIButton *btnPrev;
    IBOutlet UIButton *btnOpt5;
    IBOutlet UIButton *btnOpt1;
    
    IBOutlet UIButton *btnOpt4;
    IBOutlet UIButton *btnOpt3;
    IBOutlet UIButton *btnOpt2;
    IBOutlet UILabel *lblQuest;
    IBOutlet UIImageView *imgQuePic;
    
    NSArray *arrQuiz;
    NSMutableArray *arrAns;
    int queNo;
}

@property (nonatomic, retain) NSString *diff;
- (IBAction)btnOpt_Click:(id)sender;

- (IBAction)btnBack_click:(id)sender;
- (IBAction)btnPrev_Click:(id)sender;
- (IBAction)btnNext_Click:(id)sender;

@end
