//
//  User.m
//  yunyi
//
//  Created by 梁庆杰 on 15/4/23.
//  Copyright (c) 2015年 梁庆杰. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        self.userid = [dictionary objectForKey:@"userid"];
        self.realname  = [dictionary objectForKey:@"realname"];
        self.nickname  = [dictionary objectForKey:@"nickname"];
       
    }
    return self;
}

@end
