//
//  TYWJStartToDestinationView.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/6.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJStartToDestinationView.h"
#import "TYWJDetailStationCell.h"

#import "TYWJRouteList.h"
#import "TYWJTicketList.h"
#import "TYWJMonthTicket.h"

@interface TYWJStartToDestinationView()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* coverBtn */
@property (strong, nonatomic) UIButton *coverBtn;
@end

@implementation TYWJStartToDestinationView

#pragma mark - set up view
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.userInteractionEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[TYWJDetailStationCell class] forCellReuseIdentifier:@"TYWJDetailStationCell"];
    _tableView.rowHeight = _tableView.zl_height/2.f;
    [self addSubview:_tableView];
    
    UIButton *coverBtn = [[UIButton alloc] init];
    coverBtn.frame = self.bounds;
    coverBtn.backgroundColor = [UIColor clearColor];
//    [coverBtn addTarget:self action:@selector(coverClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:coverBtn];
    self.coverBtn = coverBtn;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJDetailStationCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJDetailStationCellID forIndexPath:indexPath];
    return cell;
}

- (void)addTarget:(id)target action:(SEL)action {
    [self.coverBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 按钮点击

- (void)reloadData {
    [self.tableView reloadData];
}
@end
