//
//  TYWJDriverSelectCarController.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/14.
//  Copyright © 2018 MacBook. All rights reserved.
//  选择车辆界面

#import "TYWJDriverSelectCarController.h"


static NSString * const TYWJDriverSelectCellID = @"TYWJDriverSelectCellID";

@interface TYWJDriverSelectCarController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TYWJDriverSelectCarController
#pragma mark - 懒加载

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth * 0.65f, ZLScreenHeight * 0.65f) style:UITableViewStylePlain];
        _tableView.zl_x = ZLScreenWidth;
        _tableView.zl_centerX = self.view.zl_width/2.f;
        _tableView.zl_y = -self.view.zl_height;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 26.f;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView setRoundViewWithCornerRaidus:8.f];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TYWJDriverSelectCellID];
    }
    return _tableView;
}

#pragma mark - lazy loading
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

#pragma mark - set up view
- (void)setupView {
    [self.view addSubview:self.tableView];
    
    WeakSelf;
    [UIView animateWithDuration:0.65f delay:0 usingSpringWithDamping:1.2f initialSpringVelocity:1.2f options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.tableView.zl_centerY = self.view.zl_height/2.f;
        [weakSelf setEffectViewAlpha:TYWJEffectViewAlpha];
    } completion:nil];
}

- (void)hideTableViewCompletion:(void(^)(void))completion {
    WeakSelf;
    [UIView animateWithDuration:0.65f delay:0 usingSpringWithDamping:1.2f initialSpringVelocity:1.2f options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.tableView.zl_y = self.view.zl_height;
        [weakSelf setEffectViewAlpha:0];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    WeakSelf;
    [self hideTableViewCompletion:^{
        if (weakSelf.viewClicked) {
            weakSelf.viewClicked();
        }
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.carLicenses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJDriverSelectCellID forIndexPath:indexPath];
    cell.textLabel.text = self.carLicenses[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WeakSelf;
    if (self.cellSeleted) {
        weakSelf.cellSeleted(weakSelf.carLicenses[indexPath.row]);
        [self hideTableViewCompletion:^{
            if (weakSelf.viewClicked) {
                weakSelf.viewClicked();
            }
        }];
        
    }
}
@end
