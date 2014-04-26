//
//  LNavigationgViewController.m
//  LNavigationBarController
//
//  Created by leo on 4/20/14.
//  Copyright (c) 2014 leo. All rights reserved.
//

#import "LNavigationViewController.h"
#import "NSMutableAttributedString+FontAwesomeIcon.h"
#import "BlueVC.h"
#import "RedVC.h"
//#import "LLeftSideBarViewController.h"

#define pi 3.1415926
#define EASEOUT(A) 130 * sin(pi / 4  * ((A) / 130))

@interface LNavigationViewController ()
{
    BOOL menuOpened;
    NSArray *_views;
    UITapGestureRecognizer *_tapGestureRecognizer;
    UIPanGestureRecognizer *_panGestureRecognizer;
    CGFloat currentTranslate;
}

@property (strong, nonatomic) UINavigationBar * navigationBar;
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
    
//    [_mainViewController.view addSubview:_navigationBar];
    [self.view addSubview:_navigationBar];
//    [self.view addSubview:_mainViewController.view];
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
    menuOpened = NO;
    [self addPanGestureToCurrentView];
    [self addTapGestureToCurrentView];

    [_leftSideBarViewController.view setFrame:CGRectMake(0, 61, ContentOffSet, bounds.size.height)];
    [_navigationBar setFrame:CGRectMake(0, 0, bounds.size.width, 61)];
    [_navigationBar setBarTintColor:[UIColor colorWithRed:242.0f / 255.0f green:242.0f / 255.0f blue:240.0f / 255.0f alpha:1]];
    [_navigationBar setTranslucent:NO];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 15)];
    [button setAttributedTitle:[NSMutableAttributedString iconWithCode:@"" pointSize:20.0 color:[UIColor colorWithRed:128.0f / 255.0f green:131.0f / 255.0f blue:129.0f / 255.0f alpha:1]] forState:UIControlStateNormal];
    [button setContentEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    [button addTarget:self action:@selector(leftBarButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    [_navigationBar setItems:[NSArray arrayWithObject:self.navigationItem]];
}

- (void)changeCurrentContentView:(UIViewController *)contentView
{
    [_currentContentView.view removeFromSuperview];
    _currentContentView = contentView;
    _currentContentView.view.autoresizesSubviews = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    
    [_currentContentView.view setFrame:CGRectMake(0, 62, self.view.bounds.size.width, self.view.bounds.size.height - 61)];
}

- (void)addTapGestureToCurrentView
{
    if (_tapGestureRecognizer) {
        [_currentContentView.view removeGestureRecognizer:_tapGestureRecognizer];
    }
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:_currentContentView action:NULL];
    [_currentContentView.view addGestureRecognizer:_tapGestureRecognizer];
}

- (void)addPanGestureToCurrentView
{
    if (_panGestureRecognizer) {
        [_currentContentView.view removeGestureRecognizer:_panGestureRecognizer];
    }
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
    [_currentContentView.view addGestureRecognizer:_panGestureRecognizer];
}

- (void)openLeftSideMenu
{
    [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:0.5];
    [self addTapGestureToCurrentView];
    menuOpened = YES;
}

- (void)closeLeftSideMenu
{
    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:0.5];
    [_currentContentView.view removeGestureRecognizer:_tapGestureRecognizer];
    menuOpened = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshWithNewViewController:(UIViewController *)viewController
{
    [_currentContentView.view removeFromSuperview];
    _currentContentView = viewController;
    NSLog(@"%@", _currentContentView);
    _currentContentView.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    [_currentContentView.view setFrame:CGRectMake(0, 61, self.view.frame.size.width, self.view.frame.size.height - 61)];
    [self.view addSubview:_currentContentView.view];
}

#pragma mark - left side bar view controller

- (void)didSelectedElementAtIndex:(NSInteger)index
{
    [self changeCurrentContentView:_views[index][@"vc"]];
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

- (void)panInContentView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    
    CGFloat translation;
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            translation = [panGestureRecognizer translationInView:_currentContentView.view].x;
            if (translation + currentTranslate >= 0) {
                [self.view insertSubview:_leftSideBarViewController.view atIndex:0];
            }
            break;
        case UIGestureRecognizerStateChanged:
            translation = [panGestureRecognizer translationInView:_currentContentView.view].x;
            if (translation < 0 && currentTranslate == 0) {
                _currentContentView.view.transform = CGAffineTransformMakeTranslation(- EASEOUT(fabs(translation)) + currentTranslate, 0);
            }
            else if (translation > 0 && currentTranslate > 0) {
                _currentContentView.view.transform = CGAffineTransformMakeTranslation(EASEOUT(translation) + currentTranslate, 0);
            } else {
                if (translation + currentTranslate > ContentOffSet) {
                    _currentContentView.view.transform = CGAffineTransformMakeTranslation(ContentOffSet + EASEOUT(translation - ContentOffSet), 0);
                }
                else if (translation + currentTranslate < 0) {
                    _currentContentView.view.transform = CGAffineTransformMakeTranslation(-EASEOUT(fabs(translation) - ContentOffSet), 0);
                } else {
                    _currentContentView.view.transform = CGAffineTransformMakeTranslation(translation + currentTranslate, 0);
                }
            }
            break;
        case UIGestureRecognizerStateCancelled:
            _currentContentView.view.transform = CGAffineTransformMakeTranslation(currentTranslate, 0);
            if (currentTranslate == 0) {
                [_leftSideBarViewController.view removeFromSuperview];
            }
            break;
        case UIGestureRecognizerStateEnded:
            currentTranslate = _currentContentView.view.transform.tx;
            if (! menuOpened) {
                if (currentTranslate < ContentMinOffSet) {
                    [self closeLeftSideMenu];
                } else {
                    [self openLeftSideMenu];
                }
            } else {
                if (currentTranslate < ContentOffSet - ContentMinOffSet) {
                    [self closeLeftSideMenu];
                } else {
                    [self openLeftSideMenu];
                }
            }
            break;
        default:
            break;
    }
}

#pragma animation

- (void)moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration
{
    void (^animations)(void) = ^{
		switch (direction) {
            case SideBarShowDirectionNone:
            {
                self.currentContentView.view.transform  = CGAffineTransformMakeTranslation(0, 0);
            }
                break;
            case SideBarShowDirectionLeft:
            {
                
                [self.view insertSubview:_leftSideBarViewController.view atIndex:0];
                self.currentContentView.view.transform  = CGAffineTransformMakeTranslation(ContentOffSet, 0);
            }
                break;
            case SideBarShowDirectionRight:
            {
                self.currentContentView.view.transform  = CGAffineTransformMakeTranslation(-ContentOffSet, 0);
            }
                break;
            default:
                break;
        }
	};
    void (^complete)(BOOL) = ^(BOOL finished) {
        self.currentContentView.view.userInteractionEnabled = YES;
        self.leftSideBarViewController.view.userInteractionEnabled = YES;
        
        if (direction == SideBarShowDirectionNone) {
            if (_tapGestureRecognizer) {
                [self.currentContentView.view removeGestureRecognizer:_tapGestureRecognizer];
                _tapGestureRecognizer = nil;
            }
            menuOpened = NO;
            [_leftSideBarViewController.view removeFromSuperview];
        } else {
            [self addTapGestureToCurrentView];
            menuOpened = YES;
        }
        currentTranslate = _currentContentView.view.transform.tx;
	};
    self.currentContentView.view.userInteractionEnabled = NO;
    self.currentContentView.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:duration animations:animations completion:complete];
}

@end
