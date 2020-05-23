//
//  TYWJScenesRankingCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/7/20.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN NSString * const TYWJScenesRankingCellID;

@interface TYWJScenesRankingCell : UITableViewCell

/* rankingImg */
@property (copy, nonatomic) NSString *rankingImg;
/* rankingTitle */
@property (copy, nonatomic) NSString *rankingTitle;

@end
