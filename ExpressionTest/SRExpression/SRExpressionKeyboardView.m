//
//  SRExpressionKeyboardView.m
//  ExpressionTest
//
//  Created by Charles on 16/9/5.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "SRExpressionKeyboardView.h"
#import "SRExpressionDataTool.h"

#define WIDE [[UIScreen mainScreen] bounds].size.width       //屏幕宽
#define HIGH [[UIScreen mainScreen] bounds].size.height      //屏幕高


@implementation SRExpressionKeyboardView

- (instancetype)init{
    float wid = 35;
    float jianju = (WIDE - 35 * 7) / 8;
    float gao = wid*3+jianju*3+30+40;
    self = [super initWithFrame:CGRectMake(0, HIGH-gao, WIDE, gao)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
        
        _emojiArry = [SRExpressionDataTool ObtainAllEmojiExpression];
        _emojinum = _emojiArry.count % 20 > 0 ? _emojiArry.count / 20 + 1 : _emojiArry.count / 20;
        
        _defaultArry = [SRExpressionDataTool ObtainAllSinaDefaultExpression];
        _defaultnum = _defaultArry.count % 20 > 0 ? _defaultArry.count / 20 + 1 : _defaultArry.count / 20;
        
        _lxhArry = [SRExpressionDataTool ObtainAllSinaLxhExpression];
        _lxhnum = _lxhArry.count % 20 > 0 ? _lxhArry.count / 20 + 1 : _lxhArry.count / 20;
        
        [self addEmojiView:_emojiArry andNum:_emojinum andBegin:0];
        [self addDefaultView:_defaultArry andNum:_defaultnum andBegin:_emojinum];
        [self addLxhView:_lxhArry andNum:_lxhnum andBegin:_defaultnum+_emojinum];
        
        self.defaultPage.numberOfPages = _emojinum;//总的图片页数
        self.defaultPage.currentPage = 0; //当前页
        
        _defaultView.contentSize = CGSizeMake(WIDE*(_emojinum+_defaultnum+_lxhnum), wid*3+jianju*4);
        
        _selectIndex = 0;
        [self addBtnSwitch];
        [self setUpBtnSelect];
    }
    return self;

}
- (void)addBtnSwitch{
    float y = self.bounds.size.height - 39.6;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, y-0.4, WIDE, 0.4)];
    lab.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lab];
    
    _emojiBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, y, WIDE/4, 39.6)];
    [_emojiBtn addTarget:self action:@selector(selectEmojiBtn) forControlEvents:UIControlEventTouchUpInside];
    [_emojiBtn setTitle:@"emoji" forState:UIControlStateNormal];
    _emojiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_emojiBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self addSubview:_emojiBtn];
    
    _defaultBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDE/4, y, WIDE/4, 39.6)];
    [_defaultBtn addTarget:self action:@selector(selectDefaultBtn) forControlEvents:UIControlEventTouchUpInside];
    [_defaultBtn setTitle:@"sina" forState:UIControlStateNormal];
    _defaultBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_defaultBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self addSubview:_defaultBtn];
    
    _lxhBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDE/4*2, y, WIDE/4, 39.6)];
    [_lxhBtn addTarget:self action:@selector(selectLxhBtn) forControlEvents:UIControlEventTouchUpInside];
    [_lxhBtn setTitle:@"浪小花" forState:UIControlStateNormal];
    _lxhBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_lxhBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self addSubview:_lxhBtn];
    
    UIButton * sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDE/4*3, y, WIDE/4, 39.6)];
    [sendBtn addTarget:self action:@selector(selectSendBtn) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self addSubview:sendBtn];

}

//emoji表情
- (void)addEmojiView:(NSArray *)defaultArry andNum:(NSInteger)ynum andBegin:(NSInteger)beginNum{
    //表情大小
    float wid = 35;
    float hig = 35;
    //间距
    float jianju = (WIDE - 35 * 7) / 8;
    
    NSInteger index = 0;
    
    for (int i=0; i<ynum; i++) {
        
        for (int y=0; y<3; y++) {
            
            for (int u=0; u<7; u++) {
                
                if(y == 2 && u == 6){
                    
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(beginNum*WIDE+jianju+(jianju+wid)*u+i*WIDE, (jianju+hig)*y+15, wid, hig-10)];
                    [btn setBackgroundImage:[SRExpressionDataTool ObtainBtnImage] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(deleteLxh:) forControlEvents:UIControlEventTouchUpInside];
                    [self.defaultView addSubview:btn];
                    
                }else if(index < defaultArry.count){
                    
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(beginNum*WIDE+jianju+(jianju+wid)*u+i*WIDE, (jianju+hig)*y+10, wid, hig)];
                    btn.tag = 10000+index;
                    btn.titleLabel.font = [UIFont systemFontOfSize:25];
                    [btn setTitle:defaultArry[index] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(tapLxhView:) forControlEvents:UIControlEventTouchUpInside];
                    [self.defaultView addSubview:btn];
                    
                    index++;
                    
                }
            }
        }
    }
}

//默认表情
- (void)addDefaultView:(NSArray *)defaultArry andNum:(NSInteger)ynum andBegin:(NSInteger)beginNum{
    //表情大小
    float wid = 35;
    float hig = 35;
    //间距
    float jianju = (WIDE - 35 * 7) / 8;
    
    NSInteger index = 0;
    
    for (int i=0; i<ynum; i++) {
        
        for (int y=0; y<3; y++) {
            
            for (int u=0; u<7; u++) {
                
                if(y == 2 && u == 6){
                    
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(beginNum*WIDE+jianju+(jianju+wid)*u+i*WIDE, (jianju+hig)*y+15, wid, hig-10)];
                    [btn setBackgroundImage:[SRExpressionDataTool ObtainBtnImage] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(deleteLxh:) forControlEvents:UIControlEventTouchUpInside];
                    [self.defaultView addSubview:btn];
                    
                }else if(index < defaultArry.count){
                    
                    NSDictionary *dict = defaultArry[index];
                    NSString *strName = dict[@"png"];
                    UIImage *image = [SRExpressionDataTool ObtainPictureDefault:strName];
                    
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(beginNum*WIDE+jianju+(jianju+wid)*u+i*WIDE, (jianju+hig)*y+10, wid, hig)];
                    btn.tag = 20000+index;
                    [btn setBackgroundImage:image forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(tapLxhView:) forControlEvents:UIControlEventTouchUpInside];
                    [self.defaultView addSubview:btn];
                    
                    index++;
                    
                }
            }
        }
    }
}

//浪小花表情
- (void)addLxhView:(NSArray *)defaultArry andNum:(NSInteger)ynum andBegin:(NSInteger)beginNum{
    //表情大小
    float wid = 35;
    float hig = 35;
    //间距
    float jianju = (WIDE - 35 * 7) / 8;
    
    NSInteger index = 0;
    
    for (int i=0; i<ynum; i++) {
        
        for (int y=0; y<3; y++) {
            
            for (int u=0; u<7; u++) {
                
                if(y == 2 && u == 6){
                    
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(beginNum*WIDE+jianju+(jianju+wid)*u+i*WIDE, (jianju+hig)*y+15, wid, hig-10)];
                    [btn setBackgroundImage:[SRExpressionDataTool ObtainBtnImage] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(deleteLxh:) forControlEvents:UIControlEventTouchUpInside];
                    [self.defaultView addSubview:btn];
                    
                }else if(index < defaultArry.count){
                    
                    NSDictionary *dict = defaultArry[index];
                    NSString *strName = dict[@"png"];
                    UIImage *image = [SRExpressionDataTool ObtainPictureLxh:strName];
                    
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(beginNum*WIDE+jianju+(jianju+wid)*u+i*WIDE, (jianju+hig)*y+10, wid, hig)];
                    btn.tag = 30000+index;
                    [btn setBackgroundImage:image forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(tapLxhView:) forControlEvents:UIControlEventTouchUpInside];
                    [self.defaultView addSubview:btn];
                    
                    index++;
                    
                }
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    NSInteger page = offset.x / bounds.size.width;
    
    if(page == _emojinum-1){
        
        self.defaultPage.numberOfPages = _emojinum;//总的图片页数
        
    }else if(page == _emojinum){
        
        self.defaultPage.numberOfPages = _defaultnum;//总的图片页数
        
    }else if(page == _emojinum+_defaultnum-1){
        
        self.defaultPage.numberOfPages = _defaultnum;//总的图片页数
        
    }else if(page == _emojinum+_defaultnum){
        
        self.defaultPage.numberOfPages = _lxhnum;//总的图片页数
        
    }else if(page == _emojinum+_defaultnum+_lxhnum-1){
        
        self.defaultPage.numberOfPages = _lxhnum;//总的图片页数
        
    }
    
    NSInteger index = page;
    if(page >= _emojinum && page < _emojinum+_defaultnum){
        index = page-_emojinum;
    }else if(page >= _emojinum+_defaultnum && page < _emojinum+_defaultnum+_lxhnum){
        index = page-_emojinum-_defaultnum;
    }
    
    [_defaultPage setCurrentPage:index];
}

- (void)selectEmojiBtn{
    if(_selectIndex != 0){
        _selectIndex = 0;
        self.defaultPage.numberOfPages = _emojinum;
        [_defaultPage setCurrentPage:0];
        self.defaultView.contentOffset = CGPointMake(0, 0);
        [self setUpBtnSelect];
    }
}

- (void)selectDefaultBtn{
    if(_selectIndex != 1){
        _selectIndex = 1;
        self.defaultPage.numberOfPages = _defaultnum;
        [_defaultPage setCurrentPage:0];
        self.defaultView.contentOffset = CGPointMake(_emojinum*WIDE, 0);
        [self setUpBtnSelect];
    }
}

- (void)selectLxhBtn{
    if(_selectIndex != 2){
        _selectIndex = 2;
        self.defaultPage.numberOfPages = _lxhnum;
        [_defaultPage setCurrentPage:0];
        self.defaultView.contentOffset = CGPointMake((_emojinum+_defaultnum)*WIDE, 0);
        [self setUpBtnSelect];
    }
}

- (void)selectSendBtn{
    if ([self.delegate respondsToSelector:@selector(srExpressionSend)]) {
        [self.delegate srExpressionSend];
    }
}
//设置选中的按钮
- (void)setUpBtnSelect{
    switch (_selectIndex) {
        case 0:
            [_emojiBtn setBackgroundColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
            [_defaultBtn setBackgroundColor:[UIColor clearColor]];
            [_lxhBtn setBackgroundColor:[UIColor clearColor]];
            break;
        case 1:
            [_emojiBtn setBackgroundColor:[UIColor clearColor]];
            [_defaultBtn setBackgroundColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
            [_lxhBtn setBackgroundColor:[UIColor clearColor]];
            break;
        case 2:
            [_emojiBtn setBackgroundColor:[UIColor clearColor]];
            [_defaultBtn setBackgroundColor:[UIColor clearColor]];
            [_lxhBtn setBackgroundColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
            break;
        default:
            break;
    }
}

//选择表情(返回文字)
- (void)tapLxhView:(UIButton *)btn{
    NSInteger num = btn.tag / 10000;
    NSInteger numTag = btn.tag % 10000;
    
    switch (num) {
        case 1:
            [self.delegate srExpressionSelect:_emojiArry[numTag]];
            break;
        case 2:
            [self.delegate srExpressionSelect:_defaultArry[numTag][@"chs"]];
            break;
        case 3:
            [self.delegate srExpressionSelect:_lxhArry[numTag][@"chs"]];
            break;
        default:
            break;
    }
}

//删除表情
- (void)deleteLxh:(UIButton *)btn{
    [self.delegate srExpressionDelete];
}

- (UIScrollView *)defaultView{
    if(!_defaultView){
        float wid = 35;
        float jianju = (WIDE - 35 * 7) / 8;
        _defaultView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDE, wid*3+jianju*3+30)];
        _defaultView.delegate = self;
        _defaultView.pagingEnabled = YES;
        _defaultView.showsVerticalScrollIndicator = FALSE;
        _defaultView.showsHorizontalScrollIndicator = FALSE;
        [self addSubview:_defaultView];
    }
    return _defaultView;
}

- (UIPageControl *)defaultPage{
    if(!_defaultPage){
        float wid = 35;
        float jianju = (WIDE - 35 * 7) / 8;
        _defaultPage = [[UIPageControl alloc] initWithFrame:CGRectMake(0, wid*3+jianju*3+10, WIDE, 20)];
        _defaultPage.currentPageIndicatorTintColor = [UIColor orangeColor];
        _defaultPage.pageIndicatorTintColor = [UIColor lightGrayColor];
        [self addSubview:_defaultPage];
    }
    return _defaultPage;
}

@end
