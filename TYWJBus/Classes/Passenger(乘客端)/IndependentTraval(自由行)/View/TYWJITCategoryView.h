//
//  TYWJITCategoryView.h
//  TYWJBus
//
//  Created by Harley He on 2018/7/19.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWJITCategoryView : UIView

/* 是否是多行 */
@property (copy, nonatomic) void(^multiRows)(BOOL isMultiRows);

/* categoryClicked */
@property (copy, nonatomic) void(^categoryClicked)(NSString *type,NSInteger index);

@end
