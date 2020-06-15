//
//  TYWJTableViewControllerCell.m
//  TYWJBus
//
//  Created by tywj on 2020/6/11.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJDriverPassegerCell.h"
#import "TYWJPassengerInfo.h"
@interface TYWJDriverPassegerCell ()
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UILabel *serialNoL;


@end
@implementation TYWJDriverPassegerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellForTableView:(UITableView *)tableView
{
    NSString *className = [NSString stringWithFormat:@"%@",[self class]];
    TYWJDriverPassegerCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@ID",className]];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil] firstObject];
    }
    return cell;
}
-(void)confirgCellWithParam:(id)Param{
    TYWJPassengerInfo *model = (TYWJPassengerInfo*)Param;
    self.phoneL.text = model.passenger_phone;
    self.serialNoL.text = model.order_serial_no;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
