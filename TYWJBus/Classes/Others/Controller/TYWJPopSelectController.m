//
//  TYWJPopSelectController.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/13.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJPopSelectController.h"
#import "ZLPOPAnimation.h"


static CGFloat const kPickerViewH = 160.f;
static CGFloat const kContentViewH = 200.f;
static CGFloat const kTimeinterval = 0.35f;
static CGFloat const kRowHeight = 30.f;
static CGFloat const kAnimSpeed = 20.f;

@interface TYWJPopSelectController ()<UIPickerViewDelegate,UIPickerViewDataSource>

/* pickerView */
@property (strong, nonatomic) UIPickerView *pickerView;
/* effectView */
@property (strong, nonatomic) UIVisualEffectView *effectView;
/* contentView */
@property (strong, nonatomic) UIView *contentView;
/* dataArray */
@property (strong, nonatomic) NSArray *dataArray;
/* 传入模型要显示的内容的属性名字 */
@property (copy, nonatomic) NSString *pName;
/* selectedModel */
@property (strong, nonatomic) id selectedModel;

@end

@implementation TYWJPopSelectController
#pragma mark - 懒加载
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.frame = CGRectMake(0, self.view.zl_height, self.view.zl_width , kContentViewH + kTabBarH);
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _effectView.alpha = 0;
        _effectView.frame = self.view.bounds;
    }
    return _effectView;
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
#pragma mark - set up view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.effectView];
    [self.view addSubview:self.contentView];
    [self addMenu];
    [self.contentView addSubview:self.pickerView];
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
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

/**
 选中某行
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    id model = self.dataArray[row];
    self.selectedModel = model;
    
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
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(0, 0, self.view.zl_width, kRowHeight);
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = ZLGrayColorWithRGB(51);
        textLabel.font = [UIFont systemFontOfSize:18.f];
        [view addSubview:textLabel];
    }
    UILabel *textLabel = view.subviews[0];
    if (self.pName) {
        id model = self.dataArray[row];
        
        NSString *text = [model valueForKeyPath:self.pName];
        textLabel.text = text;
    }else {
        NSString *text = self.dataArray[row];
        textLabel.text = text;
    }
    
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
    [self touchesBegan:[NSSet set] withEvent:[[UIEvent alloc] init]];
    if ([self.delegate respondsToSelector:@selector(popSelectControllerConfirmClickedWithModel:)]) {
        if (!self.selectedModel) {
            self.selectedModel = self.dataArray[0];
        }
        [self.delegate popSelectControllerConfirmClickedWithModel:self.selectedModel];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   WeakSelf;
    CGRect newF = self.contentView.frame;
    newF.origin.y = self.view.zl_height;
    [ZLPOPAnimation animationWithView:self.contentView fromF:self.contentView.frame toF:newF springSpeed:kAnimSpeed springBounciness:0 completionBlock:^{
        if ([weakSelf.delegate respondsToSelector:@selector(popSelectControllerViewDidClicked)]) {
            [weakSelf.delegate popSelectControllerViewDidClicked];
        }
    }];
    
    [UIView animateWithDuration:kTimeinterval animations:^{
        self.effectView.alpha = 0;
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect newF = self.contentView.frame;
    newF.origin.y = self.view.zl_height - kContentViewH;
    [ZLPOPAnimation animationWithView:self.contentView fromF:self.contentView.frame toF:newF springSpeed:kAnimSpeed springBounciness:0 completionBlock:nil];
    [UIView animateWithDuration:kTimeinterval animations:^{
        self.effectView.alpha = TYWJEffectViewAlpha;
    }];
}

#pragma mark - 外部方法
- (void)setDataArray:(NSArray *)dataArray andPropertyName:(NSString *)pName {
    if (dataArray) {
        self.dataArray = dataArray;
    }
    if (pName) {
        self.pName = pName;
    }
}
@end
