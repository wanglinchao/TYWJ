//
//  TYWJMyTicketController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJMyTicketController.h"
#import "TYWJSoapTool.h"
#import "TYWJLoginTool.h"
#import "TYWJMyTicketsCell.h"
#import "TYWJMyTicketsLayout.h"
#import "TYWJCarProtocolController.h"
#import "TYWJTicketList.h"
#import "TYWJJsonRequestUrls.h"
#import "ZLHTTPSessionManager.h"
#import "TYWJMonthTicket.h"

#import <MJExtension.h>

@interface TYWJMyTicketController ()<UICollectionViewDelegate,UICollectionViewDataSource>

/* tableView */
@property (strong, nonatomic) UICollectionView *collectionView;
/* dataLists */
@property (strong, nonatomic) NSMutableArray *dataLists;
/* 月票lists */
@property (strong, nonatomic) NSArray *monthTickets;
/* pageLabel */
@property (strong, nonatomic) UILabel *pageLabel;
/* 是否加载单次票数据完毕 */
@property (assign, nonatomic) BOOL isLoadedErrorTicketDataComp;
/* 单次票数据是否请求完毕 */
@property (assign, nonatomic) BOOL isSingleDataFinished;
/* 月票数据是否请求完毕 */
@property (assign, nonatomic) BOOL isMonthDataFinished;

@end

@implementation TYWJMyTicketController
#pragma mark - 懒加载

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        TYWJMyTicketsLayout *layout = [[TYWJMyTicketsLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.zl_y = 0;
        _collectionView.zl_height = self.view.zl_height - 60.f - kTabBarH;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJMyTicketsCell class]) bundle:nil] forCellWithReuseIdentifier:TYWJMyTicketsCellID];
    }
    return _collectionView;
}

- (UILabel *)pageLabel {
    if (!_pageLabel) {
        UILabel *pageLabel = [[UILabel alloc] init];
        pageLabel.textColor = [UIColor whiteColor];
        pageLabel.font = [UIFont systemFontOfSize:18.f];
        pageLabel.zl_size = CGSizeMake(100.f, 20.f);
        pageLabel.zl_x = self.view.zl_width - 120.f;
        pageLabel.zl_centerY = self.view.zl_height - 30.f - kTabBarH;
        pageLabel.textAlignment = NSTextAlignmentRight;
        pageLabel.text = @"0/0";
        _pageLabel = pageLabel;
    }
    return _pageLabel;
}
#pragma mark - set up view
- (void)dealloc {
    ZLFuncLog;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    
    [self requestMonthTicketData];
    [self requestSingleTicketData];
}

- (void)setupView {
    self.navigationItem.title = @"我的行程费";
    
    [self.view addSubview:self.collectionView];
}

- (void)addTicketView {
    self.view.backgroundColor = ZLColorWithRGB(112, 116, 122);
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pageLabel];
    
    UIButton *returnTicketBtn = [[UIButton alloc] init];
    [returnTicketBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    returnTicketBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [returnTicketBtn setTitle:@"购买须知" forState:UIControlStateNormal];
    [returnTicketBtn setImage:[UIImage imageNamed:@"icon_explain"] forState:UIControlStateNormal];
    returnTicketBtn.zl_size = CGSizeMake(100.f, 20.f);
    returnTicketBtn.zl_centerX = self.view.zl_width/2.f;
    returnTicketBtn.zl_centerY = self.pageLabel.zl_centerY;
    [returnTicketBtn addTarget:self action:@selector(returnTicketClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnTicketBtn];
    
    [self.collectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [TYWJLoginTool checkUniqueLoginWithVC:self];
}
#pragma mark - 加载数据
- (void)requestSingleTicketData {
    WeakSelf;
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <yhm>%@</yhm>\
                              </%@>",TYWJRequesrGetPurchasedTickets,TYWJRequestService,[TYWJLoginTool sharedInstance].phoneNum,TYWJRequesrGetPurchasedTickets];
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:soapBodyStr success:^(id responseObject) {
        weakSelf.isSingleDataFinished = YES;
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        id list = responseObject[0][@"NS1:chepiaoResponse"][@"chepiaoList"][@"chepiao"];
        
        if ([list isKindOfClass:[NSArray class]]) {
            //list是数组
            NSArray *lists = [TYWJTicketList mj_objectArrayWithKeyValuesArray:list];
            NSMutableArray *dataLists = [NSMutableArray array];
            for (TYWJTicketList *list in lists) {
                if ([list.listInfo.status isEqualToString:@"待乘车"] || [list.listInfo.status isEqualToString:@"已乘车"]) {
                    [dataLists addObject:list];
                }
            }
            if (dataLists.count) {
                weakSelf.dataLists = dataLists;
            }else {
                if (weakSelf.isMonthDataFinished && weakSelf.monthTickets.count == 0) {
                    //显示没票页面
                    [weakSelf loadNoDataViewWithImg:@"icon_no_ticket" tips:@"您还没有行程费哦,\n快去体验一下胖哒直通车吧~~" btnTitle:nil isHideBtn:YES];
                }
                
            }
        }
        else {//list是字典
                TYWJTicketList *data = [TYWJTicketList mj_objectWithKeyValues:list];
                if ([data.listInfo.status isEqualToString:@"待乘车"] || [data.listInfo.status isEqualToString:@"已乘车"]) {
                    weakSelf.dataLists = [NSMutableArray arrayWithObject:data];
                }else {
                    if (weakSelf.isMonthDataFinished && weakSelf.monthTickets.count == 0) {
                        //显示没票页面
                        [weakSelf loadNoDataViewWithImg:@"icon_no_ticket" tips:@"您还没有行程费哦,\n快去体验一下胖哒直通车吧~~" btnTitle:nil isHideBtn:YES];
                    }
                    
                }
            }
    } failure:^(NSError *error) {
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        [weakSelf loadNoDataViewWithImg:@"icon_no_network" tips:@"网络怎么了?请稍后再试试吧" btnTitle:@"重新加载" isHideBtn:NO];
    }];
    
}


- (void)requestMonthTicketData {
    WeakSelf;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"yhm"] = [TYWJLoginTool sharedInstance].phoneNum;
    [[ZLHTTPSessionManager manager] POST:[TYWJJsonRequestUrls sharedRequest].monthTicket parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        weakSelf.isMonthDataFinished = YES;
        ZLLog(@"response---%@",responseObject);
        if ([responseObject[@"reCode"] intValue] == 201) {
            weakSelf.monthTickets = [TYWJMonthTicket mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [weakSelf.collectionView reloadData];
            if (weakSelf.monthTickets.count == 0 && weakSelf.isSingleDataFinished) {
                //显示没票页面
                [weakSelf loadNoDataViewWithImg:@"icon_no_ticket" tips:@"您还没有行程费哦,\n快去体验一下胖哒直通车吧~~" btnTitle:nil isHideBtn:YES];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.dataLists.count + self.monthTickets.count;
    if (count) {
        self.pageLabel.text = [NSString stringWithFormat:@"1/%ld",(long)count];
        [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    
    return count;
}

//返回每个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([TYWJCommonTool sharedTool].currentSysVersion.doubleValue < 11) {
        return CGSizeMake(collectionView.zl_width, collectionView.zl_height);
    }
    return CGSizeMake(collectionView.zl_width, collectionView.zl_height - kNavBarH);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TYWJMyTicketsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TYWJMyTicketsCellID forIndexPath:indexPath];
    if (indexPath.row < self.monthTickets.count) {
        TYWJMonthTicket *monthTicket = self.monthTickets[indexPath.row];
        cell.monthTicket = monthTicket;
        cell.ticket = nil;
    }else {
        TYWJTicketList *ticket = self.dataLists[indexPath.row - self.monthTickets.count];
        cell.monthTicket = nil;
        cell.ticket = ticket.listInfo;
    }
    return cell;
}



#pragma mark - 按钮点击

/**
 退票规则按钮点击
 */
- (void)returnTicketClicked {
    ZLFuncLog;
    TYWJCarProtocolController *vc = [[TYWJCarProtocolController alloc] init];
    vc.type = TYWJCarProtocolControllerTypeTicketingInformation;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/scrollView.zl_width;
    
    NSString *pageText = [NSString stringWithFormat:@"%ld/%ld",index + 1,self.dataLists.count + self.monthTickets.count];
    self.pageLabel.text = pageText;
}

#pragma mark - 显示无数据页面
- (void)loadNoDataViewWithImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle isHideBtn:(BOOL)isHideBtn {
    WeakSelf;
    [TYWJCommonTool loadNoDataViewWithImg:img tips:tips btnTitle:btnTitle isHideBtn:isHideBtn showingVc:self btnClicked:^(UIViewController *failedVc) {
        [failedVc.view removeFromSuperview];
        [weakSelf requestSingleTicketData];
        [failedVc removeFromParentViewController];
    }];
}

- (void)setDataLists:(NSMutableArray *)dataLists {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy.MM.dd";
    NSInteger count = dataLists.count;
    for (NSInteger i = 0; i < count; i++) {
        TYWJTicketList *minTicket = dataLists[i];
        CGFloat minTime = [[dateFormatter dateFromString:minTicket.listInfo.getupDate] timeIntervalSince1970];
        for (NSInteger j = i + 1; j < count; j++) {
            TYWJTicketList *currTicket = dataLists[j];
            CGFloat currTime = [[dateFormatter dateFromString:currTicket.listInfo.getupDate] timeIntervalSince1970];
            if (minTime > currTime) {
                minTime = currTime;
                dataLists[j] = dataLists[i];
                dataLists[i] = currTicket;
            }
        }
    }
    _dataLists = dataLists;
    [self addTicketView];
    
}

- (void)setMonthTickets:(NSArray *)monthTickets {
    _monthTickets = monthTickets;
    
    if (monthTickets.count) {
        [self addTicketView];
    }
}
@end
