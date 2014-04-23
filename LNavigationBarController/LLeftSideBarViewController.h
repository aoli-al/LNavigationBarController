//
//  LLeftSideBarViewController.h
//  LNavigationBarController
//
//  Created by leo on 4/20/14.
//  Copyright (c) 2014 leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLeftSideBarDelegate;

@interface LLeftSideBarViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    id <LLeftSideBarDelegate> _delegate;
    NSArray *_titles;
}

@property UITableView * tableView;

- (id)initWithTitlesArray:(NSArray *)titles addDelegate:(id<LLeftSideBarDelegate>) delegate;

@end

@protocol LLeftSideBarDelegate <NSObject>

@optional

- (void)didSelectedElementAtIndex:(NSInteger)index;

@end