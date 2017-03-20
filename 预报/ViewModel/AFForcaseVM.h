//
//  AFForcaseVM.h
//  AHFastWeather
//
//  Created by Rainer on 16/8/5.
//  Copyright © 2016年 ahqxfw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFForcaseVM : NSObject

- (void)getForcaseDataWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion;

@end
