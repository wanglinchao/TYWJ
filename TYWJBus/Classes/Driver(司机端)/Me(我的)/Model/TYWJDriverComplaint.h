//
//  TYWJDriverComplaint.h
//  TYWJBus
//
//  Created by MacBook on 2019/1/4.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJDriverComplaintInfo : NSObject

/* 评价内容 */
@property (copy, nonatomic) NSString *content;
/* 线路编号 */
@property (copy, nonatomic) NSString *routeNum;
/* 时间 */
@property (copy, nonatomic) NSString *time;
/* rowh */
@property (assign, nonatomic) CGFloat rowH;

@end

@interface TYWJDriverComplaint : NSObject

/* text */
@property (copy, nonatomic) NSString *text;
/* 线路编号 */
@property (copy, nonatomic) NSString *xianlu;
/* TYWJDriverComplaintInfo */
@property (strong, nonatomic) TYWJDriverComplaintInfo *complaintInfo;

@end

NS_ASSUME_NONNULL_END
