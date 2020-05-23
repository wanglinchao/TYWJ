//
//  TYWJChangeAvatarCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/11.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJChangeAvatarCell.h"
#import "TYWJChangeCellPlist.h"


NSString * const TYWJChangeAvatarCellID = @"TYWJChangeAvatarCellID";

@interface TYWJChangeAvatarCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation TYWJChangeAvatarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setPlist:(TYWJChangeCellPlist *)plist {
    _plist = plist;
    self.titleLabel.text = plist.title;
    if (plist.isCancel) {
        self.titleLabel.textColor = ZLGrayColorWithRGB(222);
    }
}


@end
