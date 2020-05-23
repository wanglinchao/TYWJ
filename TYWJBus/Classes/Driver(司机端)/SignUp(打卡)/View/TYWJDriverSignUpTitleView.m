//
//  TYWJDriverSignUpTitleView.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/24.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJDriverSignUpTitleView.h"
#import "TYWJSelectDateController.h"


@interface TYWJDriverSignUpTitleView()

/* titleLabel */
@property (strong, nonatomic) UILabel *titleLabel;
/* dateBtn */
@property (strong, nonatomic) UIButton *dateBtn;

@end

@implementation TYWJDriverSignUpTitleView

#pragma mark - lazy loading
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.zl_width, self.zl_height/2.f)];
        _titleLabel.font = [UIFont systemFontOfSize:16.f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)dateBtn {
    if (!_dateBtn) {
        _dateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.titleLabel.zl_height, self.zl_width, self.titleLabel.zl_height)];
        _dateBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_dateBtn addTarget:self action:@selector(dateBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        //▼
    }
    return _dateBtn;
}
#pragma mark - set up view
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)titleViewWithSize:(CGSize)size {
    TYWJDriverSignUpTitleView *titleView = [[TYWJDriverSignUpTitleView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    titleView.backgroundColor = [UIColor clearColor];
    [titleView addSubview:titleView.titleLabel];
    [titleView addSubview:titleView.dateBtn];
    return titleView;
}

- (void)setTitle:(NSString *)title {
    if (title) {
        self.titleLabel.text = title;
    }
}

- (void)setDateTitle:(NSString *)title {
    if (title) {
        [self.dateBtn setTitle:[NSString stringWithFormat:@"%@ ▼",title] forState:UIControlStateNormal];
    }
}

#pragma mark - 按钮点击

- (void)dateBtnClicked {
    ZLFuncLog;
    TYWJSelectDateController *vc = [[TYWJSelectDateController alloc] init];
    NSString *dateString = [[self.dateBtn titleForState:UIControlStateNormal] stringByReplacingOccurrencesOfString:@" ▼" withString:@""];
    vc.currentDateString = dateString;
    [TYWJCommonTool pushToVc:vc];
    
    WeakSelf;
    vc.dateSelected = ^(NSString * _Nonnull dateString) {
        [weakSelf setDateTitle:dateString];
        if (weakSelf.dateUpdated) {
            weakSelf.dateUpdated(dateString);
        }
    };
}
@end
