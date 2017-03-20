//
//  ProductModel.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/13.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.aid forKey:@"aid"];
    [encoder encodeObject:self.batchno forKey:@"batchno"];
    [encoder encodeObject:self.disname forKey:@"disname"];
    [encoder encodeObject:self.docpath forKey:@"docpath"];
    [encoder encodeObject:self.pid forKey:@"pid"];
    [encoder encodeObject:self.pubtime forKey:@"pubtime"];
    [encoder encodeObject:self.ptitle forKey:@"ptitle"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.aid = [decoder decodeObjectForKey:@"aid"];
        self.batchno = [decoder decodeObjectForKey:@"batchno"];
        self.disname = [decoder decodeObjectForKey:@"disname"];
        self.docpath = [decoder decodeObjectForKey:@"docpath"];
        self.pid = [decoder decodeObjectForKey:@"pid"];
        self.ptitle = [decoder decodeObjectForKey:@"ptitle"];
        self.pubtime = [decoder decodeObjectForKey:@"pubtime"];
    }
    return self;
}

@end
