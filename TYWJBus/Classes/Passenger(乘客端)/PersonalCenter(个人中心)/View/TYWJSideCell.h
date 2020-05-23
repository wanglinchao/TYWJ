//
//  TYWJSideCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/24.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJSideTableModel;

UIKIT_EXTERN NSString * const TYWJSideCellID;

@interface TYWJSideCell : UITableViewCell

/* model */
@property (strong, nonatomic) TYWJSideTableModel *sideModel;
/* 是否显示前段分割线 */
@property (assign, nonatomic) BOOL isShowingFirstLine;
@end
