//
//  NSMutableAttributedString+FontAwesomeIcon.h
//  QSCMobile
//
//  Created by Qusic on 8/20/13.
//  Copyright (c) 2013 Qusic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (FontAwesomeIcon)

@property(assign, nonatomic) CGFloat pointSize;
@property(strong, nonatomic) UIColor *color;

+ (instancetype)iconWithCode:(NSString *)code pointSize:(CGFloat)pointSize;
+ (instancetype)iconWithCode:(NSString *)code pointSize:(CGFloat)pointSize color:(UIColor *)color;

@end
