//
//  TYWJModifyUsernameViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/28.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJModifyUsernameViewController.h"

@interface TYWJModifyUsernameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputTF;

@end

@implementation TYWJModifyUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    self.navigationItem.title = @"昵称";
    self.inputTF.text = [TYWJLoginTool sharedInstance].nickname;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveInfoClicked)];
}

#pragma makr - 按钮点击

- (void)saveInfoClicked {
    ZLFuncLog;
    if ([self.inputTF.text isEqualToString:@""]) {
        [MBProgressHUD zl_showError:@"请输入用户名"];
        return;
    }
    [TYWJLoginTool sharedInstance].nickname = self.inputTF.text;
    [[TYWJLoginTool sharedInstance] saveLoginInfo];
    [MBProgressHUD zl_showSuccess:@"保存成功"];
    [self.navigationController popViewControllerAnimated:YES];
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
