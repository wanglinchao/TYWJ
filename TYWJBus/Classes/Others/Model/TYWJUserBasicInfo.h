//
//  TYWJUserBasicInfo.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/24.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYWJUserBasicInfo : NSObject

/* avatarImage */
@property (copy, nonatomic) NSString *avatarImage;
/* nickname */
@property (copy, nonatomic) NSString *nickname;

/* uid */
@property (copy, nonatomic) NSString *uid;

/* phoneNum */
@property (copy, nonatomic) NSString *phoneNum;

@end
