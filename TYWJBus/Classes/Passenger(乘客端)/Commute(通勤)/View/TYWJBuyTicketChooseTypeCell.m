//
//  TYWJBuyTicketChooseTypeCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/12.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBuyTicketChooseTypeCell.h"


@interface TYWJBuyTicketChooseTypeCell()
@property (weak, nonatomic) IBOutlet UIView *numView;
@property (weak, nonatomic) IBOutlet UIButton *jian;




@end
@implementation TYWJBuyTicketChooseTypeCell
+ (instancetype)cellForTableView:(UITableView *)tableView
{
    NSString *className = [NSString stringWithFormat:@"%@",[self class]];
    TYWJBuyTicketChooseTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@ID",className]];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.numView.layer.cornerRadius = 5;
    self.numView.layer.borderWidth = 1;
    self.numView.layer.borderColor = [UIColor colorWithHexString:@"#ECECEC"].CGColor;
    [self changeButtonstate];
    // Initialization code
    [self setupView];
}

- (void)setupView {
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
}
- (IBAction)chooseTimeAction:(id)sender {
    if (self.buttonSeleted)
       {
           self.buttonSeleted(0);
       }

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
    self.buttonSeleted(1);

    [self changeButtonstate];
    [ZLNotiCenter postNotificationName:TYWJTicketNumsDidChangeNoti object:nil];
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

@end
