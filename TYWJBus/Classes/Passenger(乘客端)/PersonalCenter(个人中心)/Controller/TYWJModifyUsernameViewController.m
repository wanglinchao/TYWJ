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
    NSDictionary *param = @{
//        @"avatar": @"string",
//        @"birthday": @"1991-08-11",
//        @"desc": @"string",
//        @"gender": @0,
//        @"province": @"string",
//        @"province_code": @0,
//        @"region": @"string",
//        @"region_code": @0,
//        @"star_signs": @"string",
        @"uid": [ZLUserDefaults objectForKey:TYWJLoginUidString],
        @"nickName": self.inputTF.text
    };

    
//    NSDictionary *param = @{@"uid": [ZLUserDefaults objectForKey:TYWJLoginUidString],@"username":self.inputTF.text};
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:POST WithPath:@"http://192.168.2.91:9001/user/info/update/userDetail" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        //设置用户信息
        NSDictionary *userDic = [dic objectForKey:@"data"];

        [TYWJLoginTool sharedInstance].nickname = self.inputTF.text;
        [[TYWJLoginTool sharedInstance] saveLoginInfo];
        [MBProgressHUD zl_showSuccess:@"保存成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
        
        return;
    } WithFailurBlock:^(NSError *error) {
        [MBProgressHUD zl_showError:@"保存失败"];
    }];
    
    
    
    
    


}


@end
