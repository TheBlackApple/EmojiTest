//
//  ViewController.h
//  ExpressionTest
//
//  Created by Charles on 16/9/5.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic, strong) UITextView * textView;


@end


@protocol SRChatToolViewDelegate <NSObject>

- (void)srChatToolViewShowExpressionView;

- (void)srChatToolViewHideExpressionView;

@end

@interface SRChatToolView : UIView

@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, assign) id<SRChatToolViewDelegate> delegate;

- (void)hideExpressionView;

@end