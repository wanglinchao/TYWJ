//
//  TYWJFeedbackViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/23.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJFeedbackViewController.h"
#import "TYWJTextVeiw.h"
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
    if (self.tv.text.length > 0) {
        NSDictionary *param = @{
            @"code":@"467676735333203968",
            @"content":self.tv.text,
            @"user_type":ISDRIVER?@"1":@"0",
        };
        WeakSelf;
        [[TYWJNetWorkTolo sharedManager] requestWithMethod:POST WithPath:@"http://192.168.2.192:9002/feb/save" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
            [MBProgressHUD zl_showSuccess:@"反馈成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });

        } WithFailurBlock:^(NSError *error) {
      
        }];
    } else {
        [MBProgressHUD zl_showError:@"请填写反馈内容"];
    }
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
