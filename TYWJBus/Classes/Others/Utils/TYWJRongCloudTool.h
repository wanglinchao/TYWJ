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
- (void)joinChatRoom:(NSString *)roomId;
- (void)quitChatRoom:(NSString *)roomId;
- (void)connectWithToken;
- (NSArray *)getConversationList;
@end

NS_ASSUME_NONNULL_END