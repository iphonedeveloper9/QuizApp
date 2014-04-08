//
//  LevelViewController.h
//  CollegePrepExpress
//
//  Created by B's Mac on 09/04/14.
//  Copyright (c) 2014 iphonedeveloper9. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelViewController : UIViewController
{
    
    IBOutlet UIScrollView *contentScroll;
    IBOutlet UIButton *btnStart;
    IBOutlet UIButton *btnHard;
    IBOutlet UIButton *btnMedium;
    IBOutlet UIButton *btnEasy;
    IBOutlet UIButton *btnMath;
    IBOutlet UIButton *btnVocab;
    IBOutlet UIButton *btnGrammer;
}
- (IBAction)btnStart_Click:(id)sender;
- (IBAction)btnGrammer_Click:(id)sender;
- (IBAction)btnVocab_Click:(id)sender;
- (IBAction)btnMath_click:(id)sender;
- (IBAction)btnEasy_click:(id)sender;
- (IBAction)btnMedium_Click:(id)sender;
- (IBAction)btnHard_Click:(id)sender;

@end
