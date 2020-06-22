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
    TYWJTripList *model = (TYWJTripList *)Param;
    self.line_name.text = model.line_name;
    self.line_time.text = [NSString stringWithFormat:@"%@    %@",model.line_date,model.line_time];
    self.refundFeeL.text = [NSString stringWithFormat:@"手续费：¥"];
    self.refundAmountL.text = [NSString stringWithFormat:@"退款金额：¥"];
}

@end
