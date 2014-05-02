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

#define EASEOUT(A) 130 * sin(M_PI / 4  * ((A) / 130))

@interface LNavigationViewController ()
{
    BOOL menuOpened;
    NSArray *_views;
    UITapGestureRecognizer *_tapGestureRecognizer;
    UISwipeGestureRecognizer *_leftSwipeGestureRecognizer;
    UISwipeGestureRecognizer *_rightSwipeGestureRecognizer;
    CGFloat currentTranslation;
}

@property (strong, nonatomic) UINavigationBar * navigationBar;
@property (strong, nonatomic) UIButton * leftBarButton;
@property (strong, nonatomic) LLeftSideBarViewController * leftSideBarViewController;
@property (strong, nonatomic) UIViewController * mainViewController;
@property (strong, nonatomic) UIViewController * currentContentView;

@end

@implementation LNavigationViewController

const int ContentOffSet = 190;
const int ContentMinOffSet = 60;
const float MoveAnimationDuration = 0.5;

static LNavigationViewController * sharedViewController;

- (id)initWithArrayOfViewController:(NSArray *)viewControllers
{
    self = [super init];
    if (self) {
        _views = viewControllers;
        
        NSMutableArray * titleArray = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in viewControllers) {
            [titleArray addObject:[dict objectForKey:@"title"]];
        }
        menuOpened = NO;
        _leftSideBarViewController = [[LLeftSideBarViewController alloc] initWithTitlesArray:titleArray addDelegate:self];
        _navigationBar = [[UINavigationBar alloc] init];
        _currentContentView = [[UIViewController alloc] init];
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
   
    if (! _leftSideBarViewController) {
        _leftSideBarViewController = [[LLeftSideBarViewController alloc] init];
    }
    if (! _navigationBar) {
        _navigationBar = [[UINavigationBar alloc] init];
    }
    if (! _mainViewController) {
        _mainViewController = [[UIViewController alloc] init];
    }
    if (! _currentContentView) {
        _currentContentView = [[UIViewController alloc] init];
    }
    
    [self.view addSubview:_navigationBar];
    [self addChildViewController:_mainViewController];
    [self addChildViewController:_leftSideBarViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (sharedViewController) {
        sharedViewController = nil;
    }
    sharedViewController = self;
    CGRect bounds = self.view.bounds;

    [self refreshWithNewViewController:[[_views objectAtIndex:0] objectForKey:@"vc"]];
    [_currentContentView.view setFrame:CGRectMake(0, 61, bounds.size.width, bounds.size.height - 61)];
    menuOpened = NO;

    [_leftSideBarViewController.view setFrame:CGRectMake(0, 61, ContentOffSet, bounds.size.height)];
    [_navigationBar setFrame:CGRectMake(0, 0, bounds.size.width, 61)];
    [_navigationBar setBarTintColor:[UIColor colorWithRed:242.0f / 255.0f green:242.0f / 255.0f blue:240.0f / 255.0f alpha:1]];
    [_navigationBar setTranslucent:NO];

    _leftBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 15)];
    [self setLeftBarButtonWithColor:[UIColor colorWithRed:128.0f / 255.0f green:131.0f / 255.0f blue:129.0f / 255.0f alpha:1]];
    [_navigationBar setItems:[NSArray arrayWithObject:self.navigationItem]];
    _navigationBar.topItem.title = _views[0][@"title"];
}


- (void)addTapGestureToCurrentView
{
}

- (void)addSwipeGestureToCurrentView
{
    if (_leftSwipeGestureRecognizer) {
        [_currentContentView.view removeGestureRecognizer:_leftSwipeGestureRecognizer];
    }
    if (_rightSwipeGestureRecognizer) {
        [_rightSwipeGestureRecognizer.view removeGestureRecognizer:_rightSwipeGestureRecognizer];
    }
    _leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeInContentView:)];
    [_leftSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [_currentContentView.view addGestureRecognizer:_leftSwipeGestureRecognizer];
    _rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeInContentView:)];
    [_rightSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [_currentContentView.view addGestureRecognizer:_rightSwipeGestureRecognizer];
}

- (void)openLeftSideMenu
{
    menuOpened = YES;
    [self setLeftBarButtonWithColor:[UIColor colorWithRed:52.0f / 255.0f green:189.0f / 255.0f blue:237.0f / 255.0f alpha:1]];
    [self.view insertSubview:_leftSideBarViewController.view atIndex:0];
    [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:0.5];
    [self addTapGestureToCurrentView];
    [self.currentContentView.view setBackgroundColor:[UIColor colorWithRed:244.0f / 255.0f green:244.0f / 255.0f blue:242.0f / 255.0f alpha:1 ]];
}

- (void)closeLeftSideMenu
{
    menuOpened = NO;
    [self setLeftBarButtonWithColor:[UIColor colorWithRed:128.0f / 255.0f green:131.0f / 255.0f blue:129.0f / 255.0f alpha:1]];
    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:0.5];
    [_currentContentView.view removeGestureRecognizer:_tapGestureRecognizer];
    [_currentContentView.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLeftBarButtonWithColor:(UIColor *)textColor
{
    [_leftBarButton setAttributedTitle:[NSMutableAttributedString iconWithCode:@"" pointSize:20.0 color:textColor] forState:UIControlStateNormal];
    [_leftBarButton setContentEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    [_leftBarButton addTarget:self action:@selector(leftBarButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:_leftBarButton];
    self.navigationItem.leftBarButtonItem = barButton;
    
}

- (void)refreshWithNewViewController:(UIViewController *)viewController
{
    CGRect bounds = _currentContentView.view.frame;
    [_currentContentView.view removeFromSuperview];
    _currentContentView = viewController;
    _currentContentView.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    [_currentContentView.view setFrame:bounds];
    [_currentContentView.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_currentContentView.view];
    [self addSwipeGestureToCurrentView];
}


#pragma mark - left side bar view controller

- (void)didSelectedElementAtIndex:(NSInteger)index
{
//    [self closeLeftSideBarWithViewController:_views[index][@"vc"]];
    [self refreshWithNewViewController:_views[index][@"vc"]];
    self.navigationBar.topItem.title = _views[index][@"title"];
    [self closeLeftSideMenu];
}

#pragma mark - gesture delegate

- (void)leftBarButtonPressed
{
    if (menuOpened) {
        [self closeLeftSideMenu];
    } else {
        [self openLeftSideMenu];
    }
}

- (void)tapOnConetntView
{
    [self closeLeftSideMenu];
}

- (void)leftSwipeInContentView:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    [self closeLeftSideMenu];
}

- (void)rightSwipeInContentView:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    [self openLeftSideMenu];
}

#pragma animation

- (void)moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration
{
    void (^animations)(void) = ^{
		switch (direction) {
            case SideBarShowDirectionNone:
            {
                self.currentContentView.view.frame = CGRectMake(0, 61, self.view.frame.size.width, self.view.frame.size.height - 61);
            }
                break;
            case SideBarShowDirectionLeft:
            {
                
                self.currentContentView.view.frame = CGRectMake(ContentOffSet, 61, self.view.frame.size.width, self.view.frame.size.height - 61);
            }
                break;
            case SideBarShowDirectionRight:
            {
                self.currentContentView.view.frame = CGRectMake(-ContentOffSet, 61, self.view.frame.size.width, self.view.frame.size.height - 61);
            }
                break;
            default:
                break;
        }
	};
    void (^complete)(BOOL) = ^(BOOL finished) {
        if (direction == SideBarShowDirectionNone) {
            if (_tapGestureRecognizer) {
                [self.currentContentView.view removeGestureRecognizer:_tapGestureRecognizer];
                _tapGestureRecognizer = nil;
            }
            if (! menuOpened) {
                [_leftSideBarViewController.view removeFromSuperview];
            }
        } else {
            [self addTapGestureToCurrentView];
            menuOpened = YES;
        }
        currentTranslation = _currentContentView.view.frame.origin.x;
	};
    [UIView animateWithDuration:duration animations:animations completion:complete];
}

@end