//
//  TYWJRongCloudTool.h
//  TYWJBus
//
//  Created by tywj on 2020/7/6.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJRongCloudTool : NSObject
+ (instancetype)sharedTool;
//登陆融云服务器
- (void)connectWithToken;
//加入融云服务器
- (void)joinChatRoom:(NSString *)roomId;
//退出融云服务器
- (void)quitChatRoom:(NSString *)roomId;
//获取会话列表
- (NSArray *)getConversationList;
@end

NS_ASSUME_NONNULL_END
