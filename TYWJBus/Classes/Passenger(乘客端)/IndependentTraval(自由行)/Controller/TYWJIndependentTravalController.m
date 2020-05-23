//
//  TYWJIndependentTravalController.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/18.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJIndependentTravalController.h"
#import "TYWJUsableCitiesController.h"



@interface TYWJIndependentTravalController()


@end

@implementation TYWJIndependentTravalController
#pragma mark - 懒加载


#pragma mark - set up view
- (void)dealloc {
    ZLFuncLog;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadNoDataViewWithImg:@"icon_no_ticket" tips:@"您的自由行暂无数据哦,\n快去体验直通车吧~~" btnTitle:nil isHideBtn:YES];
}


#pragma mark - 显示无数据页面
- (void)loadNoDataViewWithImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle isHideBtn:(BOOL)isHideBtn {
    [TYWJCommonTool loadNoDataViewWithImg:img tips:tips btnTitle:btnTitle isHideBtn:isHideBtn showingVc:self];
    self.navigationItem.title = @"户外游";

}



@end
