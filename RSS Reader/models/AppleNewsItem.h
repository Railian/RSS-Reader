//
//  AppleNewsItem.h
//
//
//  Created by Evgeniy Raylyan on 7/27/15.
//
//

#import <Foundation/Foundation.h>

@interface AppleNewsItem : NSObject

#define APPLE_NEWS_ITEM_PN_TITLE        @"title"
#define APPLE_NEWS_ITEM_PN_SYNOPSIS     @"synopsis"
#define APPLE_NEWS_ITEM_PN_LINK         @"link"
#define APPLE_NEWS_ITEM_PN_PUB_DATE     @"pubDate"

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *synopsis;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSDate *pubDate;

+ (NSArray *)appleNewsItemsFromUrl:(NSString *)stringUrl;

@end // AppleNewsItem