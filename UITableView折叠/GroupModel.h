//
//  GroupModel.h
//  UITableView折叠
//
//  Created by xiaozai on 15/11/24.
//  Copyright (c) 2015年 xiaozai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupModel : NSObject
// 该属性用来记录是否是展开状态
@property(nonatomic,assign, getter=isSpreadOut)BOOL spreadOut;
@property(nonatomic,retain)NSMutableArray* contents; 
@end
