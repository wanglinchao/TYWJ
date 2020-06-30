//
//  TYWJBaseController.h
//  TYWJBus
//
//  Created by Harley He on 2018/7/19.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWJBaseController : UIViewController
- (void)showUIRectEdgeNone;
- (void)showNoDataViewWithDic:(NSDictionary *)dic;
- (void)showRequestFailedViewWithImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle btnClicked:(void(^)(void))btnClicked;
@end
