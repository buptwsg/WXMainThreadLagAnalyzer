//
//  WXLagAnalyzerView.m
//  WXMainThreadLagAnalyzer
//
//  Created by sulirong on 2017/12/4.
//  Copyright © 2017年 buptwsg. All rights reserved.
//

#import "WXLagAnalyzerView.h"
#import "WXLagAnalyzerConstants.h"

@interface WXLagAnalyzerView ()

@property (weak, nonatomic) IBOutlet UIButton *bgButton;

@end

@implementation WXLagAnalyzerView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(handlePan:)];
    [self addGestureRecognizer: panGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(crashReportsListDismissed:) name: WXLagAnalyzerListDismissed object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(crashReportsAllRemoved:) name: WXLagAnalyzerCrashAllRemoved object: nil];
}

- (void)handlePan: (UIPanGestureRecognizer*)panGesture {
    CGPoint center = self.center;
    CGPoint translation = [panGesture translationInView: self];
    self.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [panGesture setTranslation: CGPointZero inView: self];
}

- (IBAction)clickAnalyzerView:(id)sender {
    if (self.backgroundColor == [UIColor redColor]) {
        NSBundle *bundle = [NSBundle bundleForClass: [self class]];
        UIStoryboard *sb = [UIStoryboard storyboardWithName: @"WXCrashReportsList" bundle: bundle];
        UIViewController *vc = [sb instantiateInitialViewController];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController: vc animated: YES completion: nil];
        self.bgButton.enabled = NO;
    }
}

- (void)crashReportsListDismissed: (NSNotification*)notification {
    self.bgButton.enabled = YES;
}

- (void)crashReportsAllRemoved: (NSNotification*)notification {
    self.backgroundColor = [UIColor greenColor];
}

@end
