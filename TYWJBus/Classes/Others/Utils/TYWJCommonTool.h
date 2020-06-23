//
//  TYWJCommonTool.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TYWJUsableCity.h"


@class TYWJDriverRouteListInfo,TYWJTabBarController,TYWJRequestFailedController;

typedef enum : NSUInteger {
    TYWJCommuteControllerTypeCommute,
    TYWJCommuteControllerTypeCampus,
    TYWJCommuteControllerTypePlane,
    TYWJCommuteControllerTypeTrain
} TYWJCommuteControllerType;

@class TYWJBorderButton,AMapPOI;


@interface TYWJCommonTool : NSObject

#pragma mark - 内部单例以及方法属性等
+ (instancetype)sharedTool;
+ (BOOL)isDriver;
+ (void)saveIsDriver:(BOOL)isDriver;

/* selecteCity */
@property (strong, nonatomic) TYWJUsableCity *selectedCity;
- (void)saveSelectedCityInfo;
- (void)getDeviceId;

#pragma mark - 获取某个月的天数
/* 下个月天数 */
@property (assign, nonatomic) int nextMonthDays;
/* nextMonth */
@property (copy, nonatomic) NSString *nextMonth;
/* nextYear */
@property (copy, nonatomic) NSString *nextYear;
/* deviceID */
@property (copy, nonatomic) NSString *deviceID;
/* 当前月份 */
@property (copy, nonatomic) NSString *currentMonth;
/* 当前年份 */
@property (copy, nonatomic) NSString *currentYear;
/* 当前号数 */
@property (copy, nonatomic) NSString *currentDay;

#pragma mark - 工具方法
+ (BOOL)configTextfield:(UITextField *)textField string:(NSString *)string btn:(TYWJBorderButton *)btn limitNums:(int)limitNums;
/**
 检测是否有网
 */
+ (BOOL)checkoutNetwork;
+ (NSArray *)decodeCommaStringWithString:(NSString *)string;

+ (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineIsHorizonal:(BOOL)isHorizonal;

+ (void)drawDashWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint dashColor:(UIColor *)dashColor;
+ (void)drawDashWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint dashColor:(UIColor *)dashColor drawP:(int)drawP skipP:(int)skipP;

#pragma mark - 跳转到响应vc
+ (void)pushToVc:(UIViewController *)vc;
+ (void)popVc;

+ (void)presentToVc:(UIViewController *)vc;
+ (void)presentToVcNoanimated:(UIViewController *)vc;
#pragma mark - 获取IP地址
+ (NSString *)deviceIPAdress;
+ (void)requestIPAdressSuccessHandler:(void(^)(NSString *ip))successHandler;
#pragma mark - 获取版本号
+ (void)checkUpdateIfUpdated:(void(^)(NSString *trackViewUrl))updatedCompletion;



/* doSearchResult */
@property (copy, nonatomic) void(^doSearchResul)(NSArray *result);


- (BOOL)checkPlaceIsAssignedPlaceWithCoord:(CLLocationCoordinate2D)coord coord2:(CLLocationCoordinate2D)coord2 meters:(CGFloat)meters;

#pragma mark - 获取版本号

/* 当前版本号 */
@property (copy, nonatomic) NSString *currentVersion;

#pragma mark - 检查这个版本是否是第一次启动

+ (BOOL)checkIfFirstLaunch;

#pragma makr - 广告图片相关

+ (void)saveAdsImgDataWithUrlString:(NSString *)urlString;
+ (NSData *)getAdsImgData;
+ (void)requestAdsImgData;


/* 当前系统版本 */
@property (copy, nonatomic) NSString *currentSysVersion;

#pragma mark - 设置静音模式下播放声音
+ (void)settingPlaySoundUnderMuteMode;

#pragma mark - 发车页面相关

/* listInfo */
@property (copy, nonatomic) TYWJDriverRouteListInfo *listInfo;
/* 当前站index */
@property (assign, nonatomic) NSInteger currentStationIndex;
/* 当前站点数组中的index */
@property (assign, nonatomic) NSInteger currentIndex;


- (CGFloat)getSystemVolume;


#pragma mark - 退出登录操作

+ (void)signOutUserWithView:(UIView *)v;

#pragma mark - 显示3D touch功能

+ (void)show3DTouchActionShow:(BOOL)isShow;
+ (void)animShowNextViewWithController:(UIViewController *)vc v:(UIView *)v circleView:(UIView *)circleView;


#pragma mark - 设置rootVc

- (void)setRootVcWithTabbarVc;

#pragma mark - 是否在审核中

/* 是否在审核中 */
@property (copy, nonatomic) NSString *isCheckingApp;

#pragma mark - url encode

+ (NSString *)urlEncodeWithUrl:(NSString *)url;

#pragma mark - 跳转到safari

+ (void)jumpToSafariWithUrl:(NSString *)urlString;

#pragma mark - 获取图片url

+ (NSString *)getPicUrlWithPicName:(NSString *)picName path:(NSString *)path;

#pragma mark - 检测是否是齐刘海系列iPhone

- (void)checkIsPhoneX;
/* 检测是否是齐刘海系列iPhone */
@property (assign, nonatomic) BOOL isPhoneX;
/* 屏幕宽度 */
@property (assign, nonatomic) CGFloat screenWidth;
/* 屏幕高度 */
@property (assign, nonatomic) CGFloat screenHeight;

#pragma mark - 获取节假日数据

/* holidayDic */
@property (strong, nonatomic) NSDictionary *holidayDic;

- (void)getHoliday;

//根据状态码得到状态字符串
+ (NSString *)getOrderStatusWithStatus:(int)status;
//根据状态码得到状态字符串
+ (NSString *)getTicketStatusWithStatus:(int)status;


    //0.未出票1.待配车（调度中） 2.已配车（有车票号已分配） 3.已验票（已使用 ） 4.已过期(时间到期,客户未验票) 5.退票已受理 6. 已退票


//得到当前时间时间戳
+ (NSString *)getCurrcenTimeStr;
+ (long)getCurrcenTimeIntervall;
+ (NSString *)getPriceStringWithMount:(int)amount;
#pragma mark - 显示no data view
+ (void)loadNoDataViewWithImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle isHideBtn:(BOOL)isHideBtn showingVc:(UIViewController *)showingVc;
+ (void)loadNoDataViewWithImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle isHideBtn:(BOOL)isHideBtn showingVc:(UIViewController *)showingVc btnClicked:(void(^)(UIViewController *failedVc))btnClicked;
#pragma mark - 获取明天
+ (NSString *)getTodayDay;

//传入今天的时间，返回明天的时间
+ (NSString *)getTomorrowDay:(NSDate *)aDate;

#pragma mark - 网络请求返回错误信息

- (NSString *)returnRequestErrorInfoWithError:(NSError *)error;


#pragma mark - 拨打电话

+ (void)dialWithPhoneNum:(NSString *)phoneNum;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;


//通过时间
+ (NSString *)getTimeWithTimeStr:(NSString *)time intervalStr:(NSString *)intervalStr;
@end
