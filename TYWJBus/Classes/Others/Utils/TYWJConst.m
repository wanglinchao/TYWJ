//
//  TYWJConst.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/22.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJConst.h"

#pragma mark - 通知

NSString * const TYWJBackToLoginWithPhoneNum = @"TYWJBackToLoginWithPhoneNum";

/** textfield的placeholder的字体颜色的属性key **/
NSString * const TYWJPlacerholderColorKeyPath = @"_placeholderLabel.textColor";

#pragma mark  - 登录
NSString * const TYWJLoginStatusString = @"TYWJLoginStatusString";
NSString * const TYWJLoginPhoneNumString = @"TYWJLoginPhoneNumString";
NSString * const TYWJLoginNickanmeString = @"TYWJLoginNickanmeString";
NSString * const TYWJLoginTypeString = @"TYWJLoginTypeString";
NSString * const TYWJLoginPassengerPwdString = @"TYWJLoginPassengerPwdString";
NSString * const TYWJLoginDriverPwdString = @"TYWJLoginDriverPwdString";

#pragma mark - 选中城市
NSString * const TYWJSelectedCityString = @"TYWJSelectedCityString";
NSString * const TYWJSelectedCityIDString = @"TYWJSelectedCityIDString";

#pragma mark - plist
NSString * const TYWJSideColumnPlist = @"TYWJSideColumn.plist";
NSString * const TYWJSideColumn0Plist = @"TYWJSideColumn0.plist";
NSString * const TYWJMoreCellListPlist = @"TYWJMoreCellList.plist";
NSString * const TYWJDriverMoreCellListPlist = @"TYWJDriverMoreCellList.plist";
NSString * const TYWJPersonalCenterPlist = @"TYWJPersonalCenter.plist";
NSString * const TYWJChangeAvatarCellPlist = @"TYWJChangeAvatarCell.plist";
NSString * const TYWJApplyRoutePlist = @"TYWJApplyRoute.plist";
NSString * const TYWJCustomerServicePlist = @"TYWJCustomerService.plist";
NSString * const TYWJAboutUsPlist = @"TYWJAboutUs.plist";
NSString * const TYWJMyTicketListPlist = @"TYWJMyTicketList.plist";
NSString * const TYWJMyTicketList1Plist = @"TYWJMyTicketList1.plist";
NSString * const TYWJComplaintListPlist = @"TYWJComplaintList.plist";
NSString * const TYWJRefundTicketReasonPlist = @"TYWJRefundTicketReason.plist";
NSString * const TYWJSelectMapPlist = @"TYWJSelectMap.plist";
NSString * const TYWJDetailRouteBubblePlist = @"TYWJDetailRouteBubble.plist";
NSString * const TYWJDetailRouteBubble1Plist = @"TYWJDetailRouteBubble1.plist";
NSString * const TYWJScenesAPlist = @"TYWJScenesA.plist";
NSString * const TYWJScenesPlist = @"TYWJScenes.plist";

#pragma mark - 网络请求
//#ifdef DEBUG
//NSString * const TYWJRequestJsonPicService = @"http://114.115.175.229:9088/";
//NSString * const TYWJRequestJsonService = @"http://114.115.175.229:9088/IpandaApi";
//NSString * const TYWJRequestService = @"http://114.115.175.229:8899/soap/ITYWJAPP";
////NSString * const TYWJRequestService = @"http://114.115.175.229:8888/soap/ITYWJAPP";
//NSString * const TYWJRequestSingUpService = @"http://182.140.132.153:8080/driver";
//
////NSString * const TYWJCd917Service = @"http://beta.cd917.com";
////NSString * const TYWJCd917ApiKey = @"82AFB673A47D471182E64A41CFEE4AAC";
////NSString * const TYEJCd917AppSecret = @"FBED2885DE294C7BBB9EA6408E8EEBD5";
//NSString * const TYWJCd917Service = @"https://dzyydh.cd917.com";
//NSString * const TYWJCd917ApiKey = @"DF93564D3B2B4DEBB8DF36A23DA69DDF";
//NSString * const TYEJCd917AppSecret = @"60B7F841267C41FD92FDB78C15B7C615";
//#else
NSString * const TYWJRequestJsonPicService = @"http://114.115.175.229:8085/";
NSString * const TYWJRequestJsonService = @"http://114.115.175.229:8085/IpandaApi";
NSString * const TYWJRequestService = @"http://114.115.175.229:8888/soap/ITYWJAPP";
NSString * const TYWJRequestSingUpService = @"http://182.140.132.153:8080/driver";
////@"http://182.140.132.153:7979/driver";
//
////cd917
////NSString * const TYWJCd917Service = @"http://www.cd917.com";
NSString * const TYWJCd917Service = @"https://dzyydh.cd917.com";
NSString * const TYWJCd917ApiKey = @"DF93564D3B2B4DEBB8DF36A23DA69DDF";
NSString * const TYEJCd917AppSecret = @"60B7F841267C41FD92FDB78C15B7C615";
//#endif

//正式
//@"http://114.115.175.229:8888/soap/ITYWJAPP";
//@"http://114.115.175.229:8085/IpandaApi";
//测试
//@"http://114.115.175.229:9999/soap/ITYWJAPP";
//@"http://114.115.175.229:8082/IpandaApi";

NSString * const TYWJRequestLoginPassenger = @"ck_user";
NSString * const TYWJRequestLoginDriver = @"sj_user";
NSString * const TYWJRequestGetCityLists = @"chengshi";
NSString * const TYWJRequestAcitivity = @"huodongzhongxin";
NSString * const TYWJRequesrRouteList = @"xianlubiao";
NSString * const TYWJRequesrSubRouteList = @"xianlubiaozibiao";
NSString * const TYWJRequesrGetPurchasedTickets = @"chepiao";
NSString * const TYWJRequesrGetPurchasedMonthTickets = @"zqchepiao";
NSString * const TYWJRequestApplyForNewRoute = @"xianlushenqinginsert";
NSString * const TYWJRequestCheckoutAppliedRoute = @"xianlushenqing";
NSString * const TYWJRequstOnlineFeedback = @"zaixianfankuiinsert";
NSString * const TYWJRequstOnlineComplaint = @"tousu";
NSString * const TYWJRequstOnlineComment = @"fuwupingjia";
NSString * const TYWJRequestCommonQuestions = @"changjianwenti";
NSString * const TYWJRequestRegisterPassenger = @"ck_userinsert";
NSString * const TYWJRequestRegisterDriver = @"sj_userinsert";
NSString * const TYWJRequestGetTicketPrice = @"piaojia";
NSString * const TYWJRequestCanBuySingleTicket = @"checkgoupiao";
NSString * const TYWJRequestGetLastSeats = @"getkucun";
NSString * const TYWJRequestCanBuyMonthTicket = @"checkyuepiaogoupiao";
NSString * const TYWJRequestCheckPassengerUserIsRegistered = @"checkuser";
NSString * const TYWJRequestCheckDriverUserIsRegistered = @"checksijiuser";
NSString * const TYWJRequestCheckTicket = @"shangche";
NSString * const TYWJRequestUpdateUserUid = @"updateuser";
NSString * const TYWJRequestGetCardCategory = @"kaleixing";
NSString * const TYWJRequestMakeOrder = @"zqchepiaoinsert";
NSString * const TYWJRequestGetCarLocation = @"getweizhi";
NSString * const TYWJRequestModifyPwd = @"ck_updatepsd";
NSString * const TYWJRequestModifyDriverPwd = @"sj_updatepsd";\
NSString * const TYWJRequestGetSql = @"getsql";
NSString * const TYWJRequestGetMaiguo = @"getmaiguo";
NSString * const TYWJRequestInsertbaoche = @"insertbaoche";
NSString * const TYWJRequestRefuse = @"updatexianlupipei";
NSString * const TYWJRequesrFancheng = @"fanchengluxian";

//司机相关
NSString * const TYWJRequestGetDriverRoute = @"getsijixianlu";
//NSString * const TYWJRequestGetStaionInfo = @"getchezhan";
NSString * const TYWJRequestDriverLuanchCar = @"sijichufa";
NSString * const TYWJRequestUploadDiverLocation = @"weizhiinsert";
NSString * const TYWJRequestGetStaionPassengerNum = @"getchezhanrenshu";
NSString * const TYWJRequsetCloseRoute = @"sijishouche";
NSString * const TYWJRequestDriverSalary = @"getsijiqianbao";
NSString * const TYWJRequestCheckComment = @"sijipingjia";
NSString * const TYWJRequestCheckComplaint = @"sijitousu";

//自由行相关
NSString * const TYWJRequestGetITTicket = @"getticket";

#pragma mark - 提醒文字

NSString * const TYWJWarningBadNetwork = @"网络差，请稍后重试";
NSString * const TYWJWarningWrongUsernameOrPwd = @"用户名或密码错误";
NSString * const TYWJWarningLoginLoading = @"拼命登录中，请稍后";
NSString * const TYWJWarningLoading = @"拼命加载中，请稍后";
NSString * const TYWJWarningSearchLoading = @"拼命搜索中，请稍后";

#pragma mark - 其他
//客服电话，有可能也是请求数据获取
NSString * const TYWJCustomerServicePhoneNum = @"4000821717";
//投诉热线
NSString * const TYWJComplaintsHotlinePhoneNum = @"4000821717";
//effectView的alpha
CGFloat const TYWJEffectViewAlpha = 0.65f;

#pragma mark - key
//高德地图key
NSString * const TYWJAMapKey = @"74c02e3c6f7a0a0d4848332b7bd97c60";
//支付宝ID
NSString * const TYWJAliPayAppID = @"2018053060313344";
//友盟  //@"5b2078feb27b0a35c600003a";
NSString * const TYWJUmengAppKey = @"5c3e80e7b465f5a9a0000283";
//微信
NSString * const TYWJWechatAppKey = @"wx91e0bd2897c70b37";
//微信小程序
NSString * const TYWJWechatAppletKey = @"gh_0a41f01db536";
//微信secretkey
NSString * const TYWJWechatSecretKey = @"TYWJWechatSecretKey";
//kAppleStoreId
NSString * const kAppleStoreId = @"1407574824";//1407574824  //989673964


#pragma mark - 通知
NSString * const TYWJModifyUserInfoNoti = @"TYWJModifyUserInfoNoti";

NSString * const TYWJPhotoSelectedSuccessNoti = @"TYWJPhotoSelectedSuccessNoti";
NSString * const TYWJSelectedCityChangedNoti = @"TYWJSelectedCityChangedNoti";
NSString * const TYWJAppDidEnterBgNoti = @"TYWJAppDidEnterBgNoti";
NSString * const TYWJAppDidEnterFgNoti = @"TYWJAppDidEnterFgNoti";
NSString * const TYWJWechatPayResultNoti = @"TYWJWechatPayResultNoti";
NSString * const TYWJCloseRouteNoti = @"TYWJCloseRouteNoti";
NSString * const TYWJTicketNumsDidChangeNoti = @"TYWJTicketNumsDidChangeNoti";

NSString * const TYWJWechatPayResult = @"weixin_pay_result";

#pragma mark - app相关

NSString *kAppName = @"胖哒直通车";
NSString *kAppUrlScheme = @"TYWJAiziyouBus";

#pragma mark - 其他

NSString * const TYWJAppVersion = @"TYWJAppVersion";

NSString * const TYWJPrivacyUrl = @"http://114.115.175.229:8887/%E9%9A%90%E7%A7%81%E5%A3%B0%E6%98%8E.html";
NSString * const TYWJCarProtocolUrl = @"http://114.115.175.229:8085/%E7%94%A8%E6%88%B7%E5%8D%8F%E8%AE%AE.html";
NSString * const TYWJTicketingInformation = @"http://114.115.175.229:8085/%E8%B4%AD%E7%A5%A8%E9%A1%BB%E7%9F%A5.html";

//测试手机号
NSString * const TYWJTestPhoneNum = @"13658016266";


NSString * const TYWJBanerJumpPath = @"TYWJBanerJumpPath";
