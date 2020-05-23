//
//  NSObject+ZLAlertView.h
//  HuLaQuan
//
//  Created by Harley He on 2017/6/21.
//  Copyright © 2017年 hzl All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZLAlertView)

- (void)alertWithTitle:(NSString *)title message:(NSString *)msg finish:(void (^)(void))clickOKblock;

@end
