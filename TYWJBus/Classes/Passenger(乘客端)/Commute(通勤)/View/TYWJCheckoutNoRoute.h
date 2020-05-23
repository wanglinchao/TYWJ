//
//  TYWJCheckoutNoRoute.h
//  TYWJBus
//
//  Created by Harllan He on 2018/5/31.
//  Copyright © 2018 Harllan He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWJCheckoutNoRoute : UIView

/* getupText */
@property (copy, nonatomic) NSString *getupText;
/* getdownText */
@property (copy, nonatomic) NSString *getdownText;

/* btnClicked */
@property (copy, nonatomic) void(^btnClicked)(void);

@end
