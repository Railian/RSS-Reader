//
//  WebContent.m
//  
//
//  Created by Evgeniy Raylyan on 7/27/15.
//
//

#import "WebContent.h"
#import "AppleNewsItem.h"


@implementation WebContent

@dynamic html;
@dynamic appleNewsItem;

@end

@implementation WebContent (Create)

+ (WebContent *)webContentForAppleNewsItem:(AppleNewsItem *)appleNewsItem
                    inManagedObjectContext:(NSManagedObjectContext *)context {
    WebContent *webContent = nil;
    if (appleNewsItem) {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([AppleNewsItem class])];
        request.predicate = [NSPredicate predicateWithFormat:@"%@.%@ = '%@'", WEB_CONTENT_PN_APPLE_NEWS_ITEM, APPLE_NEWS_ITEM_PN_LINK, appleNewsItem.link];
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!error && [matches count] > 0)
            webContent = [matches firstObject];
        else {
            webContent = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([WebContent class])
                                                       inManagedObjectContext:context];
            webContent.appleNewsItem = appleNewsItem;
        }
    }
    return webContent;

}

@end