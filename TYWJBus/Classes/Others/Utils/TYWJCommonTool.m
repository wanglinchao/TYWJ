//
//  TYWJCommonTool.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJCommonTool.h"
#import "TYWJBorderButton.h"
#import "TYWJTabBarController.h"
//#import "TYWJDriverTabBarController.h"
#import "TYWJSearchReult.h"
//#import "TYWJDriverRouteList.h"
#import "TYWJNavigationController.h"
#import "AppDelegate.h"
#import "ZLScrollTitleViewController.h"
#import "TYWJLoginTool.h"
#import "ZLCAAnimation.h"
#import <AVFoundation/AVFoundation.h>
//#import <AMap3DMap/MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <SAMKeychain.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import <AFNetworking.h>
#import "ZLHTTPSessionManager.h"
#import "TYWJSoapTool.h"
#import "TYWJRouteList.h"
#import "TYWJSubRouteList.h"
#import "TYWJRequestFailedController.h"
#import <MJExtension.h>
#import "TYWJJsonRequestUrls.h"
#import "TYWJBanerModel.h"
#import "TYWJMyOrderController.h"
static NSString * const kCommonToolSearchDataKey = @"data";
static NSString * const kCommonToolSearchRouteInfoKey = @"routeInfo";



static TYWJCommonTool *_instance = nil;

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@interface TYWJCommonTool()<NSCopying>
/* dateFormatter */
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) NSDateComponents *todayComp;

#pragma mark - 搜索相关
/* selectedType */
@property (assign, nonatomic) TYWJCommuteControllerType selectedType;
/* 选中城市id */
@property (assign, nonatomic) int selectedCityID;
/* 对应城市下的所有路线站点 */
@property (strong, nonatomic) NSArray *routeList;
/* 对应城市下的所有路线站点 */
@property (strong, nonatomic) NSMutableArray *allRouteStations;
/* 计数器 */
@property (assign, nonatomic) NSInteger counter;
/* 所有的routelist数据条数 */
@property (assign, nonatomic) NSInteger allRouteCount;
/* getupPoi */
@property (strong, nonatomic) AMapPOI *getupPoi;
/* getdownPoi */
@property (strong, nonatomic) AMapPOI *getdownPoi;
/* searchResult */
@property (strong, nonatomic) NSMutableArray *searchResult;
@end

@implementation TYWJCommonTool
#pragma mark - 内部方法
#pragma mark - 单例实现
+ (instancetype)sharedTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[TYWJCommonTool alloc] init];
        [_instance getSelectedCityInfo];
        [_instance checkIsPhoneX];
        //        [_instance getHoliday];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}
#pragma mark - 懒加载
- (NSDateComponents *)todayComp {
    _todayComp = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:[NSDate date]];
    return _todayComp;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}
#pragma mark - 单例方法
- (TYWJUsableCityInfo *)selectedCity {
    if (!_selectedCity) {
        TYWJUsableCityInfo *city = [[TYWJUsableCityInfo alloc] init];
        city.city = @"成都市";
        city.cityID = @"001";
        _selectedCity = city;
        
        [self saveSelectedCityInfo];
    }
    return _selectedCity;
}

- (void)saveSelectedCityInfo {
    [ZLUserDefaults setObject:_selectedCity.city forKey:TYWJSelectedCityString];
    [ZLUserDefaults setObject:_selectedCity.cityID forKey:TYWJSelectedCityIDString];
    [ZLUserDefaults synchronize];
}


- (void)getSelectedCityInfo {
    if ([ZLUserDefaults objectForKey:TYWJSelectedCityIDString]) {
        _selectedCity = [[TYWJUsableCityInfo alloc] init];
        _selectedCity.cityID = [ZLUserDefaults objectForKey:TYWJSelectedCityIDString];
        _selectedCity.city = [ZLUserDefaults objectForKey:TYWJSelectedCityString];
    }
}

- (void)getDeviceId
{
    NSString * currentDeviceUUIDStr = [SAMKeychain passwordForService:@" "account:@"uuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SAMKeychain setPassword: currentDeviceUUIDStr forService:@" "account:@"uuid"];
    }
    _deviceID = currentDeviceUUIDStr;
    
}

- (NSString *)deviceID {
    if (!_deviceID) {
        [self getDeviceId];
    }
    return _deviceID;
}

#pragma mark - 其他工具方法
+ (BOOL)configTextfield:(UITextField *)textField string:(NSString *)string btn:(TYWJBorderButton *)btn limitNums:(int)limitNums {
    //输入删除键的时候，不做其他任何操作
    if ([string isEqualToString:@""]) {
        btn.enabled = NO;
        return YES;
    }
    //当长度大于limitNums -1的时候，就是现在已经这个输入已经limitNums位了，就不让继续输入了，否则继续输入
    if (limitNums < 2) {
        limitNums = 11;
    }
    if (textField.text.length > limitNums -2) {
        btn.enabled = YES;
        if (textField.text.length == limitNums) {
            return NO;
        }
        return YES;
    }
    return YES;
}


/**
 检测是否有网
 */
+ (BOOL)checkoutNetwork {
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

+ (NSArray *)decodeCommaStringWithString:(NSString *)string {
    NSArray *arr = nil;
    if (string) {
        arr = [string componentsSeparatedByString:@","];
    }
    return arr;
}

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
+ (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineIsHorizonal:(BOOL)isHorizonal {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    [shapeLayer setBounds:lineView.bounds];
    
    if (isHorizonal) {
        
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
        
    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame)/2)];
    }
    
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    } else {
        
        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinBevel];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:@[@(lineLength),@(lineSpacing)]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    
    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
    }
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

+ (void)drawDashWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint dashColor:(UIColor *)dashColor {
    [self drawDashWithStartPoint:startPoint endPoint:endPoint dashColor:dashColor drawP:2 skipP:2];
}

+ (void)drawDashWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint dashColor:(UIColor *)dashColor drawP:(int)drawP skipP:(int)skipP {
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置线条的样式
    CGContextSetLineCap(context, kCGLineCapRound);
    // 绘制线的宽度
    CGContextSetLineWidth(context, 0.5f);
    // 线的颜色
    CGContextSetStrokeColorWithColor(context, dashColor.CGColor);
    // 开始绘制
    CGContextBeginPath(context);
    // 设置虚线绘制起点
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    // lengths的值｛1,2｝表示先绘制1个点，再跳过2个点，如此反复
    CGFloat lengths[] = {drawP,skipP};
    // 虚线的起始点
    CGContextSetLineDash(context, 0, lengths,2);
    // 绘制虚线的终点
    CGContextAddLineToPoint(context, endPoint.x,endPoint.y);
    // 绘制
    CGContextStrokePath(context);
    // 关闭图像
    CGContextClosePath(context);
}

#pragma mark - 跳转到响应vc
+ (void)pushToVc:(UIViewController *)vc {
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in windows) {
        //判断是否是tabbarVC，是的话就进行下一步的操作，不然容易出现莫名的bug
        if ([window.rootViewController isKindOfClass:[TYWJTabBarController class]]) {
            TYWJTabBarController *tabbarVc = (TYWJTabBarController *)window.rootViewController;
            [(UINavigationController *)tabbarVc.selectedViewController pushViewController:vc animated:YES];
            break;
        }
    }
}

+ (void)popVc {
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in windows) {
        //判断是否是tabbarVC，是的话就进行下一步的操作，不然容易出现莫名的bug
        if ([window.rootViewController isKindOfClass:[TYWJTabBarController class]]) {
            TYWJTabBarController *tabbarVc = (TYWJTabBarController *)window.rootViewController;
            [(UINavigationController *)tabbarVc.selectedViewController popViewControllerAnimated:YES];
            break;
        }
    }
}

+ (void)presentToVc:(UIViewController *)vc {
    vc.modalPresentationStyle = 0;
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in windows) {
        //判断是否是tabbarVC，是的话就进行下一步的操作，不然容易出现莫名的bug
        if ([window.rootViewController isKindOfClass:[TYWJTabBarController class]]) {
            TYWJTabBarController *tabbarVc = (TYWJTabBarController *)window.rootViewController;
            [(UINavigationController *)tabbarVc.selectedViewController presentViewController:vc animated:YES completion:nil];
            break;
        }
    }
}
+ (void)presentToVcNoanimated:(UIViewController *)vc{
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in windows) {
        //判断是否是tabbarVC，是的话就进行下一步的操作，不然容易出现莫名的bug
        if ([window.rootViewController isKindOfClass:[TYWJTabBarController class]]) {
            TYWJTabBarController *tabbarVc = (TYWJTabBarController *)window.rootViewController;
            [(UINavigationController *)tabbarVc.selectedViewController presentViewController:vc animated:NO completion:nil];
            break;
        }
    }
}
#pragma mark -
// 获取某个月的天数
+ (int)getSumOfDaysInMonthWithYear:(NSString *)year month:(NSString *)month {
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM"]; // 年-月
    
    NSString * dateStr = [NSString stringWithFormat:@"%@-%@",year,month];
    
    NSDate * date = [formatter dateFromString:dateStr];
    
    //
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit: NSCalendarUnitMonth
                                  forDate:date];
    return (int)range.length;
}

#pragma mark - 属性获取
- (int)nextMonthDays {
    if (_nextMonthDays <= 0) {
        if (self.nextYear <= 0 && self.nextMonth <= 0) {
            _nextMonthDays = 0;
            return _nextMonthDays;
        }
        
        [self.dateFormatter setDateFormat:@"yyyy-MM"]; // 年-月
        NSString * dateStr = [NSString stringWithFormat:@"%@-%@",self.nextYear,self.nextMonth];
        NSDate * date = [self.dateFormatter dateFromString:dateStr];
        NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                       inUnit: NSCalendarUnitMonth
                                      forDate:date];
        _nextMonthDays = (int)range.length;
    }
    return _nextMonthDays;
}

- (NSString *)nextMonth {
    if (!_nextMonth) {
        // 获取是月份
        NSInteger currMonth = self.todayComp.month;
        if (currMonth == 12) {
            currMonth = 1;
        }else {
            currMonth ++;;
        }
        _nextMonth = [NSString stringWithFormat:@"%ld",currMonth];
    }
    
    return _nextMonth;
}

- (NSString *)nextYear {
    if (!_nextYear) {
        
        // 获取是年份
        NSInteger currMonth = self.todayComp.month;
        NSInteger currYear = self.todayComp.year;
        if (currMonth == 12) {
            currYear ++;
        }
        _nextYear = [NSString stringWithFormat:@"%ld",currYear];
    }
    return _nextYear;
}

- (NSString *)currentYear {
    if (!_currentYear) {
        // 获取是年份
        NSInteger currYear = self.todayComp.year;
        _currentYear = [NSString stringWithFormat:@"%ld",currYear];
    }
    return _currentYear;
}

- (NSString *)currentMonth {
    if (!_currentMonth) {
        
        // 获取是年份
        NSInteger currMonth = self.todayComp.month;
        _currentMonth = [NSString stringWithFormat:@"%ld",currMonth];
    }
    return _currentMonth;
}

- (NSString *)currentDay {
    if (!_currentDay) {
        
        // 获取是年份
        NSInteger currDay = self.todayComp.day;
        _currentDay = [NSString stringWithFormat:@"%ld",currDay];
    }
    return _currentDay;
}
#pragma mark - 获取IP地址

//必须在有网的情况下才能获取手机的IP地址

+ (NSString *)deviceIPAdress {
    NSDictionary *ipDic = [self getIPAddresses];
    return ipDic[@"en2/ipv4"];
    
}

+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    ZLLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
        address = addresses[key];
        if(address) *stop = YES;
    } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}
/**
 站长api获取ip
 */

+ (void)requestIPAdressSuccessHandler:(void (^)(NSString *))successHandler {
    //    NSString *url = @"http://pv.sohu.com/cityjson?ie=utf-8";
    //    //@"http://ip.taobao.com/service/getIpInfo.php?ip=myip";
    //    //@"http://ip.chinaz.com/getip.aspx";
    //    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    //    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", nil];
    //    [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        if (responseObject) {
    //
    //        }
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        [SVProgressHUD zl_showErrorWithStatus:TYWJWarningBadNetwork];
    //    }];
    
    
    //方式二：新浪api
    [MBProgressHUD zl_showMessage:@"加载中,请稍后"];
    NSString *url = @"http://pv.sohu.com/cityjson?ie=utf-8";
    //增加这几行代码；
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD zl_hideHUD];
        if (responseObject) {
            NSMutableString *ipData = [[NSMutableString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            //判断返回字符串是否为所需数据
            if ([ipData hasPrefix:@"var returnCitySN = "]) {
                //对字符串进行处理，然后进行json解析
                //删除字符串多余字符串
                NSRange range = NSMakeRange(0, 19);
                [ipData deleteCharactersInRange:range];
                NSString * nowIp =[ipData substringToIndex:ipData.length-1];
                //将字符串转换成二进制进行Json解析
                NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                ZLLog(@"%@",dict);
                NSString *ip = dict[@"cip"] ? dict[@"cip"] : @"0.0.0.0";
                if (ip && ![ip isEqualToString:@""]) {
                    if (successHandler) {
                        successHandler(ip);
                    }
                }else {
                    ZLLog(@"未获取到本机ip");
                    [MBProgressHUD zl_showError:@"获取本机ip失败"];
                }
                
            }else {
                ZLLog(@"未获取到本机ip");
                [MBProgressHUD zl_showError:@"获取本机ip失败"];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD zl_hideHUD];
        if (error) {
            [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
        }
    }];
}

+ (void)checkUpdateIfUpdated:(void(^)(NSString *trackViewUrl))updatedCompletion {
    
    // 获取本地版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]; // 就是在info.plist里面的 version
    
    // 取得AppStore信息
    //    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //    NSString *currentBundelId = infoDic[@"CFBundleIdentifier"];
    NSString *url = [[NSString alloc] initWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@", kAppleStoreId];
    //    [NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@&country=cn",currentBundelId];
    //[[NSString alloc] initWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@", kAppleStoreId];
    ZLHTTPSessionManager *manager = [ZLHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZLLog(@"responseObject --- %@", responseObject);
        
        NSArray *resultArr = responseObject[@"results"];
        NSDictionary *resultsDict = resultArr.firstObject;
        
        // 取更新日志信息
        NSString *changeStr = resultsDict[@"releaseNotes"];
        // app store 最新版本号
        NSString *appStoreVersion = resultsDict[@"version"];
        // app store 跳转版本链接
        NSString  *trackViewUrl = resultsDict[@"trackViewUrl"];
        ZLLog(@"app store 的更新信息 --- %@， app store 的最新版本号 --- %@", changeStr, appStoreVersion);
        
        // AppStore版本号大于当前版本号
        //#ifdef DEBUG//debug模式下每次启动自动弹出此窗口
        //        // 弹窗 更新
        //        if (updatedCompletion) {
        //            updatedCompletion(trackViewUrl);
        //        }
        //#else
        if ([appStoreVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
            // 弹窗 更新
            if (updatedCompletion) {
                updatedCompletion(trackViewUrl);
            }
        }
        //#endif
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"app store更新数据请求失败");
    }];
}

+ (NSDictionary *)jsonStringToDictionary:(NSString *)jsonStr
{
    if (jsonStr == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    if (error)
    {
        //ZLLog(@"json格式string解析失败:%@",error);
        return nil;
    }
    
    return dict;
}

#pragma mark - 获取搜索站点结果,没有则返回nil


- (BOOL)checkPlaceIsAssignedPlaceWithCoord:(CLLocationCoordinate2D)coord coord2:(CLLocationCoordinate2D)coord2 meters:(CGFloat)meters {
    //    MAMapPoint point = MAMapPointForCoordinate(coord);
    //    MAMapPoint point2 = MAMapPointForCoordinate(coord2);
    //    CLLocationDistance distance = MAMetersBetweenMapPoints(point,point2);
    //    if (distance < meters) {
    //        return YES;
    //    }
    return NO;
}

#pragma mark - 当前版本号

- (NSString *)currentVersion {
    if (!_currentVersion) {
        _currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return _currentVersion;
}

#pragma mark - 检查这个版本是否是第一次启动

+ (BOOL)checkIfFirstLaunch {
    NSString *storedVersion = [ZLUserDefaults objectForKey:TYWJAppVersion];
    NSString *currentVersion = [TYWJCommonTool sharedTool].currentVersion;
    
    if ([storedVersion isEqualToString:currentVersion]) {
        return NO;
    }
    return YES;
}

#pragma mark - 广告图片相关

+ (void)saveAdsImgDataWithUrlString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:url];
        NSData *preImgData = [self getAdsImgData];
        if (![imgData isEqualToData:preImgData]) {
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *imageFilePath = [path stringByAppendingPathComponent:@"adsImgData"];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [imgData writeToFile:imageFilePath atomically:YES];
            });
        }
    });
}
+ (void)saveAdsImgJumpPathString:(NSString *)path {
    [[NSUserDefaults standardUserDefaults] setValue:path forKey:TYWJBanerJumpPath];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSData *)getAdsImgData {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageFilePath = [path stringByAppendingPathComponent:@"adsImgData"];
    NSData *imgData = [NSData dataWithContentsOfFile:imageFilePath];
    return imgData;
}

+ (void)requestAdsImgData {
    [self loadBanerImages];
}
+ (void)loadBanerImages{
    //TODO: 请求图片数据
    WeakSelf;
    ZLHTTPSessionManager *mgr = [ZLHTTPSessionManager signManager];
    [mgr.requestSerializer setValue:@"" forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [mgr POST:[TYWJJsonRequestUrls sharedRequest].ADsImageInfo parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD zl_hideHUD];
        if ([responseObject[@"reCode"] intValue] == 201) {
            NSArray<TYWJBanerModel *> *banersModels = [TYWJBanerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (banersModels.count > 0 ) {
                TYWJBanerModel *model = banersModels.firstObject;
                NSString * url = model.url;
                NSString * path = model.path;
                if (url) {
                    [weakSelf saveAdsImgDataWithUrlString:url];
                }
                if (path){
                    [weakSelf saveAdsImgJumpPathString:path];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD zl_hideHUD];
    }];
}

#pragma mark - 获取当前手机系统版本号
- (NSString *)currentSysVersion {
    if (!_currentSysVersion) {
        _currentSysVersion = [UIDevice currentDevice].systemVersion;
    }
    return _currentSysVersion;
}

#pragma mark - 设置静音模式下播放声音
+ (void)settingPlaySoundUnderMuteMode {
    //设置静音模式下播放音乐
    NSError *sessionError = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback  error:&sessionError];
}

#pragma mark - 司机端发车相关


- (CGFloat)getSystemVolume {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    CGFloat volume = audioSession.outputVolume;
    return volume;
}

#pragma mark - 退出登录操作

+ (void)signOutUserWithView:(UIView *)v {
    [[TYWJLoginTool sharedInstance] delLoginInfo];
    
    
}


#pragma mark - 显示3D touch功能

+ (void)show3DTouchActionShow:(BOOL)isShow {
    
    /** type 该item 唯一标识符
     localizedTitle ：标题
     localizedSubtitle：副标题
     icon：icon图标 可以使用系统类型 也可以使用自定义的图片
     userInfo：用户信息字典 自定义参数，完成具体功能需求
     */
    
    UIApplication *application = [UIApplication sharedApplication];
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"icon_my_ticket"];
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc]initWithType:@"myTicket" localizedTitle:@"我的行程费" localizedSubtitle:nil icon:icon1 userInfo:nil];
    
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"icon_my_line"];
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc]initWithType:@"myRoute" localizedTitle:@"我的行程" localizedSubtitle:nil icon:icon2 userInfo:nil];
    if (isShow) {
        application.shortcutItems = @[item1,item2];
    }else{
        application.shortcutItems = @[];
    }
}


#pragma mark - 进入我的订单界面
- (id)setMyOrderVc {
    ZLScrollTitleViewController *vc = [[ZLScrollTitleViewController alloc] init];
    vc.navigationItem.title = @"我的订单";
    vc.titleColor = [UIColor darkGrayColor];
    vc.titleViewColor = [UIColor whiteColor];
    [vc setIsChangeSelectedTitleFont:NO titleFontSize:14.f];
    [self addMyOrderVcsWithScrollVc:vc];
    return vc;
}
- (void)addMyOrderVcsWithScrollVc:(ZLScrollTitleViewController *)scrollVc {
    NSArray *titles = @[@"全部",@"待付款",@"已付款",@"已退款"];
    int count = (int)titles.count;
    NSMutableArray *childrenVc = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        TYWJMyOrderControllerType type = i;
        TYWJMyOrderController *myRouteVc = [[TYWJMyOrderController alloc] init];
        myRouteVc.type = type;
        [childrenVc addObject:myRouteVc];
    }
    scrollVc.titles = titles;
    scrollVc.childViewControllers = childrenVc;
}


#pragma mark - 设置乘客端rootVc

- (void)setPassengerRootVcWithTabbarVc:(TYWJTabBarController *)tabbarVc {
    if (!tabbarVc) {
        tabbarVc = [[TYWJTabBarController alloc] init];
    }
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    appDelegate.window.rootViewController = tabbarVc;
    tabbarVc.delegate = appDelegate;
}


#pragma mark - url encode

+ (NSString *)urlEncodeWithUrl:(NSString *)url {
    if (url && ![url isEqualToString:@""]) {
        return [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    }
    return nil;
}

#pragma mark - 跳转到safari

+ (void)jumpToSafariWithUrl:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    if(@available(iOS 10.0, *)){
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:url options:@{}
                                     completionHandler:^(BOOL success) {
                ZLLog(@"Open %d",success);
            }];
        } else {
            BOOL success = [[UIApplication sharedApplication] openURL:url];
            ZLLog(@"Open  %d",success);
        }
        
    } else{
        bool can = [[UIApplication sharedApplication] canOpenURL:url];
        if(can){
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark - 获取图片url

+ (NSString *)getPicUrlWithPicName:(NSString *)picName path:(NSString *)path {
    NSString *urlStr = [NSString stringWithFormat:@"%@manage/%@/%@",TYWJRequestJsonPicService,path,picName];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return urlStr;
}

#pragma mark - 检测是否是齐刘海系列iPhone

- (void)checkIsPhoneX {
    if (self.screenHeight >= 812.f) {//X XS == 812  XR XSMax = 896
        self.isPhoneX = YES;
    }else {
        self.isPhoneX = NO;
    }
}

- (CGFloat)screenWidth {
    if (_screenWidth <= 0) {
        _screenWidth = ZLScreenWidth;
    }
    return _screenWidth;
}

- (CGFloat)screenHeight {
    if (_screenHeight <= 0) {
        _screenHeight = ZLScreenHeight;
    }
    return _screenHeight;
}

#pragma mark - 获取节假日数据

- (void)getHoliday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSInteger thisYear = nowCmps.year;
    //    API来源：http://apistore.baidu.com/apiworks/servicedetail/1116.html（免费）
    // 下面使用的是我项目中的地址，因为使用上述免费的需要先去申请appkey
    NSString *holidayUrl = [NSString stringWithFormat:@"http://byod.boe.com.cn:8088/portal-schedule/api/holiday.action?appCode=WEIXIN&y=%ld,%ld",thisYear-1,thisYear];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    WeakSelf;
    [manager GET:holidayUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        //        {"20160208":{"type":"2","name":"春节"},"20160208":{"type":"2","name":"春节"},"20160208":{"type":"2","name":"春节"}}
        ZLLog(@"%@ == %@",jsonStr,jsonDic);
        weakSelf.holidayDic = jsonDic;
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        ZLLog(@"获取节假日信息失败=%@",error);
    }];
}

#pragma mark - 显示no data view
+ (void)loadNoDataViewWithImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle isHideBtn:(BOOL)isHideBtn showingVc:(UIViewController *)showingVc {
    [self loadNoDataViewWithImg:img tips:tips btnTitle:btnTitle isHideBtn:isHideBtn showingVc:showingVc btnClicked:nil];
}

+ (void)loadNoDataViewWithImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle isHideBtn:(BOOL)isHideBtn showingVc:(UIViewController *)showingVc btnClicked:(void (^)(UIViewController *failedVc))btnClicked {
    for (UIView *view in showingVc.view.subviews) {
        [view removeFromSuperview];
    }
    TYWJRequestFailedController *vc = [[TYWJRequestFailedController alloc] init];
    vc.view.frame = showingVc.view.bounds;
    vc.view.zl_y = kNavBarH;
    vc.view.zl_height -= kNavBarH;
    [showingVc.view addSubview:vc.view];
    [vc setImg:img tips:tips btnTitle:btnTitle isHideBtn:isHideBtn];
    
    __weak typeof(vc) weakVc = vc;
    vc.reloadClicked = ^{
        if (btnClicked) {
            btnClicked(weakVc);
        }
    };
    
    
    [showingVc.view addSubview:vc.view];
    [showingVc addChildViewController:vc];
}

#pragma mark - 获取明天
//传入今天的时间，返回明天的时间
- (NSString *)getTomorrowDay:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd"];
    return [dateday stringFromDate:beginningOfWeek];
}


#pragma mark - 网络请求返回错误信息


- (NSString *)returnRequestErrorInfoWithError:(NSError *)error {
    NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    if (data) {
        NSError *err = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
        ZLLog(@"dataStirng---%@",dic[@"msg"]);
        [MBProgressHUD zl_showError:dic[@"msg"]];
        return dic[@"msg"];
    }
    return nil;
}


#pragma mark - 拨打电话

+ (void)dialWithPhoneNum:(NSString *)phoneNum {
    //拨打电话号码
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",phoneNum]]];
}
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}
+ (NSString *)getTimeWithTimeStr:(NSString *)time intervalStr:(NSString *)intervalStr{
    NSArray *t = [time componentsSeparatedByString:@":"];
    NSString *hs = t.firstObject;
    NSString *ds = t.lastObject;

    NSInteger h = hs.intValue;
    NSInteger d = ds.intValue;

    NSInteger num = h*60 + d;
    num += intervalStr.intValue;
    NSString *hhh = [NSString stringWithFormat:@"%ld",num/60];
    NSString *ddd = [NSString stringWithFormat:@"%ld",num%60];
    if (hhh.intValue > 23) {
        hhh = [NSString stringWithFormat:@"%d",hhh.intValue-23];
    }
    if (hhh.intValue < 10) {
        hhh = [NSString stringWithFormat:@"0%@",hhh];
    }

    if (ddd.intValue < 10) {
        ddd = [NSString stringWithFormat:@"0%@",ddd];
    }
    return [NSString stringWithFormat:@"%@:%@",hhh,ddd];
}
@end
