//
//  TYWJApplyRouteController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJApplyRouteController.h"
#import "TYWJApplyRouteCell.h"
#import "TYWJApplyRoute.h"
#import "TYWJBorderButton.h"
#import "ZLPopoverView.h"

#import "TYWJSoapTool.h"
#import "TYWJLoginTool.h"
#import "TYWJChooseStationController.h"

#import <MJExtension.h>
#import <UIImage+GIF.h>


@interface TYWJApplyRouteController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* dataLsit */
@property (strong, nonatomic) NSArray *dataList;
@end

@implementation TYWJApplyRouteController
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, 0, ZLScreenWidth, ZLScreenHeight - 60.f - kTabBarH - kNavBarH);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 54.f;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJApplyRouteCell class]) bundle:nil] forCellReuseIdentifier:TYWJApplyRouteCellID];
        
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"happy" ofType:@"gif"];
        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
        UIImage *image = [UIImage sd_animatedGIFWithData:imageData];
        
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = image;
        imgView.zl_size = CGSizeMake(self.view.zl_width, 110.f);
        _tableView.tableHeaderView = imgView;
        
    }
    return _tableView;
}

#pragma mark -

- (void)dealloc {
    ZLFuncLog;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self loadPlist];
}

- (void)setupView {
    self.navigationItem.title = @"线路申请";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self addFooterView];
}

- (void)addFooterView {
    TYWJBorderButton *commitBtn = [[TYWJBorderButton alloc] init];
    commitBtn.frame = CGRectMake(20.f, self.view.zl_height - kTabBarH - 55.f, ZLScreenWidth - 46.f, 46.f);
    [commitBtn setTitle:@"提交信息" forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [commitBtn addTarget:self action:@selector(commitClicked) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn setRoundViewWithCornerRaidus:8.f];
    [self.view addSubview:commitBtn];
    
}
- (void)loadPlist {
    NSString *path = [[NSBundle mainBundle] pathForResource:TYWJApplyRoutePlist ofType:nil];
    if (path) {
        NSArray *dataArr = [NSArray arrayWithContentsOfFile:path];
        self.dataList = [TYWJApplyRoute mj_objectArrayWithKeyValuesArray:dataArr];
        if (!self.getupPoi) {
            [self.tableView reloadData];
            return;
        }
        
        for (TYWJApplyRoute *route in self.dataList) {
            if ([route.title isEqualToString:@"出发住址"]) {
                route.body = self.getupPoi.name;
            }
            if ([route.title isEqualToString:@"目的地地址"]) {
                route.body = self.getdownPoi.name;
            }
        }
        [self.tableView reloadData];
    }
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
    switch (indexPath.row) {
        case 2:
        case 3:
            {
                WeakSelf;
                NSInteger selectedTime = indexPath.row == 2 ? 9 : 18;
                TYWJApplyRoute *route = self.dataList[indexPath.row];
                [[ZLPopoverView sharedInstance] showPopSelecteTimeViewWithSelectedTime:selectedTime ConfirmClicked:^(NSString *time) {
                    route.body = time;
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }];
            }
            break;
        case 0:
        case 1:
        {
            WeakSelf;
            TYWJApplyRoute *route = self.dataList[indexPath.row];
            //选择上下车地点
            TYWJChooseStationController *vc = [[TYWJChooseStationController alloc] init];
            vc.isGetupStation = indexPath.row == 0;
            if (![route.body isEqualToString:@"出发地在哪儿?"] && ![route.body isEqualToString:@"目的地在哪儿?"]) {
                vc.defaultStation = route.body;
            }
            
            vc.stationPoi = ^(AMapPOI *poi) {
                if (indexPath.row == 0) {
                    weakSelf.getupPoi = poi;
                }else {
                    weakSelf.getdownPoi = poi;
                }
                route.body = poi.name;
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 按钮点击

- (void)commitClicked {
    ZLFuncLog;
    TYWJApplyRoute *route0 = self.dataList[0];
    TYWJApplyRoute *route1 = self.dataList[1];

    if ([route0.body isEqualToString:@"出发地在哪儿?"] || [route1.body isEqualToString:@"目的地在哪儿?"]) {
        [MBProgressHUD zl_showAlert:@"请选择上下车地点" toView:self.view afterDelay:1.5f];
        return;
    }
    
    [self loadData];
}


/**
 提交线路申请信息
 */
- (void)loadData {
    NSMutableArray *dataArr = [NSMutableArray array];
    for (TYWJApplyRoute *route in self.dataList) {
        [dataArr addObject:route.body];
    }
    NSString *getupStation = self.getupPoi.name;
    NSString *getdownStation = self.getdownPoi.name;
    getupStation = [getupStation stringByReplacingOccurrencesOfString:@"&" withString:@"__"];
    getdownStation = [getdownStation stringByReplacingOccurrencesOfString:@"&" withString:@"__"];
    NSString *bodyStr = [NSString stringWithFormat:
                         @"<%@ xmlns=\"%@\">\
                         <yhm>%@</yhm>\
                         <jtzz>%@</jtzz>\
                         <gsdz>%@</gsdz>\
                         <sbsj>%@</sbsj>\
                         <xbsj>%@</xbsj>\
                         <cs>%@</cs>\
                         <qjingdu>%@</qjingdu>\
                         <qweidu>%@</qweidu>\
                         <zjingdu>%@</zjingdu>\
                         <zweidu>%@</zweidu>\
                         </%@>",TYWJRequestApplyForNewRoute,TYWJRequestService,[TYWJLoginTool sharedInstance].phoneNum,getupStation,getdownStation,dataArr[2],dataArr[3],[TYWJCommonTool sharedTool].selectedCity.city_code,@(self.getupPoi.location.longitude),@(self.getupPoi.location.latitude),@(self.getdownPoi.location.longitude),@(self.getdownPoi.location.latitude),TYWJRequestApplyForNewRoute];
    [TYWJSoapTool SOAPDataWithSoapBody:bodyStr success:^(id responseObject) {
        if ([responseObject[0][@"NS1:xianlushenqinginsertResponse"] isEqualToString:@"ok"]) {
//            UINavigationController *nav = self.navigationController;
//            [nav popToRootViewControllerAnimated:NO];
//            
//            TYWJRouteAppliedSuccessfullyController *vc = [[TYWJRouteAppliedSuccessfullyController alloc] init];
//            vc.dataList = self.dataList;
//            [nav pushViewController:vc animated:YES];
            [MBProgressHUD zl_showSuccess:@"提交成功"];
            
        }else {
            [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
