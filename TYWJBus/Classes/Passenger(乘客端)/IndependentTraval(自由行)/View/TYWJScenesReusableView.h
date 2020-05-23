//
//  TYWJScenesReusableView.h
//  TYWJBus
//
//  Created by Harley He on 2018/7/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const TYWJScenesReusableViewID;

@interface TYWJScenesReusableView : UICollectionReusableView

@property (weak, nonatomic, readonly) IBOutlet UILabel *titleLabel;

@end
