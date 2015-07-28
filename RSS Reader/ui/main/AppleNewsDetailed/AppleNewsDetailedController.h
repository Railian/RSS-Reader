//
//  AppleNewsDetailedController.h
//  RSS Reader
//
//  Created by Evgeniy Raylyan on 7/21/15.
//  Copyright (c) 2015 Evgeniy Raylyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppleNewsItem;

@interface AppleNewsDetailedController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) AppleNewsItem *item;

@end
