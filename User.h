//
//  User.h
//  yunyi
//
//  Created by 梁庆杰 on 15/4/23.
//  Copyright (c) 2015年 梁庆杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic,strong) NSString *userid;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *realname;
- (id)initWithDictionary:(NSDictionary*)dictionary;

@end
