//
//  WXCrashReportViewer.m
//  WXMainThreadLagAnalyzer
//
//  Created by sulirong on 2017/12/5.
//  Copyright © 2017年 buptwsg. All rights reserved.
//

#import "WXCrashReportViewer.h"

@interface WXCrashReportViewer ()

@property (weak, nonatomic) IBOutlet UIScrollView *srollView;
@property (strong, nonatomic) UILabel *label;

@end

@implementation WXCrashReportViewer

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label = [[UILabel alloc] init];
    self.label.font = [UIFont systemFontOfSize: 14];
    self.label.numberOfLines = 0;
    [self.srollView addSubview: self.label];
    
    if (self.filepath.length > 0) {
        NSString *report = [NSString stringWithContentsOfFile: self.filepath encoding: NSUTF8StringEncoding error: nil];
        if (report.length > 0) {
            self.label.text = report;
            CGSize size = [self.label sizeThatFits: CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX)];
            self.label.frame = CGRectMake(0, 0, size.width, size.height);
            self.srollView.contentSize = size;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
