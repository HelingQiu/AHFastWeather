//
//  SettingModel.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/23.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "SettingModel.h"

@implementation SettingModel

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.account forKey:@"account"];
    [encoder encodeObject:[NSNumber numberWithBool:self.isVoice] forKey:@"isVoice"];
    [encoder encodeObject:[NSNumber numberWithBool:self.isVibration] forKey:@"isVibration"];
    [encoder encodeObject:self.visibility forKey:@"visibility"];
    [encoder encodeObject:self.temperture forKey:@"temperture"];
    [encoder encodeObject:self.rainfall forKey:@"rainfall"];
    [encoder encodeObject:self.windspeed forKey:@"windspeed"];
    [encoder encodeObject:self.onetime forKey:@"onetime"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.account = [decoder decodeObjectForKey:@"account"];
        self.isVoice = [[decoder decodeObjectForKey:@"isVoice"] boolValue];
        self.isVibration = [[decoder decodeObjectForKey:@"isVibration"] boolValue];
        self.visibility = [decoder decodeObjectForKey:@"visibility"];
        self.temperture = [decoder decodeObjectForKey:@"temperture"];
        self.rainfall = [decoder decodeObjectForKey:@"rainfall"];
        self.windspeed = [decoder decodeObjectForKey:@"windspeed"];
        self.onetime = [decoder decodeObjectForKey:@"onetime"];
    }
    return self;
}

@end
