//
//  TYWJAboutUsController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/23.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJAboutUsController.h"
@interface TYWJAboutUsController ()
@property (weak, nonatomic) IBOutlet UILabel *versionL;

@end

@implementation TYWJAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.versionL.text = [NSString stringWithFormat:@"V%@",[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
