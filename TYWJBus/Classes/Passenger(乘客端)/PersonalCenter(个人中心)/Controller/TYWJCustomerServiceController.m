//
//  TYWJCustomerServiceController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJCustomerServiceController.h"
#import "TYWJApplyRoute.h"
#import "TYWJApplyRouteCell.h"
#import "NSObject+ZLAlertView.h"
#import "TYWJOnlineFeedback.h"
#import "TYWJHelpController.h"
#import "TYWJLoginTool.h"
#import "TYWJSoapTool.h"
#import "TYWJTextVeiw.h"



static CGFloat const kRowHeight = 54.f;

#import <MJExtension.h>

@interface TYWJCustomerServiceController ()<UITableViewDelegate,UITableViewDataSource>

/* dataList */
@property (strong, nonatomic) NSArray *dataList;
/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* tf */
@property (weak, nonatomic) TYWJTextVeiw *tv;

@end

@implementation TYWJCustomerServiceController
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = ZLGlobalBgColor;
        _tableView.rowHeight = kRowHeight;
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJApplyRouteCell class]) bundle:nil] forCellReuseIdentifier:TYWJApplyRouteCellID];
        
        TYWJOnlineFeedback *footer = [[[NSBundle mainBundle] loadNibNamed:@"TYWJOnlineFeedback" owner:nil options:nil] lastObject];
        footer.zl_height = 300.f;
        self.tv = footer.tv;
        [footer addTarget:self action:@selector(commitClicked)];
        [footer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTableView)]];
        _tableView.tableFooterView = footer;
        
    }
    return _tableView;
}
#pragma mark -set up view

- (void)dealloc {
    ZLFuncLog;
    [self removeNotis];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self loadPlist];
    [self addNotis];
}

- (void)setupView {
    
    self.navigationItem.title = @"客服";
    
    [self.view addSubview:self.tableView];
    
}

- (void)loadPlist {
    NSString *path = [[NSBundle mainBundle] pathForResource:TYWJCustomerServicePlist ofType:nil];
    if (path) {
        NSArray *dataArr = [NSArray arrayWithContentsOfFile:path];
        self.dataList = [TYWJApplyRoute mj_objectArrayWithKeyValuesArray:dataArr];
        [self.tableView reloadData];
    }
}


/*
 180.76.171.32 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEWtUkqjJkr0ApaGb2PoiSl+9PvhZHx+FtNLDS9QMfVtp+OrAVl007+IKKUpqMMTyLSkUSBpeDujWCAV+nz229k=
 120.27.16.250 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHfJUZ/ysuEBbiSkPxEeccv3PQRMFW+yOTe7m1gvGRQHQPYrF4tMUEhuK753h9SE7sVzZ8f7XN27PTr5Su+quB4=
 [localhost]:10010 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD1NZPyXib5YHzm4VRLMa34w4DRWhzLRmhMWyj0c/YjFBaVa8D8uLQdgnEpjWGwjZ3FxXfuGVWBaTbtsx2/Q3OrC+MXMa/6Mf3SOkJJ6hcTzMlErISBvt9Mgeo1rM3jzzuFRcD9p3Oa9C/c/emwZtWmkFajaWzz2GCxL7Zm+pkfgBMIi8AlkXseIfOksf5Z1rA+/gtFHB4iq/7rwtSSYzx4SSqw1ACZchaAg2w58Wq0mhuQ9+uHeWjpq/FJ0hVXdX1cldKWn8xBN/ZcOhC/9t7mxHDmrMXDJxRlTDqGIosKmAjXPLYPc2bciXc1YzTKUPnsFDt1tvz6QxtBT+Fq2sLj
 [127.0.0.1]:10010 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD1NZPyXib5YHzm4VRLMa34w4DRWhzLRmhMWyj0c/YjFBaVa8D8uLQdgnEpjWGwjZ3FxXfuGVWBaTbtsx2/Q3OrC+MXMa/6Mf3SOkJJ6hcTzMlErISBvt9Mgeo1rM3jzzuFRcD9p3Oa9C/c/emwZtWmkFajaWzz2GCxL7Zm+pkfgBMIi8AlkXseIfOksf5Z1rA+/gtFHB4iq/7rwtSSYzx4SSqw1ACZchaAg2w58Wq0mhuQ9+uHeWjpq/FJ0hVXdX1cldKWn8xBN/ZcOhC/9t7mxHDmrMXDJxRlTDqGIosKmAjXPLYPc2bciXc1YzTKUPnsFDt1tvz6QxtBT+Fq2sLj
 192.168.10.100 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD1NZPyXib5YHzm4VRLMa34w4DRWhzLRmhMWyj0c/YjFBaVa8D8uLQdgnEpjWGwjZ3FxXfuGVWBaTbtsx2/Q3OrC+MXMa/6Mf3SOkJJ6hcTzMlErISBvt9Mgeo1rM3jzzuFRcD9p3Oa9C/c/emwZtWmkFajaWzz2GCxL7Zm+pkfgBMIi8AlkXseIfOksf5Z1rA+/gtFHB4iq/7rwtSSYzx4SSqw1ACZchaAg2w58Wq0mhuQ9+uHeWjpq/FJ0hVXdX1cldKWn8xBN/ZcOhC/9t7mxHDmrMXDJxRlTDqGIosKmAjXPLYPc2bciXc1YzTKUPnsFDt1tvz6QxtBT+Fq2sLj

 */

- (void)tapTableView {
    [self.view endEditing:YES];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJApplyRouteCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJApplyRouteCellID forIndexPath:indexPath];
    TYWJApplyRoute *route = self.dataList[indexPath.row];
    cell.route = route;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row
            ) {
        case 0:
        {
            //咨询服务
            [self alertWithTitle:@"拨打咨询电话" message:TYWJCustomerServicePhoneNum finish:^{
                //拨打电话号码
                [TYWJCommonTool dialWithPhoneNum:TYWJCustomerServicePhoneNum];
            }];
        }
            break;
        case 1:
        {
            //投诉建议
            [self alertWithTitle:@"拨打投诉电话" message:TYWJComplaintsHotlinePhoneNum finish:^{
                //拨打电话号码
                [TYWJCommonTool dialWithPhoneNum:TYWJComplaintsHotlinePhoneNum];
            }];
        }
            break;
        case 2:
        {
            //常见问题
            TYWJHelpController *helpVc = [[TYWJHelpController alloc] init];
            [self.navigationController pushViewController:helpVc animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 通知相关
- (void)addNotis {
    [ZLNotiCenter addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    [ZLNotiCenter addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
}

- (void)removeNotis {
    [ZLNotiCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [ZLNotiCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow {
    
    [UIView animateKeyframesWithDuration:0.45f delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        self.tableView.zl_y = -kRowHeight*self.dataList.count;
    } completion:nil];
}

- (void)keyboardWillHide {
    [UIView animateKeyframesWithDuration:0.45f delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        self.tableView.zl_y = 0;
    } completion:nil];
}


- (void)commitClicked {
    ZLFuncLog;
    [self request];
}

//请求数据

- (void)request {
    //TYWJRequstOnlineFeedback
    NSString *feedbackString = self.tv.text;
    if (feedbackString.length == 0) {
        [MBProgressHUD zl_showError:@"请填写反馈内容"];
        return;
    }
    WeakSelf;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat =  @"yyyy.MM.dd";
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <yhm>%@</yhm>\
                              <zxfk>%@</zxfk>\
                              <sj>%@</sj>\
                              </%@>",TYWJRequstOnlineFeedback,TYWJRequestService,[TYWJLoginTool sharedInstance].phoneNum,self.tv.text,dateString,TYWJRequstOnlineFeedback];
    
    [TYWJSoapTool SOAPDataWithSoapBody:soapBodyStr success:^(id responseObject) {
        if (responseObject) {
            NSString *response = responseObject[0][@"NS1:zaixianfankuiinsertResponse"];
            if ([response isEqualToString:@"ok"]) {
                [weakSelf.view endEditing:YES];
                weakSelf.tv.text = @"";
                [weakSelf.tv showPlaceholder];
                [MBProgressHUD zl_showSuccess:@"提交成功，感谢您的反馈"];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
