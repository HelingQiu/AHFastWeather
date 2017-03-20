//
//  ActuallyVM.h
//  AHFastWeather
//
//  Created by Rainer on 15/12/15.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActuallyVM : NSObject

- (void)getStationWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion;

@end
