//
//  TYWJDriveHomeDetailViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/6/11.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJDriveHomeDetailViewController.h"
#import "TYWJDriverHomeTableViewController.h"
#import "YJPageControlView.h"

@interface TYWJDriveHomeDetailViewController ()

@end

@implementation TYWJDriveHomeDetailViewController

        
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
//    // Do any additional setup after loading the view from its nib.
        NSMutableArray *viewControllers = [NSMutableArray array];
    NSArray *titles = @[@"待完成", @"已完成"];
    CGRect frame =CGRectMake(0, kNavBarH, ZLScreenWidth, self.view.bounds.size.height-kNavBarH-[[UIApplication sharedApplication] statusBarFrame].size.height);
    for (int i = 0 ; i<titles.count; i++) {
        TYWJDriverHomeTableViewController *vc = [self viewControllerIndex:i];
        vc.view.zl_height =frame.size.height-40;
        
        [viewControllers addObject:vc];
    }
    YJPageControlView *PageControlView = [[YJPageControlView alloc] initWithFrame:frame Titles:titles viewControllers:viewControllers Selectindex:0];
    PageControlView.tintColor = [UIColor greenColor];
    [PageControlView showInViewController:self];
}
- (TYWJDriverHomeTableViewController *)viewControllerIndex:(NSInteger)index {
    TYWJDriverHomeTableViewController *vc = [[TYWJDriverHomeTableViewController alloc] init];
    
    switch (index) {
        case 0:
        {
        }
            break;
        case 1:
        {
            
        }
            break;
        default:
            break;
    }
    return vc;
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
