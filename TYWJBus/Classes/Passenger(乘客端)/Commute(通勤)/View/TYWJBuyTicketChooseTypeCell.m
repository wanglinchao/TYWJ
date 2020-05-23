//
//  TYWJBuyTicketChooseTypeCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/12.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBuyTicketChooseTypeCell.h"

NSString * const TYWJBuyTicketChooseTypeCellID = @"TYWJBuyTicketChooseTypeCellID";

@interface TYWJBuyTicketChooseTypeCell()
@property (weak, nonatomic) IBOutlet UIView *numView;
@property (weak, nonatomic) IBOutlet UIButton *jian;




@end
@implementation TYWJBuyTicketChooseTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.numView.layer.cornerRadius = 10;
    self.numView.layer.borderWidth = 1;
    self.numView.layer.borderColor = [UIColor colorWithHexString:@"#ECECEC"].CGColor;
    [self changeButtonstate];
    // Initialization code
    [self setupView];
}
- (void)changeButtonstate{
    if (self.numLabel.text.intValue == 1) {
           self.jian.userInteractionEnabled = NO;
         [self.jian setTitleColor:[UIColor colorWithHexString:@"#ECECEC"] forState:UIControlStateNormal];
    }else{
        self.jian.userInteractionEnabled = YES;
         [self.jian setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    }
 
    
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
    [self changeButtonstate];
}


@end
