//
//  ServiceModel.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/13.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "ServiceModel.h"

@implementation ServiceModel

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:[NSNumber numberWithInteger:self.isshow] forKey:@"isshow"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.showorder] forKey:@"showorder"];
    [encoder encodeObject:self.lstbatch forKey:@"lstbatch"];
    [encoder encodeObject:self.pid forKey:@"pid"];
    [encoder encodeObject:self.pname forKey:@"pname"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.isshow = [[decoder decodeObjectForKey:@"isshow"] integerValue];
        self.showorder = [[decoder decodeObjectForKey:@"showorder"] integerValue];
        self.lstbatch = [decoder decodeObjectForKey:@"lstbatch"];
        self.pid = [decoder decodeObjectForKey:@"pid"];
        self.pname = [decoder decodeObjectForKey:@"pname"];
    }
    return self;
}

@end
