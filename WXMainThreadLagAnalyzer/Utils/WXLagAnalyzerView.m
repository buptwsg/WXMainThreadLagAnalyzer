//
//  WXLagAnalyzerView.m
//  WXMainThreadLagAnalyzer
//
//  Created by sulirong on 2017/12/4.
//  Copyright © 2017年 buptwsg. All rights reserved.
//

#import "WXLagAnalyzerView.h"

@interface WXLagAnalyzerView ()

@end

@implementation WXLagAnalyzerView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(handlePan:)];
    [self addGestureRecognizer: panGesture];
}

- (void)handlePan: (UIPanGestureRecognizer*)panGesture {
    CGPoint center = self.center;
    CGPoint translation = [panGesture translationInView: self];
    self.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [panGesture setTranslation: CGPointZero inView: self];
}

- (IBAction)clickAnalyzerView:(id)sender {
}
@end
