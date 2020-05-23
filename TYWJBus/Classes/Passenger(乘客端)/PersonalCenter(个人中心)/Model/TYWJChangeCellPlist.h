//
//  TYWJChangeCellPlist.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/11.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYWJChangeCellPlist : NSObject

/* title */
@property (copy, nonatomic) NSString *title;
/* indec */
@property (copy, nonatomic) NSString *index;
/* 是否是取消 */
@property (assign, nonatomic) BOOL isCancel;
/* url */
@property (copy, nonatomic) NSString *url;

@end
