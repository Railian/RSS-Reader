//
//  WebContent.h
//  
//
//  Created by Evgeniy Raylyan on 7/27/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AppleNewsItem;

@interface WebContent : NSManagedObject

#define WEB_CONTENT_PN_HTML             @"html"
#define WEB_CONTENT_PN_APPLE_NEWS_ITEM  @"appleNewsItem"

@property (nonatomic, retain) NSString * html;
@property (nonatomic, retain) AppleNewsItem *appleNewsItem;

@end

@interface WebContent (Create)

+ (WebContent *)webContentForAppleNewsItem:(AppleNewsItem *)appleNewsItem
                    inManagedObjectContext:(NSManagedObjectContext *)context;

@end
