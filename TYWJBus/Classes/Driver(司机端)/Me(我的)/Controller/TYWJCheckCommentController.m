//
//  TYWJCheckCommentController.m
//  TYWJBus
//
//  Created by MacBook on 2019/1/3.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import "TYWJCheckCommentController.h"
#import "TYWJSoapTool.h"
#import "TYWJLoginTool.h"
#import "TYWJDriverComment.h"
#import "TYWJDriverComplaint.h"
#import "TYWJCheckCommentCell.h"
#import "CDZStarsControl.h"

#import <MJExtension.h>


static CGFloat const kHeaderH = 40.f;

@interface TYWJCheckCommentController ()<UITableViewDelegate,UITableViewDataSource>

/* 评价 */
@property (strong, nonatomic) NSArray *comments;
/* 投诉 */
@property (strong, nonatomic) NSArray *complaints;
/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* 综合平均评分 */
@property (assign, nonatomic) CGFloat avarageScore;
@end

@implementation TYWJCheckCommentController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"TYWJCheckCommentCell" bundle:nil] forCellReuseIdentifier:TYWJCheckCommentCellID];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    if (self.type == TYWJCheckCommentTypeComment) {
        self.navigationItem.title = @"评价查看";
        [self requestComment];
    }else {
        self.navigationItem.title = @"投诉查看";
        [self requestComplaint];
    }
    
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == TYWJCheckCommentTypeComment) {
        return self.comments.count;
    }
    return self.complaints.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJCheckCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJCheckCommentCellID forIndexPath:indexPath];
    if (self.type == TYWJCheckCommentTypeComment) {
        TYWJDriverComment *comment = self.comments[indexPath.row];
        cell.comment = comment.commentInfo;
    }else {
        TYWJDriverComplaint *comp = self.complaints[indexPath.row];
        cell.complaint = comp.complaintInfo;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == TYWJCheckCommentTypeComment) {
        TYWJDriverComment *comment = self.comments[indexPath.row];
        return comment.commentInfo.rowH;
    }
    
    TYWJDriverComplaint *comp = self.complaints[indexPath.row];
    return comp.complaintInfo.rowH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.comments) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth, kHeaderH)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 0, 110.f, kHeaderH - 1.f)];
        tipsLabel.font = [UIFont boldSystemFontOfSize:18.f];
        tipsLabel.text = [NSString stringWithFormat:@"综合评分:%.01f",self.avarageScore];
        [headerView addSubview:tipsLabel];
        
        CGRect f = CGRectMake(CGRectGetMaxX(tipsLabel.frame) + 4.f, 0, 13.f*5, kHeaderH - 1.f);
        CDZStarsControl *starControl = [[CDZStarsControl alloc] initWithFrame:f stars:5 starSize:CGSizeMake(13.f, 12.f) noramlStarImage:[UIImage imageNamed:@"icon_star_hui_13x12_"] highlightedStarImage: [UIImage imageNamed:@"icon_star_cheng_13x12_"]];
        starControl.enabled = NO;
        starControl.allowFraction = YES;
        starControl.score = self.avarageScore;
        [headerView addSubview:starControl];
        
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(15.f, kHeaderH - 1.f, ZLScreenWidth - 30.f, 1.f)];
        sepView.backgroundColor = ZLGrayColorWithRGB(244);
        [headerView addSubview:sepView];
        return headerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.comments) {
        return kHeaderH;
    }
    return 0;
}

#pragma mark - 数据请求

/**
 评价数据获取
 */
- (void)requestComment {
    WeakSelf;
    
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <yhm>%@</yhm>\
                              </%@>",TYWJRequestCheckComment,TYWJRequestService,[TYWJLoginTool sharedInstance].phoneNum,TYWJRequestCheckComment];
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:soapBodyStr success:^(id responseObject) {
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        id resp = responseObject[0][@"NS1:sijipingjiaResponse"][@"sijipingjiaList"];
        if (resp) {
            id rating = resp[@"pingjia"];
            if ([rating isKindOfClass: [NSArray class]]) {
                weakSelf.comments = [TYWJDriverComment mj_objectArrayWithKeyValuesArray:rating];
                [weakSelf.tableView reloadData];
            }else if ([rating isKindOfClass: [NSDictionary class]]) {
                TYWJDriverComment *comment = [TYWJDriverComment mj_objectWithKeyValues:rating];
                weakSelf.comments = @[comment];
                [weakSelf.tableView reloadData];
            }else {
                [TYWJCommonTool loadNoDataViewWithImg:@"icon_no_ticket" tips:@"暂无评价" btnTitle:nil isHideBtn:YES showingVc:weakSelf];
            }
            
        }else {
            [TYWJCommonTool loadNoDataViewWithImg:@"icon_no_ticket" tips:@"暂无评价" btnTitle:nil isHideBtn:YES showingVc:weakSelf];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:weakSelf.view];
        if (error) {
            [TYWJCommonTool loadNoDataViewWithImg:@"icon_no_ticket" tips:@"暂未加载出数据" btnTitle:nil isHideBtn:YES showingVc:weakSelf];
        }
    }];
}


/**
 投诉数据获取
 */
- (void)requestComplaint {
    WeakSelf;
    
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <yhm>%@</yhm>\
                              </%@>",TYWJRequestCheckComplaint,TYWJRequestService,[TYWJLoginTool sharedInstance].phoneNum,TYWJRequestCheckComplaint];
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:soapBodyStr success:^(id responseObject) {
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        id resp = responseObject[0][@"NS1:sijitousuResponse"][@"sijitousuList"];
        if (resp) {
            id comp = resp[@"tousu"];
            if ([comp isKindOfClass: [NSArray class]]) {
                weakSelf.complaints = [TYWJDriverComplaint mj_objectArrayWithKeyValuesArray:comp];
                [weakSelf.tableView reloadData];
            }else if ([comp isKindOfClass: [NSDictionary class]]) {
                TYWJDriverComplaint *complaint = [TYWJDriverComplaint mj_objectWithKeyValues:comp];
                weakSelf.complaints = @[complaint];
                [weakSelf.tableView reloadData];
            }else {
                [TYWJCommonTool loadNoDataViewWithImg:@"icon_no_ticket" tips:@"暂无投诉" btnTitle:nil isHideBtn:YES showingVc:weakSelf];
            }
            
        }else {
            [TYWJCommonTool loadNoDataViewWithImg:@"icon_no_ticket" tips:@"暂无投诉" btnTitle:nil isHideBtn:YES showingVc:weakSelf];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:weakSelf.view];
        if (error) {
            [TYWJCommonTool loadNoDataViewWithImg:@"icon_no_ticket" tips:@"暂无未加载出数据" btnTitle:nil isHideBtn:YES showingVc:weakSelf];
        }
    }];
}

- (void)setComments:(NSArray *)comments {
    _comments = [comments reverseObjectEnumerator].allObjects;
    
    CGFloat sum = 0;
    for (TYWJDriverComment *comment in comments) {
        if (comment.commentInfo.rating && ![comment.commentInfo.rating isEqualToString:@""]) {
            sum += comment.commentInfo.rating.floatValue;
        }
    }
    self.avarageScore = sum/comments.count;
}

- (void)setComplaints:(NSArray *)complaints {
    _complaints = [complaints reverseObjectEnumerator].allObjects;
}

@end
