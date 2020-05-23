//
//  TYWJRankView.h
//  TYWJBus
//
//  Created by Harley He on 2018/7/20.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWJRankView : UIView

/* img */
@property (copy, nonatomic) NSString *img;
/* title */
@property (copy, nonatomic) NSString *title;
/* rank */
@property (copy, nonatomic) NSString *rank;
/* viewClicked */
@property (copy, nonatomic) void(^viewClicked)(void);

@end
