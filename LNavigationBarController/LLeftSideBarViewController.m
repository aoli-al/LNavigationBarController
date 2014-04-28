//
//  LLeftSideBarViewController.m
//  LNavigationBarController
//
//  Created by leo on 4/20/14.
//  Copyright (c) 2014 leo. All rights reserved.
//

#import "LLeftSideBarViewController.h"
#import "LLeftSideBarTableViewCell.h"

@interface LLeftSideBarViewController ()

@property (strong, nonatomic) LLeftSideBarTableViewCell * cell;

@end

@implementation LLeftSideBarViewController

- (id)initWithTitlesArray:(NSArray *)titles addDelegate:(id<LLeftSideBarDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _titles = titles;
        _currentPage = 0;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self.tableView setFrame: self.view.frame];
    self.tableView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[LLeftSideBarTableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)cellsForTableView:(UITableView *)tableView
{
    NSInteger sections = tableView.numberOfSections;
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    
    for (int section = 0; section < sections; section++) {
        NSInteger rows = [tableView numberOfRowsInSection:section];
        for (int row = 0; row < rows; row++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cells addObject:cell];
        }
    }
    
    return cells;
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
   
    LLeftSideBarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [self setCell:cell forRowAtIndextOfPath:indexPath];
    return cell;
}

- (void)setCell:(LLeftSideBarTableViewCell *)cell forRowAtIndextOfPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = [_titles objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.backgroundColor = [UIColor whiteColor];
    if (_currentPage == indexPath.row) {
        cell.setSelected = YES;
    } else {
        cell.setSelected = NO;
    }
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"yeah");
    static NSString *cellIndentifier = @"cell";
    LLeftSideBarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    cell.setSelected = NO;
    [cell setSelected:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(didSelectedElementAtIndex:)]) {
        [_delegate didSelectedElementAtIndex:indexPath.row];
    }
    static NSString *cellIndentifier = @"cell";
    LLeftSideBarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    [cell setSelected:YES animated:YES];
    
    NSIndexPath * currentIndexPath = [NSIndexPath indexPathForRow:_currentPage inSection:0];
    cell = (LLeftSideBarTableViewCell *)[self.tableView cellForRowAtIndexPath:currentIndexPath];
    cell.setSelected = NO;
    [cell setSelected:NO animated:NO];
    _currentPage = indexPath.row;
}

@end
