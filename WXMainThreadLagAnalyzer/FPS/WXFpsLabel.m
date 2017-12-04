//
//  WXFpsLabel.m
//  PerformanceTest
//
//  Created by Shuguang Wang on 2017/11/28.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "WXFpsLabel.h"

@interface WXFpsLabel ()

@property (strong, nonatomic) NSArray *textArray;

@end

@implementation WXFpsLabel {
    CADisplayLink *_displayLink;
    CFTimeInterval _lastTime;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //预先创建好将要用到的字符串
    NSMutableArray *strArray = [NSMutableArray array];
    for (int i = 0; i <= 60; i++) {
        [strArray addObject: [NSString stringWithFormat: @"%d", i]];
    }
    self.textArray = [strArray copy];
    
    self.text = self.textArray[0];
}

#pragma mark - public methods
- (BOOL)isRunning {
    if (nil == _displayLink) {
        return NO;
    }
    return !_displayLink.paused;
}

- (void)start {
    if (nil == _displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget: self selector: @selector(tick:)];
        _displayLink.paused = NO;
        [_displayLink addToRunLoop: [NSRunLoop mainRunLoop] forMode: NSRunLoopCommonModes];
    }
    
    if (nil == self.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview: self];
    }
}

- (void)pause {
    _displayLink.paused = YES;
}

- (void)stop {
    _displayLink.paused = YES;
    [_displayLink invalidate];
    _displayLink = nil;
}

#pragma mark - private
- (void)setFps:(NSUInteger)fps {
    _fps = fps;
    self.text = self.textArray[MIN(self.fps, 60)];
}

- (void)tick: (CADisplayLink*)link {
    if (0 == _lastTime) {
        _lastTime = link.timestamp;
    }
    
    CFTimeInterval elapsedTime = link.timestamp - _lastTime;
    _lastTime = link.timestamp;
    self.fps = ceil(1 / elapsedTime);
}
@end
