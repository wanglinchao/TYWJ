//
//  NSObject+ZLDecode.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/1.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "NSObject+ZLDecode.h"
#import <objc/runtime.h>


@implementation NSObject (ZLDecode)

+ (instancetype)zl_objectWithArray:(NSArray *)array {
    
    return [[[self alloc] init] p_zl_objectWithArray:array];
}

- (instancetype)p_zl_objectWithArray:(NSArray *)array {
    // 1.获得所有的成员变量
    unsigned int outCount = 0;
    NSInteger arrCount = array.count;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    NSInteger count = MIN(outCount, arrCount);
    // 2.遍历每一个成员变量
    for (unsigned int i = 0; i<count; i++) {
        Ivar ivar = ivars[i];
        char const *name = ivar_getName(ivar);
        NSString *n = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        id val = array[i];
        [self setValue:val forKeyPath:n];
    }
    
    free(ivars);
    
    
    
    
    
    return self;
}

#pragma mark - copy新对象的属性数据
- (void)zl_setPropertiesWithObject:(id)obj {
    //不是一个类，则返回
    if (![[self class] isEqual:[obj class]]) return;
    
    // 1.获得所有的成员变量
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    if (outCount) {
        // 2.遍历每一个成员变量
        for (unsigned int i = 0; i<outCount; i++) {
            Ivar ivar = ivars[i];
            char const *name = ivar_getName(ivar);
            NSString *n = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            id val = [obj valueForKeyPath:n];
            [self setValue:val forKeyPath:n];
        }
    }
    
    free(ivars);
}


#pragma mark - 自定义类的归档解档

- (void)zl_encodeWithCoder:(NSCoder *)aCoder {
    // 1.获得所有的成员变量
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    if (outCount) {
        // 2.遍历每一个成员变量
        for (unsigned int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            char const *name = ivar_getName(ivar);
            NSString *n = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            id val = [self valueForKeyPath:n];
            [aCoder encodeObject:val forKey:n];
        }
    }
    
    free(ivars);
}

- (void)zl_decodeWithCoder:(NSCoder *)aDecoder {
    // 1.获得所有的成员变量
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    if (outCount) {
        // 2.遍历每一个成员变量
        for (unsigned int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            char const *name = ivar_getName(ivar);
            NSString *n = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            id val = [aDecoder decodeObjectForKey:n];
            [self setValue:val forKey:n];
        }
    }
    
    free(ivars);
}
@end
