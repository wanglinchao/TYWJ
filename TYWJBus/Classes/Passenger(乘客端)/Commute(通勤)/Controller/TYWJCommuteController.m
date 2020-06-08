//
//  TYWJCommuteController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/22.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJCommuteController.h"

#import "TYWJDetailRouteController.h"
#import "TYWJChooseStationController.h"
#import "TYWJCheckoutRouteController.h"
#import "TYWJBuyTicketController.h"
#import "TYWJUsableCitiesController.h"
#import "TYWJSearchRouteResultController.h"
#import "TYWJZYXWebController.h"
#import "TYWJApplyLineViewController.h"

#import "TYWJCommuteHeaderView.h"
#import "TYWJCommuteCell.h"
#import "ZLRefreshGifHeader.h"

#import "TYWJSingleLocation.h"
#import "TYWJSoapTool.h"
#import "TYWJLoginTool.h"

#import "TYWJRouteList.h"
#import "TYWJPeirodTicket.h"

#import "SDCycleScrollView.h"
#import "ZLHTTPSessionManager.h"

#import "TYWJJsonRequestUrls.h"
#import "TYWJBanerModel.h"

#import <WechatOpenSDK/WXApi.h>
#import <MJExtension.h>
#import <WRNavigationBar.h>
#import "TYWJHomeHeaderView.h"
#import "CQMarqueeView.h"
#import "TYWJMessageViewController.h"
#pragma mark - class
@class TYWJCommuteHeaderView;
@interface TYWJCommuteController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,CQMarqueeViewDelegate>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* headerView */
@property (strong, nonatomic) TYWJCommuteHeaderView *headerView;
@property (strong, nonatomic) UIView *secondHeaderView;

@property (strong, nonatomic) TYWJHomeHeaderView *navHeaderView;

/* routeList */
@property (strong, nonatomic) NSArray *routeList;

/* getupPoi */
@property (copy, nonatomic) AMapPOI *getupPoi;
/* getdownPoi */
@property (copy, nonatomic) AMapPOI *getdownPoi;


@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
@property (strong, nonatomic) NSArray<TYWJBanerModel *> *banersModels;

@end

@implementation TYWJCommuteController



- (void)applykBtnClick
{
    TYWJApplyLineViewController *applyVC = [[TYWJApplyLineViewController alloc] init];
    [self.navigationController pushViewController:applyVC animated:YES];
}



#pragma mark - setup view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNotis];
    //    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
    [self loadData];
    
    [TYWJCommonTool show3DTouchActionShow:YES];
    
#ifdef DEBUG
    [self test];
#endif
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupView];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)test {
    //浮点数的二进制表现形式的问题，如果在类似财务的计算上的准确性的话， 最好将小数转换为整数后进行计算，计算完成后再转换为小数，如下所示/或者用BCD码
    //    float a = 0.1f;
    float sum = 0;
    for (NSInteger i = 0; i < 100; i++) {
        sum += 1;
    }
    sum /= 10;
    ZLLog(@"sum = %f",sum);
    if (sum == 10) {
        ZLLog(@"sum = %f",sum);
    }
}

- (void)setupView {
    [[TYWJSingleLocation stantardLocation] startBasicLocation];
    
    _navHeaderView = [[TYWJHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth, kNavBarH + 40)];
    CQMarqueeView *marqueeView = [[CQMarqueeView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth , 40)];
    [_navHeaderView.messageVIew addSubview:marqueeView];
    marqueeView.marqueeTextArray = @[@"你的行程#linename#已发车。请提前5分钟上车"];
    marqueeView.delegate = self;
    
    
    [_navHeaderView showMessage];
    _navHeaderView.leftBtn.titleLabel.text = [TYWJCommonTool sharedTool].selectedCity.city;
    WeakSelf;
    _navHeaderView.buttonSeleted = ^(NSInteger index){
        switch (index) {
            case 0:
            {
                ZLFuncLog;
                TYWJUsableCitiesController *Vc = [[TYWJUsableCitiesController alloc] init];
                [TYWJCommonTool pushToVc:Vc];
            }
                break;
            case 1:
            {
                ZLFuncLog;
                TYWJMessageViewController *Vc = [[TYWJMessageViewController alloc] init];
                [TYWJCommonTool pushToVc:Vc];
            }
                break;
            default:
                break;
        }
    };
    [self.view addSubview:_navHeaderView];
    
    
    
}
// 跑马灯view上的关闭按钮点击时回调
- (void)marqueeView:(CQMarqueeView *)marqueeView closeButtonDidClick:(UIButton *)sender {
    NSLog(@"点击了关闭按钮");
    //    [UIView animateWithDuration:1 animations:^{
    //        marqueeView.height = 0;
    //    } completion:^(BOOL finished) {
    //        [marqueeView removeFromSuperview];
    //    }];
}

- (void)setTableViewHeader{
    WeakSelf;
    _headerView = [[TYWJCommuteHeaderView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth, TYWJCommuteHeaderViewH)];
    _headerView.frame =CGRectMake(0, self.cycleScrollView.zl_height, ZLScreenWidth, 100);
    _headerView.backgroundColor = ZLGlobalBgColor;
    _headerView.getupBtnClicked = ^{
        [weakSelf pushToChooseVcWithIsGetupStation:YES];
    };
    _headerView.getdownBtnClicked = ^{
        [weakSelf pushToChooseVcWithIsGetupStation:NO];
    };
    _headerView.searchBtnClicked = ^{
        [weakSelf doSearch];
    };
    _headerView.switchBtnClicked = ^{
        //交换按钮点击
        AMapPOI *tmpPoi = [weakSelf.getupPoi copy];
        weakSelf.getupPoi = [weakSelf.getdownPoi copy];
        weakSelf.getdownPoi = [tmpPoi copy];
    };
    self.secondHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, _navHeaderView.zl_y +_navHeaderView.zl_height, ZLScreenWidth, _headerView.zl_height +self.cycleScrollView.zl_height)];
    self.secondHeaderView.backgroundColor = kMainRedColor;
    
    
    
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.zl_height, ZLScreenWidth - 40, (ZLScreenWidth - 40)/343*112)];
    UIImageView *bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth, headerView.frame.size.height)];
    bgV.image = [UIImage imageNamed:@"headerBGView"];
    [headerView addSubview:bgV];
    [headerView addSubview:self.cycleScrollView];
    
    self.cycleScrollView.imageURLStringsGroup = [self getImagesFromBanerModels:self.banersModels];
    //    [self.secondHeaderView addSubview:_headerView];
    //
    //    [self.secondHeaderView addSubview:headerView];
    [self.view addSubview:headerView];
    _headerView.zl_y =headerView.zl_height +headerView.zl_y;
    [self.view addSubview:_headerView];
    
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [MBProgressHUD zl_hideHUD];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self wr_setNavBarBackgroundAlpha:1.f];
    
    [TYWJLoginTool checkUniqueLoginWithVC:self];
    
}

- (void)dealloc {
    ZLFuncLog;
    [self removeNotis];
}
#pragma mark - 通知相关
- (void)addNotis {
    [ZLNotiCenter addObserver:self selector:@selector(cityChanged:) name:TYWJSelectedCityChangedNoti object:nil];
}

- (void)removeNotis {
    [ZLNotiCenter removeObserver:self name:TYWJSelectedCityChangedNoti object:nil];
}

- (void)cityChanged:(NSNotification *)noti {
    NSString *city = [noti object];
    if (city) {
        if ([city isEqualToString:self.navigationItem.rightBarButtonItem.title]) {
            return;
        }
        self.routeList = nil;
        _navHeaderView.leftBtn.titleLabel.text = [TYWJCommonTool sharedTool].selectedCity.city;
        [self.navigationItem.leftBarButtonItem setTitle:[TYWJCommonTool sharedTool].selectedCity.city];
        for (UIView *view in self.view.subviews) {
            [view removeFromSuperview];
        }
        //        [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
        [self loadData];
    }
}


#pragma mark - 加载数据

- (void)loadData {
    
    [self loadBanerImages];
}

- (void)loadBanerImages{
    //TODO: 请求图片数据
    WeakSelf;
    ZLHTTPSessionManager *mgr = [ZLHTTPSessionManager signManager];
    [mgr.requestSerializer setValue:@"" forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"oldPassword"] = [TYWJLoginTool sharedInstance].driverLoginPwd;
    params[@"requestFrom"] = @"iOS";
    [mgr POST:[TYWJJsonRequestUrls sharedRequest].bannerImageInfo parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"reCode"] intValue] == 201) {
            weakSelf.banersModels = [TYWJBanerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [weakSelf setTableViewHeader];
            [self loadRouteListData];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
- (NSArray *)getImagesFromBanerModels:(NSArray<TYWJBanerModel *>*)banerModels{
    NSMutableArray *array = [NSMutableArray new];
    for (NSInteger i = 0; i < banerModels.count; i++) {
        TYWJBanerModel *banerModel = banerModels[i];
        [array addObject:banerModel.url];
    }
    return array;
}
/**
 加载线路表数据
 */
- (void)loadRouteListData {
    WeakSelf;
    NSInteger index ;
    NSDictionary *param = @{
        @"s_lng":@"",
        @"s_lat":@"",
        @"e_lng":@"",
        @"e_lat":@"",
        @"offset":@1,
        @"limit":@1,
    };
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.91:9003/trip/search" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *data = [dic objectForKey:@"data"];
        if (data.count) {
            weakSelf.routeList = data;
            [weakSelf.view addSubview:weakSelf.tableView];
            
            [weakSelf.tableView reloadData];
        }else {
            [weakSelf showRequestFailedViewWithImg:nil tips:@"没找到线路？申请线路可能会开通哦！" btnTitle:@"申请线路" tag:1];
        }
    } WithFailurBlock:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
        [weakSelf showRequestFailedViewWithImg:@"icon_no_network" tips:@"网络差，请稍后再试" btnTitle:nil tag:0];
    }];
}


#pragma mark - 显示no data view
- (void)showRequestFailedViewWithImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle tag:(NSInteger)index{
    WeakSelf;
    [TYWJCommonTool loadNoDataViewWithImg:img tips:tips btnTitle:btnTitle isHideBtn:NO showingVc:self btnClicked:^(UIViewController *failedVc) {
        if (index == 1) {
            [weakSelf applykBtnClick];
        }
        [failedVc.view removeFromSuperview];
        
        [weakSelf loadData];
        [failedVc removeFromParentViewController];
    }];
    [self setupView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.routeList.count;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //    return TYWJCommuteHeaderViewH + 86.f;
    return 105;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return TYWJCommuteCellH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    TYWJCommuteCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJCommuteCellID forIndexPath:indexPath];
    NSDictionary *data = self.routeList[indexPath.row];
    TYWJRouteListInfo *routeListinfo = [TYWJRouteListInfo mj_objectWithKeyValues:data];
    
    cell.routeListInfo = routeListinfo;
    cell.buyClicked = ^(TYWJRouteListInfo *routeListInfo) {
        [TYWJGetCurrentController showLoginViewWithSuccessBlock:^{
            TYWJBuyTicketController *buyTicketVc = [[TYWJBuyTicketController alloc] init];
            buyTicketVc.line_info_id = routeListInfo.line_info_id;
            [weakSelf.navigationController pushViewController:buyTicketVc animated:YES];
            
        }];
        
    };
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    //当自定义view并且重写了layoutSubviews的话，就会不悬浮
//    //    TYWJCommuteHeaderView *headerView = [[TYWJCommuteHeaderView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth, TYWJCommuteHeaderViewH)];
//    TYWJCommuteHeaderView *headerView = [[TYWJCommuteHeaderView alloc] init];
//    WeakSelf;
//    headerView.backgroundColor = ZLGlobalBgColor;
//    headerView.getupBtnClicked = ^{
//        [weakSelf pushToChooseVcWithIsGetupStation:YES];
//    };
//    headerView.getdownBtnClicked = ^{
//        [weakSelf pushToChooseVcWithIsGetupStation:NO];
//    };
//    headerView.searchBtnClicked = ^{
//        [weakSelf doSearch];
//    };
//    headerView.switchBtnClicked = ^{
//        //交换按钮点击
//        AMapPOI *tmpPoi = [weakSelf.getupPoi copy];
//        weakSelf.getupPoi = [weakSelf.getdownPoi copy];
//        weakSelf.getdownPoi = [tmpPoi copy];
//    };
//
//    self.headerView = headerView;
//    return self.headerView;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJDetailRouteController *detailRouteVc = [[TYWJDetailRouteController alloc] init];
    detailRouteVc.isDetailRoute = YES;
    detailRouteVc.routeListInfo = [TYWJRouteListInfo mj_objectWithKeyValues:self.routeList[indexPath.row]];
    [self.navigationController pushViewController:detailRouteVc animated:YES];
    
}



#pragma mark - 搜索站点
- (void)doSearch {
    WeakSelf;
    //    [[TYWJCommonTool sharedTool] searchStationWithGetupPoi:self.getupPoi getdownPoi:self.getdownPoi type:self.type];
    //    [TYWJCommonTool sharedTool].doSearchResul = ^(NSArray *result) {
    //        if (result.count) {
    //            TYWJSearchRouteResultController *searchResultVc = [[TYWJSearchRouteResultController alloc] init];
    //            searchResultVc.searchResult = result;
    //            [weakSelf.navigationController pushViewController:searchResultVc animated:YES];
    //
    //        }else {
    //            TYWJCheckoutRouteController *checkRouteVc = [[TYWJCheckoutRouteController alloc] init];
    //            checkRouteVc.getdownPoi = weakSelf.getdownPoi;
    //            checkRouteVc.getupPoi = weakSelf.getupPoi;
    //            [weakSelf.navigationController pushViewController:checkRouteVc animated:YES];
    //        }
    //    };
}
#pragma mark -

- (void)pushToChooseVcWithIsGetupStation:(BOOL)isGetupStation {
    WeakSelf;
    TYWJChooseStationController *vc = [[TYWJChooseStationController alloc] init];
    vc.isGetupStation = isGetupStation;
    vc.isDefaultSearch = YES;
    vc.stationPoi = ^(AMapPOI *poi) {
        if (isGetupStation) {
            weakSelf.getupPoi = poi;
            [weakSelf.headerView setGetupText:poi.name];
        }else {
            weakSelf.getdownPoi = poi;
            [weakSelf.headerView setGetdownText:poi.name];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    TYWJBanerModel * model = _banersModels[index];
    [self openWechatApplet:model.path];
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}

- (void)openWechatApplet:(NSString *)path{
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = TYWJWechatAppletKey;  //拉起的小程序的username
    launchMiniProgramReq.path = path;    ////拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
    [WXApi sendReq:launchMiniProgramReq];
}

#pragma mark - lazy

- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(20, 0, ZLScreenWidth - 40, (ZLScreenWidth - 40)/343*112) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        _cycleScrollView.pageDotColor = kMainYellowColor;
        _cycleScrollView.autoScrollTimeInterval = 5;
    }
    return _cycleScrollView;
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.size.height +self.headerView.zl_y, self.view.bounds.size.width, self.view.bounds.size.height - (self.headerView.frame.size.height +self.headerView.zl_y)) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth, 10)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJCommuteCell class]) bundle:nil] forCellReuseIdentifier:TYWJCommuteCellID];
        
        
        NSMutableArray *refreshImgs = [NSMutableArray array];
        for (NSInteger i = 0; i <= 15; i++) {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"loading_000%02ld_58x10_",i]];
            [refreshImgs addObject:img];
        }
        ZLRefreshGifHeader *mjHeader = [ZLRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        _tableView.mj_header = mjHeader;
        
    }
    return _tableView;
}
@end
