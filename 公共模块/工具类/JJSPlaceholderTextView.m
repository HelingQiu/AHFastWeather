//
//  JJSPlaceholderTextView.m
//  JJSMOA
//
//  Created by Rainer on 15/6/4.
//  Copyright (c) 2015年 JJSHome. All rights reserved.
//

#import "JJSPlaceholderTextView.h"

@interface JJSPlaceholderTextView ()

@property (nonatomic, readonly) NSString* realText;

- (void) beginEditing:(NSNotification*) notification;
- (void) endEditing:(NSNotification*) notification;

@end

@implementation JJSPlaceholderTextView
@synthesize realTextColor;
@synthesize placeholder;

#pragma mark -
#pragma mark Initialisation

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedEditing:) name:UITextViewTextDidChangeNotification object:self];
    self.realTextColor = [UIColor blackColor];
    
    //UITextView 中的 layoutManager(NSLayoutManager) 的是否非连续布局属性，默认是 YES，设置为 NO 后 UITextView 就不会再自己重置滑动
    self.layoutManager.allowsNonContiguousLayout = NO;
}

#pragma mark -
#pragma mark Setter/Getters

- (void) setPlaceholder:(NSString *)aPlaceholder {
    if ([self.realText isEqualToString:placeholder]) {
        self.text = aPlaceholder;
    }
    
    placeholder = nil;
    placeholder = aPlaceholder;
    
    [self endEditing:nil];
}

- (NSString *) text {
    NSString* text = [super text];
    if ([text isEqualToString:self.placeholder]) return @"";
    return text;
}

- (void) setText:(NSString *)text {
    if ([text isEqualToString:@""] || text == nil) {
        super.text = self.placeholder;
    }
    else {
        super.text = text;
    }
    
    if ([text isEqualToString:self.placeholder]) {
        if (self.placeholderColor) {
            self.textColor = self.placeholderColor;
        }else{
            self.textColor = [UIColor lightGrayColor];
        }
    }
    else {
        self.textColor = self.realTextColor;
    }
}

- (NSString *) realText {
    return [super text];
}

- (void) beginEditing:(NSNotification*) notification {
    if ([self.realText isEqualToString:self.placeholder]) {
        super.text = nil;
        self.textColor = self.realTextColor;
    }
}

- (void) endEditing:(NSNotification*) notification {
    if ([self.realText isEqualToString:@""] || self.realText == nil) {
        super.text = self.placeholder;
        if (self.placeholderColor) {
            self.textColor = self.placeholderColor;
        }else{
            self.textColor = [UIColor lightGrayColor];
        }
    }
}

- (void)changedEditing:(NSNotification*)notification
{
    if (self.limitCount != 0) {
        if (self.text.length > self.limitCount) {
            NSString *toBeString = self.text;
            NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
            if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
                UITextRange *selectedRange = [self markedTextRange];
                //获取高亮部分
                UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
                // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
                if (!position) {
                    if (toBeString.length > self.limitCount) {
                        self.text = [toBeString substringToIndex:self.limitCount];
                    }
                }
                // 有高亮选择的字符串，则暂不对文字进行统计和限制
                else{
                }
            }
            // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            else{
                if (toBeString.length > self.limitCount) {
                    self.text = [toBeString substringToIndex:self.limitCount];
                }
            }
        }
    }
}

- (void) setTextColor:(UIColor *)textColor {
    if ([self.realText isEqualToString:self.placeholder]) {
        if (self.placeholderColor) {
            if ([textColor isEqual:self.placeholderColor])
                [super setTextColor:textColor];
            else self.realTextColor = textColor;
        }else{
            if ([textColor isEqual:[UIColor lightGrayColor]])
                [super setTextColor:textColor];
            else self.realTextColor = textColor;
        }
    }
    else {
        self.realTextColor = textColor;
        [super setTextColor:textColor];
    }
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
