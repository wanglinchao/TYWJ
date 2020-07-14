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
#import "TYWJBuyTicketController.h"
#import "TYWJUsableCitiesController.h"
#import "TYWJApplyLineViewController.h"
#import "TYWJCommuteHeaderView.h"
#import "TYWJCommuteCell.h"
#import "ZLRefreshGifHeader.h"
#import "TYWJSingleLocation.h"
#import "TYWJRouteList.h"
#import "SDCycleScrollView.h"
#import "TYWJBanerModel.h"
#import <WechatOpenSDK/WXApi.h>
#import <MJExtension.h>
#import "WRNavigationBar.h"
#import "TYWJHomeHeaderView.h"
#import "CQMarqueeView.h"
#import "TYWJMessageViewController.h"
#import "TYWJRongCloudTool.h"
#import "TYWJMessageModel.h"
#import "TYWJMessageDetailTableViewController.h"
#pragma mark - class
@class TYWJCommuteHeaderView;
@interface TYWJCommuteController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,CQMarqueeViewDelegate>
/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* headerView */
//站点选择view
@property (strong, nonatomic) TYWJCommuteHeaderView *stationHeaderView;
//导航条view
@property (strong, nonatomic) TYWJHomeHeaderView *navHeaderView;

@property (strong, nonatomic) CQMarqueeView *marqueeView;
/* routeList */
@property (strong, nonatomic) NSMutableArray *routeList;
@property (strong, nonatomic) NSArray *cityList;
@property (strong, nonatomic) NSArray *messageArr;

/* getupPoi */
@property (copy, nonatomic) AMapPOI *getupPoi;
/* getdownPoi */
@property (copy, nonatomic) AMapPOI *getdownPoi;
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
@property (strong, nonatomic) NSArray<TYWJBanerModel *> *banersModels;
@property (assign, nonatomic) BOOL newMessage;
@end

@implementation TYWJCommuteController
#pragma mark - setup view
- (void)viewDidLoad {
    [super viewDidLoad];
    [[TYWJRongCloudTool sharedTool] connectWithToken];
    self.routeList = [NSMutableArray array];
    self.messageArr = [NSMutableArray array];
    TYWJSingleLocation *loc = [TYWJSingleLocation stantardLocation];
    [loc startBasicLocation];
    loc.locationDataDidChange = ^(AMapLocationReGeocode *reGeocode,CLLocation *location) {
        if (reGeocode) {
            //            for (TYWJUsableCity *city in self.cityList) {
            //                if (city.city_name == reGeocode.city) {
            //                    [TYWJCommonTool sharedTool].selectedCity = city;
            //                    [[TYWJCommonTool sharedTool] saveSelectedCityInfo];
            //                    //发送通知
            //                    [ZLNotiCenter postNotificationName:TYWJSelectedCityChangedNoti object:city.city_name];
            //                }
            //            }
        }
    };
    [self addNotis];
    [self loadData];
    //    [TYWJCommonTool show3DTouchActionShow:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupView];
    [self loadMessage];
    self.navigationController.navigationBarHidden = YES;
}
- (void)refreshHeaderView{
    float marqueeViewHeight = 0;
    float bannerHight = (ZLScreenWidth - 40)/343*112;
    if (_newMessage) {
        [_navHeaderView.rightV setImage:[UIImage imageNamed:@"首页_导航栏_消息带红点"] forState:UIControlStateNormal];
        marqueeViewHeight = 40;
        NSString *content = @"";
        WeakSelf;
        TYWJMessageModel *model = self.messageArr.firstObject;
        content = [NSString stringWithFormat:@"%@",model.content];

//        for (TYWJMessageModel *model in weakSelf.messageArr) {
//                  if (model.read == 0 && [TYWJCommonTool isBlankString:content]) {
//                      content = [NSString stringWithFormat:@"%@",model.content];
//                      break;
//                  }
//              }
        _marqueeView.marqueeTextArray = @[content];
        [_navHeaderView.messageVIew addSubview:_marqueeView];
    } else {
        [_navHeaderView.rightV setImage:[UIImage imageNamed:@"首页_导航栏_消息"] forState:UIControlStateNormal];
        marqueeViewHeight = 0;
        _marqueeView.marqueeTextArray = @[@""];
    }
    _navHeaderView.zl_height = kNavBarH + bannerHight + 100 + marqueeViewHeight;
    [_navHeaderView showMessage:_newMessage];
    _tableView.zl_y = _navHeaderView.zl_y + _navHeaderView.zl_height + 10;
    _tableView.zl_height = ZLScreenHeight - _tableView.zl_y;
}
- (void)setupView {
    float bannerHight = (ZLScreenWidth - 40)/343*112;
    _navHeaderView = [[TYWJHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth, kNavBarH + bannerHight + 100)];
    _navHeaderView.bannerViewHeight.constant = bannerHight;
    _marqueeView = [[CQMarqueeView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth , _navHeaderView.messageVIew.zl_height)];
    [_navHeaderView.messageVIew addSubview:_marqueeView];
    _marqueeView.marqueeTextArray = @[@""];
    _marqueeView.delegate = self;
    [_navHeaderView showMessage:_newMessage];
    [_navHeaderView.leftBtn setTitle:[TYWJCommonTool sharedTool].selectedCity.city_name forState:UIControlStateNormal];
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
                TYWJMessageViewController *vc = [[TYWJMessageViewController alloc] init];
                vc.dataArr = weakSelf.messageArr;
                [TYWJCommonTool pushToVc:vc];
            }
                break;
            default:
                break;
        }
    };
    [self.view addSubview:_navHeaderView];
    [_navHeaderView.bannerView addSubview:self.cycleScrollView];
    _stationHeaderView = [[TYWJCommuteHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.navHeaderView.stationView.zl_width, self.navHeaderView.stationView.zl_height)];
    _stationHeaderView.backgroundColor = ZLGlobalBgColor;
    _stationHeaderView.getupBtnClicked = ^{
        [weakSelf pushToChooseVcWithIsGetupStation:YES];
    };
    _stationHeaderView.getdownBtnClicked = ^{
        [weakSelf pushToChooseVcWithIsGetupStation:NO];
    };
    _stationHeaderView.searchBtnClicked = ^{
        if (!(self->_stationHeaderView.getGetupText.length > 0)) {
            weakSelf.getupPoi = nil;
        }
        if (!(self->_stationHeaderView.getGetdownText.length > 0)) {
            weakSelf.getdownPoi = nil;
        }
        [weakSelf doSearch];
    };
    _stationHeaderView.switchBtnClicked = ^{
        //交换按钮点击
        AMapPOI *tmpPoi = [weakSelf.getupPoi copy];
        weakSelf.getupPoi = [weakSelf.getdownPoi copy];
        weakSelf.getdownPoi = [tmpPoi copy];
    };
    [self.navHeaderView.stationView addSubview:_stationHeaderView];
}
// 跑马灯view上的按钮点击时回调
- (void)marqueeView:(CQMarqueeView *)marqueeView closeButtonDidClick:(UIButton *)sender {
    NSLog(@"点击了跑马灯");
    
    
    TYWJMessageDetailTableViewController *vc = [TYWJMessageDetailTableViewController new];
    TYWJMessageModel *model = self.messageArr.firstObject;
//    for (TYWJMessageModel *model in self.messageArr) {
              if (model.read == 0 ) {
                     vc.dataArr = @[model];
                  [TYWJCommonTool pushToVc:vc];
              }
//          }

    
    
    
//    _newMessage = NO;
//    [self refreshHeaderView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [MBProgressHUD zl_hideHUD];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self wr_setNavBarBackgroundAlpha:1.f];
    
    
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
        [self.routeList removeAllObjects];
        [_navHeaderView.leftBtn setTitle:[TYWJCommonTool sharedTool].selectedCity.city_name forState:UIControlStateNormal];
        [self.navigationItem.leftBarButtonItem setTitle:[TYWJCommonTool sharedTool].selectedCity.city_name];
        for (UIView *view in self.view.subviews) {
            [view removeFromSuperview];
        }
        [self loadData];
    }
}


#pragma mark - 加载数据

- (void)loadData {
    [self loadMessage];
    //    [self loadCityData];
    [self loadRouteListData];
    if (!(self.banersModels.count > 0)) {
        [self loadBanerImages];
    }
}
- (void)loadMessage{
    WeakSelf;
    NSDictionary *param = @{
        @"page_size":@"20",
        @"page_type":@"1",
        @"uid":[ZLUserDefaults objectForKey:TYWJLoginUidString],
    };
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.91:9005/loc/remind/list" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *data = [dic objectForKey:@"data"];
        if (data.count > 0) {
                    weakSelf.messageArr = [TYWJMessageModel mj_objectArrayWithKeyValuesArray:data];
                    TYWJMessageModel *model = self.messageArr.firstObject;

            //        for (TYWJMessageModel *model in weakSelf.messageArr) {
                        if (model.read == 0) {
                            self->_newMessage = YES;
                            [weakSelf refreshHeaderView];
                        }
            //        }
        }
    } WithFailurBlock:^(NSError *error) {
        
    }];
}
- (void)loadCityData{
    WeakSelf;
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.91:9005/ticket/position/city" WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *data = [dic objectForKey:@"data"];
        weakSelf.cityList = [TYWJUsableCity mj_objectArrayWithKeyValuesArray:data];
    } WithFailurBlock:^(NSError *error) {
        
    }];
    
}
- (void)loadBanerImages{
    //TODO: 请求图片数据
    WeakSelf;
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.91:9005/banner/list" WithParams:@{@"banner_type":@(2)} WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *data = [dic objectForKey:@"data"];
        weakSelf.banersModels = [TYWJBanerModel mj_objectArrayWithKeyValuesArray:data];
        self.cycleScrollView.imageURLStringsGroup = [self getImagesFromBanerModels:self.banersModels];
    } WithFailurBlock:^(NSError *error) {
        
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
    NSString *codes = [ZLUserDefaults objectForKey:TYWJSelectedCityString];
    
    NSString *code = [ZLUserDefaults objectForKey:TYWJSelectedCityIDString];
    NSDictionary *dic = @{
        @"s_lng":@"104.07",
        @"s_lat":@"30.67",
        @"e_lng":@"",
        @"e_lat":@"",
        @"offset":@0,
        @"limit":@10,
        @"city_code":@(code.intValue),
        @"type":@1,
    };
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (self.getupPoi && self.getupPoi.location && self.getupPoi.location.longitude > 0&& self.getupPoi.location.latitude > 0) {
        [param setValue:@(self.getupPoi.location.longitude) forKey:@"s_lng"];
        [param setValue:@(self.getupPoi.location.latitude) forKey:@"s_lat"];
        [param setValue:@(2) forKey:@"type"];
        
    }
    if (self.getdownPoi && self.getdownPoi.location && self.getdownPoi.location.longitude > 0&& self.getdownPoi.location.latitude > 0) {
        [param setValue:@(self.getdownPoi.location.longitude) forKey:@"s_lng"];
        [param setValue:@(self.getdownPoi.location.latitude) forKey:@"s_lat"];
    }
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.91:9003/trip/search" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        [self.tableView.mj_header endRefreshing];
        [weakSelf.routeList removeAllObjects];
        
        NSArray *data = [dic objectForKey:@"data"];
        if (data.count) {
            [weakSelf.routeList addObjectsFromArray:data];
            [weakSelf.view addSubview:weakSelf.tableView];
            
            [weakSelf.tableView reloadData];
        }else {
            [MBProgressHUD zl_showError:@"暂没找到线路"];
            [weakSelf.tableView reloadData];
            
            //            [weakSelf showRequestFailedViewWithImg:nil tips:@"没找到线路？申请线路可能会开通哦！" btnTitle:nil btnClicked:^{
            ////                [self applykBtnClick];
            //            }];
        }
    } WithFailurBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [weakSelf showRequestFailedViewWithImg:@"icon_no_network" tips:TYWJWarningBadNetwork btnTitle:nil btnClicked:^{
            [self loadData];
        }];
        
    }];
}
- (void)applykBtnClick
{
    TYWJApplyLineViewController *applyVC = [[TYWJApplyLineViewController alloc] init];
    [self.navigationController pushViewController:applyVC animated:YES];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.routeList.count;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //    return TYWJCommuteHeaderViewH + 86.f;
    return 0;
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
            buyTicketVc.line_name = routeListInfo.name;
            
            [weakSelf.navigationController pushViewController:buyTicketVc animated:YES];
            
        }];
        
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJDetailRouteController *detailRouteVc = [[TYWJDetailRouteController alloc] init];
    detailRouteVc.isDetailRoute = YES;
    detailRouteVc.routeListInfo = [TYWJRouteListInfo mj_objectWithKeyValues:self.routeList[indexPath.row]];
    [self.navigationController pushViewController:detailRouteVc animated:YES];
    
}



#pragma mark - 搜索站点
- (void)doSearch {
    [self loadRouteListData];
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
            [weakSelf.stationHeaderView setGetupText:poi.name];
        }else {
            weakSelf.getdownPoi = poi;
            [weakSelf.stationHeaderView setGetdownText:poi.name];
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
    [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success) {
        
    }];
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
        _cycleScrollView.layer.cornerRadius = 5;
        _cycleScrollView.layer.masksToBounds = YES;
    }
    return _cycleScrollView;
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navHeaderView.zl_height + self.navHeaderView.zl_y + 10, self.view.bounds.size.width, ZLScreenHeight - _navHeaderView.zl_y - _navHeaderView.zl_height - 10) style:UITableViewStylePlain];
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
