//
//  LLeftSideBarViewController.m
//  LNavigationBarController
//
//  Created by leo on 4/20/14.
//  Copyright (c) 2014 leo. All rights reserved.
//

#import "LLeftSideBarViewController.h"

@interface LLeftSideBarViewController ()

@end

@implementation LLeftSideBarViewController

- (id)initWithTitlesArray:(NSArray *)titles addDelegate:(id<LLeftSideBarDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _titles = titles;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    CGRect bounds = self.view.frame;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 167, bounds.size.height) style:UITableViewStylePlain];
    _tableView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(didSelectedElementAtIndex:)]) {
        [_delegate didSelectedElementAtIndex:indexPath.row];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
