//
//  TYWJHelpModel.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/19.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYWJHelpModel : NSObject

/* wtmc */
@property (copy, nonatomic) NSString *wtmc;
/* text */
@property (copy, nonatomic) NSString *text;
/* answer */
@property (copy, nonatomic) NSString *answer;
/* cellH */
@property (assign, nonatomic) CGFloat cellH;

@end
