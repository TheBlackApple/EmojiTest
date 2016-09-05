//
//  SRExpressionTool.h
//  ExpressionTest
//
//  Created by Charles on 16/9/5.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SRExpressionTool : NSObject

/**
 *  处理表情字符
 *
 *  @param text 带表情的文字
 *
 *  @return 处理后的文字
 */
+ (NSMutableAttributedString *)emotionStrWithString:(NSString *)text;

/**
 *  将带有表情符的文字转换为图文混排的文字
 *
 *  @param text      带表情符的文字
 *  @param plistName 表情符与表情对应的plist文件
 *  @param y         图片的y偏移值
 *
 *  @return 转换后的文字
 */
+ (NSMutableAttributedString *)emotionStrWithString:(NSString *)text plistName:(NSString *)plistName yOffset:(CGFloat)offset;

/**
 *  将个别文字转换为特殊的图片
 *
 *  @param string    原始文字段落
 *  @param text      特殊的文字
 *  @param imageName 要替换的图片
 *
 *  @return  NSMutableAttributedString
 */
+ (NSMutableAttributedString *)exchangeString:(NSString *)string withText:(NSString *)text imageName:(NSString *)imageName;

/**
 *  删除表情
 *
 *  @param content 字符串
 */
+ (void)deleteExpression:(NSMutableString *)content;

/**
 *  计算文本高度
 *
 *  @param text 传入的字符
 *
 *  @return 返回字符的size
 */
+ (CGSize)textSize:(NSAttributedString *)text maxSize:(CGSize)maxSize;

@end
