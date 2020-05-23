//
//  TYWJMoreCellList.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/26.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYWJMoreCellList : NSObject

/* title */
@property (copy, nonatomic) NSString *title;
/* 是否显示switch */
@property (assign, nonatomic) BOOL isShowSwitch;
/* index */
@property (assign, nonatomic) int index;

@end
