//
//  RoadModel.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/28.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "RoadModel.h"

@implementation RoadModel

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    
    [encoder encodeObject:self.aid forKey:@"aid"];
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.depart forKey:@"depart"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.aid = [decoder decodeObjectForKey:@"aid"];
        self.city = [decoder decodeObjectForKey:@"city"];
        self.depart = [decoder decodeObjectForKey:@"depart"];
    }
    return self;
}

@end
