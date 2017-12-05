//
//  WXLagAnalyzer.h
//  WXMainThreadLagAnalyzer
//
//  Created by sulirong on 2017/12/4.
//  Copyright © 2017年 buptwsg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXLagAnalyzerConfig : NSObject

/**
 卡顿的时长标准，单位是毫秒
 */
@property (nonatomic) NSUInteger lagCriteria;

/**
 卡顿的次数标准，也就是发生了多少次认为是发生了卡顿
 */
@property (nonatomic) NSUInteger lagTimes;

/**
 允许产生的崩溃日志的最大数量
 */
@property (nonatomic) NSUInteger maxNumberOfCrashReports;

/**
 产生崩溃日志时，是否检查调用栈一样的崩溃日志已经存在
 */
@property (nonatomic) BOOL checkDuplicate;

/**
 是否在发布构建中打开分析功能
 */
@property (nonatomic) BOOL enableInReleaseBuild;

@end

@interface WXLagAnalyzer : NSObject

+ (instancetype)sharedInstance;

+ (void)startWithConfig: (nullable WXLagAnalyzerConfig*)config;

- (void)saveCrashReport: (NSString*)report;

@end

NS_ASSUME_NONNULL_END
