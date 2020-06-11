//
//  TYWJTicketStoreList.h
//  TYWJBus
//
//  Created by tywj on 2020/6/11.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJTicketStoreList : NSObject
@property (assign, nonatomic) int assign_seate_no;
@property (assign, nonatomic) int id;
@property (assign, nonatomic) int sell_num;
@property (assign, nonatomic) int status;
@property (copy, nonatomic) NSString *line_code;
@property (copy, nonatomic) NSString *line_date;
@property (copy, nonatomic) NSString *line_name;
@property (copy, nonatomic) NSString *line_time;
@property (copy, nonatomic) NSString *store_no;
@end

NS_ASSUME_NONNULL_END
