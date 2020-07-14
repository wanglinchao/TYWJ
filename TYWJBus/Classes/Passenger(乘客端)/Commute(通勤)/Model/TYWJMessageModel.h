//
//  TYWJMessageModel.h
//  TYWJBus
//
//  Created by tywj on 2020/7/13.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJMessageModel : NSObject
@property (copy, nonatomic) NSString *content;
@property (assign, nonatomic) double createDate;
@property (copy, nonatomic) NSString *id;
@property (assign, nonatomic) int read;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) int type;
@property (copy, nonatomic) NSString *uid;
@end

NS_ASSUME_NONNULL_END
