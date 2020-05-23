//
//  TYWJCheckoutNoRoute.m
//  TYWJBus
//
//  Created by Harllan He on 2018/5/31.
//  Copyright © 2018 Harllan He. All rights reserved.
//

#import "TYWJCheckoutNoRoute.h"
#import "TYWJBorderButton.h"
#import "TYWJStationToStationView.h"

@interface TYWJCheckoutNoRoute()

@property (weak, nonatomic) IBOutlet UIView *s2sBgView;
/* s2sView */
@property (weak, nonatomic) TYWJStationToStationView *s2sView;
@property (weak, nonatomic) IBOutlet TYWJBorderButton *applyBtn;

@end

@implementation TYWJCheckoutNoRoute

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupView];
}

- (void)setupView {
    self.backgroundColor = ZLGlobalBgColor;
    
    TYWJStationToStationView *s2sView = [[TYWJStationToStationView alloc] initWithFrame:self.s2sBgView.bounds];
    [self.s2sBgView addSubview:s2sView];
    self.s2sView = s2sView;
    
}
#pragma mark -按钮点击

- (IBAction)applyRouteClicked:(id)sender {
    if (self.btnClicked) {
        self.btnClicked();
    }
}

- (void)setGetupText:(NSString *)getupText {
    _getupText = getupText;
    self.s2sView.getupTF.placeholder = getupText;
}

- (void)setGetdownText:(NSString *)getdownText {
    _getdownText = getdownText;
    
    self.s2sView.getdownTF.placeholder = getdownText;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.applyBtn setRoundViewWithCornerRaidus:8.f];
}

@end
