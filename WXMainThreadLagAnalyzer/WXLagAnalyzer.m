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
#import "WXLagAnalyzerConstants.h"

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
        config.lagCriteria = 40;
        config.lagTimes = 2;
        config.maxNumberOfCrashReports = 5;
        config.checkDuplicate = NO;
        config.enableInReleaseBuild = NO;
    }
    analyzer.config = config;
    [analyzer start];
}

- (void)start {
    //create main run loop monitor
    self.mainLoopMonitor = [[WXMainRunLoopMonitor alloc] init];
    self.mainLoopMonitor.lagCriteria = self.config.lagCriteria;
    self.mainLoopMonitor.lagTimes = self.config.lagTimes;
    
    //create analyzer view, which contains FPS label
    NSBundle *bundle = [NSBundle bundleForClass: [self class]];
    self.analyzerView = [bundle loadNibNamed: @"WXLagAnalyzerView" owner: self options: nil][0];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect frame = self.analyzerView.frame;
    self.analyzerView.frame = CGRectMake(screenSize.width - frame.size.width - 4, 20, frame.size.width, frame.size.height);
    
    [[[UIApplication sharedApplication] keyWindow] addSubview: self.analyzerView];
    
    //create crash reports folder
    NSString *folder = crashReportFolder();
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: folder]) {
        [fileManager createDirectoryAtPath: folder withIntermediateDirectories: YES attributes: nil error: nil];
    }
    
    NSArray *files = [fileManager contentsOfDirectoryAtPath: folder error: nil];
    if (files.count > self.config.maxNumberOfCrashReports) {
        self.analyzerView.backgroundColor = [UIColor redColor];
    }
}

#pragma mark - Save Report
- (void)saveCrashReport:(NSString *)report {
    NSString *folder = crashReportFolder();
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *filesArray = [fileManager contentsOfDirectoryAtPath: folder error: nil];
    if (filesArray.count > self.config.maxNumberOfCrashReports) {
        return;
    }
    
    NSString *fileName = [NSString stringWithFormat: @"crash_%@", [NSDate date]];
    NSString *filePath = [folder stringByAppendingPathComponent: fileName];
    [report writeToFile: filePath atomically: YES encoding: NSUTF8StringEncoding error: nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       self.analyzerView.backgroundColor = [UIColor redColor];
    });
}

#pragma mark - Actions
- (IBAction)toggleFPS:(id)sender {
    if (self.analyzerView.fpsLabel.isRunning) {
        [self.analyzerView.fpsLabel stop];
        self.analyzerView.fpsLabel.fps = 0;
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
