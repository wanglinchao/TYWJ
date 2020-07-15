//
//  TYWJChooseUserTypeView.m
//  TYWJBus
//
//  Created by tywj on 2020/6/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJChooseUserTypeView.h"
@interface TYWJChooseUserTypeView ()
@property (weak, nonatomic) IBOutlet UIButton *passengeBtn;
@property (weak, nonatomic) IBOutlet UIButton *driveBtn;
@property (weak, nonatomic) IBOutlet UILabel *passageBottomL;
@property (weak, nonatomic) IBOutlet UILabel *driveBottomL;

@end
@implementation TYWJChooseUserTypeView
- (IBAction)chooseDrive:(UIButton *)sender {
    switch (sender.tag - 200) {
        case 0:
            [self chooseType:NO];
            break;
        case 1:
            [self chooseType:YES];
            break;
        default:
            break;
    }
}

-(void)chooseType:(BOOL)isDrive{
    if (isDrive) {
        SAVEISDRIVER(YES);
        [self.passengeBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [self.driveBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        
        self.driveBottomL.backgroundColor = kMainYellowColor;
        self.passageBottomL.backgroundColor = [UIColor clearColor];
    } else{
        SAVEISDRIVER(NO);
        
        
        
        [self.passengeBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [self.driveBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        self.driveBottomL.backgroundColor = [UIColor clearColor];
        self.passageBottomL.backgroundColor = kMainYellowColor;
    }
    [ZLNotiCenter postNotificationName:@"ChooseUserTypeView" object:self userInfo:nil];
}


@end
