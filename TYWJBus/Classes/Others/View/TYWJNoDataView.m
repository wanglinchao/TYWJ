//
//  TYWJNoDataView.m
//  TYWJBus
//
//  Created by tywj on 2020/5/28.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJNoDataView.h"
@interface TYWJNoDataView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end
@implementation TYWJNoDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)confirgCellWithParam:(id)Param{
    NSDictionary *dataDic = (NSDictionary *)Param;
    self.imageV.image = [UIImage imageNamed:[dataDic objectForKey:@"image"]];
    self.titleL.text = [dataDic objectForKey:@"title"];
}
@end
