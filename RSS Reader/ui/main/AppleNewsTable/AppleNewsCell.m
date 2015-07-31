//
//  AppleNewsCell.m
//  RSS Reader
//
//  Created by Evgeniy Raylyan on 7/20/15.
//  Copyright (c) 2015 Evgeniy Raylyan. All rights reserved.
//

#import "AppleNewsCell.h"
#import "AppleNewsItem.h"
#import "DateUtils.h"
#import "Label.h"

@interface AppleNewsCell ()

@property (weak, nonatomic) IBOutlet Label *labelTitle;
@property (weak, nonatomic) IBOutlet Label *labelDescription;
@property (weak, nonatomic) IBOutlet Label *labelDate;

@end // AppleNewsCell

@implementation AppleNewsCell

- (void)configureWithItem:(AppleNewsItem *)item {
    self.labelTitle.text = item.title;
    self.labelDescription.text = item.synopsis;
    self.labelDate.text = [DateUtils stringFromDate:item.pubDate];
}

- (CGFloat)calculateHeightWithTableWidth:(CGFloat)width {
    self.bounds = CGRectMake(0.f, 0.f, width, CGRectGetHeight(self.bounds));
    [self setNeedsLayout];
    [self layoutIfNeeded];
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

@end // AppleNewsCell
