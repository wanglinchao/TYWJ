//
//  TYWJApplyDetailRouteController.h
//  TYWJBus
//
//  Created by tywj on 2020/3/13.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJRouteListInfo;
@class TYWJApplyListInfo;
NS_ASSUME_NONNULL_BEGIN

@interface TYWJApplyDetailRouteController : UIViewController
/* routeListInfo */
@property (copy, nonatomic) TYWJRouteListInfo *routeListInfo;
/* 是否是线路详情页面 */
@property (assign, nonatomic) BOOL isDetailRoute;
@property (copy, nonatomic) NSString *kind;
/* ppid */
@property (copy, nonatomic) NSString *ppid;
/* sbid */
@property (copy, nonatomic) NSString *sbid;
/* sbState */
@property (copy, nonatomic) NSString *sbState;
/* xbid */
@property (copy, nonatomic) NSString *xbid;
/* xbState */
@property (copy, nonatomic) NSString *xbState;
/* 线路状态 */
@property (copy, nonatomic) NSString *status;

@property (strong, nonatomic) TYWJApplyListInfo *applyListInfo;
@end

NS_ASSUME_NONNULL_END
