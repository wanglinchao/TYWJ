//
//  TYWJStartToDestinationView.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/6.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJRouteListInfo,TYWJTicketListInfo,TYWJTicketListMonthInfo,TYWJDriverRouteListInfo,TYWJMonthTicket;

//定义某个文件内的全局变量的时候，最好在前面加上static，以防出现重复定义的报错，这是沿用了C++的变量风格：多文件程序的外部定义变量，只要定义在文件内的全局变量，只要没加上static关键字，则默认为外部变量，由于OC没有命名空间，所以这样子做必将出现k重复定义的报错
//CGFloat test666 = 0;

@interface TYWJStartToDestinationView : UIView

/* listInfo */
@property (strong, nonatomic) TYWJRouteListInfo *listInfo;
/* driveListInfo */
@property (strong, nonatomic) TYWJDriverRouteListInfo *driveListInfo;
/* ticket */
@property (strong, nonatomic) TYWJTicketListInfo *ticket;
/* monthTicket */
@property (strong, nonatomic) TYWJMonthTicket *monthTicket;

- (void)addTarget:(id)target action:(nonnull SEL)action;
- (void)reloadData;

@end
