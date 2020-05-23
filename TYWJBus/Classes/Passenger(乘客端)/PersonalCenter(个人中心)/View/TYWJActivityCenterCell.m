//
//  TYWJActivityCenterCell.m
//  TYWJBus
//
//  Created by Harllan He on 2018/5/30.
//  Copyright © 2018 Harllan He. All rights reserved.
//

#import "TYWJActivityCenterCell.h"
#import "TYWJActivityCenter.h"
#import <UIImageView+WebCache.h>


NSString * const TYWJActivityCenterCellID = @"TYWJActivityCenterCellID";

@interface TYWJActivityCenterCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewH;

@end

@implementation TYWJActivityCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}

- (void)setupView {
//    self.titleLabel.text = self.acInfo.content;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setAcInfo:(TYWJActivityCenterInfo *)acInfo {
    _acInfo = acInfo;
    
    WeakSelf;
    self.titleLabel.text = self.acInfo.hdmc;
    if (acInfo.nailPicUrl && ![acInfo.nailPicUrl isEqualToString:@""]) {
        NSURL *url = [NSURL URLWithString:[TYWJCommonTool getPicUrlWithPicName:acInfo.nailPicUrl path:@"huodong"]];
        [self.imgView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            CGFloat rate = image.size.width/weakSelf.imgView.zl_width;
            weakSelf.imgViewH.constant *= rate;
        }];
    }
    
}

@end
