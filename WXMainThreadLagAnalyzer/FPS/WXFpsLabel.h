//
//  WXFpsLabel.h
//  PerformanceTest
//
//  Created by Shuguang Wang on 2017/11/28.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXFpsLabel : UILabel

@property (nonatomic, readonly) NSUInteger fps;
@property (nonatomic, readonly) BOOL isRunning;

- (void)start;
- (void)pause;
- (void)stop;

@end
