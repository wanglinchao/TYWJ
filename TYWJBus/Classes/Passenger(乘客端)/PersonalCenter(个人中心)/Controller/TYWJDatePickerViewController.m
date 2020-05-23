//
//  TYWJDatePickerViewController.m
//  TYWJBus
//
//  Created by tywj on 2019/11/28.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import "TYWJDatePickerViewController.h"
#import "ZLPOPAnimation.h"

static CGFloat const kContentViewH = 200.f;
static CGFloat const kPickerViewH = 160.f;
static CGFloat const kTimeinterval = 0.35f;
static CGFloat const kAnimSpeed = 20.f;

@interface TYWJDatePickerViewController ()
/* contentView */
@property (strong, nonatomic) UIView *contentView;
/* pickerView */
@property (strong, nonatomic) UIDatePicker *datePicker;
/* pickerView */
@property (copy, nonatomic) NSString *startDateStr;
@end

@implementation TYWJDatePickerViewController
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.frame = CGRectMake(0, self.view.zl_height, self.view.zl_width , kContentViewH + kTabBarH);
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kContentViewH - kPickerViewH, self.view.zl_width, kPickerViewH)];
        _datePicker.backgroundColor = [UIColor clearColor];
        
        //设置本地语言
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        //设置日期显示的格式
        _datePicker.datePickerMode = UIDatePickerModeDate;
        //设置能选择的最小日期
        _datePicker.minimumDate = [NSDate date];
        //监听datePicker的ValueChanged事件
        [_datePicker addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        [self valueChange:_datePicker];
    }
    return _datePicker;
}

- (void)valueChange:(UIDatePicker *)datePicker{
    //创建一个日期格式
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //设置日期的显示格式
    fmt.dateFormat = @"yyyy年MM月dd日";
    //将日期转为指定格式显示
    NSString *dateStr = [fmt stringFromDate:datePicker.date];
    self.startDateStr = dateStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.contentView];
    [self addMenu];
    [self.contentView addSubview:self.datePicker];
}

- (void)addMenu {
    CGFloat btnW = 50.0;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(10, 0, btnW, kContentViewH - kPickerViewH);
    [self.contentView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    confirmBtn.frame = CGRectMake(self.view.zl_width - btnW - 10.0, 0, btnW, kContentViewH - kPickerViewH);
    [self.contentView addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *separator = [[UIView alloc] init];
    separator.frame = CGRectMake(0, kContentViewH - kPickerViewH, self.view.zl_width, 0.5);
    separator.backgroundColor = ZLGlobalTextColor;
    [self.contentView addSubview:separator];
}

/**
 取消点击
 */
- (void)cancelBtnClicked {
    [self touchesBegan:[NSSet set] withEvent:[[UIEvent alloc] init]];
}


/**
 确定点击
 */
- (void)confirmBtnClicked {
    [self animHideWithIsConfirm:YES];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self animHideWithIsConfirm:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    WeakSelf;
    CGRect newF = self.contentView.frame;
    newF.origin.y = self.view.zl_height - kContentViewH;
    [ZLPOPAnimation animationWithView:self.contentView fromF:self.contentView.frame toF:newF springSpeed:kAnimSpeed springBounciness:0 completionBlock:nil];
    [UIView animateWithDuration:kTimeinterval animations:^{
        [weakSelf setEffectViewAlpha:TYWJEffectViewAlpha];
    }];
    
}

- (void)animHideWithIsConfirm:(BOOL)isConfirm {
    WeakSelf;
    CGRect newF = self.contentView.frame;
    newF.origin.y = self.view.zl_height;
    [ZLPOPAnimation animationWithView:self.contentView fromF:self.contentView.frame toF:newF springSpeed:kAnimSpeed springBounciness:0 completionBlock:^{
        if (isConfirm) {
            if (weakSelf.confirmClicked) {
                weakSelf.confirmClicked(self.startDateStr);
            }
        }else {
            if (weakSelf.viewClicked) {
                weakSelf.viewClicked();
            }
        }
    }];
    
    [UIView animateWithDuration:kTimeinterval animations:^{
        [weakSelf setEffectViewAlpha:0];
    }];
}

@end
