//
//  WXLagAnalyzerConstants.m
//  WXMainThreadLagAnalyzer
//
//  Created by sulirong on 2017/12/5.
//  Copyright © 2017年 buptwsg. All rights reserved.
//

#import "WXLagAnalyzerConstants.h"

NSString * crashReportFolder() {
    NSString *libraryFolder = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    return [libraryFolder stringByAppendingPathComponent: @"CrashReports"];
}
