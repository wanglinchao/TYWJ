//
//  TYWJComplaintModel.h
//  TYWJBus
//
//  Created by MacBook on 2019/1/2.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJComplaintModel : NSObject

/* title */
@property (copy, nonatomic) NSString *title;
/* 是否被选中 */
@property (assign, nonatomic) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
