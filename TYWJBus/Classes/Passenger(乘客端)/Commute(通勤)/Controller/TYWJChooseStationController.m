//
//  TYWJChooseStationController.m
//  TYWJBus
//
//  Created by Harllan He on 2018/5/29.
//  Copyright © 2018 Harllan He. All rights reserved.
//

#import "TYWJChooseStationController.h"
#import "YDYBHotSaleLayout.h"
#import "YDYBSearchCollectionCell.h"
#import "TYWJSearchModel.h"
#import "TYWJUsableCitiesController.h"
#import "TYWJSearchPOICell.h"

#import "TYWJSingleLocation.h"
#import "TYWJCommonTool.h"
#import "ZLPopoverView.h"

#import <MAMapKit/MAMapKit.h>
#import <MJExtension.h>


@interface TYWJChooseStationController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,AMapSearchDelegate,MAMapViewDelegate>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* cityBtn */
@property (strong, nonatomic) UIButton *cityBtn;
/* tf */
@property (strong, nonatomic) UITextField *tf;
/* contentView */
@property (strong, nonatomic) UIView *contentView;
/* collectionView */
@property (strong, nonatomic) UICollectionView *collectionView;

/* dataList */
@property (strong, nonatomic) NSArray *dataList;

/* selectedStation */
@property (copy, nonatomic) NSString *selectedStation;
/* selectedPoi */
@property (strong, nonatomic) AMapPOI *selectedPoi;
/* amapSearch */
@property (strong, nonatomic) AMapSearchAPI *search;
/* AMapPOI信息数组 */
@property (strong, nonatomic) NSArray *mapPOIArr;
/* mapView */
@property (strong, nonatomic) MAMapView *mapView;
//当前位置
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

@end

@implementation TYWJChooseStationController

#pragma mark - tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = ZLGlobalBgColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.frame = self.contentView.bounds;
        _tableView.rowHeight = 60.f;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJSearchPOICell class]) bundle:nil] forCellReuseIdentifier:TYWJSearchPOICellID];
    }
    return _tableView;
}
- (MAMapView *)mapView {
    if (!_mapView) {
        ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
        [AMapServices sharedServices].enableHTTPS = YES;
        _mapView = [[MAMapView alloc] initWithFrame:self.contentView.bounds];
        
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
#pragma mark - set up view
- (void)dealloc {
    ZLFuncLog;
    [self removeNotis];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    [self setupView];
    [self loadPlist];
    [self setupSearch];
    [self addNotis];
    [self startLocation];
}

- (void)setupView {
    self.view.backgroundColor = ZLGlobalBgColor;
    if (self.isGetupStation) {
        self.navigationItem.title = @"选择234567上车地点";
    }else {
        self.navigationItem.title = @"选择下车地点";
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishClicked)];
    
    
    //搜索view
    UIView *searchView = [[UIView alloc] init];
    searchView.frame = CGRectMake(0, 10.f + kNavBarH, self.view.zl_width, 44.f);
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];
    
    CGFloat cityBtnW = 50.f;
    //城市按钮
    UIButton *cityBtn = [[UIButton alloc] init];
    cityBtn.frame = CGRectMake(20.f, 0, cityBtnW, searchView.zl_height);
    [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [cityBtn setTitle:[TYWJCommonTool sharedTool].selectedCity.city forState:UIControlStateNormal];
    [cityBtn setTitle:[TYWJCommonTool sharedTool].selectedCity.city forState:UIControlStateNormal];
    self.cityBtn = cityBtn;
    [cityBtn addTarget:self action:@selector(cityClicked:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:cityBtn];
    
    //箭头
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"icon_more2_7x11_"]];
    arrowImageView.zl_size = CGSizeMake(7.f, 11.f);
    arrowImageView.zl_x = CGRectGetMaxX(cityBtn.frame) + 6.f;
    arrowImageView.zl_centerY = cityBtn.zl_centerY;
    [searchView addSubview:arrowImageView];
    
    //分割线
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = ZLGlobalTextColor;
    separator.zl_width = 1.f;
    separator.zl_height = 13.f;
    separator.zl_x = CGRectGetMaxX(arrowImageView.frame) + 10.f;
    separator.zl_centerY = cityBtn.zl_centerY;
    [searchView addSubview:separator];
    
    CGFloat tfX = CGRectGetMaxX(separator.frame) + 6.f;
    UITextField *tf = [[UITextField alloc] init];
    tf.placeholder = @"请输入地点";
    tf.font = [UIFont systemFontOfSize:14.f];
    tf.tintColor = ZLNavTextColor;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.delegate = self;
    tf.frame = CGRectMake(tfX, 0, searchView.zl_width - tfX, searchView.zl_height);
    tf.borderStyle = UITextBorderStyleNone;
    [tf becomeFirstResponder];
    self.tf = tf;
    [searchView addSubview:tf];
    
    //contentView
    CGFloat contentViewY = CGRectGetMaxY(searchView.frame) + 15.f;
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.frame = CGRectMake(0, contentViewY, self.view.zl_width, self.view.zl_height - contentViewY);
    self.contentView = contentView;
    [self.view addSubview:contentView];
    
    //历史记录
    UILabel *historyLabel = [[UILabel alloc] init];
    historyLabel.font = [UIFont systemFontOfSize:14.f];
    historyLabel.textColor = ZLGlobalTextColor;
    historyLabel.text = @"历史记录";
    historyLabel.frame = CGRectMake(20.f, 0, 100.f, 20.f);
    [self.view addSubview:historyLabel];
    [contentView addSubview:historyLabel];
    
    //清空历史记录按钮
    UIButton *clearHistoryBtn = [[UIButton alloc] init];
    clearHistoryBtn.frame = CGRectMake(contentView.zl_width - 80.f, 0, 60.f, 20.f);
    clearHistoryBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [clearHistoryBtn setTitle:@"清空记录" forState:UIControlStateNormal];
    [clearHistoryBtn setTitleColor:ZLGlobalTextColor forState:UIControlStateNormal];
    [clearHistoryBtn addTarget:self action:@selector(clearHistoryClicked) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:clearHistoryBtn];
    
    [self addCollectionView];
    
}

- (void)addCollectionView {
    CGFloat x = 20.f;
    CGFloat y = 26.f;
    
    YDYBHotSaleLayout *layout = [[YDYBHotSaleLayout alloc] init];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(x, y, ZLScreenWidth - 2*x, self.contentView.zl_height - y) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
    
    //注册cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YDYBSearchCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:YDYBSearchCollectionCellID];
}


- (void)setupSearch {
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
}

- (void)startLocation {
    if (self.defaultStation) {
        [self showSearchResultView];
        [self startSearchWithKeywords:self.defaultStation];
        self.tf.text = self.defaultStation;
        return;
    }
    if (!self.isDefaultSearch) {
        return;
    }
    WeakSelf;
    //开始定位当前位置,并将定位位置进行搜索，放入tableview
    TYWJSingleLocation *loc = [TYWJSingleLocation stantardLocation];
    [loc startBasicLocation];
    loc.locationDataDidChange = ^(AMapLocationReGeocode *reGeocode,CLLocation *location) {
        if (reGeocode) {
            [weakSelf showSearchResultView];
            weakSelf.defaultStation = reGeocode.POIName;
            [weakSelf startSearchWithKeywords:weakSelf.defaultStation];
            weakSelf.tf.text = weakSelf.defaultStation;
        }
    };
}

- (void)showMapViewWithPoi:(AMapPOI *)poi {
    [self.contentView addSubview:self.mapView];
    //icon_search_place
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    [self.mapView removeAnnotations: self.mapView.annotations];
//    [self.mapView reloadMap];
    MAAnimatedAnnotation *annotation = [[MAAnimatedAnnotation alloc] init];
    annotation.coordinate = coord;
    [self.mapView addAnnotation:annotation];
    [self.mapView setCenterCoordinate:(coord) animated:YES];
}

- (void)hideMapView {
    [self.mapView removeFromSuperview];
}

#pragma mark - 通知相关
- (void)addNotis {
    [ZLNotiCenter addObserver:self selector:@selector(selectedCityChanged:) name:TYWJSelectedCityChangedNoti object:nil];
    [ZLNotiCenter addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)removeNotis {
    [ZLNotiCenter removeObserver:self name:TYWJSelectedCityChangedNoti object:nil];
    [ZLNotiCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardDidChangeFrame:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    CGFloat timeInterval = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginF = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaH = endF.origin.y - beginF.origin.y;
    
    [UIView animateWithDuration:timeInterval delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.tableView.zl_height += deltaH;
        self.collectionView.zl_height += deltaH;
    } completion:nil];
}
#pragma mark - 加载最近搜索plist
- (void)loadPlist {
    NSString *path = [self getSavePath];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:path];
    if (dataArr) {
        self.dataList = [TYWJSearchModel mj_objectArrayWithKeyValuesArray:dataArr];
        [self.collectionView reloadData];
    }
}

/**
 保存搜索历史
 */
- (BOOL)savePlist {
    NSMutableArray *newDataArr = [NSMutableArray array];
    NSString *path = [self getSavePath];
    [newDataArr addObject:@{@"title" : self.selectedStation}];
    for (TYWJSearchModel *model in self.dataList) {
        if ([model.title isEqualToString:self.selectedStation]) {
            continue;
        }
        NSDictionary *dic = @{@"title" : model.title};
        [newDataArr addObject:dic];
    }
    
    return [newDataArr writeToFile:path atomically:YES];
}

- (BOOL)clearPlist {
    NSArray *dataArr = [NSArray array];
    NSString *path = [self getSavePath];
    BOOL success = [dataArr writeToFile:path atomically:YES];
    if (success) {
        ZLLog(@"清空成功");
    }else {
        ZLLog(@"清空失败");
    }
    return success;
}
/**
 获取搜索历史保存路径
 */
- (NSString *)getSavePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    if (path) {
        path = [path stringByAppendingPathComponent:@"latestSearchPlaces.plist"];
    }
    return path;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mapPOIArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TYWJSearchPOICell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJSearchPOICellID forIndexPath:indexPath];
    AMapPOI *poi = self.mapPOIArr[indexPath.row];
    cell.poi = poi;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AMapPOI *poi = self.mapPOIArr[indexPath.row];
    self.selectedPoi = poi;
    self.selectedStation = poi.name;
    self.tf.text = self.selectedStation;
    [self showKeywordsView];
    [self.view endEditing:YES];
    [self showMapViewWithPoi:poi];
//    if (self.stationPoi && self.selectedStation) {
//        self.stationPoi(poi);
//    }
//    [self savePlist];
//    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}
//返回每个cell  的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TYWJSearchModel *model = self.dataList[indexPath.row];
    return CGSizeMake(model.itemW, 25.0f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YDYBSearchCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YDYBSearchCollectionCellID forIndexPath:indexPath];
    TYWJSearchModel *model = self.dataList[indexPath.item];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    
    TYWJSearchModel *model = self.dataList[indexPath.row];
    [self.tf becomeFirstResponder];
    self.tf.text = model.title;
    [self startSearchWithKeywords:model.title];
//    [self showSearchResultView];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self showSearchResultView];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    //TODO --
    [self showKeywordsView];
    [self hideMapView];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""] && textField.text.length == 0) {
        return YES;
    }
    if ([string isEqualToString:@""] && textField.text.length == 1) {
        [self showKeywordsView];
        [self hideMapView];
        return YES;
    }
    [self showSearchResultView];
    NSString *keywords = @"";
    if ([string isEqualToString:@""]) {
        keywords = [textField.text substringToIndex:textField.text.length - 2];
    }else {
        keywords = [textField.text stringByAppendingString:string];
    }
    [self startSearchWithKeywords:keywords];
    return YES;
}

/**
 显示搜索时的关键字的view
 */
- (void)showKeywordsView {
    [self.tableView removeFromSuperview];
}
/**
 显示搜索结果页面
 */
- (void)showSearchResultView {
    [self.contentView addSubview:self.tableView];
}

#pragma mark - 按钮点击

/**
 城市按钮点击
 */
- (void)cityClicked:(UIButton *)btn {
    TYWJUsableCitiesController *vc = [[TYWJUsableCitiesController alloc] init];
    vc.cellSelected = ^(NSString *city) {
        [btn setTitle:[TYWJCommonTool sharedTool].selectedCity.city forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 清空历史记录按钮点击
 */
- (void)clearHistoryClicked {
    ZLFuncLog;
    if (!self.dataList) {
        ZLLog(@"没有历史记录");
        return;
    }
    
    [self.view endEditing:NO];
    WeakSelf;
    [[ZLPopoverView sharedInstance] showTipsViewWithTips:@"确定删除历史记录?" leftTitle:@"取消" rightTitle:@"确定" RegisterClicked:^{
        self.dataList = nil;
        [weakSelf.collectionView reloadData];
        
        [weakSelf clearPlist];
    }];
        }

- (void)selectedCityChanged:(NSNotification *)noti {
        
    [self.cityBtn setTitle:[TYWJCommonTool sharedTool].selectedCity.city forState:UIControlStateNormal];
}

- (void)finishClicked {
    ZLFuncLog;
    if (self.tf.text.length > 0 && !self.selectedPoi) {
        AMapPOI *poi = self.mapPOIArr[0];
        self.selectedPoi = poi;
        self.selectedStation = poi.name;
    }
    if (self.stationPoi && self.selectedStation) {
        self.stationPoi(self.selectedPoi);
    }
    if (self.selectedStation) {
        [self savePlist];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

#pragma mark - search

- (void)startSearchWithKeywords:(NSString *)keywords {
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords            = keywords;
    request.city                = [self.cityBtn titleForState:UIControlStateNormal];
//    request.types               = @"高等院校";
    request.requireExtension    = YES;
    
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    
    [self.search AMapPOIKeywordsSearch:request];
    [MBProgressHUD zl_showMessage:TYWJWarningSearchLoading];
}

#pragma mark - searchDelegate

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    [MBProgressHUD zl_hideHUD];
    if (response.pois.count == 0)
    {
        return;
    }
    
    //解析response获取POI信息，具体解析见 Demo
    self.mapPOIArr = response.pois;
    [self.tableView reloadData];
}

/**
 * @brief 当请求发生错误时，会调用代理的此方法.
 * @param request 发生错误的请求.
 * @param error   返回的错误.
 */
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    if (error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
    }
}

//根据导航类型绘制覆盖物
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        
        if ([annotation isKindOfClass:[MAAnimatedAnnotation class]]) {
            MAAnnotationView *view = (MAAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"MAAnimationAnnotationViewID"];
            
            if (!view) {
                view = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MAAnimationAnnotationViewID"];
            }
            //设置当前位置annotation的image
            if ([annotation isKindOfClass: [MAUserLocation class]]) {
                view.image = [UIImage imageNamed:@"userPosition"];
                self.userLocationAnnotationView = view;
            }else {
                view.image = [UIImage imageNamed:@"star_point"];
            }
            
            return view;
        }
    }
    return nil;
}

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
@end
