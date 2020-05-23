//
//  TYWJFeedbackViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/23.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJFeedbackViewController.h"
#import "TYWJTextVeiw.h"
#import "JXTextView.h"
@interface TYWJFeedbackViewController ()
@property (weak, nonatomic) IBOutlet TYWJTextVeiw *tv;

@end

@implementation TYWJFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户反馈";
    [self.tv showPlaceholder];
    self.tv.phText = @"您的建议与反馈，是我们前进的动力";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)submitAction:(id)sender {
}
- (IBAction)closeTF:(id)sender {
    [self.tv resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
