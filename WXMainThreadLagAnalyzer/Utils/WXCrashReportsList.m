//
//  WXCrashReportsList.m
//  WXMainThreadLagAnalyzer
//
//  Created by sulirong on 2017/12/5.
//  Copyright © 2017年 buptwsg. All rights reserved.
//

#import "WXCrashReportsList.h"
#import "WXCrashReportViewer.h"
#import "WXLagAnalyzerConstants.h"

@interface WXCrashReportsList () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray<NSString*> *crashReports;
@property (copy, nonatomic) NSString *reportsFolder;

@end

@implementation WXCrashReportsList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"卡顿日志";
    
    UIBarButtonItem *exit = [[UIBarButtonItem alloc] initWithTitle: @"退出" style: UIBarButtonItemStylePlain target: self action: @selector(exit)];
    self.navigationItem.leftBarButtonItem = exit;
    
    self.reportsFolder = crashReportFolder();
    [self loadCrashReports];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
- (void)loadCrashReports {
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: self.reportsFolder error: nil];
    self.crashReports = [files mutableCopy];
}

- (void)exit {
    [self dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.crashReports.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell" forIndexPath: indexPath];
    NSString *fileName = self.crashReports[indexPath.row];
    cell.textLabel.text = fileName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    UIStoryboard *sb = [UIStoryboard storyboardWithName: @"WXCrashReportViewer" bundle: [NSBundle bundleForClass: [self class]]];
    WXCrashReportViewer *viewer = [sb instantiateInitialViewController];
    viewer.filepath = [self.reportsFolder stringByAppendingPathComponent: self.crashReports[indexPath.row]];
    [self.navigationController pushViewController: viewer animated: YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}

- (NSArray<UITableViewRowAction*> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle: UITableViewRowActionStyleDestructive title: @"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [tableView endEditing: YES];
    }];
    return @[delete];
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"确认删除此条日志？";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        [tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
    }
}
@end
