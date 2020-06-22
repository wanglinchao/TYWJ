//
//  TYWJDriveRouteInfoView.m
//  TYWJBus
//
//  Created by tywj on 2020/6/12.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJDriveRouteInfoView.h"
@interface TYWJDriveRouteInfoView ()
@property (weak, nonatomic) IBOutlet UILabel *mileageL;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeL;
@property (weak, nonatomic) IBOutlet UILabel *startL;
@property (weak, nonatomic) IBOutlet UILabel *endL;

@end
@implementation TYWJDriveRouteInfoView
- (void)confirgCellWithParam:(id)Param{
    NSDictionary *dic = (NSDictionary *)Param;
    self.mileageL.text = [NSString stringWithFormat:@"%@km",[dic objectForKey:@"mileage"]];
    self.totalTimeL.text = [NSString stringWithFormat:@"%@min",[dic objectForKey:@"totalTime"]];
    self.startL.text = [[dic objectForKey:@"start"] objectForKey:@"name"];
    self.endL.text = [[dic objectForKey:@"end"] objectForKey:@"name"];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
