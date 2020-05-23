//
//  TYWJChangeAvatarCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/11.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJChangeCellPlist;

UIKIT_EXTERN NSString * const TYWJChangeAvatarCellID;

@interface TYWJChangeAvatarCell : UITableViewCell

/* plist */
@property (strong, nonatomic) TYWJChangeCellPlist *plist;


@end
