//
//  TYWJChooseStopsCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/12.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYWJChooseStationView;

UIKIT_EXTERN NSString * const TYWJChooseStopsCellID;

@interface TYWJChooseStopsCell : UITableViewCell

/* getupStatonClicked */
@property (copy, nonatomic) void(^getupStatonClicked)(void);
/* getdownStatonClicked */
@property (copy, nonatomic) void(^gedownStatonClicked)(void);

/* getupView */
@property (strong, nonatomic, readonly) TYWJChooseStationView *getupView;
/* getdownView */
@property (strong, nonatomic, readonly) TYWJChooseStationView *getdownView;
- (void)setGetupStation:(NSString *)station;
- (void)setGetdownStation:(NSString *)station;


@end
