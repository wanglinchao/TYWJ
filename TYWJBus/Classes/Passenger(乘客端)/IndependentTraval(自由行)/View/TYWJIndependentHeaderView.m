//
//  TYWJIndependentHeaderView.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/18.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJIndependentHeaderView.h"
#import "TYWJCommuteHeaderView.h"
#import "TYWJITCategoryView.h"
#import "TYWJRankView.h"
#import "TYWJITCategoryController.h"
#import "TYWJITDetailSceneController.h"
#import "TYWJHotScenesRankingController.h"
#import "TYWJChooseSceneController.h"
#import "TYWJNavigationController.h"


NSString * const TYWJIndependentHeaderViewID = @"TYWJIndependentHeaderViewID";

@interface TYWJIndependentHeaderView()

@property (weak, nonatomic) IBOutlet TYWJCommuteHeaderView *selectStationsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryViewH;
@property (weak, nonatomic) IBOutlet TYWJITCategoryView *categoryView;
@property (weak, nonatomic) IBOutlet TYWJRankView *rankView1;
@property (weak, nonatomic) IBOutlet TYWJRankView *rankView2;
@property (weak, nonatomic) IBOutlet TYWJRankView *rankView3;


@end

@implementation TYWJIndependentHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}

- (void)setupView {
    [self.selectStationsView setShowShadow:YES];
    
    self.categoryView.multiRows = ^(BOOL isMultiRows) {
        if (isMultiRows) {
            self.categoryViewH.constant = 200.f;
        }else {
            self.categoryViewH.constant = 110.f;
        }
    };
    
    self.rankView1.img = @"rankImg1";
    self.rankView1.title = @"漫花庄园";
    self.rankView1.rank = @"Top 1";
    self.rankView2.img = @"rankImg2";
    self.rankView2.title = @"都江堰景区";
    self.rankView2.rank = @"Top 2";
    self.rankView3.img = @"rankImg3";
    self.rankView3.title = @"碧峰峡野生动物园";
    self.rankView3.rank = @"Top 3";
    
    
    self.categoryView.categoryClicked = ^(NSString *type, NSInteger index) {
        TYWJITCategoryController *categoryVc = [[TYWJITCategoryController alloc] init];
        categoryVc.type = type;
        [TYWJCommonTool pushToVc:categoryVc];
    };
    
    self.rankView1.viewClicked = ^{
        TYWJITDetailSceneController *detailVc = [[TYWJITDetailSceneController alloc] init];
        [TYWJCommonTool pushToVc:detailVc];
    };
    self.rankView2.viewClicked = ^{
        TYWJITDetailSceneController *detailVc = [[TYWJITDetailSceneController alloc] init];
        [TYWJCommonTool pushToVc:detailVc];
    };
    self.rankView3.viewClicked = ^{
        TYWJITDetailSceneController *detailVc = [[TYWJITDetailSceneController alloc] init];
        [TYWJCommonTool pushToVc:detailVc];
    };
    
    [self.selectStationsView setGetupPlaceholder:@"出发地"];
    [self.selectStationsView setGetdownPlaceholder:@"目的地"];
    self.selectStationsView.getupBtnClicked = ^{
        [self showChooseSceneVcWithType:NO];
    };
    self.selectStationsView.getdownBtnClicked = ^{
        [self showChooseSceneVcWithType:YES];
    };
}


- (void)showChooseSceneVcWithType:(BOOL)isGetdown {
    TYWJChooseSceneController *vc = [[TYWJChooseSceneController alloc] init];
    TYWJNavigationController *nav = [[TYWJNavigationController alloc] initWithRootViewController:vc];
    vc.isGetdown = isGetdown;
    [TYWJCommonTool presentToVc:nav];
}

- (IBAction)checkMoreClicked:(id)sender {
    ZLFuncLog;
    
    TYWJHotScenesRankingController *rankVc = [[TYWJHotScenesRankingController alloc] init];
    [TYWJCommonTool pushToVc:rankVc];
}

@end
