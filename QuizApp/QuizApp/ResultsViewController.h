//
//  ResultsViewController.h
//  CollegePrepExpress
//
//  Created by B's Mac on 10/04/14.
//  Copyright (c) 2014 iphonedeveloper9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ResultsViewController : UIViewController<UIAlertViewDelegate>
{
    
    IBOutlet UILabel *lblAns;
    IBOutlet UILabel *lblTotQues;
    
    NSURLConnection *resultCon;
    NSMutableData *resultData;
}
- (IBAction)btnBack_Click:(id)sender;
- (IBAction)btnSend_Click:(id)sender;

@property (nonatomic, readwrite)int total;
@property (nonatomic, readwrite)int correct;
@property (nonatomic, readwrite) NSString *diff;

@property (nonatomic, retain)NSMutableArray *arrAns;
@end
