//
//  TYWJDetailActivityController.m
//  TYWJBus
//
//  Created by MacBook on 2018/8/31.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJDetailActivityController.h"
#import "TYWJZYXWebController.h"
#import "TYWJActivityCenter.h"
#import <UIImageView+WebCache.h>

@interface TYWJDetailActivityController ()

/* imgView */
@property (strong, nonatomic) UIImageView *imgView;

@end

@implementation TYWJDetailActivityController

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imgView.contentMode = UIViewContentModeScaleToFill;
        _imgView.userInteractionEnabled = NO;
        _imgView.zl_y = kNavBarH;
        _imgView.zl_height -= kNavBarH;
    }
    return _imgView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    self.navigationItem.title = self.acInfo.hdmc;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imgView];
    
    [MBProgressHUD zl_showMessage:@"加载中,请稍后" toView:self.view];
    WeakSelf;
    NSURL *url = [NSURL URLWithString:[TYWJCommonTool getPicUrlWithPicName:self.acInfo.picUrl path:@"huodong"]];
    [self.imgView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageContinueInBackground progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        [MBProgressHUD zl_showAlert:@"点击查看详情" afterDelay:2.f];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *url = self.acInfo.content;
    if (![url containsString:@"http"]) {
        url = [NSString stringWithFormat:@"http://%@",url];
    }
    TYWJZYXWebController *vc = [[TYWJZYXWebController alloc] init];
    vc.navTitle = self.acInfo.hdmc;
    vc.url = url;
    //    vc.isNotSetInset = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
