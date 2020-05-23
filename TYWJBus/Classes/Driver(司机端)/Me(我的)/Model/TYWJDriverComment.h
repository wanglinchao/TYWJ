//
//  TYWJDriverComment.h
//  TYWJBus
//
//  Created by MacBook on 2019/1/4.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJDriverCommentInfo : NSObject

/* 评价分数 */
@property (copy, nonatomic) NSString *rating;
/* 评价内容 */
@property (copy, nonatomic) NSString *content;
/* 线路编号 */
@property (copy, nonatomic) NSString *routeNum;
/* text */
@property (copy, nonatomic) NSString *time;
/* rowH */
@property (assign, nonatomic) CGFloat rowH;

@end

@interface TYWJDriverComment : NSObject

/* 评价分数 */
@property (copy, nonatomic) NSString *dengji;
/* text */
@property (copy, nonatomic) NSString *text;
/* commentInfo */
@property (strong, nonatomic) TYWJDriverCommentInfo *commentInfo;

@end

NS_ASSUME_NONNULL_END
