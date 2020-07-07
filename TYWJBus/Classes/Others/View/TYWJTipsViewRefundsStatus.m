//
//  TYWJTipsViewRefunds.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJTipsViewRefundsStatus.h"
#import "TYWJCarProtocolController.h"
@interface TYWJTipsViewRefundsStatus()<UITextViewDelegate>

{
    CGRect tempframe;
}
@property (weak, nonatomic) IBOutlet UIView *numView;

@property (weak, nonatomic) IBOutlet UIButton *jian;
@property (strong, nonatomic) UITextView *textLabel;
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
        _textLabel = [[UITextView alloc] initWithFrame: CGRectMake(0, 0, ZLScreenWidth - 48*2- 40, self.contentView.zl_height)];
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.delegate = self;
        _textLabel.editable = NO;
        _textLabel.scrollEnabled = NO;
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
    if ([[dic objectForKey:@"success"] intValue]) {
        self.titleL.text = @"退款提交成功";
        _textLabel.text = @"我们将根据退款规则，将退款退回到你的支付";
    } else {
        self.titleL.text = @"退款失败";
        NSDictionary * dictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor blackColor]};
        NSString *string = NSLocalizedString(@"已超出退款规则，无法退款，详情查询《购票服务协议》", nil);
        NSMutableAttributedString *conditionsAttributeStr = [[NSMutableAttributedString alloc] initWithString:string attributes:dictionary];
        [conditionsAttributeStr addAttribute:NSLinkAttributeName value:@"testURL" range:[string rangeOfString:NSLocalizedString(@"《购票服务协议》", nil)]];
        _textLabel.attributedText = conditionsAttributeStr;
    }
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if ([URL.absoluteString isEqualToString:@"testURL"]) {
        if (self.buttonSeleted)
        {
            self.buttonSeleted(0);
        }
        TYWJCarProtocolController *vc = [[TYWJCarProtocolController alloc] init];
        vc.type = TYWJCarProtocolControllerTypeTicketingInformation;
        [TYWJCommonTool pushToVc:vc];
    }

    //在这里是可以做一些判定什么的，用来确定对应的操作。
    return NO;
}
@end
