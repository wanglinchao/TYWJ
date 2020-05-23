//
//  ZLPopoverView.m
//  YunDuoYouBao
//
//  Created by Harley He on 18/11/2017.
//  Copyright © 2017 GY. All rights reserved.
//

#import "ZLPopoverView.h"
#import "TYWJSideColumController.h"
#import "TYWJTipsController.h"
#import "TYWJChangeAvatarController.h"
#import "TYWJPopSelectController.h"
#import <IDMPhotoBrowser.h>
#import "TYWJPopSelectTimeController.h"
#import "ZLPopBubbleController.h"
#import "TYWJSelectMapController.h"
#import "TYWJPopNotiController.h"
#import "TYWJDriverSelectCarController.h"
#import "TYWJDatePickerViewController.h"


static UIWindow *window_ = nil;
static ZLPopoverView *_instance = nil;

@interface ZLPopoverView()<NSCopying,TYWJPopSelectControllerDelegate>

/* popSelectBlock */
@property (copy, nonatomic) void(^confirmClickedModel)(id model);

@end

@implementation ZLPopoverView

#pragma mark - 单例
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZLPopoverView alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

#pragma mark - 各方法

- (void)show {
    window_ = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window_.windowLevel = UIWindowLevelNormal;
    window_.backgroundColor = [UIColor clearColor];
    window_.hidden = NO;
    
    UIButton *coverBtn = [[UIButton alloc] initWithFrame:window_.bounds];
    coverBtn.backgroundColor = [UIColor clearColor];
    [coverBtn addTarget:self action:@selector(tapWindow:) forControlEvents:UIControlEventTouchUpInside];
    [window_ addSubview:coverBtn];
}
- (void)tapWindow:(UIButton *)btn {
    [self hide];
}
- (void)hide {
    window_.rootViewController = nil;
    window_.hidden = YES;
    window_ = nil;
    
}

#pragma mark - 显示sideview
- (void)showSideView {
    [self show];
    
    TYWJSideColumController *sideVc = [[TYWJSideColumController alloc] init];
    window_.rootViewController = sideVc;
    WeakSelf;
    sideVc.viewClicked = ^{
        [weakSelf hide];
    };
}

#pragma mark - 显示tips view
- (void)showTipsViewWithTips:(NSString*)tips leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle RegisterClicked:(void(^)(void))registerClicked {
    [self show];
    
    TYWJTipsController *tipsVc = [[TYWJTipsController alloc] init];
    window_.rootViewController = tipsVc;
    [tipsVc setTips:tips leftTitle:leftTitle rightTitle:rightTitle];
    WeakSelf;
    tipsVc.viewClicked = ^(BOOL isRegisterClicked){
        [weakSelf hide];
        if (isRegisterClicked && registerClicked) {
            registerClicked();
        }
    };
}

- (void)showSingleBtnViewWithTips:(NSString *)tips {
    [self showSingleBtnViewWithTips:tips confirmClicked:nil];
}

- (void)showSingleBtnViewWithTips:(NSString *)tips confirmClicked:(void (^)(void))confirmClicked {
    [self show];
    
    TYWJTipsController *tipsVc = [[TYWJTipsController alloc] init];
    window_.rootViewController = tipsVc;
    [tipsVc setSingleBtnWithTips:tips];
    
    WeakSelf;
    tipsVc.viewClicked = ^(BOOL isRegisterClicked){
        [weakSelf hide];
        if (confirmClicked) {
            confirmClicked();
        }
    };
}

#pragma mark - 显示选择头像view
- (void)showChangeAvatarView {
    [self show];
    
    TYWJChangeAvatarController *vc = [[TYWJChangeAvatarController alloc] init];
    window_.rootViewController = vc;
    WeakSelf;
    vc.viewClicked = ^{
        [weakSelf hide];
    };
}

#pragma mark - 显示PopSelectView
- (void)showPopSelectViewWithDataArray:(NSArray *)dataArray andProertyName:(NSString *)pName confirmClicked:(void (^)(id))confirmClicked {
    if (dataArray) {
        [self show];
        
        TYWJPopSelectController *vc = [[TYWJPopSelectController alloc] init];
        vc.delegate = self;
        [vc setDataArray:dataArray andPropertyName:pName];
        if (confirmClicked) {
            self.confirmClickedModel = confirmClicked;
        }
        window_.rootViewController = vc;
    }
}

- (void)showPopSelecteTimeViewWithSelectedTime:(NSInteger)selectedTime ConfirmClicked:(void (^)(NSString *))confirmClicked {
    [self show];
    
    WeakSelf;
    TYWJPopSelectTimeController *vc = [[TYWJPopSelectTimeController alloc] init];
    vc.defaultTime = selectedTime;
    window_.rootViewController = vc;
    vc.viewClicked = ^{
        [weakSelf hide];
    };
    vc.confirmClicked = ^(NSString *time) {
        [weakSelf hide];
        if (confirmClicked) {
            confirmClicked(time);
        }
    };
}

- (void)showPopDatePickerWithSelectedDate:(NSInteger)selectedDate ConfirmClicked:(void (^)(NSString *))confirmClicked
{
    [self show];
    
    WeakSelf;
    TYWJDatePickerViewController *vc = [[TYWJDatePickerViewController alloc] init];
    window_.rootViewController = vc;
    vc.viewClicked = ^{
        [weakSelf hide];
    };
    vc.confirmClicked = ^(NSString *time) {
        [weakSelf hide];
        if (confirmClicked) {
            confirmClicked(time);
        }
    };
}

#pragma mark - TYWJPopSelectControllerDelegate

- (void)popSelectControllerViewDidClicked {
    [self hide];
    self.confirmClickedModel = nil;
}

- (void)popSelectControllerConfirmClickedWithModel:(id)model {
    if (self.confirmClickedModel) {
        self.confirmClickedModel(model);
    }
}

#pragma mark - showCheckAvatarViewWithPicture
- (void)showCheckAvatarViewWithPicture:(id)pic sender:(UIButton *)sender {
    if (!pic) {
        ZLLog(@"传入的pic为空");
        return;
    }
    
    NSArray *images = @[pic];
    NSArray *photos = [IDMPhoto photosWithImages:images];
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos animatedFromView:sender];
    browser.displayActionButton = NO;
    browser.dismissOnTouch = YES;
    browser.displayDoneButton = NO;
    browser.scaleImage = pic;
    [TYWJCommonTool presentToVc:browser];
}

#pragma mark - 显示popBubbleView
- (void)showPopBubbleViewWithView:(UIView *)view showingView:(UIView *)showingView showingViewH:(CGFloat)showingViewH {
    [self show];
    
    WeakSelf;
    ZLPopBubbleController *popBubbleVc = [ZLPopBubbleController popBubbleWithView:view showingView:showingView showingViewH:showingViewH];
    window_.rootViewController = popBubbleVc;
    popBubbleVc.viewClicked = ^{
        [weakSelf hide];
    };
}

- (void)showPopBubbleViewWithView:(UIView *)view showingView:(UIView *)showingView {
    [self showPopBubbleViewWithView:view showingView:showingView showingViewH:0];
}

#pragma mark - 显示选择地图view
- (void)showSelectMapViewWithLocation:(CGPoint)location {
    [self show];
    
    WeakSelf;
    TYWJSelectMapController *vc = [[TYWJSelectMapController alloc] init];
    vc.location = location;
    window_.rootViewController = vc;
    vc.viewClicked = ^{
        [weakSelf hide];
    };
}

#pragma mark - showITNotiView
- (void)showITNotiView {
    [self show];
    WeakSelf;
    TYWJPopNotiController *vc = [[TYWJPopNotiController alloc] init];
    vc.viewClicked = ^{
        [weakSelf hide];
    };
    window_.rootViewController = vc;
}

//#import "TYWJDriverSelectCarController.h"
- (void)showChooseCarLicenseViewWithCarLicenses:(NSArray *)carLicenses cellSelected:(void (^)(NSString *))cellSelected {
    [self show];
    WeakSelf;
    TYWJDriverSelectCarController *vc = [[TYWJDriverSelectCarController alloc] init];
    vc.carLicenses = carLicenses;
    vc.viewClicked = ^{
        [weakSelf hide];
    };
    vc.cellSeleted = ^(NSString * _Nonnull cl) {
        if (cellSelected) {
            cellSelected(cl);
        }
    };
    window_.rootViewController = vc;
}
@end
