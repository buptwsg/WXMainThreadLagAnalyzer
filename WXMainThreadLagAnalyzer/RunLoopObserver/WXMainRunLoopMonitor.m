//
//  WXMainRunLoopMonitor.m
//  PerformanceTest
//
//  Created by Shuguang Wang on 2017/11/30.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import <CrashReporter/CrashReporter.h>
#import "WXMainRunLoopMonitor.h"

@interface WXMainRunLoopMonitor() {
    int timeoutCount;
    CFRunLoopObserverRef observer;
    PLCrashReporter *crashReporter;
    
@public
    dispatch_semaphore_t semaphore;
    CFRunLoopActivity activity;
}

@end

@implementation WXMainRunLoopMonitor

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    WXMainRunLoopMonitor *moniotr = (__bridge WXMainRunLoopMonitor*)info;
    moniotr->activity = activity;
    dispatch_semaphore_t semaphore = moniotr->semaphore;
    dispatch_semaphore_signal(semaphore);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _lagCriteria = 50;
        _lagTimes = 5;
        
        PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType: PLCrashReporterSignalHandlerTypeBSD
                                                                           symbolicationStrategy: PLCrashReporterSymbolicationStrategyAll];
        crashReporter = [[PLCrashReporter alloc] initWithConfiguration: config];
    }
    return self;
}

- (void)stop {
    if (!observer)
        return;
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
    observer = NULL;
    self.running = NO;
}

- (void)start {
    if (observer)
        return;
    
    self.running = YES;
    
    // 信号
    semaphore = dispatch_semaphore_create(0);
    
    // 注册RunLoop状态观察
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                       kCFRunLoopAllActivities,
                                       YES,
                                       0,
                                       &runLoopObserverCallBack,
                                       &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    
    // 在子线程监控时长
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        while (YES) {
            long st = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, self.lagCriteria * NSEC_PER_MSEC));
            if (st != 0) {
                if (!observer) {
                    timeoutCount = 0;
                    semaphore = nil;
                    activity = 0;
                    return;
                }
                
                if (activity == kCFRunLoopBeforeSources || activity == kCFRunLoopAfterWaiting) {
                    if (++timeoutCount < self.lagTimes)
                        continue;

                    NSData *data = [crashReporter generateLiveReport];
                    PLCrashReport *report = [[PLCrashReport alloc] initWithData: data error: nil];
                    NSString *reportText = [PLCrashReportTextFormatter stringValueForCrashReport: report withTextFormat: PLCrashReportTextFormatiOS];
                    NSLog(@"------------\n%@\n------------", reportText);
                }
            }
            else {
                //not timeout
            }
            timeoutCount = 0;
        }
    });
}
@end
