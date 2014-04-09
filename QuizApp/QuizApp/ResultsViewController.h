//
//  ResultsViewController.h
//  CollegePrepExpress
//
//  Created by B's Mac on 10/04/14.
//  Copyright (c) 2014 iphonedeveloper9. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsViewController : UIViewController
{
    
    IBOutlet UILabel *lblAns;
    IBOutlet UILabel *lblTotQues;
}
- (IBAction)btnBack_Click:(id)sender;

@property (nonatomic, readwrite)int total;
@property (nonatomic, readwrite)int correct;
@end
