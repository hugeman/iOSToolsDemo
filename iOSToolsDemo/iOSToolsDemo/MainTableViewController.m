//
//  MainTableViewController.m
//  iOSToolsDemo
//
//  Created by SmallJun on 2018/8/29.
//  Copyright © 2018年 SJ. All rights reserved.
//

#import "MainTableViewController.h"

@interface MainTableViewController ()

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Demo";
    
    self.dataSource = [NSMutableArray array];
    
    [self.dataSource addObject:@{
                                 @"title" : @"动效集",
                                 @"className" : @"AnimationsTableViewController",
                                 }];
    
    [self.dataSource addObject:@{
                                 @"title" : @"手势集",
                                 @"className" : @"GesturesTableViewController",
                                 }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.dataSource[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *className = self.dataSource[indexPath.row][@"className"];
    
    UIViewController *vc = (UIViewController *)[[NSClassFromString(className) alloc] init];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end

