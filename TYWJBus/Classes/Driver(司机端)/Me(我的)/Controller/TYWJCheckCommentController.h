//
//  TYWJCheckCommentController.h
//  TYWJBus
//
//  Created by MacBook on 2019/1/3.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TYWJCheckCommentTypeComment,
    TYWJCheckCommentTypeComplaint
} TYWJCheckCommentType;

NS_ASSUME_NONNULL_BEGIN


@interface TYWJCheckCommentController : UIViewController

/* type */
@property (assign, nonatomic) TYWJCheckCommentType type;

@end

NS_ASSUME_NONNULL_END
