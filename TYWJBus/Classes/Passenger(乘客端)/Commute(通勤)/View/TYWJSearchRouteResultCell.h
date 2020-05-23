//
//  TYWJSearchRouteResultCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/7/4.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJSearchReult;


UIKIT_EXTERN NSString * const TYWJSearchRouteResultCellID;

@interface TYWJSearchRouteResultCell : UITableViewCell

/* TYWJSearchReult */
@property (strong, nonatomic) TYWJSearchReult *result;
/* 购买按钮点击 */
@property (copy, nonatomic) void(^purchaseBtnClicked)(TYWJSearchReult *result);


@end
