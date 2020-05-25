//
//  TYWJMyOrderController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/25.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJMyOrderController.h"
#import "TYWJMyRouteCell.h"
#import "TYWJSoapTool.h"
#import "TYWJLoginTool.h"
#import "TYWJCommentController.h"
#import "TYWJDetailRouteController.h"
#import "TYWJTicketList.h"
#import "TYWJPeirodTicket.h"

#import <MJExtension.h>


@interface TYWJMyOrderController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* dataList */
@property (strong, nonatomic) NSMutableArray *tickets;
/* monthTickets */
@property (strong, nonatomic) NSArray *monthTickets;
/* 接送行程 */
@property (strong, nonatomic) NSArray *commuteTickets;

@end

@implementation TYWJMyOrderController

#pragma mark - lazy loading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 130.f;
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJMyRouteCell class]) bundle:nil] forCellReuseIdentifier:TYWJMyRouteCellID];
    }
    _tableView.frame = self.view.bounds;
    return _tableView;
}


#pragma mark - set up view
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD zl_hideHUD];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    self.navigationItem.title = @"我的订单";
    
    [self.view addSubview:self.tableView];
   
    [self loadData];
}

- (void)dealloc {
    ZLFuncLog;
}

#pragma mark - 数据请求

- (void)loadData {
    switch (self.type) {
        case ALL:
        {
            [self loadSingleTicketData];
        }
            break;
        case WAIT_PAY:
        {
            [self loadPeriodTicketData];
        }
            break;
        case PAYED:
        {
            [self loadPeriodTicketData];
        }
            case REFUD:
            {
                [self loadPeriodTicketData];
            }
            break;
    }
}

- (void)loadSingleTicketData {
    WeakSelf;
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <yhm>%@</yhm>\
                              </%@>",TYWJRequesrGetPurchasedTickets,TYWJRequestService,[TYWJLoginTool sharedInstance].phoneNum,TYWJRequesrGetPurchasedTickets];
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:soapBodyStr success:^(id responseObject) {
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        if (responseObject) {
            id list = responseObject[0][@"NS1:chepiaoResponse"][@"chepiaoList"][@"chepiao"];
            if ([list isKindOfClass:[NSArray class]]) {
                weakSelf.tickets = [TYWJTicketList mj_objectArrayWithKeyValuesArray:list];
                [weakSelf reloadData];
            }else {
                TYWJTicketList *data = [TYWJTicketList mj_objectWithKeyValues:list];
                if (data) {
                    weakSelf.tickets = [NSMutableArray arrayWithObject:data];
                    [weakSelf reloadData];
                }
                
            }
            if (!weakSelf.tickets.count) {
                //显示没票页面
                [weakSelf loadNoDataViewWithImg:@"icon_no_ticket" tips:@"您还没有行程费哦,\n快去体验一下胖哒直通车吧~~" btnTitle:nil isHideBtn:YES];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zl_hideHUDForView:self.view];
        [weakSelf loadNoDataViewWithImg:@"icon_no_network" tips:@"网络怎么了?请稍后再试试吧" btnTitle:@"重新加载" isHideBtn:NO];
    }];
}

- (void)loadPeriodTicketData {
    WeakSelf;
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
    NSString * soapBodyStr = [NSString stringWithFormat:
                               @"<%@ xmlns=\"%@\">\
                               <yhm>%@</yhm>\
                               </%@>",TYWJRequesrGetPurchasedMonthTickets,TYWJRequestService,[TYWJLoginTool sharedInstance].phoneNum,TYWJRequesrGetPurchasedMonthTickets];
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:soapBodyStr success:^(id responseObject) {
        [MBProgressHUD zl_hideHUDForView:self.view];
        id list = responseObject[0][@"NS1:zqchepiaoResponse"][@"zqchepiaoList"][@"zqchepiao"];
        if ([list isKindOfClass:[NSArray class]]) {
            weakSelf.commuteTickets = [TYWJPeriodTicket mj_objectArrayWithKeyValuesArray:list];
            [weakSelf reloadData];
        }else {
            TYWJPeriodTicket *data = [TYWJPeriodTicket mj_objectWithKeyValues:list];
            if (data) {
                weakSelf.commuteTickets = @[data];
                [weakSelf reloadData];
            }
            
            
        }
        if (!weakSelf.commuteTickets.count) {
            //显示没票页面
            [weakSelf loadNoDataViewWithImg:@"icon_no_ticket" tips:@"您还没有行程费哦,\n快去体验一下胖哒直通车吧~~" btnTitle:nil isHideBtn:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zl_hideHUDForView:self.view];
        [weakSelf loadNoDataViewWithImg:@"icon_no_network" tips:@"网络怎么了?请稍后再试试吧" btnTitle:@"重新加载" isHideBtn:NO];
    }];
}

- (void)reloadData {
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}


#pragma mark - 显示无数据页面
- (void)loadNoDataViewWithImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle isHideBtn:(BOOL)isHideBtn {
    WeakSelf;
    [TYWJCommonTool loadNoDataViewWithImg:img tips:tips btnTitle:btnTitle isHideBtn:isHideBtn showingVc:self btnClicked:^(UIViewController *failedVc) {
        [failedVc.view removeFromSuperview];
        [weakSelf loadData];
        [failedVc removeFromParentViewController];
    }];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.type) {
        case ALL:
        {
            return self.tickets.count;
        }
            break;
        case WAIT_PAY:
        {
            return self.monthTickets.count;
        }
            break;
        case PAYED:
        {
            return self.commuteTickets.count;
        }
            break;
            case REFUD:
            {
                return self.commuteTickets.count;
            }
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJMyRouteCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJMyRouteCellID forIndexPath:indexPath];
    switch (self.type) {
        case ALL:
        {
            TYWJTicketList *ticket = self.tickets[indexPath.row];
            cell.ticket = ticket.listInfo;
        }
            break;
        case WAIT_PAY:
        {
            
        }
            break;
        case PAYED:
        {
            TYWJPeriodTicket *commuteTicket = self.commuteTickets[indexPath.row];
            cell.periodTicket = commuteTicket.detailTicket;
        }
            break;
        case REFUD:
        {
            
        }
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.type) {

            
        case ALL:
        {
            TYWJTicketList *list = self.tickets[indexPath.row];
            if ([list.listInfo.status isEqualToString:@"待乘车"] || [list.listInfo.status isEqualToString:@"已乘车"]) {
                TYWJDetailRouteController *vc = [[TYWJDetailRouteController alloc] init];
                vc.isDetailRoute = NO;
                vc.ticket = list.listInfo;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([list.listInfo.status isEqualToString:@"已完成"]) {
                TYWJCommentController *commentVc = [[TYWJCommentController alloc] init];
                TYWJTicketList *ticket = self.tickets[indexPath.row];
                commentVc.ticket = ticket;
                [self.navigationController pushViewController:commentVc animated:YES];
            }
        }
            break;
        case WAIT_PAY:
        {
            
        }
                break;
            case PAYED:
            {
                //不让点
            }
            break;
        case REFUD:
        {
            //不让点
        }
            break;
    }
    
}

- (void)setTickets:(NSMutableArray *)tickets {
    _tickets = nil;
    _tickets = [NSMutableArray array];
    NSMutableArray *tmpArray1 = [NSMutableArray array];
    NSMutableArray *tmpArray2 = [NSMutableArray array];
    NSMutableArray *tmpArray3 = [NSMutableArray array];
    NSMutableArray *tmpArray4 = [NSMutableArray array];
    NSMutableArray *tmpArray5 = [NSMutableArray array];
    for (TYWJTicketList *ticket in tickets) {
        if ([ticket.listInfo.status isEqualToString:@"待乘车"]) {
            [tmpArray1 addObject:ticket];
        }else if ([ticket.listInfo.status isEqualToString:@"已乘车"]) {
            [tmpArray2 addObject:ticket];
        }else if ([ticket.listInfo.status isEqualToString:@"待支付"]) {
            [tmpArray3 addObject:ticket];
        }else if ([ticket.listInfo.status isEqualToString:@"已完成"]) {
            [tmpArray4 addObject:ticket];
        }else {
            [tmpArray5 addObject:ticket];
        }
    }
    [_tickets addObjectsFromArray:tmpArray1];
    [_tickets addObjectsFromArray:tmpArray2];
//    [_tickets addObjectsFromArray:tmpArray3];
    [_tickets addObjectsFromArray:tmpArray4];
    [_tickets addObjectsFromArray:tmpArray5];
}

@end

