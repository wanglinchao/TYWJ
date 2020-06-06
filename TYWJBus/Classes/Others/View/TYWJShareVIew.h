//
//  TYWJShareVIew.h
//  TYWJBus
//
//  Created by tywj on 2020/6/6.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJShareVIew : UIView
@property (copy, nonatomic) void(^buttonSeleted)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
