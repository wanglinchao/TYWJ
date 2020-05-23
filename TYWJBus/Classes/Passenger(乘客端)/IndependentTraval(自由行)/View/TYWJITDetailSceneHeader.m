//
//  TYWJITDetailSceneHeader.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJITDetailSceneHeader.h"
#import "ZLScrollPictureView.h"


@interface TYWJITDetailSceneHeader()

@property (weak, nonatomic) IBOutlet UIView *picView;
@property (weak, nonatomic) IBOutlet UIView *contentView;


@end

@implementation TYWJITDetailSceneHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.contentView setRoundViewWithCornerRaidus:6.f];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *view in self.picView.subviews) {
        [view removeFromSuperview];
    }
    NSArray *pics = @[@"rankImg1",@"rankImg1",@"rankImg1"];
    ZLScrollPictureView *picView = [ZLScrollPictureView scrollPicWithPicsName:pics frame:self.picView.bounds pageControlCurrentTintColor:ZLNavTextColor pageContorlTintColor:[UIColor whiteColor]];
    [self.picView addSubview:picView];
}

@end
