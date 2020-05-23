//
//  NSObject+ZLDecode.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/1.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZLDecode)

+ (instancetype)zl_objectWithArray:(NSArray *)array;
/**
 copy新对象的属性数据

 @return 要copy的对象，必须和调用者是同一个类才行
 */
#pragma mark -
- (void)zl_setPropertiesWithObject:(id)obj;

#pragma mark - 自定义类的归档解档

- (void)zl_encodeWithCoder:(NSCoder *)aCoder;
- (void)zl_decodeWithCoder:(NSCoder *)aDecoder;

@end
