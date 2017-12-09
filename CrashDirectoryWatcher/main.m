//
//  main.m
//  CrashDirectoryWatcher
//
//  Created by sulirong on 2017/12/8.
//  Copyright © 2017年 buptwsg. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *toolRootPath() {
    return [NSHomeDirectory() stringByAppendingPathComponent: @"Downloads/symbolicatetool"];
}

NSString *watchedPath() {
    return [toolRootPath() stringByAppendingPathComponent: @"crashLog"];
}

void handleCrashFile(NSString *filepath) {
    //执行完脚本后，删除文件
    NSString *shellPath = @"./symbolicatecrashtool.sh";
    NSString *filename = [filepath lastPathComponent];
    NSString *symbolicatedCrashPath = [NSString stringWithFormat: @"./symbolicatecrashLog/%@", filename];
    NSString *openCmd = [NSString stringWithFormat: @"open -a TextEdit %@", symbolicatedCrashPath];
    NSLog(@"openCmd is %@", openCmd);
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/bash"];
    [task setCurrentDirectoryPath: toolRootPath()];
    [task setArguments:@[ @"-c", shellPath, openCmd]];
    [task launch];
    [task waitUntilExit];
    
    [[NSFileManager defaultManager] removeItemAtPath: filepath error: nil];
}

void queryCrashFiles(NSString *dir) {
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: dir error: nil];
    NSUInteger fileCount = files.count;
    
    if (fileCount > 0) {
        NSUInteger index = [files indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *file = (NSString*)obj;
            return [file hasSuffix: @".crash"];
        }];
        
        if (index != NSNotFound) {
            NSLog(@"发现一个日志文件 : %@", files[index]);
            handleCrashFile([dir stringByAppendingPathComponent: files[index]]);
        }
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *dir = watchedPath();
        if (![fileManager fileExistsAtPath: dir]) {
            NSLog(@"请将symbolicatetool解压在~/Downloads目录！\n");
            return 0;
        }
        
        while (YES) {
            queryCrashFiles(dir);
            sleep(2);
        }
    }
    return 0;
}
