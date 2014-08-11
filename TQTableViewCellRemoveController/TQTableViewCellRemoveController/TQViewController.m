//
//  TQViewController.m
//  TQTableViewCellRemoveController
//
//  Created by qfu on 8/11/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "TQViewController.h"
#import "TQCell.h"
#import "TQTableViewCellRemoveController.h"

@interface TQViewController ()<UITableViewDelegate,UITableViewDataSource,TQTableViewCellRemoveControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) TQTableViewCellRemoveController *cellRemoveController;

@end

@implementation TQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dataSource = [@[@"0.jpg",@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg"] mutableCopy];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.cellRemoveController = [[TQTableViewCellRemoveController alloc] initWithTableView:self.tableView];
    self.cellRemoveController.delegate = self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    TQCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TQCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.contentImageView.image = [UIImage imageNamed:self.dataSource[indexPath.row]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.alpha = 1;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    cell.alpha = 0;
    cell.transform = CGAffineTransformMakeTranslation(0, 0);
}

#pragma mark - TQTableViewCellRemoveControllerDelegate

- (void)didRemoveTableViewCellWithIndexPath:(NSIndexPath *)indexPath
{
    [self.dataSource removeObjectAtIndex:indexPath.row];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

@end
