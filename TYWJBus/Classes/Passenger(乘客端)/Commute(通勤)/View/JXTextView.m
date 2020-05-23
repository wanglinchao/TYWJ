//
//  JXTextView.m
//  BTBTC
//
//  Created by thls on 2019/7/22.
//  Copyright © 2019 yjy361. All rights reserved.
//

#import "JXTextView.h"

#import <objc/runtime.h>

@implementation JXTextView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tintColor = self.placeholderColor;
    [self resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
//    self.placeholderColor = JXRGBColor(204, 204, 204);
    self.tintColor = self.placeholderColor;
    return [super becomeFirstResponder];
}
- (BOOL)resignFirstResponder
{
//    self.placeholderColor = JXRGBColor(204, 204, 204);
    return [super resignFirstResponder];
}
#pragma mark - 通知
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.textColor = [UIColor blackColor];
        self.placeholderColor = [UIColor grayColor];
        self.font = [UIFont systemFontOfSize:14];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)textDidChange:(NSNotification *)note
{
    [self setNeedsDisplay];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)drawRect:(CGRect)rect
{
    if (self.text.length) return;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = self.font;
    dict[NSForegroundColorAttributeName] = self.placeholderColor;
    
    
    rect.origin.x = 10;
    rect.origin.y = 8;
    rect.size.width = self.zl_width - 2 * rect.origin.x;
    
    [self.placeholder drawInRect:rect withAttributes:dict];
}

#pragma mark - 需要重写的属性
- (void)setPlaceholder:(NSString *__nullable)placeholder
{
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}
- (void)setPlaceholderTextFont:(UIFont *)placeholderTextFont
{
    [super setFont:placeholderTextFont];
    [self setNeedsDisplay];
}
- (void)setText:(NSString *)text{
    [super setText:text];
    [self setNeedsDisplay];
}
- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setNeedsDisplay];
}
@end
