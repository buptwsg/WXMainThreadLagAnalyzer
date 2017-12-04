//
//  WXLagAnalyzerView.h
//  WXMainThreadLagAnalyzer
//
//  Created by sulirong on 2017/12/4.
//  Copyright © 2017年 buptwsg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WXFpsLabel;

@interface WXLagAnalyzerView : UIView

@property (weak, nonatomic) IBOutlet WXFpsLabel *fpsLabel;

@end
