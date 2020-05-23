//
//  TYWJPopSelectController.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/13.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TYWJPopSelectControllerDelegate  <NSObject>

@optional
- (void)popSelectControllerViewDidClicked;
- (void)popSelectControllerConfirmClickedWithModel:(id)model;

@end

@interface TYWJPopSelectController : UIViewController

/* delegate */
@property (weak, nonatomic) id<TYWJPopSelectControllerDelegate> delegate;

/**
 传入要显示的数据数组，如果传入的数组是模型数组的话，pName务必要传入模型中要显示的属性的名称，如果传入pName是nil的话，dataArray务必传入的是NSString的数组

 @param dataArray 要显示的信息的数据数组
 @param pName 如果传入的是模型数组的话，这个便是此模型要显示的文字的属性名称
 */
- (void)setDataArray:(nonnull NSArray *)dataArray andPropertyName:(NSString *)pName;

@end
