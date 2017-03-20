//
//  AFChatVM.h
//  AHFastWeather
//
//  Created by Rainer on 16/8/5.
//  Copyright © 2016年 ahqxfw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFChatVM : NSObject

- (void)getChatDataWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion;

- (void)sendMessageWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion;

@end
