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
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [_titles objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.backgroundColor = [UIColor whiteColor];
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
