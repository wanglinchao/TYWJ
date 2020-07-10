//
//  TYWJRongCloudTool.m
//  TYWJBus
//
//  Created by tywj on 2020/7/6.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJRongCloudTool.h"
#import <RongIMLib/RongIMLib.h>
static TYWJRongCloudTool *_instance = nil;
@interface TYWJRongCloudTool ()<RCIMClientReceiveMessageDelegate>
@end
@implementation TYWJRongCloudTool
+ (instancetype)sharedTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[TYWJRongCloudTool alloc] init];
    });
    return _instance;
}
- (void)connectWithToken{
    NSString *token = [ZLUserDefaults objectForKey:@"rongyun_token"];
    if ([TYWJCommonTool isBlankString:token]) {
        return;
    }
    [[RCIMClient sharedRCIMClient] connectWithToken:token
                                           dbOpened:^(RCDBErrorCode code) {
    }
                                            success:^(NSString *userId) {
        NSArray *arr = [self getConversationList];
        NSLog(@"融云=======登陆成功");
    }
                                              error:^(RCConnectErrorCode status) {
        NSLog(@"融云=======登陆失败");
        
    }];
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
}
- (void)joinChatRoom:(NSString *)roomId{
    [[RCIMClient sharedRCIMClient] joinChatRoom:roomId
                                   messageCount:20
                                        success:^{
        NSLog(@"融云=======进入聊天室成功");
    }
                                          error:^(RCErrorCode status) {
        NSLog(@"融云=======进入聊天室失败");
        
    }];
}
- (void)quitChatRoom:(NSString *)roomId{
    [[RCIMClient sharedRCIMClient] quitChatRoom:roomId success:^{
        NSLog(@"融云=======退出聊天室成功");
        
    } error:^(RCErrorCode status) {
        NSLog(@"融云=======退出聊天室失败");
        
    }];
}
- (void)onReceived:(RCMessage *)message
              left:(int)nLeft
            object:(id)object {
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *testMessage = (RCTextMessage *)message.content;
        NSLog(@"融云=======消息内容：%@", testMessage.content);
        [ZLNotiCenter postNotificationName:TYWJReceiveCarLocationNoti object:testMessage.content];
    }
    NSLog(@"还剩余的未接收的消息数：%d", nLeft);
}
- (NSArray *)getConversationList{
    return [[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE)]];
}
@end
