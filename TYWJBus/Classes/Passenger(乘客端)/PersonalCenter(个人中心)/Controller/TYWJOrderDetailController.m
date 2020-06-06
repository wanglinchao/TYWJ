//
//  TYWJOrderDetailController.m
//  TYWJBus
//
//  Created by tywj on 2020/6/5.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJOrderDetailController.h"
#import "TYWJBottomPurchaseView.h"
#import "TYWJOrderDetail.h"
#import "TYWJCarProtocolController.h"
#import "TYWJPayDetailController.h"
#define ContentViewHeight 712

@interface TYWJOrderDetailController ()
@property (strong, nonatomic) TYWJBottomPurchaseView *bottomView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet UIView *bottomV;
@property (strong, nonatomic) TYWJOrderDetail *dataModel;
@property (weak, nonatomic) IBOutlet UILabel *upL;
@property (weak, nonatomic) IBOutlet UILabel *downL;
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UILabel *startTimeL;
@property (weak, nonatomic) IBOutlet UILabel *order_serial_noL;

@end

@implementation TYWJOrderDetailController
#pragma mark - 懒加载

- (TYWJBottomPurchaseView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[TYWJBottomPurchaseView alloc] initWithFrame:CGRectMake(0, 0, self.bottomV.zl_width, self.bottomV.zl_height)];
        _bottomView.showTips = YES;
        [_bottomView setPrice: @"0"];
        [_bottomView setTipsWithNum:0];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView addTarget:self action:@selector(purchaseClicked)];
        
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.scrollView.contentSize = CGSizeMake(ZLScreenWidth, ContentViewHeight);
    self.bottomV.zl_width = ZLScreenWidth;
    self.bottomV.zl_height += kTabBarH;
    self.contentView.zl_width = ZLScreenWidth;
    [self.bottomV addSubview:self.bottomView];
    [self.scrollView addSubview:self.contentView];
    [self loadData];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)loadData{
    NSString *str = [NSString stringWithFormat:@"http://192.168.2.91:9005/orderinfo/search/order/detail?&orderSerialNo=%@",self.model.order_serial_no];
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:POST WithPath:str WithParams:@{} WithSuccessBlock:^(NSDictionary *dic) {
        NSDictionary *dicc = [dic objectForKey:@"data"];
        if (dicc) {
            self.dataModel = [TYWJOrderDetail mj_objectWithKeyValues:dicc];
            [self setupView];
        }
    } WithFailurBlock:^(NSError *error) {
        [MBProgressHUD zl_showError:@"获取用户信息失败"];
    }];
}
- (void)setupView{
    self.upL.text = self.dataModel.get_on_loc;
    self.downL.text = self.dataModel.get_off_loc;
    self.numL.text = [NSString stringWithFormat:@"%d",self.dataModel.number];
    self.order_serial_noL.text = self.dataModel.order_serial_no;


}
- (void)purchaseClicked{
  TYWJPayDetailController *payVc = [[TYWJPayDetailController alloc] init];
  [TYWJCommonTool pushToVc:payVc];
}
- (IBAction)refundAgreement:(id)sender {
    
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
