//
//  AppleNewsItem.m
//  
//
//  Created by Evgeniy Raylyan on 7/27/15.
//
//

#import "AppleNewsItem.h"
#import "WebContent.h"
#import "DateUtils.h"

@implementation AppleNewsItem

@dynamic title;
@dynamic synopsis;
@dynamic link;
@dynamic pubDate;
@dynamic webContent;

@end



@implementation AppleNewsItem (Create)

+ (AppleNewsItem *)appleNewsItemWithLink:(NSString *)link
                     inManagedObjectContext:(NSManagedObjectContext *)context {
    AppleNewsItem *appleNewsItem = nil;
    if (link && [link length]) {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([AppleNewsItem class])];
        request.predicate = [NSPredicate predicateWithFormat:@"%@ = '%@'", APPLE_NEWS_ITEM_PN_LINK, link];
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!error && [matches count] > 0)
            appleNewsItem = [matches firstObject];
        else {
            appleNewsItem = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([AppleNewsItem class])
                                                          inManagedObjectContext:context];
            appleNewsItem.link = link;
        }
    }
    return appleNewsItem;
}

@end



@implementation AppleNewsItem (RSS)

+ (NSArray *)allAppleNewsItemsInManagedObjectContext:(NSManagedObjectContext *)context { // array of all apple news items
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!error && matches) return matches;
    else return nil;
}

+ (BOOL)refreshAppleNewsItemsFromUrl:(NSString *)stringUrl
           inManagedObjectContext:(NSManagedObjectContext *)context {
    NSURL *url = [[NSURL alloc] initWithString: stringUrl];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    AppleNewsItemParserDelegate *delegate = [[AppleNewsItemParserDelegate alloc] initWithManagedObjectContext:context];
    xmlParser.delegate = delegate;
    return [xmlParser parse];
}

@end



@implementation AppleNewsItemParserDelegate

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context {
     self.managedObjectContext = context;
    return self;
}

+ (void)appendString:(NSString *)string toDictionary:(NSMutableDictionary *)dictionary forKey:(id)key {
    NSString *oldValue = [dictionary objectForKey:key];
    if (oldValue) [dictionary setObject:[oldValue stringByAppendingString:string] forKey:key];
    else [dictionary setObject:string forKey:key];
}

#pragma mark - NSXMLParserDelegate

#define APPLE_NEWS_ITEM_XMLPN_ITEM          @"item"
#define APPLE_NEWS_ITEM_XMLPN_TITLE         @"title"
#define APPLE_NEWS_ITEM_XMLPN_LINK          @"link"
#define APPLE_NEWS_ITEM_XMLPN_DESCRIPTION   @"description"
#define APPLE_NEWS_ITEM_XMLPN_PUB_DATE      @"pubDate"

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([elementName isEqualToString:APPLE_NEWS_ITEM_XMLPN_ITEM])
        self.itemDictionary = [NSMutableDictionary dictionary];
    else if (self.itemDictionary)
        self.propertyName = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!self.propertyName) return;
    if ([self.propertyName isEqualToString:APPLE_NEWS_ITEM_XMLPN_TITLE])
        [AppleNewsItemParserDelegate appendString:string toDictionary:self.itemDictionary forKey:APPLE_NEWS_ITEM_PN_TITLE];
    else if ([self.propertyName isEqualToString:APPLE_NEWS_ITEM_XMLPN_LINK])
        [AppleNewsItemParserDelegate appendString:string toDictionary:self.itemDictionary forKey:APPLE_NEWS_ITEM_PN_LINK];
    else if ([_propertyName isEqualToString:APPLE_NEWS_ITEM_XMLPN_DESCRIPTION]) {
        [AppleNewsItemParserDelegate appendString:string toDictionary:self.itemDictionary forKey:APPLE_NEWS_ITEM_PN_SYNOPSIS];
    } else if ([_propertyName isEqualToString:APPLE_NEWS_ITEM_XMLPN_PUB_DATE])
        [_itemDictionary setObject:[DateUtils dateFromString:string] forKey:APPLE_NEWS_ITEM_PN_PUB_DATE];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:APPLE_NEWS_ITEM_XMLPN_ITEM]) {
        AppleNewsItem *appleNewsItem = [AppleNewsItem appleNewsItemWithLink:[self.itemDictionary objectForKey:APPLE_NEWS_ITEM_PN_LINK]
                                                        inManagedObjectContext:self.managedObjectContext];
        appleNewsItem.title = [self.itemDictionary objectForKey:APPLE_NEWS_ITEM_PN_TITLE];
        appleNewsItem.synopsis = [self.itemDictionary objectForKey:APPLE_NEWS_ITEM_PN_SYNOPSIS];
        appleNewsItem.pubDate = [self.itemDictionary objectForKey:APPLE_NEWS_ITEM_PN_PUB_DATE];
        self.itemDictionary = nil;
    } else self.propertyName = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    [self.managedObjectContext save:nil];
}

@end
