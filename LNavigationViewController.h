//
//  LNavigationgViewController.h
//  LNavigationBarController
//
//  Created by leo on 4/20/14.
//  Copyright (c) 2014 leo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLeftSideBarViewController.h"


@interface LNavigationViewController : UIViewController <LLeftSideBarDelegate>

@property (strong, nonatomic) UIViewController * menuViewController;

+ (id)sharedViewController;

@end
