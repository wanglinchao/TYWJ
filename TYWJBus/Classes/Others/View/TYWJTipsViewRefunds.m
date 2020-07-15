//
//  TYWJTipsViewRefunds.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJTipsViewRefunds.h"

@interface TYWJTipsViewRefunds()

{
    CGRect tempframe;
}
@property (weak, nonatomic) IBOutlet UIView *numView;

@property (weak, nonatomic) IBOutlet UIButton *jian;
@property (strong, nonatomic) TYWJTripList *model;
@end
@implementation TYWJTipsViewRefunds

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
    self.numView.layer.cornerRadius = 5;
    self.numView.layer.borderWidth = 1;
    self.numView.layer.borderColor = [UIColor colorWithHexString:@"#ECECEC"].CGColor;
    [self changeButtonstate];

    // Drawing code
}
- (IBAction)handnumaction:(UIButton *)sender {
    int num = [self.numLabel.text intValue];
    switch (sender.tag) {
        case 201:
        {
            num ++;
            self.numLabel.text = [NSString stringWithFormat:@"%d",num];
        }
            break;
            case 200:
        {
            num --;
            self.numLabel.text = [NSString stringWithFormat:@"%d",num];
        }
                      
                break;
        default:
            break;
    }
    [self changeButtonstate];
}
- (void)changeButtonstate{
    if (self.numLabel.text.intValue == 1) {
           self.jian.userInteractionEnabled = NO;
         [self.jian setTitleColor:[UIColor colorWithHexString:@"#ECECEC"] forState:UIControlStateNormal];
    }else{
        self.jian.userInteractionEnabled = YES;
         [self.jian setTitleColor:[UIColor colorWithHexString:@"#B2B2B2"] forState:UIControlStateNormal];
    }
    [self confirgCellWithParam:_model];
}
#pragma mark - 按钮点击

- (void)awakeFromNib {
    [super awakeFromNib];
    self.changePhoneBtn.layer.borderColor = [UIColor colorWithHexString:@"#FED302"].CGColor;
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
    _model = (TYWJTripList *)Param;
    self.line_name.text = _model.line_name;
    self.line_time.text = [NSString stringWithFormat:@"%@    %@",_model.line_date,_model.line_time];
    NSString *timerStr = [NSString stringWithFormat:@"%@ %@",_model.line_date,_model.line_time];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSDate *date = [inputFormatter dateFromString:timerStr];
    long current = [TYWJCommonTool getCurrcenTimeIntervall];
    long time=  (long)[date timeIntervalSince1970]*1000;
    long value = time - current;
    int percentage = 0;
    if (value < 60*1000*10) {
        percentage = 10;
    }
    int refundFee = _model.price*self.numLabel.text.intValue/percentage;
    int refundAmountFee = _model.price*self.numLabel.text.intValue - refundFee;
    self.refundFeeL.text = [NSString stringWithFormat:@"手续费：¥%@",[TYWJCommonTool getPriceStringWithMount:refundFee]];
    self.refundAmountL.text = [NSString stringWithFormat:@"退款金额：¥%@",[TYWJCommonTool getPriceStringWithMount:refundAmountFee]];
}

@end
