//
//  TYWJActivityCenter.h
//  TYWJBus
//
//  Created by MacBook on 2018/8/29.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TYWJActivityCenterInfo : NSObject

/* 标题 */
@property (copy, nonatomic) NSString *hdmc;
/* text */
@property (copy, nonatomic) NSString *content;
/* 是否发送短信 */
@property (copy, nonatomic) NSString *isSendMsg;
/* 图片路径 */
@property (copy, nonatomic) NSString *picUrl;
/* 小图路径 */
@property (copy, nonatomic) NSString *nailPicUrl;

@end


@interface TYWJActivityCenter : NSObject

/* text */
@property (copy, nonatomic) NSString *text;
/* 标题 */
@property (copy, nonatomic) NSString *hdmc;
/* info */
@property (strong, nonatomic) TYWJActivityCenterInfo *info;

@end


