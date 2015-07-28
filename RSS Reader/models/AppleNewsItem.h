//
//  AppleNewsItem.h
//
//
//  Created by Evgeniy Raylyan on 7/27/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WebContent;

@interface AppleNewsItem : NSManagedObject

#define APPLE_NEWS_ITEM_PN_TITLE        @"title"
#define APPLE_NEWS_ITEM_PN_SYNOPSIS     @"synopsis"
#define APPLE_NEWS_ITEM_PN_LINK         @"link"
#define APPLE_NEWS_ITEM_PN_PUB_DATE     @"pubDate"
#define APPLE_NEWS_ITEM_PN_WEB_CONTENT  @"webContent"

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *synopsis;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSDate *pubDate;
@property (nonatomic, retain) WebContent *webContent;

- (WebContent *)webContent;
- (void)setWebContent:(WebContent *)webContent;

@end



@interface AppleNewsItem (Create)

+ (AppleNewsItem *)appleNewsItemWithLink:(NSString *)link
                     inManagedObjectContext:(NSManagedObjectContext *)context;

@end



@interface AppleNewsItem (RSS)

+ (NSArray *)allAppleNewsItemsInManagedObjectContext:(NSManagedObjectContext *)context;

+ (BOOL)refreshAppleNewsItemsFromUrl:(NSString *)stringUrl
              inManagedObjectContext:(NSManagedObjectContext *)context;

@end



@interface AppleNewsItemParserDelegate : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSString *propertyName;
@property (strong, nonatomic) NSMutableDictionary *itemDictionary;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
