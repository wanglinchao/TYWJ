//
//  TYWJSearchModel.h
//  TYWJBus
//
//  Created by Harllan He on 2018/5/31.
//  Copyright © 2018 Harllan He. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN CGFloat const TYWJSearchLabelFont;

@interface TYWJSearchModel : NSObject

/* title */
@property (copy, nonatomic) NSString *title;
/* itemW */
@property (assign, nonatomic) CGFloat itemW;

@end
