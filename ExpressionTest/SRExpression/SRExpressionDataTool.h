//
//  SRExpressionDataTool.h
//  ExpressionTest
//
//  Created by Charles on 16/9/5.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SRExpressionDataTool : NSObject
/**
 *获取所有emoji表情
 */
+ (NSArray *)ObtainAllEmojiExpression;

/**
 *获取所有sina默认表情
 */
+ (NSArray *)ObtainAllSinaDefaultExpression;

/**
 *获取所有浪小花表情
 */
+ (NSArray *)ObtainAllSinaLxhExpression;

/**
 *根据图片名称获取sina默认表情图片
 */
+ (UIImage *)ObtainPictureDefault:(NSString *)name;

/**
 *根据图片名称获取sina浪小花表情图片
 */
+ (UIImage *)ObtainPictureLxh:(NSString *)name;

/**
 *根据表情名称获取sina默认表情图片
 */
+ (UIImage *)ObtainPictureNameDefault:(NSString *)name;

/**
 *根据表情名称获取sina浪小花表情图片
 */
+ (UIImage *)ObtainPictureNameLxh:(NSString *)name;

/**
 *根据表情名称获取表情图片
 */
+ (UIImage *)ObtainPictureName:(NSString *)name;

/**
 *获取删除按钮图片
 */
+ (UIImage *)ObtainBtnImage;


@end
