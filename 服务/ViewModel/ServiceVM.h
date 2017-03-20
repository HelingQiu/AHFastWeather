//
//  ServiceVM.h
//  AHFastWeather
//
//  Created by Rainer on 15/12/13.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceModel.h"
#import "ProductModel.h"

@interface ServiceVM : NSObject

- (void)getServiceProductListWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion;

- (void)getProductListWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion;

@end
