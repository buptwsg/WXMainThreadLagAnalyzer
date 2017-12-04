//
//  WXLagAnalyzer.m
//  WXMainThreadLagAnalyzer
//
//  Created by sulirong on 2017/12/4.
//  Copyright © 2017年 buptwsg. All rights reserved.
//

#import "WXLagAnalyzer.h"
#import "WXFpsLabel.h"
#import "WXMainRunLoopMonitor.h"
#import "WXLagAnalyzerView.h"

@implementation WXLagAnalyzerConfig
@end

@interface WXLagAnalyzer ()

@property (strong, nonatomic) WXLagAnalyzerConfig *config;
@property (strong, nonatomic) WXMainRunLoopMonitor *mainLoopMonitor;
@property (strong, nonatomic) WXLagAnalyzerView *analyzerView;

@end

@implementation WXLagAnalyzer

+ (instancetype)sharedInstance {
    static WXLagAnalyzer *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[WXLagAnalyzer alloc] init];
        }
    });
    
    return instance;
}

+ (void)startWithConfig:(WXLagAnalyzerConfig *)config {
    if (nil == config || !config.enableInReleaseBuild) {
#ifndef DEBUG
        return;
#endif
    }
    
    WXLagAnalyzer *analyzer = [self sharedInstance];
    if (nil == config) {
        config = [[WXLagAnalyzerConfig alloc] init];
        config.lagCriteria = 50;
        config.lagTimes = 5;
        config.maxNumberOfCrashReports = 5;
        config.checkDuplicate = NO;
        config.enableInReleaseBuild = NO;
    }
    analyzer.config = config;
    [analyzer start];
}

- (void)start {
    self.mainLoopMonitor = [[WXMainRunLoopMonitor alloc] init];
    
    NSBundle *bundle = [NSBundle bundleForClass: [WXLagAnalyzerView class]];
    self.analyzerView = [bundle loadNibNamed: @"WXLagAnalyzerView" owner: self options: nil][0];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect frame = self.analyzerView.frame;
    self.analyzerView.frame = CGRectMake(screenSize.width - frame.size.width - 4, 20, frame.size.width, frame.size.height);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIApplication sharedApplication] keyWindow] addSubview: self.analyzerView];
    });
}

#pragma mark - Actions
- (IBAction)toggleFPS:(id)sender {
    if (self.analyzerView.fpsLabel.isRunning) {
        [self.analyzerView.fpsLabel stop];
    }
    else {
        [self.analyzerView.fpsLabel start];
    }
}

- (IBAction)toggleMainRunloop:(id)sender {
    if (self.mainLoopMonitor.isRunning) {
        [self.mainLoopMonitor stop];
    }
    else {
        [self.mainLoopMonitor start];
    }
}

@end
