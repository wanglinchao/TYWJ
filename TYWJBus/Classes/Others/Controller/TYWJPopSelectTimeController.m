//
//  TYWJPopSelectTimeController.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/16.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJPopSelectTimeController.h"
#import "ZLPOPAnimation.h"


static CGFloat const kPickerViewH = 160.f;
static CGFloat const kContentViewH = 200.f;
static CGFloat const kTimeinterval = 0.35f;
static CGFloat const kRowHeight = 30.f;
static CGFloat const kAnimSpeed = 20.f;
static NSInteger const kMultiple = 100;

@interface TYWJPopSelectTimeController ()<UIPickerViewDelegate,UIPickerViewDataSource>

/* contentView */
@property (strong, nonatomic) UIView *contentView;
/* pickerView */
@property (strong, nonatomic) UIPickerView *pickerView;

/* selectedRow1 */
@property (assign, nonatomic) NSInteger selectedRow1;
/* selectedRow2 */
@property (assign, nonatomic) NSInteger selectedRow2;

@end

@implementation TYWJPopSelectTimeController
#pragma mark - 懒加载
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.frame = CGRectMake(0, self.view.zl_height, self.view.zl_width , kContentViewH + kTabBarH);
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kContentViewH - kPickerViewH, self.view.zl_width, kPickerViewH)];
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor clearColor];
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupV];
}

- (void)setupV {
    
    self.selectedRow1 = 0;
    self.selectedRow2 = 0;
    
    [self.view addSubview:self.contentView];
    [self addMenu];
    [self.contentView addSubview:self.pickerView];
    
    if (self.defaultTime) {
        [self.pickerView selectRow:(self.defaultTime + kMultiple*24/2) inComponent:0 animated:NO];
        [self.pickerView selectRow:kMultiple*60/2 inComponent:1 animated:NO];
        self.selectedRow1 = self.defaultTime;
    }
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

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 24*kMultiple;
    }
    return 60*kMultiple;
}

/**
 选中某行
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger rowNum = 0;
    
    if (component == 0) {
        rowNum = 24;
        self.selectedRow1 = row%24;
    }else {
        rowNum = 60;
        self.selectedRow2 = row%60;
    }
    //中间位置的相对长度
    NSInteger length = kMultiple/2 * rowNum;
    
    //返回到中间位置
    [pickerView selectRow:row%rowNum + length inComponent:component animated:NO];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return kRowHeight;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = [UIColor clearColor];
        }
    }
    
    if (!view) {
        view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, ZLScreenWidth/2.f, kRowHeight);
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(0, 0, view.zl_width, view.zl_height);
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = ZLGrayColorWithRGB(51);
        textLabel.font = [UIFont systemFontOfSize:18.f];
        [view addSubview:textLabel];
    }
    UILabel *textLabel = view.subviews[0];
    NSString *text = nil;
    if (component == 0) {
        text = [NSString stringWithFormat:@"%02ld",row%24];
    }else {
        text = [NSString stringWithFormat:@"%02ld",row%60];
    }
    
    textLabel.text = text;
    
    return view;
}
#pragma mark - 按钮点击

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
                NSString *time = [NSString stringWithFormat:@"%02ld:%02ld",weakSelf.selectedRow1,weakSelf.selectedRow2];
                weakSelf.confirmClicked(time);
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
