//
//  TYWJSelectMapController.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/21.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJSelectMapController.h"
#import "ZLPOPAnimation.h"
#import "TYWJChangeAvatarCell.h"
#import "TYWJChangeCellPlist.h"

#import <MapKit/MapKit.h>
#import <MJExtension.h>

static CGFloat const kTimeInterval = 0.25f;

@interface TYWJSelectMapController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* plistArr */
@property (strong, nonatomic) NSArray *plistArr;

@end

@implementation TYWJSelectMapController
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat rowH = 50.f;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.zl_height, ZLScreenWidth, rowH*self.plistArr.count + kTabBarH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = rowH;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJChangeAvatarCell class]) bundle:nil] forCellReuseIdentifier:TYWJChangeAvatarCellID];
    }
    return _tableView;
}
#pragma mark - set up view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadPlist];
    [self setupView];
    
}

- (void)dealloc {
    ZLFuncLog;
}

- (void)setupView {
    [self.view addSubview:self.tableView];
}

- (void)loadPlist {
    self.plistArr = [self getAvailableMap];
    
    if (self.plistArr) {
        [self.tableView reloadData];
        
        CGRect newF = self.tableView.frame;
        newF.origin.y = self.view.zl_height - self.tableView.zl_height;
        [ZLPOPAnimation animationWithView:self.tableView fromF:self.tableView.frame toF:newF springSpeed:20.f springBounciness:0 completionBlock:nil];
        
        [UIView animateWithDuration:kTimeInterval animations:^{
            [self setEffectViewAlpha:TYWJEffectViewAlpha];
        }];
    }
    
}

- (NSArray *)getAvailableMap {
    NSString *path = [[NSBundle mainBundle] pathForResource:TYWJSelectMapPlist ofType:nil];
    NSMutableArray *arr = [NSMutableArray array];
    if (path) {
        NSArray *dataArr = [NSArray arrayWithContentsOfFile:path];
        dataArr = [TYWJChangeCellPlist mj_objectArrayWithKeyValuesArray:dataArr];
        for (TYWJChangeCellPlist *plist in dataArr) {
            if (!plist.url || [plist.url isEqualToString:@""]) {
                [arr addObject:plist];
                continue;
            }
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:plist.url]]) {
                [arr addObject:plist];
            }
        }
    }
    
    
    return arr;
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.plistArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJChangeAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJChangeAvatarCellID forIndexPath:indexPath];
    TYWJChangeCellPlist *plist = self.plistArr[indexPath.row];
    cell.plist = plist;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self touchesBegan:[NSSet set] withEvent:[[UIEvent alloc] init]];
    
    //这个要用模型里的index才行
    TYWJChangeCellPlist *p = self.plistArr[indexPath.row];
    switch ([p.index intValue]) {
        case 0:
        {
            //自带地图
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(self.location.y, self.location.x);
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
            
            [[TYWJCommonTool sharedTool] showNavigatorWithArr:@[@{@"lon":@(self.location.x),@"lat":@(self.location.y)}]];
            return;
            
            
            
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                           MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        }
            break;
        case 1:
        {
            //高德地图
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",kAppName,kAppUrlScheme,self.location.y, self.location.x] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
            break;
        case 2:
        {
            //百度地图
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",self.location.y, self.location.x] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }
            break;
        case 3:
        {
            //谷歌地图
            NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",kAppName,kAppUrlScheme,self.location.y, self.location.x] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
            break;
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGRect newF = self.tableView.frame;
    newF.origin.y = self.view.zl_height;
    WeakSelf;
    [ZLPOPAnimation animationWithView:self.tableView fromF:self.tableView.frame toF:newF springSpeed:20.f springBounciness:0 completionBlock:^{
        if (weakSelf.viewClicked) {
            weakSelf.viewClicked();
        }
    }];
    [UIView animateWithDuration:kTimeInterval animations:^{
        [weakSelf setEffectViewAlpha:0];
    }];
}
@end
