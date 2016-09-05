//
//  ViewController.m
//  ExpressionTest
//
//  Created by Charles on 16/9/5.
//  Copyright © 2016年 Charles. All rights reserved.
//
#import "ViewController.h"
#import "SRExpressionKeyboardView.h"
#import "SRExpressionTool.h"

#define WIDE [[UIScreen mainScreen] bounds].size.width       //屏幕宽
#define HIGH [[UIScreen mainScreen] bounds].size.height      //屏幕高

@interface ViewController ()<SRExpressionKeyboardViewDelegate,UITextViewDelegate,SRChatToolViewDelegate>{
    NSMutableString *contentStr;
    SRChatToolView * _toolView;
    CGFloat _keyBoardHeight;
    CGRect originFr;
}

@property (nonatomic, strong) SRExpressionKeyboardView *expressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    contentStr = [[NSMutableString alloc] init];
    [self makeView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

}


- (void)makeView{
    
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.layer.cornerRadius = 4.0f;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 1.0f;

    _toolView = [[SRChatToolView alloc]initWithFrame:CGRectMake(0, HIGH- 60, WIDE, 60)];
    _toolView.textView.delegate = self;
    _toolView.delegate = self;
    [self.view addSubview:_toolView];
    originFr = _toolView.frame;
    self.expressView.hidden = YES;
}

#pragma mark - SRChatToolViewDelegate

- (void)srChatToolViewShowExpressionView{
    [_toolView.textView resignFirstResponder];
    self.expressView.hidden = NO;
    _toolView.frame = CGRectMake(0, CGRectGetMinY(self.expressView.frame) - 60, WIDE, 60);
}

- (void)srChatToolViewHideExpressionView{
    self.expressView.hidden = YES;
    [self.view endEditing:NO];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.expressView.hidden = YES;
    [contentStr appendString:textView.text];
    if (!textView.text.length) {
        return;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [contentStr appendString:textView.text];
}
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    _toolView.frame = originFr;
    return YES;
}

#pragma mark - SRExpressionKeyboardViewDelegate

- (void)srExpressionSelect:(NSString *)select{
    [contentStr appendString:select];
    NSLog(@"select is %@",select);
    _toolView.textView.attributedText= [SRExpressionTool  emotionStrWithString:contentStr];
}

- (void)srExpressionDelete{
    [SRExpressionTool deleteExpression:contentStr];
    _toolView.textView.attributedText= [SRExpressionTool  emotionStrWithString:contentStr];
}

- (void)srExpressionSend{
    self.textView.attributedText = [SRExpressionTool  emotionStrWithString:contentStr];
    [self chanageTextViewFrame:self.textView text:self.textView.attributedText];
}

#pragma mark - Other method

- (void)chanageTextViewFrame:(UITextView *)myTextView text:(NSAttributedString *)content{
    NSMutableAttributedString * attrContent = [[NSMutableAttributedString alloc]initWithAttributedString:content];
    [attrContent addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, content.length)];
    CGSize maxSize = CGSizeMake(WIDE - 20, MAXFLOAT);
    CGSize attrStrSize = [SRExpressionTool textSize:content maxSize:maxSize];
    CGRect fr = myTextView.frame;
    fr.size.height = attrStrSize.height+15;
    [UIView animateWithDuration:0.35 animations:^{
        myTextView.frame = fr;
    }];
}

-(void)keyboardWillShow:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _keyBoardHeight = keyboardSize.height;
    if (_keyBoardHeight > 0) {
        _toolView.frame = CGRectMake(0, HIGH - _keyBoardHeight - 60, WIDE, 60);
    }
}

#pragma mark - 一堆属性

- (UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(10,80, WIDE - 20, 200)];
        _textView.font = [UIFont systemFontOfSize:15.0f];
        [self.view addSubview:_textView];
    }
    return _textView;
}

- (SRExpressionKeyboardView *)expressView{
    if (nil == _expressView) {
        _expressView= [[SRExpressionKeyboardView alloc] init];
        _expressView.delegate = self;
        [self.view addSubview:_expressView];
    }
    return _expressView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


@implementation SRChatToolView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self makeView];
    }
    return self;
}

- (void)makeView{
    self.textView.layer.cornerRadius = 2.0f;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 1.0f;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(CGRectGetMaxX(self.textView.frame) + 10, 10, 40, 40);
    [button setTitle:@"表情" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnExpresstion) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    button.layer.cornerRadius = 20.0f;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 1.0f;

}

- (void)btnExpresstion{
    
    if ([self.delegate respondsToSelector:@selector(srChatToolViewShowExpressionView)]) {
        [self.delegate srChatToolViewShowExpressionView];
    }
}

- (UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(10,10, WIDE - 10 - 60, 40)];
        _textView.returnKeyType = UIReturnKeySend;
        [self addSubview:_textView];
    }
    return _textView;
}


- (void)hideExpressionView{
    if ([self.delegate respondsToSelector:@selector(srChatToolViewHideExpressionView)]) {
        [self.delegate srChatToolViewHideExpressionView];
    }
}

@end
