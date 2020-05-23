//
//  TYWJRankView.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/20.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJRankView.h"
#import "TYWJTipsLabel.h"

@implementation TYWJRankView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake(10.f, 6.f, self.zl_width - 20.f, self.zl_height - 40.f);
    [imgView setRoundViewWithCornerRaidus:6.f];
    imgView.image = [UIImage imageNamed:self.img];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imgView];
    
    TYWJTipsLabel *rankLabel = [TYWJTipsLabel tipsLabelWithFrame:CGRectMake(15.f, 0, 55.f, 20.f)];
    rankLabel.backgroundColor = ZLColorWithRGB(252, 50, 57);
    rankLabel.text = self.rank;
    [imgView addSubview:rankLabel];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.text = self.title;
    titleLabel.frame = CGRectMake(10.f, 0, self.zl_width - 20.f, 20.f);
    titleLabel.zl_centerY = self.zl_height - 15.f;
    [self addSubview:titleLabel];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.viewClicked) {
        ZLFuncLog;
        self.viewClicked();
    }
}

@end
