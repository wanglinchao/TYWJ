//
//  TYWJRongCloudTool.m
//  TYWJBus
//
//  Created by tywj on 2020/7/6.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJRongCloudTool.h"
#import <RongIMLib/RongIMLib.h>
@interface TYWJRongCloudTool ()<RCIMClientReceiveMessageDelegate>

@end
@implementation TYWJRongCloudTool
+ (void)connectWithToken:(NSString *)token{
    [[RCIMClient sharedRCIMClient] connectWithToken:token
    dbOpened:^(RCDBErrorCode code) {}
     success:^(NSString *userId) {}
       error:^(RCConnectErrorCode status) {}];
    
    
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];

}
- (void)onReceived:(RCMessage *)message
              left:(int)nLeft
            object:(id)object {
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *testMessage = (RCTextMessage *)message.content;
        NSLog(@"消息内容：%@", testMessage.content);
    }

    NSLog(@"还剩余的未接收的消息数：%d", nLeft);
}
+ (NSArray *)getConversationList{
    return [[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE)]];
}
@end
