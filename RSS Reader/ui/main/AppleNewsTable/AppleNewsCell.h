//
//  AppleNewsCell.h
//  RSS Reader
//
//  Created by Evgeniy Raylyan on 7/20/15.
//  Copyright (c) 2015 Evgeniy Raylyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppleNewsItem;

@interface AppleNewsCell : UITableViewCell

- (void)configureWithItem:(AppleNewsItem *)item;

- (CGFloat)calculateHeightWithTableWidth:(CGFloat)width;

@end