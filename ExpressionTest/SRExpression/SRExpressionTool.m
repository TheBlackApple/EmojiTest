//
//  SRExpressionTool.m
//  ExpressionTest
//
//  Created by Charles on 16/9/5.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "SRExpressionTool.h"
#import "SRExpressionDataTool.h"

@implementation SRExpressionTool

+ (NSMutableAttributedString *)emotionStrWithString:(NSString *)text
{
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
//    NSArray  *face = [NSArray arrayWithContentsOfFile:filePath];
//    //1、创建一个可变的属性字符串
//    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
//    //2、通过正则表达式来匹配字符串
//    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]"; //匹配表情
//    
//    NSError *error = nil;
//    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
//    if (!re) {
//        NSLog(@"%@", [error localizedDescription]);
//        return attributeString;
//    }
//    
//    NSArray *resultArray = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];
//    //3、获取所有的表情以及位置
//    //用来存放字典，字典中存储的是图片和图片对应的位置
//    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
//    //根据匹配范围来用图片进行相应的替换
//    for(NSTextCheckingResult *match in resultArray) {
//        //获取数组元素中得到range
//        NSRange range = [match range];
//        //获取原字符串中对应的值
//        NSString *subStr = [text substringWithRange:range];
//        for (int i = 0; i < face.count; i ++) {
//            if ([face[i][@"cht"] isEqualToString:subStr]) {
//                //face[i][@"png"]就是我们要加载的图片
//                //新建文字附件来存放我们的图片,iOS7才新加的对象
//                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//                //给附件添加图片
//                textAttachment.image = [UIImage imageNamed:face[i][@"png"]];
//                //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
//                textAttachment.bounds = CGRectMake(0, -8, textAttachment.image.size.width, textAttachment.image.size.height);
//                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
//                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
//                //把图片和图片对应的位置存入字典中
//                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
//                [imageDic setObject:imageStr forKey:@"image"];
//                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
//                //把字典存入数组中
//                [imageArray addObject:imageDic];
//            }
//        }
//    }
//    
//    //4、从后往前替换，否则会引起位置问题
//    for (int i = (int)imageArray.count -1; i >= 0; i--) {
//        NSRange range;
//        [imageArray[i][@"range"] getValue:&range];
//        //进行替换
//        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
//    }
//    return attributeString;
    
    //创建可变的属性字符串
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    
    //通过正则表达式来匹配字符
    NSString *regex = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]";
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (!re) {
        NSLog(@"%@",[error localizedDescription]);
        return attributeString;
    }
    
    NSArray *resultArray = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        
        //获取数组元素中得到range
        NSRange range = [match range];
        
        //获取原字符串中对应的值
        NSString *subStr = [text substringWithRange:range];
        
        //新建文字附件来存放我们的图片,iOS7才新加的对象
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc]init];
        
        //给附件添加图片
        textAttachment.image= [SRExpressionDataTool ObtainPictureName:subStr];
        
        //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
        textAttachment.bounds=CGRectMake(0, -8,textAttachment.image.size.width, textAttachment.image.size.height);
        
        //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        //把图片和图片对应的位置存入字典中
        NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
        
        [imageDic setObject:imageStr forKey:@"image"];
        
        [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
        
        //把字典存入数组中
        [imageArray addObject:imageDic];
        
    }
    
    //4、从后往前替换，否则会引起位置问题
    for(int i = (int)imageArray.count-1; i >=0; i--) {
        
        NSRange range;
        
        [imageArray[i][@"range"] getValue:&range];
        
        //进行替换
        
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
        
    }
    return attributeString;

}

/**
 *  将带有表情符的文字转换为图文混排的文字
 *
 *  @param text      带表情符的文字
 *  @param plistName 表情符与表情对应的plist文件
 *  @param y         图片的y偏移值
 *
 *  @return 转换后的文字
 */
+ (NSMutableAttributedString *)emotionStrWithString:(NSString *)text plistName:(NSString *)plistName yOffset:(CGFloat)offset
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:plistName ofType:nil];
    NSArray  *face = [NSArray arrayWithContentsOfFile:filePath];
    //1、创建一个可变的属性字符串
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    //2、通过正则表达式来匹配字符串
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]"; //匹配表情
    
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
        return attributeString;
    }
    
    NSArray *resultArray = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    //3、获取所有的表情以及位置
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        //获取原字符串中对应的值
        NSString *subStr = [text substringWithRange:range];
        for (int i = 0; i < face.count; i ++) {
            if ([face[i][@"cht"] isEqualToString:subStr]) {
                //face[i][@"png"]就是我们要加载的图片
                //新建文字附件来存放我们的图片,iOS7才新加的对象
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                //给附件添加图片
                textAttachment.image = [UIImage imageNamed:face[i][@"png"]];
                //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
                textAttachment.bounds = CGRectMake(0, offset, textAttachment.image.size.width, textAttachment.image.size.height);
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                //把字典存入数组中
                [imageArray addObject:imageDic];
            }
        }
    }
    
    //4、从后往前替换，否则会引起位置问题
    for (int i = (int)imageArray.count -1; i >= 0; i--) {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
    }
    return attributeString;
}

+ (NSMutableAttributedString *)exchangeString:(NSString *)string withText:(NSString *)text imageName:(NSString *)imageName
{
    //1、创建一个可变的属性字符串
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    
    //2、匹配字符串
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:string options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
        return attributeString;
    }
    
    NSArray *resultArray = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    //3、获取所有的图片以及位置
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        //新建文字附件来存放我们的图片(iOS7才新加的对象)
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        //给附件添加图片
        textAttachment.image = [UIImage imageNamed:imageName];
        //修改一下图片的位置,y为负值，表示向下移动
        textAttachment.bounds = CGRectMake(0, -2, textAttachment.image.size.width, textAttachment.image.size.height);
        //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        //把图片和图片对应的位置存入字典中
        NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
        [imageDic setObject:imageStr forKey:@"image"];
        [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
        //把字典存入数组中
        
        
        [imageArray addObject:imageDic];
    }
    
    //4、从后往前替换，否则会引起位置问题
    for (int i = (int)imageArray.count -1; i >= 0; i--) {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
    }
    
    return attributeString;
}


+ (void)deleteExpression:(NSMutableString *)content{
    if([content length] <= 0){
        return;
    }
    //字符串末尾
    NSInteger length = [content length] - 1;
    
    //字符串末尾位置
    NSRange range = NSMakeRange(length, 1);
    
    //获取末尾位置字符串
    NSString *lastStr = [content substringWithRange:range];
    
    if ([lastStr isEqualToString:@"]"]) {
        //新浪,小浪花表情
        
        //获取[的位置
        NSRange biaoqingRang = [content rangeOfString:@"[" options:NSBackwardsSearch];
        
        //获取[]长度
        NSInteger biaoqingLength = range.location - biaoqingRang.location;
        
        //重置删除的range
        range = NSMakeRange(length - biaoqingLength, biaoqingLength + 1);
        
    }else if ([lastStr intValue] < 0x1F600 || [lastStr intValue] > 0x1F64F) {
        //系统表情
        
        //重置删除的range
        range = NSMakeRange(length - 1, 2);
    }
    [content deleteCharactersInRange:range];
}

+ (CGSize)textSize:(NSAttributedString *)text maxSize:(CGSize)maxSize{
    CGSize size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return size;
}

@end
