//
//  ViewController.m
//  WXMainThreadLagAnalyzerDemo
//
//  Created by sulirong on 2017/12/4.
//  Copyright © 2017年 buptwsg. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell" forIndexPath: indexPath];
    cell.imageView.image = [UIImage imageNamed: @"default_videoFace"];
    cell.textLabel.text = [NSString stringWithFormat: @"这是第%d行", (int)indexPath.row];
    if (indexPath.row % 2 == 0) {
        NSData *testData = [NSData dataWithContentsOfURL: [NSURL URLWithString: @"https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=3038023804,3612858515&fm=173&s=E51A82754EE827261C323ECC0300C0AC&w=218&h=146&img.JPEG"]];
        testData = nil;
    }
    
    return cell;
}

@end
