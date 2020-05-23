//
//  TYWJRequestFailedController.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/12.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWJRequestFailedController : UIViewController

- (void)setImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle isHideBtn:(BOOL)isHideBtn;

/* reloadClicked */
@property (copy, nonatomic) void(^reloadClicked)(void);

@end
