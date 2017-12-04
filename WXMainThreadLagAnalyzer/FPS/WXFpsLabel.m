//
//  WXFpsLabel.m
//  PerformanceTest
//
//  Created by Shuguang Wang on 2017/11/28.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "WXFpsLabel.h"

#define WXDefaultLabelSize CGSizeMake(55, 20)

@interface WXFpsLabel ()

@property (nonatomic, readwrite) NSUInteger fps;
@property (strong, nonatomic) NSArray *textArray;

@end

@implementation WXFpsLabel {
    CADisplayLink *_displayLink;
    CFTimeInterval _lastTime;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = WXDefaultLabelSize;
    }
    
    self = [super initWithFrame: frame];
    self.textAlignment = NSTextAlignmentLeft;
    self.backgroundColor = [UIColor clearColor];
    self.textColor = [UIColor whiteColor];
    self.font = [UIFont systemFontOfSize: 14];
    
    //预先创建好将要用到的字符串
    NSMutableArray *strArray = [NSMutableArray array];
    for (int i = 0; i <= 60; i++) {
        [strArray addObject: [NSString stringWithFormat: @"%d", i]];
    }
    self.textArray = [strArray copy];
    
    self.text = self.textArray[0];
    
    return self;
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
- (void)tick: (CADisplayLink*)link {
    if (0 == _lastTime) {
        _lastTime = link.timestamp;
    }
    
    CFTimeInterval elapsedTime = link.timestamp - _lastTime;
    _lastTime = link.timestamp;
    self.fps = 1 / elapsedTime;
    self.text = self.textArray[(int)MIN(self.fps, 60)];
}
@end
