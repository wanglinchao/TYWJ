//
//  TYWJApplyDetailRouteController.m
//  TYWJBus
//
//  Created by tywj on 2020/3/13.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJApplyDetailRouteController.h"
#import "TYWJBuyTicketController.h"
#import "TYWJComplaintController.h"

#import "TYWJApplyDetailRouteView.h"
#import "TYWJStartToDestinationView.h"
#import "TYWJApplyBottomPurchaseView.h"
#import "TYWJDetailStationCell.h"
#import "CustomAnnotationView.h"
#import "ZLPopoverView.h"
#import "TYWJMyTicketTableCell.h"


#import "TYWJSoapTool.h"
#import "TYWJRouteList.h"
#import "TYWJSubRouteList.h"
#import "TYWJTicketList.h"
#import "TYWJApplyRoute.h"
#import "TYWJCarLocation.h"
#import "TYWJDriverRouteList.h"
#import "TYWJMonthTicket.h"

#import "MANaviRoute.h"
#import "CommonUtility.h"
#import <MJExtension.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
#import "TYWJLoginTool.h"
#import "TYWJSubLine.h"

#import "TYWJUnmatchView.h"
#import "TYWJApplyList.h"


static CGFloat const kBottomViewH = 44.f;
static CGFloat const kTimeInterval = 0.25f;
static CGFloat const kRouteViewH = 135.f;
static CGFloat const kTableViewRowH = 32.5f;
static CGFloat const kRowH = 50.f;


static NSString  * const RoutePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
static NSString * const MAAnimationAnnotationViewID = @"MAAnimationAnnotationViewID";
static const NSInteger RoutePlanningPaddingEdge                    = 20;

@interface TYWJApplyDetailRouteController()<MAMapViewDelegate,UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>

/* mapView */
@property (strong, nonatomic) MAMapView *mapView;
/* routeView */
@property (strong, nonatomic) TYWJApplyDetailRouteView *routeView;
/* bottomView */
@property (strong, nonatomic) TYWJApplyBottomPurchaseView *bottomView;
/* s2dView */
@property (strong, nonatomic) TYWJStartToDestinationView *s2dView;
/* routeTableView */
@property (strong, nonatomic) UITableView *routeTableView;
/* routeLists */
@property (strong, nonatomic) NSArray *routeLists;
/* bubbleLists */
@property (strong, nonatomic) NSArray *bubbleLists;
/* arrowBtn */
@property (strong, nonatomic) UIButton *arrowBtn;
/* trafficBtn */
@property (strong, nonatomic) UIButton *trafficBtn;
/* 显示当前位置按钮 */
@property (strong, nonatomic) UIButton *currentLocationBtn;
/* 是否是展开的view */
@property (assign, nonatomic) BOOL isExpansionView;
/* 展开view之后要加的高度 */
@property (assign, nonatomic) CGFloat expansionViewDeltaH;
/* 起始点info */
@property (strong, nonatomic) TYWJSubRouteListInfo *startStationInfo;
/* 结束点info */
@property (strong, nonatomic) TYWJSubRouteListInfo *endStationInfo;
/* mapSearch */
@property (strong, nonatomic) AMapSearchAPI *mapSearch;
/* 用于显示当前路线方案. */
@property (nonatomic,strong) MANaviRoute *naviRoute;
@property (nonatomic, strong) AMapRoute *route;

/* timer */
@property (strong, nonatomic) NSTimer *timer;
/* carLocation */
@property (strong, nonatomic) TYWJCarLocation *carLocation;
/* MAAnimatedAnnotation */
@property (strong, nonatomic) MAAnimatedAnnotation *carAnnotation;
///记录的上次经纬度
@property (nonatomic, assign) CLLocationCoordinate2D lastCoordinate;
//当前位置
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

/* oldInfo */
@property (copy, nonatomic) TYWJRouteListInfo *oldInfo;
/* oldLists */
//@property (strong, nonatomic) NSArray *oldLists;
/* oldRouteAnno */
@property (strong, nonatomic) NSMutableArray *oldRouteAnno;

@property (strong, nonatomic) TYWJUnmatchView *unmatchView;

/* ppid */
@property (copy, nonatomic) NSString *postId;
@end

@implementation TYWJApplyDetailRouteController

#pragma mark - lazy loading
- (TYWJUnmatchView *)unmatchView
{
    if (!_unmatchView) {
        _unmatchView = [TYWJUnmatchView unmatchView];
        _unmatchView.frame = CGRectMake(0, kNavBarH, ZLScreenWidth, self.view.zl_height - kNavBarH);
    }
    return _unmatchView;
}

- (AMapSearchAPI *)mapSearch {
    if (!_mapSearch) {
        _mapSearch = [[AMapSearchAPI alloc] init];
        _mapSearch.delegate = self;
    }
    return _mapSearch;
}
- (MAMapView *)mapView {
    if (!_mapView) {
        ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
        CGFloat tabbarH = kTabBarH;
        CGFloat bottomViewH = kBottomViewH;
        [AMapServices sharedServices].enableHTTPS = YES;
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, kNavBarH, ZLScreenWidth, self.view.zl_height - tabbarH - bottomViewH - kNavBarH)];
        
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        _mapView.showsUserLocation = YES;
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        
        [_mapView setZoomLevel:15 animated:YES];
        _mapView.showsCompass = NO;
        _mapView.rotateEnabled = NO;
        //关闭3D旋转
        _mapView.rotateCameraEnabled = NO;
        _mapView.delegate = self;
        [_mapView setMaxZoomLevel:19];
    }
    return _mapView;
}

- (TYWJApplyDetailRouteView *)routeView {
    if (!_routeView) {
        _routeView = [TYWJApplyDetailRouteView detailRouteViewWithFrame:CGRectMake(15.f, 10.f + kNavBarH, self.view.zl_width - 30.f, kRouteViewH)];
        
        NSString *startStop = nil;
        NSString *stopStop = nil;
        if (self.isDetailRoute) {
            startStop = self.routeListInfo.startingStop;
            stopStop = self.routeListInfo.stopStop;
        }
        [_routeView setMonthIconImg:@"icon_search_place" s2sStr:[NSString stringWithFormat:@"%@——%@",startStop,stopStop] isShowTips:YES type:self.routeListInfo.type startTime:self.routeListInfo.startingTime kind:self.kind status:self.status];
        WeakSelf;
        _routeView.cBtnClicked = ^(BOOL hasChanged) {
            if (hasChanged) {
                weakSelf.postId = weakSelf.xbid;
            }else {
//                weakSelf.routeListInfo = weakSelf.oldInfo;
//                weakSelf.s2dView.listInfo = weakSelf.routeListInfo;
//                [weakSelf.s2dView reloadData];
//                [weakSelf.bottomView setPrice:weakSelf.routeListInfo.price];
//
//                weakSelf.routeLists = weakSelf.oldLists;
//
//                weakSelf.expansionViewDeltaH = kTableViewRowH*(self.routeLists.count - 2);
//                if (weakSelf.expansionViewDeltaH > 200.f) {
//                    weakSelf.expansionViewDeltaH = 200.f;
//                }
//                [weakSelf.routeTableView reloadData];
//                [weakSelf configureCustomRoute];
//                [weakSelf configureRoute];
//                [weakSelf.routeView setMonthIconImg:@"icon_search_place" s2sStr:[NSString stringWithFormat:@"%@——%@",weakSelf.routeListInfo.startingStop,weakSelf.routeListInfo.stopStop] isShowTips:YES type:weakSelf.routeListInfo.type startTime:weakSelf.routeListInfo.startingTime kind:weakSelf.kind status:weakSelf.status];
                
                weakSelf.postId = weakSelf.sbid;
            }
            [weakSelf loadDownData];
        };
    }
    return _routeView;
}

- (TYWJApplyBottomPurchaseView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[TYWJApplyBottomPurchaseView alloc] initWithFrame:CGRectMake(0, self.view.zl_height - kTabBarH - kBottomViewH, ZLScreenWidth, kTabBarH + kBottomViewH)];
        [_bottomView addPurchaceTarget:self action:@selector(purchaseClicked)];
        [_bottomView addInterestTarget:self action:@selector(interestClicked)];
        [_bottomView setPrice: self.routeListInfo.price];
    }
    return _bottomView;
}

- (void)interestClicked
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定对该匹配线路不感兴趣吗?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
        NSString * soapBodyStr = [NSString stringWithFormat:
                                  @"<%@ xmlns=\"%@\">\
                                  <yhm>%@</yhm>\
                                  <uid>%@</uid>\
                                  </%@>",TYWJRequestRefuse,TYWJRequestService,[TYWJLoginTool sharedInstance].phoneNum,self.postId,TYWJRequestRefuse];
        ZLLog(@"self.postId----%@",self.postId);
        [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:soapBodyStr success:^(id responseObject) {
            [MBProgressHUD zl_hideHUDForView:self.view];
            if (responseObject) {
                ZLFuncLog;
                id result = responseObject[0][@"NS1:updatexianlupipeiResponse"];
                if ([result isEqualToString:@"ok"]) {
//                    [self.navigationController popViewControllerAnimated:YES];
                    
                    if ([self.kind isEqualToString:@"往返线路"]) {
                        if ([self.status isEqualToString:@"已匹配"]) {
                            self.status = @"待处理";
                            if (self.postId == self.sbid) {
                                self.routeView.cBtnClicked(YES);
                            }else {
                                self.routeView.cBtnClicked(NO);
                            }
                        }else {//待处理
                            self.status = @"已拒绝";
                            [self.view addSubview:self.unmatchView];
                            self.applyListInfo.status = @"已拒绝";
                            self.unmatchView.applyListInfo = self.applyListInfo;
                        }
                    }else {
                        self.status = @"已拒绝";
                        [self.view addSubview:self.unmatchView];
                        self.applyListInfo.status = @"已拒绝";
                        self.unmatchView.applyListInfo = self.applyListInfo;
                    }
                }
            }
        } failure:^(NSError *error) {
            [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:self.view];
        }];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (TYWJStartToDestinationView *)s2dView {
    if (!_s2dView) {
        _s2dView = [[TYWJStartToDestinationView alloc] initWithFrame:CGRectMake(0, 0, self.routeView.stopsView.zl_width, self.routeView.stopsView.zl_height - 10.f)];
        _s2dView.listInfo = self.routeListInfo;
        _s2dView.backgroundColor = [UIColor clearColor];
        [_s2dView addTarget:self action:@selector(s2dClicked)];
    }
    return _s2dView;
}

- (UITableView *)routeTableView {
    if (!_routeTableView) {
        _routeTableView = [[UITableView alloc] initWithFrame:self.s2dView.frame style:UITableViewStylePlain];
        _routeTableView.delegate = self;
        _routeTableView.dataSource = self;
        _routeTableView.backgroundColor = [UIColor clearColor];
        _routeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _routeTableView.alpha = 0;
        _routeTableView.rowHeight = _routeTableView.zl_height/2.f;
        [_routeTableView registerClass:[TYWJDetailStationCell class] forCellReuseIdentifier:TYWJDetailStationCellID];
    }
    return _routeTableView;
}

- (UIButton *)arrowBtn {
    if (!_arrowBtn) {
        _arrowBtn = [[UIButton alloc] init];
        [_arrowBtn setImage:[UIImage imageNamed:@"icon_down_11x5_"] forState:UIControlStateNormal];
        [_arrowBtn setImage:[UIImage imageNamed:@"icon_up_11x5_"] forState:UIControlStateSelected];
        _arrowBtn.zl_size = CGSizeMake(11.f, 5.f);
        _arrowBtn.zl_centerX = self.routeView.stopsView.zl_width/2.f;
        _arrowBtn.zl_y = CGRectGetMaxY(self.s2dView.frame) + 2.f;
        [_arrowBtn addTarget:self action:@selector(arrowBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _arrowBtn;
}
- (UIButton *)trafficBtn {
    if (!_trafficBtn) {
        _trafficBtn = [[UIButton alloc] init];
        _trafficBtn.frame = CGRectMake(20.f, self.view.zl_height - self.bottomView.zl_height - 20.f - 30.f, 30.f, 30.f);
        [_trafficBtn setImage:[UIImage imageNamed:@"icon_traffic_30x30_"] forState:UIControlStateNormal];
        [_trafficBtn setImage:[UIImage imageNamed:@"icon_traffic_pre_30x30_"] forState:UIControlStateSelected];
        [_trafficBtn addTarget:self action:@selector(trafficClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _trafficBtn;
}

- (UIButton *)currentLocationBtn {
    if (!_currentLocationBtn) {
        _currentLocationBtn = [[UIButton alloc] init];
        _currentLocationBtn.frame = CGRectMake(20.f, CGRectGetMinY(self.trafficBtn.frame) - 10.f - 30.f, 30.f, 30.f);
        _currentLocationBtn.backgroundColor = [UIColor whiteColor];
        [_currentLocationBtn setRoundViewWithCornerRaidus:6.f];
        [_currentLocationBtn setImage:[UIImage imageNamed:@"icon_map_location"] forState:UIControlStateNormal];
        [_currentLocationBtn addTarget:self action:@selector(currentLocationClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _currentLocationBtn;
}

#pragma mark - set up view
- (void)dealloc {
    ZLFuncLog;
    [self invalidateTimer];
    [self clearMemory];
}
- (void)clearMemory {
    
    self.mapView = nil;
    self.carLocation = nil;
    self.carAnnotation = nil;
    self.route = nil;
    self.naviRoute = nil;
    self.mapSearch = nil;
    self.startStationInfo = nil;
    self.endStationInfo = nil;
    self.routeLists = nil;
    self.bubbleLists = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
//    [self loadData];
    
    self.oldInfo = self.routeListInfo;
    
    if ([self.kind isEqualToString:@"往返线路"]) {
        if ([self.status isEqualToString:@"已匹配"]) {
            self.postId = self.sbid;
            [self loadUpData];
        }else {//待处理
            if ([self.sbState isEqualToString:@"已拒绝"]) {//已拒绝上班线路
                self.postId = self.xbid;
                [self loadDownData];
            }else {
                self.postId = self.sbid;
                [self loadUpData];
            }
        }
    }else if ([self.kind isEqualToString:@"上班线路"]) {
        self.postId = self.ppid;
        [self loadUpData];
    }else {
        self.postId = self.ppid;
//        [self loadDownData];
        [self loadUpData];
    }
    
//    [self loadUpData];
    
}

- (void)setupView {
    
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.routeView];
    
    [self.view addSubview:self.trafficBtn];
    [self.view addSubview:self.currentLocationBtn];
    
    [self.routeView.stopsView addSubview:self.s2dView];
    [self.routeView.stopsView addSubview:self.arrowBtn];
    
    [self.routeView.stopsView addSubview:self.routeTableView];
    
    if (self.isDetailRoute) {
        self.navigationItem.title = @"线路详情";
        [self.view addSubview:self.bottomView];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self invalidateTimer];
    [MBProgressHUD zl_hideHUD];
}

#pragma mark - 定时器相关

- (void)validateTimer {
    self.timer = [NSTimer timerWithTimeInterval:10.f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)invalidateTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)countDown {
    [self loadCarLocationData];
}
#pragma mark - button clicked

/**
 购买按钮点击
 */
- (void)purchaseClicked {
    ZLFuncLog;
    TYWJBuyTicketController *buyTicketVc = [[TYWJBuyTicketController alloc] init];
    buyTicketVc.routeListInfo = self.routeListInfo;
    buyTicketVc.routeLists = self.routeLists;
    [self.navigationController pushViewController:buyTicketVc animated:YES];
}

/**
 监听点击
 */
- (void)arrowBtnClicked:(UIButton *)btn {
    if (btn.selected) {
        //收缩
        [self shrinkView];
    }else {
        //放大
        [self expandView];
    }
}


- (void)s2dClicked {
    ZLFuncLog;
    [self expandView];
}

/**
 定位到当前位置点击
 */
- (void)currentLocationClicked {
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [_mapView setZoomLevel:15 animated:YES];
}
/**
 显示交通状况按钮点击
 */
- (void)trafficClicked:(UIButton *)btn {
    if (btn.selected) {
        self.mapView.showTraffic = NO;
    }else {
        self.mapView.showTraffic = YES;
    }
    btn.selected = !btn.selected;
}
#pragma mark - 展开/收缩 view

/**
 展开视图
 */
- (void)expandView {
    //展开的话，则直接返回
    if (self.isExpansionView) return;
    if (self.routeLists.count == 0) return;
    
    WeakSelf;
    [UIView animateWithDuration:kTimeInterval delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.s2dView.alpha = 0;
        weakSelf.routeTableView.alpha = 1;
        
        weakSelf.routeView.zl_height += weakSelf.expansionViewDeltaH;
        weakSelf.routeView.stopsView.zl_height += weakSelf.expansionViewDeltaH;
        weakSelf.routeTableView.zl_height += weakSelf.expansionViewDeltaH;
        weakSelf.arrowBtn.zl_y += weakSelf.expansionViewDeltaH;
    } completion:^(BOOL finished) {
        self.arrowBtn.selected = YES;
        self.isExpansionView = YES;
    }];
}

/**
 收缩视图
 */
- (void)shrinkView {
    //收缩的话，直接返回
    if (!self.isExpansionView) return;
    
    CGRect newF = self.routeView.frame;
    newF.size.height = kRouteViewH;
    
    WeakSelf;
    [UIView animateWithDuration:kTimeInterval delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.routeView.zl_height -= weakSelf.expansionViewDeltaH;
        weakSelf.routeView.stopsView.zl_height -= weakSelf.expansionViewDeltaH;
        weakSelf.routeTableView.zl_height -= weakSelf.expansionViewDeltaH;
        weakSelf.arrowBtn.zl_y -= weakSelf.expansionViewDeltaH;
        
        weakSelf.s2dView.alpha = 1;
        weakSelf.routeTableView.alpha = 0;
    } completion:^(BOOL finished) {
        weakSelf.arrowBtn.selected = NO;
        weakSelf.isExpansionView = NO;
    }];
}
#pragma mark - 加载数据

- (void)loadData {
    
    if ([self.kind isEqualToString:@"往返线路"]) {
        if ([self.status isEqualToString:@"已匹配"]) {
            [self loadUpData];
        }else {//待处理
            if ([self.sbState isEqualToString:@"已拒绝"]) {//已拒绝上班线路
                [self loadDownData];
            }else {
                [self loadUpData];
            }
        }
    }else if ([self.kind isEqualToString:@"上班线路"]) {
        [self loadUpData];
    }else {
        [self loadDownData];
    }
    
}

- (void)loadUpData
{
    WeakSelf;
    NSString *routeNum = nil;
    if (self.routeListInfo) {
        routeNum = self.routeListInfo.routeNum;
    }
    
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <xlbh>%@</xlbh>\
                              </%@>",TYWJRequesrSubRouteList,TYWJRequestService,routeNum,TYWJRequesrSubRouteList];
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:soapBodyStr success:^(id responseObject) {
        [MBProgressHUD zl_hideHUDForView:self.view];
        if (responseObject) {
            ZLFuncLog;
            
//            weakSelf.routeListInfo = weakSelf.oldInfo;
//            weakSelf.s2dView.listInfo = weakSelf.routeListInfo;
//            [weakSelf.s2dView reloadData];
            
            NSArray *dataArr = responseObject[0][@"NS1:xianlubiaozibiaoResponse"][@"xianlubiaozibiaoList"][@"xianlubiaozibiao"];
            if (dataArr) {
                weakSelf.routeLists = [TYWJSubRouteList mj_objectArrayWithKeyValuesArray:dataArr];
//                    weakSelf.oldLists = weakSelf.routeLists;
                weakSelf.expansionViewDeltaH = kTableViewRowH*(self.routeLists.count - 2);
                if (weakSelf.expansionViewDeltaH > 200.f) {
                    weakSelf.expansionViewDeltaH = 200.f;
                }
                [weakSelf.routeTableView reloadData];
                [weakSelf configureCustomRoute];
                [weakSelf configureRoute];
                
//                [weakSelf.routeView setMonthIconImg:@"icon_search_place" s2sStr:[NSString stringWithFormat:@"%@——%@",weakSelf.routeListInfo.startingStop,weakSelf.routeListInfo.stopStop] isShowTips:YES type:weakSelf.routeListInfo.type startTime:weakSelf.routeListInfo.startingTime kind:weakSelf.kind status:weakSelf.status];
            }else {
                [MBProgressHUD zl_showError:@"线路加载失败" toView:self.view];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:self.view];
    }];
}

- (void)loadDownData
{
    WeakSelf;
    NSString *routeNum = nil;
    if (weakSelf.routeListInfo) {
        routeNum = self.routeListInfo.routeNum;
    }
    
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:weakSelf.view];
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <xlbh>%@</xlbh>\
                              </%@>",TYWJRequesrFancheng,TYWJRequestService,routeNum,TYWJRequesrFancheng];
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:soapBodyStr success:^(id responseObject) {
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        if (responseObject) {
            ZLFuncLog;
            NSDictionary *xianlubiao = responseObject[0][@"NS1:fanchengluxianResponse"][@"xianlubiaozibiaoList"][@"xianlubiao"];
            if (xianlubiao) {
                TYWJSubLine *subLine = [TYWJSubLine mj_objectWithKeyValues:xianlubiao];
                weakSelf.routeListInfo.routeNum = subLine.lineInfo.routeNum;
                weakSelf.routeListInfo.routeName = subLine.lineInfo.routeName;
                weakSelf.routeListInfo.startingStop = subLine.lineInfo.startingStop;
                weakSelf.routeListInfo.stopStop = subLine.lineInfo.stopStop;
                weakSelf.routeListInfo.oriPrice = subLine.lineInfo.oriPrice;
                weakSelf.routeListInfo.startingTime = subLine.lineInfo.startingTime;
                weakSelf.routeListInfo.stopTime = subLine.lineInfo.stopTime;
                weakSelf.routeListInfo.price = subLine.lineInfo.price;
                weakSelf.routeListInfo.isFullPrice = subLine.lineInfo.isFullPrice;
                weakSelf.routeListInfo.carLicenseNum = subLine.lineInfo.carLicenseNum;
                weakSelf.routeListInfo.carStatus = subLine.lineInfo.carStatus;
                weakSelf.routeListInfo.cityID = subLine.lineInfo.cityID;
                weakSelf.routeListInfo.type = subLine.lineInfo.type;
                weakSelf.routeListInfo.startStopId = subLine.lineInfo.startStopId;
                weakSelf.routeListInfo.stopStopId = subLine.lineInfo.stopStopId;
                weakSelf.s2dView.listInfo = weakSelf.routeListInfo;
                [weakSelf.s2dView reloadData];
                [weakSelf.bottomView setPrice:weakSelf.routeListInfo.price];
            }
            NSArray *dataArr = responseObject[0][@"NS1:fanchengluxianResponse"][@"xianlubiaozibiaoList"][@"xianlubiaozibiao"];
            if (dataArr) {
                weakSelf.routeLists = [TYWJSubRouteList mj_objectArrayWithKeyValuesArray:dataArr];
                weakSelf.expansionViewDeltaH = kTableViewRowH*(self.routeLists.count - 2);
                if (weakSelf.expansionViewDeltaH > 200.f) {
                    weakSelf.expansionViewDeltaH = 200.f;
                }
                [weakSelf.routeTableView reloadData];
                [weakSelf configureCustomRoute];
                [weakSelf configureRoute];
                
                [weakSelf.routeView setMonthIconImg:@"icon_search_place" s2sStr:[NSString stringWithFormat:@"%@——%@",weakSelf.routeListInfo.startingStop,weakSelf.routeListInfo.stopStop] isShowTips:YES type:weakSelf.routeListInfo.type startTime:weakSelf.routeListInfo.startingTime kind:weakSelf.kind status:weakSelf.status];
            }else {
                [MBProgressHUD zl_showError:@"线路加载失败" toView:weakSelf.view];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:weakSelf.view];
    }];
}

- (void)loadCarLocationData {
    
    NSString *ID = nil;
    if (self.isDetailRoute) {
        ID = self.routeListInfo.routeNum;
    }
    WeakSelf;
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <xl>%@</xl>\
                              <chegnshi>%@</chegnshi>\
                              </%@>",TYWJRequestGetCarLocation,TYWJRequestService,ID,[TYWJCommonTool sharedTool].selectedCity.cityID,TYWJRequestGetCarLocation];
    
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:soapBodyStr success:^(id responseObject) {
        if (responseObject) {
            if (weakSelf.lastCoordinate.latitude == 0){
                weakSelf.carLocation = [TYWJCarLocation mj_objectWithKeyValues:responseObject[0][@"NS1:getweizhiResponse"][@"weizhiList"][@"weizhi"]];
                CLLocationCoordinate2D locations[1] = {CLLocationCoordinate2DMake(weakSelf.carLocation.info.latitude.doubleValue, weakSelf.carLocation.info.longitude.doubleValue)};
//                CLLocationCoordinate2D locations[1] = {CLLocationCoordinate2DMake(30.658952, 104.093445)};
                weakSelf.lastCoordinate = locations[0];
                [weakSelf.carAnnotation addMoveAnimationWithKeyCoordinates:locations count:sizeof(locations)/sizeof(locations[0]) withDuration:0.1f withName:nil completeCallback:^(BOOL isFinished) {

                }];
//                [weakSelf.mapView setCenterCoordinate:locations[0] animated:YES];
            }else {
                weakSelf.carLocation = [TYWJCarLocation mj_objectWithKeyValues:responseObject[0][@"NS1:getweizhiResponse"][@"weizhiList"][@"weizhi"]];
                CLLocationCoordinate2D locations[1] = {CLLocationCoordinate2DMake(weakSelf.carLocation.info.latitude.doubleValue, weakSelf.carLocation.info.longitude.doubleValue)};
//                            CLLocationCoordinate2D locations[1] = {CLLocationCoordinate2DMake(30.658952, 104.093445)};
//                [weakSelf.mapView setCenterCoordinate:locations[0] animated:YES];
                [weakSelf.carAnnotation addMoveAnimationWithKeyCoordinates:locations count:sizeof(locations)/sizeof(locations[0]) withDuration:6.f withName:nil completeCallback:^(BOOL isFinished) {
                    
                }];
            }
            
        }
    } failure:nil];
}

#pragma mark - 传入的参数

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.routeTableView) {
      return self.routeLists.count;
    }
    return self.bubbleLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TYWJDetailStationCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJDetailStationCellID forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.hasUpDash = NO;
        cell.hasDownDash = YES;
        cell.isRealHeart = YES;
        cell.isStartStation = YES;
    }else {
        cell.hasUpDash = YES;
        cell.hasDownDash = YES;
        cell.isRealHeart = NO;
        cell.isStartStation = NO;
    }
    if (indexPath.row == self.routeLists.count - 1) {
        cell.isRealHeart = YES;
        cell.isStartStation = NO;
        cell.hasDownDash = NO;
        cell.hasUpDash = YES;
    }
    [cell setNeedsDisplay];
    TYWJSubRouteList *list = self.routeLists[indexPath.row];
    cell.listInfo = list.routeListInfo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self shrinkView];
    
    TYWJSubRouteList *list = self.routeLists[indexPath.row];
    [self showSelectedRegionWithListInfo:list.routeListInfo];
    for (MAPointAnnotation *pointAnn in self.mapView.annotations) {
        if (list.routeListInfo.latitude.doubleValue == pointAnn.coordinate.latitude) {
            [self.mapView selectAnnotation:pointAnn animated:YES];
            [self.mapView setCenterCoordinate:pointAnn.coordinate animated:YES];
            break;
        }
    }
    if (self.s2dView.listInfo.startStopId.integerValue == list.routeListInfo.stationID.integerValue) return;
    
    //因为用的strong，所以可以直接修改自己的info属性二改变s2dView的info属性内容
    self.routeListInfo.stopStop = list.routeListInfo.station;
    self.routeListInfo.stopTime = list.routeListInfo.time;
    self.routeListInfo.stopStopId = list.routeListInfo.stationID;
    [self.s2dView reloadData];
}
#pragma mark - 地图相关
#pragma mark - AMapSearchDelegate
/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
    
    if (response.count > 0)
    {
        [self presentCurrentCourse];
    }
}

#pragma mark - MAMapViewDelegate

/**
 更新当前位置的方向
 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!updatingLocation && self.userLocationAnnotationView != nil) {
        [UIView animateWithDuration:0.1 animations:^{
            double degree = userLocation.heading.trueHeading - self.mapView.rotationDegree;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
        }];
    }
}
/**
 * @brief 单击地图回调，返回经纬度
 * @param mapView 地图View
 * @param coordinate 经纬度
 */
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    //点击点图
    //收缩view
    [self shrinkView];
}


#pragma mark -


- (void)showSelectedRegionWithListInfo:(TYWJSubRouteListInfo *)info {
    CGFloat longtitude = info.longitude.doubleValue;
    CGFloat latitude = info.latitude.doubleValue;
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(latitude, longtitude) animated:YES];
    [self.mapView setZoomLevel:15 animated:YES];
}

- (void)configureRoute {
    
    NSMutableArray *wayPoints = [NSMutableArray array];
    for (TYWJSubRouteList *list in self.routeLists) {
        if ([list isEqual:self.routeLists.firstObject] || [list isEqual:self.routeLists.lastObject]) {
            continue;
        }
        AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:list.routeListInfo.latitude.doubleValue
                                                       longitude:list.routeListInfo.longitude.doubleValue];
        [wayPoints addObject:point];
    }
    
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    navi.strategy = 5;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startStationInfo.latitude.doubleValue
                                           longitude:self.startStationInfo.longitude.doubleValue];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.endStationInfo.latitude.doubleValue
                                                longitude:self.endStationInfo.longitude.doubleValue];
    navi.waypoints = wayPoints;
    [self.naviRoute removeFromMapView];
    [self.mapSearch AMapDrivingRouteSearch:navi];
}

- (void)configureCustomRoute {
    
    NSInteger count = self.routeLists.count;
    CLLocationCoordinate2D commonPolylineCoords[count];
    for (NSInteger i = 0; i < count; i++) {
        TYWJSubRouteList *list = self.routeLists[i];
        commonPolylineCoords[i].latitude = list.routeListInfo.latitude.doubleValue;
        commonPolylineCoords[i].longitude = list.routeListInfo.longitude.doubleValue;
        if (0 == i) {
            self.startStationInfo = list.routeListInfo;
        }
        if (count - 1 == i) {
            self.endStationInfo = list.routeListInfo;
        }
    }
    //构造折线对象
    //参数一：多个点组成的类似数组的经纬度数据
    //参数二：构成折线总共涉及到几个点
    [self showRouteForCoords:commonPolylineCoords count:count];
    
    self.routeListInfo.startStopId = self.startStationInfo.stationID;
    self.routeListInfo.stopStopId = self.endStationInfo.stationID;
    
}

/**
 这个主要用于将自定义的点添加到路线上
 */
- (void)showRouteForCoords:(CLLocationCoordinate2D *)coords count:(NSUInteger)count
{
    NSMutableArray *routeAnno = [NSMutableArray array];
#ifdef DEBUG
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH.mm";
    NSTimeInterval nowTime = [[formatter dateFromString: [formatter stringFromDate: [NSDate date]]] timeIntervalSince1970];
    NSTimeInterval startingTime = [[formatter dateFromString:self.routeListInfo.startingTime] timeIntervalSince1970];
    NSTimeInterval stopTime = [[formatter dateFromString:self.routeListInfo.stopTime] timeIntervalSince1970];
    if ((nowTime >= startingTime && nowTime <= stopTime) || [self.routeListInfo.carStatus isEqualToString: @"已发车"]) {
        self.carAnnotation = [[MAAnimatedAnnotation alloc] init];
        self.carAnnotation.coordinate = coords[0];
        [routeAnno addObject:self.carAnnotation];
        [self validateTimer];
    }
#else
    if (self.isDetailRoute == NO) {
        self.carAnnotation = [[MAAnimatedAnnotation alloc] init];
        self.carAnnotation.coordinate = coords[0];
        [routeAnno addObject:self.carAnnotation];
        [self validateTimer];
    }
#endif


    for (int i = 0 ; i < count; i++)
    {
        MAPointAnnotation *a = [[MAPointAnnotation alloc] init];
        a.coordinate = coords[i];
        a.title = @"route";
        [routeAnno addObject:a];
    }
    if (self.oldRouteAnno) {
        [self.mapView removeAnnotations:self.oldRouteAnno];
//        [self.mapView deselectAnnotation:self.oldRouteAnno animated:NO];
    }
    [self.mapView addAnnotations:routeAnno];
    [self.mapView showAnnotations:routeAnno animated:YES];
    self.oldRouteAnno = routeAnno;
}


//根据导航类型绘制覆盖物
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        if (![self isGivenStationWithAnnotation:annotation]) {
            return nil;
        }
        
        if ([annotation isKindOfClass:[MAAnimatedAnnotation class]]) {
            MAAnnotationView *view = (MAAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:MAAnimationAnnotationViewID];
            if (!view) {
                view = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MAAnimationAnnotationViewID];
            }
            view.image = [UIImage imageNamed:@"icon_car_feiniu_180c_13x23_"];
            //设置当前位置annotation的image
            if ([annotation isKindOfClass: [MAUserLocation class]]) {
                view.image = [UIImage imageNamed:@"userPosition"];
                self.userLocationAnnotationView = view;
            }
            return view;
        }
        CustomAnnotationView *poiAnnotationView = (CustomAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:RoutePlanningCellIdentifier];
        if (!poiAnnotationView)
        {
            poiAnnotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:RoutePlanningCellIdentifier];
        }
        poiAnnotationView.canShowCallout = NO;
        poiAnnotationView.image = [UIImage imageNamed:@"icon_get_on2_18x18_"];
        if (self.startStationInfo.latitude.doubleValue == annotation.coordinate.latitude) {
            //起始点
            poiAnnotationView.image = [UIImage imageNamed:@"icon_ride-start_16x16_"];
        }
        if (self.endStationInfo.latitude.doubleValue == annotation.coordinate.latitude) {
            //结束点
            poiAnnotationView.image = [UIImage imageNamed:@"icon_ride-end_16x16_"];
        }
        if ([annotation isKindOfClass:[MAUserLocation class]]) {
            poiAnnotationView.image = [UIImage imageNamed:@"icon_get_on_pre_18x18_"];
        }
        
        if ([self getStataionInfoWithAnnonation:annotation]) {
            poiAnnotationView.routeListInfo = [self getStataionInfoWithAnnonation:annotation];
        }
        return poiAnnotationView;
    }
    return nil;
}

-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    //旧版的返回值是MAOverLayView，新版的是MAOverlayRenderer
    //画折线
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineRenderer * polyLine = [[MAPolylineRenderer alloc] initWithPolyline:(MAPolyline *)overlay];
        polyLine.strokeImage = [UIImage imageNamed:@"route_32x32_"];
        //设置属性
        //设置线宽
        polyLine.lineWidth = 18.f;
        return polyLine;
    }
    return nil;
}

/**
 判断是否在给定站内
 */
- (BOOL)isGivenStationWithAnnotation:(id<MAAnnotation>)annonation {
    if ([annonation isKindOfClass: [MAAnimatedAnnotation class]]) {
        return YES;
    }
    for (TYWJSubRouteList *list in self.routeLists) {
        if (annonation.coordinate.latitude == list.routeListInfo.latitude.doubleValue) {
            return YES;
        }
        if ([annonation isKindOfClass:[MAUserLocation class]]) {
            return YES;
        }
    }
    return NO;
}

- (TYWJSubRouteListInfo *)getStataionInfoWithAnnonation:(id<MAAnnotation>)annonation {
    for (TYWJSubRouteList *list in self.routeLists) {
        if (list.routeListInfo.latitude.doubleValue == annonation.coordinate.latitude) {
            return list.routeListInfo;
        }
    }
    return nil;
}
/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[0] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startStationInfo.latitude.doubleValue longitude:self.startStationInfo.longitude.doubleValue] endPoint:[AMapGeoPoint locationWithLatitude:self.endStationInfo.latitude.doubleValue longitude:self.endStationInfo.longitude.doubleValue]];
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];
}



/* 清空地图上已有的路线. */
- (void)clear
{
    [self.naviRoute removeFromMapView];
}

@end
