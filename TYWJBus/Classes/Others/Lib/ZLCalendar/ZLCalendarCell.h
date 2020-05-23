//
//  ZLCalendarCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/7/16.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const ZLCalendarCellID;

@interface ZLCalendarCell : UICollectionViewCell


@property (weak, nonatomic, readonly) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic, readonly) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic, readonly) IBOutlet UILabel *boughtLabel;
/* cell选中状态 */
@property (assign, nonatomic) BOOL selectedStatus;


- (void)selectCellWithStatus:(BOOL)isSelected;

- (void)disableCell;

@end
