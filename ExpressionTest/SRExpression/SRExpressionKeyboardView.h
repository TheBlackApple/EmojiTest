//
//  SRExpressionKeyboardView.h
//  ExpressionTest
//
//  Created by Charles on 16/9/5.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRExpressionKeyboardViewDelegate <NSObject>

- (void)srExpressionSelect:(NSString *)select;

- (void)srExpressionDelete;

- (void)srExpressionSend;

@end

@interface SRExpressionKeyboardView : UIView <UIScrollViewDelegate>

@property(nonatomic,assign) id<SRExpressionKeyboardViewDelegate> delegate;

@property (nonatomic,strong) UIScrollView *defaultView;     //默认view

@property (nonatomic,strong) UIPageControl *defaultPage;    //默认页

@property (nonatomic,strong) NSArray *emojiArry;            //emoji表情数据
@property (nonatomic,strong) NSArray *defaultArry;          //默认表情数据
@property (nonatomic,strong) NSArray *lxhArry;              //

@property (nonatomic,assign) NSInteger emojinum;            //
@property (nonatomic,assign) NSInteger defaultnum;          //
@property (nonatomic,assign) NSInteger lxhnum;              //

@property (nonatomic,strong) UIButton *emojiBtn;            //
@property (nonatomic,strong) UIButton *defaultBtn;          //
@property (nonatomic,strong) UIButton *lxhBtn;              //

@property (nonatomic,assign) NSInteger selectIndex;         //选中的索引位置


@end
