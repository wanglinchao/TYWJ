//
//  TYWJTipsViewRefunds.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJTipsViewRefundsStatus.h"
#import <TTTAttributedLabel.h>
@interface TYWJTipsViewRefundsStatus()<TTTAttributedLabelDelegate>

{
    CGRect tempframe;
}
@property (weak, nonatomic) IBOutlet UIView *numView;

@property (weak, nonatomic) IBOutlet UIButton *jian;
@property (strong, nonatomic) TTTAttributedLabel *textLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@end
@implementation TYWJTipsViewRefundsStatus

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle]loadNibNamed:[NSString stringWithFormat:@"%@",[self class]] owner:nil options:nil] objectAtIndex:0];
        _textLabel = [[TTTAttributedLabel alloc] initWithFrame: CGRectMake(0, 0, self.contentView.zl_width, self.contentView.zl_height)];
        
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.numberOfLines = 0;
        _textLabel.delegate = self;
        _textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:_textLabel];
        tempframe = frame;
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.frame = tempframe;
}
-(void)drawRect:(CGRect)rect
{
    self.frame = tempframe;


    // Drawing code
}
- (IBAction)handnumaction:(UIButton *)sender {

}

#pragma mark - 按钮点击

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setupView];
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    [self setRoundViewWithCornerRaidus:8.f];
}
- (IBAction)handleAction:(UIButton *)sender {
    if (self.buttonSeleted)
    {
        self.buttonSeleted(sender.tag);
    }
}

- (void)confirgCellWithParam:(id)Param{
    NSDictionary *dic = (NSDictionary *)Param;
    NSString *linkText = @"";
    NSString *promptText = @"";
    if ([[dic objectForKey:@"success"] intValue]) {
        self.titleL.text = @"退款提交成功";
        linkText = @"";

        promptText = @"我们将根据退款规则，将退款退回到你的支付";
    }else{
        self.titleL.text = @"退款失败";
        linkText = @"《购票服务协议》";
        promptText = [NSString stringWithFormat:@"已超出退款规则，无法退款，详情查询%@", linkText];
        
    }
    
    

    

    NSRange linkRange = [promptText rangeOfString:linkText];
    
    _textLabel.text = promptText;
    NSDictionary *attributesDic = @{(NSString *)kCTForegroundColorAttributeName : (__bridge id)[UIColor colorWithHexString:@"#1677FF"].CGColor,
                                    (NSString *)kCTUnderlineStyleAttributeName : @(YES)
                                    };
    _textLabel.linkAttributes = attributesDic;
    _textLabel.activeLinkAttributes = attributesDic;
    [_textLabel addLinkToURL:[NSURL URLWithString:@"testURL"] withRange:linkRange];

}
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([url.absoluteString isEqualToString:@"testURL"]) {
//响应点击事件
    }
}
@end
