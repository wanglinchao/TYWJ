//
//  TYWJCharteredBusViewController.m
//  TYWJBus
//
//  Created by tywj on 2019/11/26.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import "TYWJCharteredBusViewController.h"
#import "TYWJChooseStationController.h"

#import "TYWJCharteredBusCell.h"
#import "SDCycleScrollView.h"
#import "TYWJStationToStationView.h"
#import "UIControl+ZLEventTimeInterval.h"
#import "TYWJSoapTool.h"

@interface TYWJCharteredBusViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property(nonatomic,weak) UITableView *tableView;
/* getupPoi */
@property (copy, nonatomic) AMapPOI *getupPoi;
/* getdownPoi */
@property (copy, nonatomic) AMapPOI *getdownPoi;
/* s2sView */
@property (strong, nonatomic) TYWJStationToStationView *s2sView;
@end

@implementation TYWJCharteredBusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ZLGlobalBgColor;
    [self initTableView];
}

- (void)initTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = ZLGlobalBgColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
//    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
////            make.edges.mas_equalTo(self.view.safeAreaInsets);
//            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(40);
//            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
//            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
//            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
//        }else {
//            make.edges.mas_equalTo(self.view);
//        }
//    }];
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, ZLScreenWidth, 360);
    headerView.backgroundColor = ZLGlobalBgColor;
    self.tableView.tableHeaderView = headerView;
    
    NSArray *imagesURLStrings = @[
    @"https://www.pdztc917.com/mipmap/pandaapp_banner1.png",
    @"https://www.pdztc917.com/mipmap/pandaapp_banner2.jpg"
    ];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ZLScreenWidth, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    cycleScrollView.autoScrollTimeInterval = 5;
    [headerView addSubview:cycleScrollView];
    
    
    UIView *sView = [[UIView alloc] initWithFrame:CGRectMake(0, 190, ZLScreenWidth, 160)];
    sView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:sView];
    
    WeakSelf;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"我要包车";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.frame = CGRectMake(20, 10, 200, 20);
    [sView addSubview:titleLabel];
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.zl_x = titleLabel.zl_x - 6;
    separatorView.zl_y = 10;
    separatorView.zl_width = 2;
    separatorView.zl_height = titleLabel.zl_height;
    separatorView.backgroundColor = ZLColorWithRGB(250, 205, 0);
    [sView addSubview:separatorView];
    
    TYWJStationToStationView *s2sView = [[TYWJStationToStationView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 10, ZLScreenWidth - 60.f, 120)];
    [sView addSubview:s2sView];
    self.s2sView = s2sView;
    
    s2sView.getupBtnClicked = ^{
        [weakSelf pushToChooseVcWithIsGetupStation:YES];
    };
    
    s2sView.getdownBtnClicked = ^{
        [weakSelf pushToChooseVcWithIsGetupStation:NO];
    };
    
    UIButton *switchBtn = [[UIButton alloc] init];
    switchBtn.zl_size = CGSizeMake(25.f, 50.f);
    switchBtn.zl_x = s2sView.zl_width + 20.f;
    switchBtn.zl_centerY = s2sView.zl_centerY;
    [switchBtn setImage:[UIImage imageNamed:@"icon_exchange2_25x25_"] forState:UIControlStateNormal];
    [switchBtn addTarget:self action:@selector(switchClicked) forControlEvents:UIControlEventTouchUpInside];
    switchBtn.zl_eventTimeInterval = 0.6;
    [sView addSubview:switchBtn];
    
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJCharteredBusCell *cell = [TYWJCharteredBusCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    WeakSelf;
    cell.submitBtnClicked = ^(NSString * _Nonnull numStr, NSString * _Nonnull nameStr, NSString * _Nonnull phoneStr, NSString * _Nonnull timeStr, NSString * _Nonnull reqStr) {
        [self.view endEditing:YES];
        if (self.s2sView.getupTF.text.length == 0 || self.s2sView.getdownTF.text.length == 0) {
            [MBProgressHUD zl_showAlert:@"请选择包车地点" afterDelay:1.0f];
            return;
        }
        
        if (numStr.length == 0 || nameStr.length == 0 || phoneStr.length == 0 || timeStr.length == 0) {
            [MBProgressHUD zl_showAlert:@"请先填写必填信息" afterDelay:1.0f];
            return;
        }
        
        if ([numStr intValue] <= 0) {
            [MBProgressHUD zl_showAlert:@"乘车人数必须为大于0的整数" afterDelay:1.0f];
            return;
        }
        
        if (![self verifyPhoneNum:phoneStr]) {
            [MBProgressHUD zl_showAlert:@"手机号填写有误，请重新填写" afterDelay:1.0f];
            return;
        }
        
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        //设置日期的显示格式
        fmt.dateFormat = @"yyyy年MM月dd日";
        //将日期转为指定格式显示
        NSDate *date = [fmt dateFromString:timeStr];
        fmt.dateFormat = @"yyyy-MM-dd";
        NSString *dateStr = [fmt stringFromDate:date];
        
        NSString * soapBodyStr = [NSString stringWithFormat:
                                         @"<%@ xmlns=\"%@\">\
                                         <chufa>%@</chufa>\
                                         <mudi>%@</mudi>\
                                         <renshu>%@</renshu>\
                                         <cdate>%@</cdate>\
                                         <person>%@</person>\
                                         <tel>%@</tel>\
                                         <remark>%@</remark>\
                                         </%@>",TYWJRequestInsertbaoche,TYWJRequestService,self.s2sView.getupTF.text,self.s2sView.getdownTF.text,numStr,nameStr,phoneStr,dateStr,reqStr,TYWJRequestInsertbaoche];
               AFHTTPSessionManager *afMgr = [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:soapBodyStr success:^(id responseObject) {
                   id resp = responseObject[0][@"NS1:insertbaocheResponse"];
                   if ([resp isEqualToString:@"ok"]) {
                       ZLLog(@"提交成功");
                       [weakSelf.navigationController popViewControllerAnimated:YES];
                   }else {
                       [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
                   }
               } failure:^(NSError *error) {
                   [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
               }];
    };
    return cell;
}

- (BOOL)verifyPhoneNum:(NSString *)phoneNum
{
    NSString *regex = @"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:phoneNum]) {
        return YES ;
    }else
        return NO;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 750;
}

- (void)pushToChooseVcWithIsGetupStation:(BOOL)isGetupStation {
    WeakSelf;
    TYWJChooseStationController *vc = [[TYWJChooseStationController alloc] init];
    vc.isGetupStation = isGetupStation;
    vc.isDefaultSearch = YES;
    vc.stationPoi = ^(AMapPOI *poi) {
        if (isGetupStation) {
            weakSelf.getupPoi = poi;
            [self setGetupText:poi.name];
        }else {
            weakSelf.getdownPoi = poi;
            [self setGetdownText:poi.name];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)switchClicked
{
    [self.view endEditing:YES];
    
    if (self.s2sView.getupTF.text.length == 0 || self.s2sView.getdownTF.text.length == 0) {
        [MBProgressHUD zl_showAlert:@"请选择上下车地点" afterDelay:1.5f];
        return;
    }
    [self.s2sView switchTF];
    
    AMapPOI *tmpPoi = [self.getupPoi copy];
    self.getupPoi = [self.getdownPoi copy];
    self.getdownPoi = [tmpPoi copy];
}

- (void)setGetupText:(NSString *)text {
    if (self.s2sView.getupTF.zl_y < self.s2sView.getdownTF.zl_y) {
        self.s2sView.getupTF.text = text;
    }
    else {
        self.s2sView.getdownTF.text = text;
    }
}

- (void)setGetdownText:(NSString *)text {
    if (self.s2sView.getupTF.zl_y > self.s2sView.getdownTF.zl_y) {
        self.s2sView.getupTF.text = text;
    }
    else {
        self.s2sView.getdownTF.text = text;
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    ZLLog(@"---点击了第%ld张图片", (long)index);
    [self.view endEditing:YES];
}

@end
