//
//  TYWJConst.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/22.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 通知

UIKIT_EXTERN NSString * const TYWJBackToLoginWithPhoneNum;

/** textfield的placeholder的字体颜色的属性key **/
UIKIT_EXTERN NSString * const TYWJPlacerholderColorKeyPath;

#pragma mark - 登录
UIKIT_EXTERN NSString * const TYWJLoginStatusString;
UIKIT_EXTERN NSString * const TYWJLoginPhoneNumString;
UIKIT_EXTERN NSString * const TYWJLoginNickanmeString;
//乘客登录密码
UIKIT_EXTERN NSString * const TYWJLoginPassengerPwdString;
//司机登录密码
UIKIT_EXTERN NSString * const TYWJLoginDriverPwdString;

#pragma mark - 选中城市
UIKIT_EXTERN NSString * const TYWJSelectedCityString;
UIKIT_EXTERN NSString * const TYWJSelectedCityIDString;
UIKIT_EXTERN NSString * const TYWJLoginTypeString;
UIKIT_EXTERN NSString * const TYWJLoginAvatarString;
UIKIT_EXTERN NSString * const TYWJLoginUidString;
#pragma mark - plist

UIKIT_EXTERN NSString * const TYWJSideColumn0Plist;
UIKIT_EXTERN NSString * const TYWJSideColumnPlist;
UIKIT_EXTERN NSString * const TYWJMoreCellListPlist;
UIKIT_EXTERN NSString * const TYWJDriverMoreCellListPlist;
UIKIT_EXTERN NSString * const TYWJPersonalCenterPlist;
UIKIT_EXTERN NSString * const TYWJChangeAvatarCellPlist;
UIKIT_EXTERN NSString * const TYWJApplyRoutePlist;
UIKIT_EXTERN NSString * const TYWJCustomerServicePlist;
UIKIT_EXTERN NSString * const TYWJAboutUsPlist;
UIKIT_EXTERN NSString * const TYWJMyTicketListPlist;
UIKIT_EXTERN NSString * const TYWJMyTicketList1Plist;
UIKIT_EXTERN NSString * const TYWJComplaintListPlist;
UIKIT_EXTERN NSString * const TYWJRefundTicketReasonPlist;
UIKIT_EXTERN NSString * const TYWJSelectMapPlist;
UIKIT_EXTERN NSString * const TYWJDetailRouteBubblePlist;
UIKIT_EXTERN NSString * const TYWJDetailRouteBubble1Plist;
UIKIT_EXTERN NSString * const TYWJScenesAPlist;
UIKIT_EXTERN NSString * const TYWJScenesPlist;

#pragma mark - 网络请求
//站点图片
UIKIT_EXTERN NSString * const TYWJRequestJsonPicService;
//json service
UIKIT_EXTERN NSString * const TYWJRequestJsonService;
//xml service
UIKIT_EXTERN NSString * const TYWJRequestService;
//打卡service
UIKIT_EXTERN NSString * const TYWJRequestSingUpService;

//cd917
UIKIT_EXTERN NSString * const TYWJCd917Service;
UIKIT_EXTERN NSString * const TYWJCd917ApiKey;
UIKIT_EXTERN NSString * const TYEJCd917AppSecret;

//登录
//乘客
UIKIT_EXTERN NSString * const TYWJRequestLoginPassenger;
//司机
UIKIT_EXTERN NSString * const TYWJRequestLoginDriver;
//获取开通城市列表
UIKIT_EXTERN NSString * const TYWJRequestGetCityLists;
//活动中心
UIKIT_EXTERN NSString * const TYWJRequestAcitivity;
//线路表
UIKIT_EXTERN NSString * const TYWJRequesrRouteList;
//线路子表
UIKIT_EXTERN NSString * const TYWJRequesrSubRouteList;
//获取已购买车票
UIKIT_EXTERN NSString * const TYWJRequesrGetPurchasedTickets;
//获取已购买的月票信息
UIKIT_EXTERN NSString * const TYWJRequesrGetPurchasedMonthTickets;
//申请线路
UIKIT_EXTERN NSString * const TYWJRequestApplyForNewRoute;
//查询已申请的线路
UIKIT_EXTERN NSString * const TYWJRequestCheckoutAppliedRoute;
//在线反馈
UIKIT_EXTERN NSString * const TYWJRequstOnlineFeedback;
//投诉
UIKIT_EXTERN NSString * const TYWJRequstOnlineComplaint;
//评价
UIKIT_EXTERN NSString * const TYWJRequstOnlineComment;
//常见问题
UIKIT_EXTERN NSString * const TYWJRequestCommonQuestions;
//乘客注册
UIKIT_EXTERN NSString * const TYWJRequestRegisterPassenger;
//司机注册
UIKIT_EXTERN NSString * const TYWJRequestRegisterDriver;
//获取票价
UIKIT_EXTERN NSString * const TYWJRequestGetTicketPrice;
//能否购买单次车票
UIKIT_EXTERN NSString * const TYWJRequestCanBuySingleTicket;
//获取剩余座位
UIKIT_EXTERN  NSString * const TYWJRequestGetLastSeats;
//能否购买月票
UIKIT_EXTERN NSString * const TYWJRequestCanBuyMonthTicket;
//设置短信验证码
UIKIT_EXTERN NSString * const TYWJRequestSetVerifyCode;
//检测乘客手机号是否注册
UIKIT_EXTERN NSString * const TYWJRequestCheckPassengerUserIsRegistered;
//检测司机手机号是否注册
UIKIT_EXTERN NSString * const TYWJRequestCheckDriverUserIsRegistered;
//验票
UIKIT_EXTERN NSString * const TYWJRequestCheckTicket;
//kAppleStoreId
UIKIT_EXTERN NSString * const kAppleStoreId;
//更新用户uid
UIKIT_EXTERN NSString * const TYWJRequestUpdateUserUid;
//获取卡类型
UIKIT_EXTERN NSString * const TYWJRequestGetCardCategory;
//下订单
UIKIT_EXTERN NSString * const TYWJRequestMakeOrder;
//获取车辆位置
UIKIT_EXTERN NSString * const TYWJRequestGetCarLocation;
//修改密码
UIKIT_EXTERN NSString * const TYWJRequestModifyPwd;
UIKIT_EXTERN NSString * const TYWJRequestModifyDriverPwd;
//获取线路剩余座位
UIKIT_EXTERN NSString * const TYWJRequestGetSql;
//获取已买信息
UIKIT_EXTERN NSString * const TYWJRequestGetMaiguo;
//包车
UIKIT_EXTERN NSString * const TYWJRequestInsertbaoche;
//不感兴趣
UIKIT_EXTERN NSString * const TYWJRequestRefuse;
//返程线路
UIKIT_EXTERN NSString * const TYWJRequesrFancheng;

#pragma mark - 司机相关
//获取司机线路
UIKIT_EXTERN NSString * const TYWJRequestGetDriverRoute;
//获取车站信息
//UIKIT_EXTERN NSString * const TYWJRequestGetStaionInfo;
//司机发车
UIKIT_EXTERN NSString * const TYWJRequestDriverLuanchCar;
//司机位置上传
UIKIT_EXTERN NSString * const TYWJRequestUploadDiverLocation;
//获取车站人数
UIKIT_EXTERN NSString * const TYWJRequestGetStaionPassengerNum;
//司机收车
UIKIT_EXTERN NSString * const TYWJRequsetCloseRoute;
//获取司机当日提成
UIKIT_EXTERN NSString * const TYWJRequestDriverSalary;
//司机查看评价
UIKIT_EXTERN NSString * const TYWJRequestCheckComment;
//司机查看投诉
UIKIT_EXTERN NSString * const TYWJRequestCheckComplaint;

#pragma mark - 自由行
//获取门票
UIKIT_EXTERN NSString * const TYWJRequestGetITTicket;

#pragma mark - 提醒文字

UIKIT_EXTERN NSString * const TYWJWarningBadNetwork;
UIKIT_EXTERN NSString * const TYWJWarningWrongUsernameOrPwd;
UIKIT_EXTERN NSString * const TYWJWarningLoginLoading;
UIKIT_EXTERN NSString * const TYWJWarningLoading;
UIKIT_EXTERN NSString * const TYWJWarningSearchLoading;

#pragma mark - 其他
//客服电话，有可能也是请求数据获取
UIKIT_EXTERN NSString * const TYWJCustomerServicePhoneNum;
//投诉热线
UIKIT_EXTERN NSString * const TYWJComplaintsHotlinePhoneNum;
//effectView的alpha
UIKIT_EXTERN CGFloat const TYWJEffectViewAlpha;
#pragma mark - key
//高德地图key
UIKIT_EXTERN NSString * const TYWJAMapKey;
//支付宝AppID
UIKIT_EXTERN NSString * const TYWJAliPayAppID;
//友盟
UIKIT_EXTERN NSString * const TYWJUmengAppKey;
//微信
UIKIT_EXTERN NSString * const TYWJWechatAppKey;
//微信小程序key
UIKIT_EXTERN NSString * const TYWJWechatAppletKey;
//微信secret key
UIKIT_EXTERN NSString * const TYWJWechatSecretKey;

#pragma mark - 通知
UIKIT_EXTERN NSString * const TYWJModifyUserInfoNoti;
UIKIT_EXTERN NSString * const TYWJPhotoSelectedSuccessNoti;
UIKIT_EXTERN NSString * const TYWJSelectedCityChangedNoti;
UIKIT_EXTERN NSString * const TYWJAppDidEnterBgNoti;
UIKIT_EXTERN NSString * const TYWJAppDidEnterFgNoti;
//微信支付结果通知
UIKIT_EXTERN NSString * const TYWJWechatPayResultNoti;
//司机收车通知
UIKIT_EXTERN NSString * const TYWJCloseRouteNoti;
//单次票数购票数量改变
UIKIT_EXTERN NSString * const TYWJTicketNumsDidChangeNoti;

UIKIT_EXTERN NSString * const TYWJWechatPayResult;

#pragma mark - app相关

UIKIT_EXTERN NSString *kAppName;
UIKIT_EXTERN NSString *kAppUrlScheme;

#pragma mark - 其他

UIKIT_EXTERN NSString * const TYWJAppVersion;
//隐私政策
UIKIT_EXTERN NSString * const TYWJPrivacyUrl;
//用车协议
UIKIT_EXTERN NSString * const TYWJCarProtocolUrl;
//购票须知
UIKIT_EXTERN NSString * const TYWJTicketingInformation;
//测试手机号
UIKIT_EXTERN NSString * const TYWJTestPhoneNum;

UIKIT_EXTERN NSString * const TYWJBanerJumpPath;
