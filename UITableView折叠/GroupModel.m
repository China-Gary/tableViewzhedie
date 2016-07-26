//
//  GroupModel.m
//  UITableView折叠
//
//  Created by xiaozai on 15/11/24.
//  Copyright (c) 2015年 xiaozai. All rights reserved.
//

#import "GroupModel.h"

@implementation GroupModel

-(instancetype)init{
    self=[super init];
    if (self) {
        self.spreadOut=NO;
        self.contents=[NSMutableArray new];
    }
    return self;
}

@end
