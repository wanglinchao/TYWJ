//
//  TYWJChangeAvatarController.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/11.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJChangeAvatarController.h"
#import "TYWJChangeAvatarCell.h"
#import "TYWJChangeCellPlist.h"
#import "ZLPOPAnimation.h"
#import "TYWJNavigationController.h"

#import <MJExtension.h>

static CGFloat const kTimeInterval = 0.25f;

@interface TYWJChangeAvatarController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* effectView */
@property (strong, nonatomic) UIVisualEffectView *effectView;
/* plistArr */
@property (strong, nonatomic) NSArray *plistArr;
/* manager */
@property (strong, nonatomic) HXPhotoManager *manager;
/* toolManager */
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@end

@implementation TYWJChangeAvatarController
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
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = YES;
        // 在这里设置为单选模式
        _manager.configuration.singleSelected = YES;
        // 单选模式下选择图片时是否直接跳转到编辑界面
        _manager.configuration.singleJumpEdit = NO;
        // 是否可移动的裁剪框
        _manager.configuration.movableCropBox = NO;
        // 可移动的裁剪框是否可以编辑大小
        _manager.configuration.movableCropBoxEditSize = NO;
    }
    return _manager;
}
- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}
- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _effectView.frame = self.view.bounds;
        _effectView.alpha = 0;
    }
    return _effectView;
}

#pragma mark -

- (void)dealloc {
    ZLFuncLog;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self loadPlist];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.effectView];
}

- (void)loadPlist {
    NSString *path = [[NSBundle mainBundle] pathForResource:TYWJChangeAvatarCellPlist ofType:nil];
    NSArray *plistArr = [NSArray arrayWithContentsOfFile:path];
    self.plistArr = [TYWJChangeCellPlist mj_objectArrayWithKeyValuesArray:plistArr];
    if (self.plistArr) {
        [self.view addSubview:self.tableView];
        [self.tableView reloadData];
        
        CGFloat navBarH = 0;
        if ([TYWJCommonTool sharedTool].currentSysVersion.doubleValue < 11) {
            navBarH = kNavBarH;
        }
        CGRect newF = self.tableView.frame;
        newF.origin.y = self.view.zl_height - self.tableView.zl_height +  navBarH;
        [ZLPOPAnimation animationWithView:self.tableView fromF:self.tableView.frame toF:newF springSpeed:20.f springBounciness:0 completionBlock:nil];
        
        [UIView animateWithDuration:kTimeInterval animations:^{
            self.effectView.alpha = TYWJEffectViewAlpha;
        }];
    }
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.plistArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
    
    switch (indexPath.row) {
        case 1:
        {
            [self showChoosePhotoVC];
        }
            break;
        case 0:
        {
            [self showCameraVC];
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
        weakSelf.effectView.alpha = 0;
    }];
}

- (void)showChoosePhotoVC {
    WeakSelf;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController hx_presentAlbumListViewControllerWithManager:self.manager done:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL original, HXAlbumListViewController *viewController) {
        if (photoList.count > 0) {
            [weakSelf.view showLoadingHUDText:@"获取图片中"];
            [self.toolManager getSelectedImageList:photoList requestType:0 success:^(NSArray<UIImage *> *imageList) {
                [weakSelf.view handleLoading];
                [ZLNotiCenter postNotificationName:TYWJPhotoSelectedSuccessNoti object:imageList.firstObject];
            } failed:^{
                [weakSelf.view handleLoading];
                [weakSelf.view showImageHUDText:@"获取失败"];
            }];
            ZLLog(@"%ld张图片",photoList.count);
        }
    } cancel:^(HXAlbumListViewController *viewController) {
        ZLLog(@"取消了");
    }];
}

- (void)showCameraVC {
    __weak typeof(self) weakSelf = self;
    HXCustomCameraViewController *cameraVc = [[HXCustomCameraViewController alloc] init];
    cameraVc.doneBlock = ^(HXPhotoModel *model, HXCustomCameraViewController *viewController) {
        NSArray *photoList = @[model];
        [self.toolManager getSelectedImageList:photoList requestType:0 success:^(NSArray<UIImage *> *imageList) {
            [weakSelf.view handleLoading];
            [ZLNotiCenter postNotificationName:TYWJPhotoSelectedSuccessNoti object:imageList.firstObject];
        } failed:^{
            [weakSelf.view handleLoading];
            [weakSelf.view showImageHUDText:@"获取失败"];
        }];
    };
    TYWJNavigationController *navVc = [[TYWJNavigationController alloc] initWithRootViewController:cameraVc];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navVc animated:YES completion:nil];
}
@end
