//
//  NSString+Size.m
//  ZLApp
//
//  Created by MacTsin on 16/4/9.
//  Copyright © 2016年 MacTsin. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)sizeWithMaxSize:(CGSize)maxSize font:(CGFloat )font
{
    NSMutableDictionary *attrsDic = [NSMutableDictionary dictionary];
    attrsDic[NSFontAttributeName] = [UIFont systemFontOfSize:font];
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrsDic context:nil].size;
}

+ (NSString *)cachePathWithFileName:(NSString *)filename
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:filename];
//    path = [path stringByAppendingString:@".plist"];
    ZLLog(@"路径---%@",path);
    return path;
}

+ (NSString *)docPathWithFileName:(NSString *)filename {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:filename];
    path = [path stringByAppendingString:@".plist"];
    ZLLog(@"路径---%@",path);
    return path;
}

- (NSMutableAttributedString *)crossLine {
    //添加中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attribtDic];
    return attribtStr;
}

- (NSMutableAttributedString *)underLineWithTextColor:(UIColor *)textColor {
    //添加下划线
    if (!textColor) {
        textColor = [UIColor blackColor];
    }
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSForegroundColorAttributeName : textColor};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attribtDic];
    return attribtStr;
}

- (NSString *)addDoubleQuotationMark {
    return [NSString stringWithFormat:@"\"%@\"",self];;
}
@end
