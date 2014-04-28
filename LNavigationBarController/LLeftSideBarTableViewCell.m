//
//  LLeftSideBarTableViewCell.m
//  LNavigationBarController
//
//  Created by leo on 4/26/14.
//  Copyright (c) 2014 leo. All rights reserved.
//

#import "LLeftSideBarTableViewCell.h"

@interface LLeftSideBarTableViewCell()

@property (strong, nonatomic) UIView * lineView;

@end

@implementation LLeftSideBarTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 50)];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.textLabel setFrame:CGRectMake(25, 0, 140, 50)];
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
    
    [_lineView setBackgroundColor:[UIColor colorWithRed:52.0f / 255.0f green:189.0f / 255.0f blue:237.0f / 255.0f alpha:1]];
    if (! _setSelected) {
        self.textLabel.textColor = [UIColor colorWithRed:127.0f / 255.0f green:130.0f / 255.0f blue:128.0f / 255.0f alpha:1];
        [_lineView removeFromSuperview];
    } else {
        self.textLabel.textColor = [UIColor colorWithRed:52.0f / 255.0f green:189.0f / 255.0f blue:237.0f / 255.0f alpha:1];
        [self addSubview:_lineView];
    }
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    _setSelected |= selected;
    if (! _setSelected) {
        self.textLabel.textColor = [UIColor colorWithRed:127.0f / 255.0f green:130.0f / 255.0f blue:128.0f / 255.0f alpha:1];
        [_lineView removeFromSuperview];
     } else {
        self.textLabel.textColor = [UIColor colorWithRed:52.0f / 255.0f green:189.0f / 255.0f blue:237.0f / 255.0f alpha:1];
        [self addSubview:_lineView];
     }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (! highlighted) {
        self.textLabel.textColor = [UIColor colorWithRed:127.0f / 255.0f green:130.0f / 255.0f blue:128.0f / 255.0f alpha:1];
        [_lineView removeFromSuperview];
     } else {
        self.textLabel.textColor = [UIColor colorWithRed:52.0f / 255.0f green:189.0f / 255.0f blue:237.0f / 255.0f alpha:1];
        [self addSubview:_lineView];
     }
}

@end
