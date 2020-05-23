//
//  ZLPhoneDevice.h
//  TYWJBus
//
//  Created by MacBook on 2018/10/10.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,DeviceType) {
    Unknown = 0,
    Simulator,
    IPhone_1G,          //基本不用
    IPhone_3G,          //基本不用
    IPhone_3GS,         //基本不用
    IPhone_4,           //基本不用
    IPhone_4s,          //基本不用
    IPhone_5,
    IPhone_5C,
    IPhone_5S,
    IPhone_SE,
    IPhone_6,
    IPhone_6P,
    IPhone_6s,
    IPhone_6s_P,
    IPhone_7,
    IPhone_7P,
    IPhone_8,
    IPhone_8P,
    IPhone_X = 10010,
    IPhone_XS = 10011,
    IPhone_XS_MAX = 10012,
    IPhone_XR = 10013
};
    
@interface ZLPhoneDevice : NSObject

+ (DeviceType)deviceType;

@end

NS_ASSUME_NONNULL_END
