//
//  AFPhotoModel.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/22.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "AFPhotoModel.h"

@implementation AFPhotoModel

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.filename forKey:@"filename"];
    [encoder encodeObject:self.time forKey:@"time"];
    [encoder encodeObject:self.lng forKey:@"lng"];
    [encoder encodeObject:self.lat forKey:@"lat"];
    [encoder encodeObject:self.address forKey:@"address"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.filename = [decoder decodeObjectForKey:@"filename"];
        self.lat = [decoder decodeObjectForKey:@"lat"];
        self.lng = [decoder decodeObjectForKey:@"lng"];
        self.time = [decoder decodeObjectForKey:@"time"];
        self.address = [decoder decodeObjectForKey:@"address"];
    }
    return self;
}

@end
