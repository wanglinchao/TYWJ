//
//  TYWJBanerModel.h
//  TYWJBus
//
//  Created by panjiulong on 2020/4/28.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJBanerModel : NSObject
/* 是否可以跳转 */
@property (assign, nonatomic) NSInteger type;
/* 图片地址 */
@property (strong, nonatomic) NSString *url;
/* 跳转地址 */
@property (strong, nonatomic) NSString *path;
/* 是否可以跳转 */
@property (assign, nonatomic) BOOL isJump;
@end

NS_ASSUME_NONNULL_END
