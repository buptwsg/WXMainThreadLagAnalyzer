//
//  WXMainRunLoopMonitor.h
//  PerformanceTest
//
//  Created by Shuguang Wang on 2017/11/30.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXMainRunLoopMonitor : NSObject

@property (nonatomic) NSUInteger lagCriteria;
@property (nonatomic) NSUInteger lagTimes;
@property (nonatomic, getter=isRunning) BOOL running;

- (void)start;
- (void)stop;

@end
