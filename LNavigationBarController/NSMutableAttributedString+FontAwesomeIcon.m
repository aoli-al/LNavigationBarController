//
//  NSMutableAttributedString+FontAwesomeIcon.m
//  QSCMobile
//
//  Created by Qusic on 8/20/13.
//  Copyright (c) 2013 Qusic. All rights reserved.
//

#import "NSMutableAttributedString+FontAwesomeIcon.h"

@implementation NSMutableAttributedString (FontAwesomeIcon)

+ (instancetype)iconWithCode:(NSString *)code pointSize:(CGFloat)pointSize
{
    NSMutableParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *icon = [[NSMutableAttributedString alloc]initWithString:code attributes:@{NSFontAttributeName: [UIFont fontWithName:@"FontAwesome" size:pointSize], NSParagraphStyleAttributeName: paragraphStyle}];
    return icon;
}

+ (instancetype)iconWithCode:(NSString *)code pointSize:(CGFloat)pointSize color:(UIColor *)color
{
    NSMutableAttributedString *icon = [NSMutableAttributedString iconWithCode:code pointSize:pointSize];
    icon.color = color;
    return icon;
}

- (CGFloat)pointSize
{
    return ((UIFont *)[self attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL]).pointSize;
}

- (void)setPointSize:(CGFloat)pointSize
{
    [self addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"FontAwesome" size:pointSize] range:NSMakeRange(0, self.length)];
}

- (UIColor *)color
{
    return (UIColor *)[self attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:NULL];
}

- (void)setColor:(UIColor *)color
{
    [self addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.length)];
}

@end
