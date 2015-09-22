//
//  ViewController.m
//  UnfoldTableViewCellDemo
//
//  Created by liuge on 9/22/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import "ViewController.h"
#import "UnfoldTableViewCell.h"

static NSString *cellID = @"cell";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - UITableViewDataSource


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"This is cell: %d", (int)indexPath.row];
    cell.detailTextLabel.text = @"details here";
    
    CGFloat r, g, b;
    
    // make it brighter
    do {
        r = arc4random_uniform(255) / 255.;
        g = arc4random_uniform(255) / 255.;
        b = arc4random_uniform(255) / 255.;
    } while (r < .3 || g < .3 || b < .3);
    
    cell.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    
    return cell;
}

@end
