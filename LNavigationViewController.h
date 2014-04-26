//
//  LNavigationgViewController.h
//  LNavigationBarController
//
//  Created by leo on 4/20/14.
//  Copyright (c) 2014 leo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLeftSideBarViewController.h"

typedef enum _SideBarShowDirection
{
    SideBarShowDirectionNone = 0,
    SideBarShowDirectionLeft = 1,
    SideBarShowDirectionRight = 2
}SideBarShowDirection;

@interface LNavigationViewController : UIViewController <LLeftSideBarDelegate>

@property (strong, nonatomic) UIViewController * menuViewController;

+ (id)sharedViewController;
- (id)initWithArrayOfViewController:(NSArray *)viewControllers;

@end
