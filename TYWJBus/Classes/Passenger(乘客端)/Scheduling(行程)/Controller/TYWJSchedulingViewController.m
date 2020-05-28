//
//  TYWJSchedulingViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/18.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJSchedulingViewController.h"
#import "TYWJNoSchedulingView.h"
#import "TYWJSectionHeadView.h"
#import "TYWJSchedulingTableViewCell.h"
@interface TYWJSchedulingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TYWJSchedulingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行程";
    TYWJNoSchedulingView * view = [[[NSBundle mainBundle] loadNibNamed:@"TYWJNoSchedulingView" owner:self options:nil] lastObject];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJSchedulingTableViewCell class]) bundle:nil] forCellReuseIdentifier:TYWJSchedulingTableViewCellID];
  
//    [self.view addSubview:view];
    // Do any additional setup after loading the view from its nib.
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"fff";
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TYWJSectionHeadView *header = [[[NSBundle mainBundle] loadNibNamed:@"TYWJSectionHeadView" owner:self options:nil] lastObject];
    header.citynameL.text = @"成都";
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 204;
    }
    return 204;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TYWJSchedulingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJSchedulingTableViewCellID forIndexPath:indexPath];
    cell.backgroundColor = randomColor;
    return cell;
 
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
