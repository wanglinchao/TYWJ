//
//  TYWJRouteCalloutView.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/21.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJRouteCalloutView.h"
#import "TYWJSubRouteList.h"
#import "TYWJTriangleView.h"

#import "ZLPopoverView.h"
#import <IDMPhotoBrowser.h>

@interface TYWJRouteCalloutView()

@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *stationBtn;
@property (weak, nonatomic) IBOutlet UIButton *gowhereBtn;
@end

@implementation TYWJRouteCalloutView

- (void)awakeFromNib {
    [super awakeFromNib];

    
    self.backgroundColor = [UIColor whiteColor];
    
    [self.timeBtn setTitle:[NSString stringWithFormat:@"预计 %@",[NSString stringWithFormat:@"预计 %@",_routeListInfo.estimatedTime]] forState:UIControlStateNormal];
    [self.stationBtn setTitle:_routeListInfo.station forState:UIControlStateNormal];
}

- (void)setRouteListInfo:(TYWJSubRouteListInfo *)routeListInfo {
    _routeListInfo = routeListInfo;
    
    [self.timeBtn setTitle:[NSString stringWithFormat:@"预计 %@",_routeListInfo.estimatedTime] forState:UIControlStateNormal];
    [self.stationBtn setTitle:_routeListInfo.routeNum forState:UIControlStateNormal];
    
}
- (IBAction)btnClicked:(id)sender {
    ZLFuncLog;
    
    [[ZLPopoverView sharedInstance] showSelectMapViewWithLocation:CGPointMake(self.routeListInfo.longitude.floatValue, self.routeListInfo.latitude.floatValue)];
}


- (IBAction)checkStationPic:(UIButton *)sender {
    ZLFuncLog;
    if (self.routeListInfo.stationPicUrl && ![self.routeListInfo.stationPicUrl isEqualToString:@""]) {
        NSString *urlStr = [TYWJCommonTool getPicUrlWithPicName:self.routeListInfo.stationPicUrl path:@"img"];
        
        NSArray *photosURL = @[[NSURL URLWithString:urlStr]];
        
        NSArray *photos = [IDMPhoto photosWithURLs:photosURL];
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos animatedFromView:sender];
        browser.displayActionButton = NO;
        browser.scaleImage = sender.currentImage;
        browser.dismissOnTouch = YES;
        browser.displayDoneButton = NO;
        [TYWJCommonTool presentToVc:browser];
        return;
    }

    [MBProgressHUD zl_showAlert:@"暂无站点图片" afterDelay:1.5f];
}


- (IBAction)checkStationInfoClicked:(id)sender {
    ZLFuncLog;
        [MBProgressHUD zl_showAlert:@"暂无线路信息" afterDelay:1.5f];
}

@end
