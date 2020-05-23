//
//  TYWJComplaintController.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/21.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJComplaintController.h"
#import "TYWJComplaintCell.h"
#import "TYWJComplaintFooter.h"
#import "ZLHTTPSessionManager.h"
#import "TYWJJsonRequestUrls.h"
#import "TYWJTicketList.h"
#import "TYWJReturnedTicketController.h"
#import "TYWJSoapTool.h"
#import "TYWJLoginTool.h"
#import "TYWJComplaintModel.h"
#import "TYWJTextVeiw.h"


static CGFloat const kRowHeight = 55.f;


@interface TYWJComplaintController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* plistList */
@property (strong, nonatomic) NSArray *plistList;
/* selectedCell */
@property (weak, nonatomic) TYWJComplaintCell *selectedCell;

@end

@implementation TYWJComplaintController

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.zl_y = kNavBarH;
        _tableView.zl_y -= kNavBarH;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = kRowHeight;
        [_tableView registerNib:[UINib nibWithNibName:@"TYWJComplaintCell" bundle:nil] forCellReuseIdentifier:TYWJComplaintCellID];
        
        TYWJComplaintFooter *footer = [[[NSBundle mainBundle] loadNibNamed:@"TYWJComplaintFooter" owner:nil options:nil] lastObject];
        [footer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTableView)]];
        footer.isRefundTicket = self.isRefundTicket;
        footer.zl_height = 265.f;
        
        WeakSelf;
        __weak typeof(footer) weakFooter = footer;
        footer.quitTicketClicked = ^(NSString *reason) {
            //退票
            [weakSelf requestQuitTicketWithReason:reason];

        };
        footer.complaintClicked = ^(NSString *reason) {
            //投诉
            weakFooter.tv.text = @"";
            [weakFooter.tv showPlaceholder];
            [weakSelf requestComplaintWithReason:reason];
        };
        _tableView.tableFooterView = footer;
    }
    return _tableView;
}
#pragma mark -

- (void)dealloc {
    ZLFuncLog;
    [self removeNotis];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self loadDatalist];
    [self addNotis];
}

- (void)setupView {
    [self.view addSubview:self.tableView];
    
    if (self.isRefundTicket) {
        self.navigationItem.title = @"退行程费原因";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"投诉" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClicked)];
    }else {
        self.navigationItem.title = @"投诉";
    }
}

- (void)loadDatalist {
    NSString *path = nil;
    if (self.isRefundTicket) {
        path = [[NSBundle mainBundle] pathForResource:TYWJRefundTicketReasonPlist ofType:nil];
    }else {
        path = [[NSBundle mainBundle] pathForResource:TYWJComplaintListPlist ofType:nil];
    }
    if (path) {
        self.plistList = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *tmpList = [NSMutableArray array];
        NSInteger count = self.plistList.count;
        for (NSInteger i = 0; i < count; i ++) {
            NSString *title = self.plistList[i];
            TYWJComplaintModel *model = [[TYWJComplaintModel alloc] init];
            model.title = title;
            model.isSelected = NO;
            if (0 == i) {
                model.isSelected = YES;
            }
            [tmpList addObject:model];
        }
        self.plistList = [tmpList copy];
        [self.tableView reloadData];
    }
    
}

#pragma mark - 点击事件
- (void)tapTableView {
    [self.view endEditing:YES];
}

- (void)rightItemClicked {
    ZLFuncLog;
    TYWJComplaintController *vc = [[TYWJComplaintController alloc] init];
    vc.ticket = self.ticket;
    vc.monthTicket = self.monthTicket;
    vc.isRefundTicket = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.plistList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJComplaintCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJComplaintCellID forIndexPath:indexPath];
    cell.body = self.plistList[indexPath.row];
    if (indexPath.row == 0) {
        self.selectedCell = cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.selectedCell setBtnSelectedStatus:NO];
    
    TYWJComplaintCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setBtnSelectedStatus:YES];
    self.selectedCell = cell;
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
        self.tableView.zl_y = -kRowHeight*self.plistList.count;
    } completion:nil];
}

- (void)keyboardWillHide {
    
    [UIView animateKeyframesWithDuration:0.45f delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        self.tableView.zl_y = 0;
    } completion:nil];
}

#pragma mark - 数据请求

- (void)requestQuitTicketWithReason:(NSString *)reason {
    
    NSString *qr = self.selectedCell.body.title;
    if (reason) {
        qr = [NSString stringWithFormat:@"%@:\n%@",self.selectedCell.body.title,reason];
    }
    [MBProgressHUD zl_showMessage:@"请求退行程费中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.ticket ? self.ticket.ticketID : self.monthTicket.ticketID;
    params[@"type"] = self.ticket ? @"0" : @"1";
    params[@"reason"] = qr;

    [[ZLHTTPSessionManager manager] POST:[TYWJJsonRequestUrls sharedRequest].quitTicket parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"reCode"] intValue] == 201) {
            ZLLog(@"%@",responseObject[@"codeTxt"]);
            [MBProgressHUD zl_showSuccess:responseObject[@"codeTxt"]];
            UINavigationController *nav = self.navigationController;
            TYWJReturnedTicketController *vc = [[TYWJReturnedTicketController alloc] init];
            vc.ticket = self.ticket;
            vc.monthTicket = self.monthTicket;
            vc.returnTicketReason = self.selectedCell.body.title;
            [nav popToRootViewControllerAnimated:NO];
            [nav pushViewController:vc animated:YES];
        }else {
            [MBProgressHUD zl_showError:responseObject[@"codeTxt"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[TYWJCommonTool sharedTool] returnRequestErrorInfoWithError:error];
        
    }];
}

- (void)requestComplaintWithReason:(NSString *)reason {
    //TYWJRequstOnlineFeedback
//    NSString *feedbackString = self.tf.text;
//    if (feedbackString.length == 0) {
//        [SVProgressHUD zl_showErrorWithStatus:@"请填写反馈内容"];
//        return;
//    }
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    formmater.dateFormat = @"yyyy.MM.dd";
    NSString *todayStr = [formmater stringFromDate:[NSDate date]];
    if (![todayStr isEqualToString:self.ticket.getupDate]) {
        [self.view endEditing:YES];
        [MBProgressHUD zl_showSuccess:@"提交成功，感谢您的投诉"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSString *qr = self.selectedCell.body.title;
    if (reason) {
        qr = [NSString stringWithFormat:@"%@",reason];
    }
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat =  @"yyyy.MM.dd";
//    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <xl>%@</xl>\
                              <tsnr>%@</tsnr>\
                              <pjr>%@</pjr>\
                              </%@>",TYWJRequstOnlineComplaint,TYWJRequestService,self.ticket.routeID,qr,[TYWJLoginTool sharedInstance].phoneNum,TYWJRequstOnlineComplaint];
    
    WeakSelf;
    [TYWJSoapTool SOAPDataWithSoapBody:soapBodyStr success:^(id responseObject) {
        if (responseObject) {
            NSString *response = responseObject[0][@"NS1:tousuResponse"];
            if ([response isEqualToString:@"ok"]) {
                [weakSelf.view endEditing:YES];
                [MBProgressHUD zl_showSuccess:@"提交成功，感谢您的反馈"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else {
                [MBProgressHUD zl_showError:@"投诉失败"];
                
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
    }];
}


@end
