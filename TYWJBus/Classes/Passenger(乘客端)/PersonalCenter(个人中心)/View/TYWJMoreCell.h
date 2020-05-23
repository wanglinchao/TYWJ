//
//  TYWJMoreCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/26.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJMoreCellList;

UIKIT_EXTERN NSString * const TYWJMoreCellID;

@interface TYWJMoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIView *sepLine;


/* cellList */
@property (strong, nonatomic) TYWJMoreCellList *cellList;
@end
