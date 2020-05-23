//
//  TYWJCommentController.m
//  TYWJBus
//
//  Created by MacBook on 2019/1/4.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import "TYWJCommentController.h"
#import "TYWJComplaintFooter.h"
#import "TYWJComplaintController.h"
#import "TYWJTicketList.h"
#import "CDZStarsControl.h"
#import "TYWJTextVeiw.h"
#import "TYWJSoapTool.h"
#import "TYWJLoginTool.h"


@interface TYWJCommentController ()<CDZStarsControlDelegate>

/* CDZStarsControl *starControl */
@property (strong, nonatomic) CDZStarsControl *starControl;
/* UILabel *scoreLabel */
@property (strong, nonatomic) UILabel *scoreLabel;

@end

@implementation TYWJCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"评价司机";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"投诉" style:UIBarButtonItemStylePlain target:self action:@selector(comlpaintClicked)];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, kNavBarH + 15.f, ZLScreenWidth - 30.f, 20.f)];
    tipsLabel.textColor = [UIColor lightGrayColor];
    tipsLabel.font = [UIFont systemFontOfSize:14.f];
    tipsLabel.text = [NSString stringWithFormat:@"请对 %@ 司机评价",self.ticket.listInfo.routeName];
    [self.view addSubview:tipsLabel];
    
    CDZStarsControl *starControl = [[CDZStarsControl alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(tipsLabel.frame) + 8.f, 6*26.f, 24.f) stars:5 starSize:CGSizeMake(26.f,24.f) noramlStarImage:[UIImage imageNamed:@"icon_star_hui_13x12_"] highlightedStarImage: [UIImage imageNamed:@"icon_star_cheng_13x12_"]];
    starControl.enabled = NO;
    starControl.enabled = YES;
    starControl.allowFraction = YES;
    starControl.delegate = self;
    [self.view addSubview:starControl];
    _starControl = starControl;
    
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(starControl.frame) + 8.f, starControl.zl_y, 40.f, starControl.zl_height)];
    scoreLabel.textColor = ZLNavTextColor;
    scoreLabel.font = [UIFont systemFontOfSize:20.f];
    scoreLabel.text = @"0";
    [self.view addSubview:scoreLabel];
    self.scoreLabel = scoreLabel;
    
    TYWJComplaintFooter *footer = [[[NSBundle mainBundle] loadNibNamed:@"TYWJComplaintFooter" owner:nil options:nil] lastObject];
    footer.frame = CGRectMake(0, CGRectGetMaxY(starControl.frame) + 8.f, ZLScreenWidth, 150.f);
    footer.tv.backgroundColor = ZLGrayColorWithRGB(248);
    footer.contentView.backgroundColor = footer.tv.backgroundColor;
    footer.backgroundColor = [UIColor whiteColor];
    footer.isRefundTicket = NO;
    footer.zl_height = 265.f;
    footer.tv.phText = @"请输入评价内容";
    [self.view addSubview:footer];
    
    WeakSelf;
    __weak typeof(footer) weakFooter = footer;
    footer.complaintClicked = ^(NSString *reason) {
        if (self.starControl.score == 0) {
            [MBProgressHUD zl_showAlert:@"请对司机打分" afterDelay:2.5f];
            return;
        }
        if (reason.length == 0) {
            [MBProgressHUD zl_showAlert:@"请填写评价内容" afterDelay:2.5f];
            return;
        }
        weakFooter.tv.text = @"";
        [weakFooter.tv showPlaceholder];
        [weakSelf requestCommentWithReason:reason];
    };
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)comlpaintClicked {
    ZLFuncLog;
    TYWJComplaintController *vc = [[TYWJComplaintController alloc] init];
    vc.ticket = self.ticket.listInfo;
    vc.isRefundTicket = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - CDZStarsControlDelegate

/**
 回调星星改变后的分数
 
 @param starsControl 星星组件
 @param score 分数
 */
- (void)starsControl:(CDZStarsControl *)starsControl didChangeScore:(CGFloat)score {
    if (score) {
        self.scoreLabel.text = [NSString stringWithFormat:@"%.01f",score];
    }else {
        self.scoreLabel.text = @"0";
    }
}

#pragma mark - 数据请求

- (void)requestCommentWithReason:(NSString *)reason {
//    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
//    formmater.dateFormat = @"yyyy.MM.dd";
//    NSString *todayStr = [formmater stringFromDate:[NSDate date]];
//    if (![todayStr isEqualToString:self.ticket.listInfo.getupDate]) {
//        [self.view endEditing:YES];
//        [MBProgressHUD zl_showSuccess:@"提交成功，感谢您的评价"];
//        [self.navigationController popViewControllerAnimated:YES];
//        return;
//    }
    reason = [reason stringByReplacingOccurrencesOfString:@"," withString:@"，"];
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <xl>%@</xl>\
                              <pj>%@</pj>\
                              <pjnr>%@</pjnr>\
                              <pjr>%@</pjr>\
                              </%@>",TYWJRequstOnlineComment,TYWJRequestService,self.ticket.listInfo.routeID,@(self.starControl.score),reason,[TYWJLoginTool sharedInstance].phoneNum,TYWJRequstOnlineComment];
    
    WeakSelf;
    [TYWJSoapTool SOAPDataWithSoapBody:soapBodyStr success:^(id responseObject) {
        if (responseObject) {
            NSString *response = responseObject[0][@"NS1:fuwupingjiaResponse"];
            if ([response isEqualToString:@"ok"]) {
                [weakSelf.view endEditing:YES];
                [MBProgressHUD zl_showSuccess:@"提交成功，感谢您的评价"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else {
                [MBProgressHUD zl_showError:@"评价失败,请稍后再试"];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
    }];
}

@end
