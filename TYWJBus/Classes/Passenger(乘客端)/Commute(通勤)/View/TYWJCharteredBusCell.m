//
//  TYWJCharteredBusCell.m
//  TYWJBus
//
//  Created by tywj on 2019/11/26.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import "TYWJCharteredBusCell.h"
#import "JXTextView.h"
#import "ZLPopoverView.h"

@interface TYWJCharteredBusCell ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet JXTextView *reqTextView;
@property (weak, nonatomic) IBOutlet UITextField *numField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *timeField;

@end

@implementation TYWJCharteredBusCell

+ (instancetype)cellForTableView:(UITableView *)tableView
{
    static NSString *cellID = @"charteredBusCell";
    TYWJCharteredBusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.reqTextView.placeholder = @"请填写您的需求";
    self.reqTextView.placeholderColor = ZLColorWithRGB(202, 202, 202);
    self.reqTextView.delegate = self;
    self.reqTextView.layer.borderWidth = 1;
    self.reqTextView.layer.borderColor = ZLColorWithRGB(202, 202, 202).CGColor;
}

#pragma mark - UITextView代理
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *str = textView.text;
    if ([str hasSuffix:@"\n"]) {
        str = [str substringToIndex:str.length - 1];
    }
    NSInteger strCount = [str length] - [[str stringByReplacingOccurrencesOfString:@"\n" withString:@""] length];
    if (str.length - strCount == 0) {
        self.reqTextView.placeholder = @"请填写您的需求";
    }else {
        self.reqTextView.placeholder = nil;
    }
}

- (IBAction)clickSubmitButton:(UIButton *)sender {
//    if (self.numField.text.length == 0 || self.nameField.text.length == 0 || self.phoneField.text.length == 0 || self.timeField.text.length == 0) {
//        [MBProgressHUD zl_showAlert:@"请先填写必填信息" afterDelay:1.0f];
//        return;
//    }
    if (self.submitBtnClicked) {
        self.submitBtnClicked(self.numField.text, self.nameField.text, self.phoneField.text, self.timeField.text, self.reqTextView.text);
    }
}

- (IBAction)clickPhoneButton:(UIButton *)sender {
    NSString *phone = [[NSString alloc] initWithFormat:@"tel:%@",sender.titleLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}

- (IBAction)clickSelectTimeButton:(UIButton *)sender {
    [self endEditing:YES];
    [[ZLPopoverView sharedInstance] showPopDatePickerWithSelectedDate:0 ConfirmClicked:^(NSString *dateStr) {
        self.timeField.text = dateStr;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

@end
