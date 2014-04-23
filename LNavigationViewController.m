//
//  LNavigationgViewController.m
//  LNavigationBarController
//
//  Created by leo on 4/20/14.
//  Copyright (c) 2014 leo. All rights reserved.
//

#import "LNavigationViewController.h"
#import "NSMutableAttributedString+FontAwesomeIcon.h"
//#import "LLeftSideBarViewController.h"

@interface LNavigationViewController ()
{
    UIViewController *_currentContentViewController;
    UITapGestureRecognizer *_tapGestureRecognizer;
    UIPanGestureRecognizer *_panGestureRecognizer;
}

@property (strong, nonatomic) UINavigationBar * navigationBar;
@property (strong, nonatomic) LLeftSideBarViewController * leftSideBarViewController;

@end

@implementation LNavigationViewController

static LNavigationViewController * sharedViewController;

- (id)initWithArrayOfViewController:(NSArray *)viewControllers
{
    self = [super init];
    if (self) {
        NSMutableArray * titleArray = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in viewControllers) {
            [titleArray addObject:[dict objectForKey:@"title"]];
        }
        
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture)];

    _navigationBar = [[UINavigationBar alloc] init];
    }
    return self;
}

+ (id)sharedViewController;
{
    return sharedViewController;
}

- (void)loadView
{
    [super loadView];
   
    CGRect bounds = self.view.frame;
    
    if (! _navigationBar) {
        _navigationBar = [[UINavigationBar alloc] init];
    }
    
    [_navigationBar setFrame:CGRectMake(0, 0, bounds.size.width, 61)];
    [_navigationBar setTintColor:[UIColor colorWithRed:242.0f / 255.0f green:252.0f / 255.0f blue:244.0f / 255.0f alpha:1]];
    //[_navigationBar setBackgroundColor:[UIColor colorWithRed:242.0f / 255.0f green:252.0f / 255.0f blue:244.0f / 255.0f alpha:1]];
    [_navigationBar setBarTintColor:[UIColor colorWithRed:242.0f / 255.0f green:252.0f / 255.0f blue:244.0f / 255.0f alpha:1]];
    [_navigationBar setTranslucent:NO];
    
    self.navigationBar = _navigationBar;
    [self.view addSubview:_navigationBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (sharedViewController) {
        sharedViewController = nil;
    }
    sharedViewController = self;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 15)];
    [button setAttributedTitle:[NSMutableAttributedString iconWithCode:@"123" pointSize:10 color:[UIColor colorWithRed:124.0f / 255.0f green:127.0f / 255.0f blue:125.0f / 255.0f alpha:1]]
                      forState:UIControlStateNormal];
    [button setContentEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    
    [button addTarget:self action:@selector(leftSideBarPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)leftButtonPressed
{
    NSLog(@"被按啦！！");
}

- (void)panGesture
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshWithNewViewController:(UIViewController *)viewController
{
    [_currentContentViewController.view removeFromSuperview];
    
    _currentContentViewController = viewController;
    _currentContentViewController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    
    [_currentContentViewController.view setFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60)];
    [self.view addSubview:_currentContentViewController.view];
}

#pragma mark - side bar delegate

- (void)leftSideBarPressed
{
    NSLog(@"123");
}

@end
