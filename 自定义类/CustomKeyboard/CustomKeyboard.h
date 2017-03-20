//
//  CustomKeyboard.h
//  CustomKeyboard
//
//  Created by Kalyan Vishnubhatla on 10/9/12.
//
//

#import <UIKit/UIKit.h>

// Protocol for classes using this
@protocol CustomKeyboardDelegate
@optional
- (void)nextClicked:(NSUInteger)sender;
- (void)previousClicked:(NSUInteger)sender;
- (void)resignResponder:(NSUInteger)sender;
@end

@interface CustomKeyboard : NSObject

@property (nonatomic, strong) UIColor *navBarColor;
@property (nonatomic, strong) UIColor *fontColor;
@property (nonatomic, weak) id<CustomKeyboardDelegate> delegate;
@property (nonatomic) NSUInteger currentSelectedTextboxIndex;

- (UIToolbar *)getToolbarWithPrevNextDone:(BOOL)prevEnabled :(BOOL)nextEnabled;
- (UIToolbar *)getToolbarWithPrevNext:(BOOL)prevEnabled :(BOOL)nextEnabled;
- (UIToolbar *)getToolbarWithDone;

@end
