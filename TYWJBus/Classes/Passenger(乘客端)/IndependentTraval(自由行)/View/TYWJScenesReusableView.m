//
//  TYWJScenesReusableView.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJScenesReusableView.h"

NSString * const TYWJScenesReusableViewID = @"TYWJScenesReusableViewID";

@interface TYWJScenesReusableView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation TYWJScenesReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
