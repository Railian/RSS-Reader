//
//  AppleNewsItem.m
//
//
//  Created by Evgeniy Raylyan on 7/27/15.
//
//

#import "AppleNewsItem.h"
#import "DateUtils.h"

@interface AppleNewsItemParserDelegate : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) AppleNewsItemFetchCallback callback;

@property (strong, nonatomic) NSString *propertyName;
@property (strong, nonatomic) NSMutableDictionary *itemDictionary;
@property (strong, nonatomic) NSMutableArray *tempItems;

- (instancetype)initWithCallack:(AppleNewsItemFetchCallback)callback;

@end // AppleNewsItemParserDelegate

#pragma mark -

@implementation AppleNewsItem

+ (void)loadAppleNewsItemsFromUrl:(NSString *)stringUrl
                      withSuccess:(AppleNewsItemFetchCallback)callback
                          failure:(nullable void (^)(AFHTTPRequestOperation *__nonnull __strong, NSError *__nonnull __strong)) failure {
    NSURL *url = [[NSURL alloc] initWithString: stringUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSDictionary *responseDictionary) {
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        AppleNewsItemParserDelegate *delegate = [[AppleNewsItemParserDelegate alloc] initWithCallack:callback];
        xmlParser.delegate = delegate;
        [xmlParser parse];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure(operation, error);
    }];
    [operation start];
}

@end // AppleNewsItem

#pragma mark -

@implementation AppleNewsItemParserDelegate

- (instancetype)initWithCallack:(AppleNewsItemFetchCallback)callback {
    if (self = [super init])
        self.callback = callback;
    return self;
}

+ (void)appendString:(NSString *)string toDictionary:(NSMutableDictionary *)dictionary forKey:(id)key {
    if (dictionary[key]) dictionary[key] = [dictionary[key] stringByAppendingString:string];
    else dictionary[key] = string;
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
    else if ([self.propertyName isEqualToString:APPLE_NEWS_ITEM_XMLPN_DESCRIPTION]) {
        [AppleNewsItemParserDelegate appendString:string toDictionary:self.itemDictionary forKey:APPLE_NEWS_ITEM_PN_SYNOPSIS];
    } else if ([self.propertyName isEqualToString:APPLE_NEWS_ITEM_XMLPN_PUB_DATE])
        self.itemDictionary[APPLE_NEWS_ITEM_PN_PUB_DATE] = [DateUtils dateFromString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:APPLE_NEWS_ITEM_XMLPN_ITEM]) {
        AppleNewsItem *appleNewsItem = [[AppleNewsItem alloc] init];
        appleNewsItem.title = self.itemDictionary[APPLE_NEWS_ITEM_PN_TITLE];
        appleNewsItem.synopsis = self.itemDictionary[APPLE_NEWS_ITEM_PN_SYNOPSIS];
        appleNewsItem.link = self.itemDictionary[APPLE_NEWS_ITEM_PN_LINK];
        appleNewsItem.pubDate = self.itemDictionary[APPLE_NEWS_ITEM_PN_PUB_DATE];
        if (!self.tempItems) self.tempItems = [[NSMutableArray alloc] init];
        [self.tempItems addObject:appleNewsItem];
        self.itemDictionary = nil;
    } else self.propertyName = nil;
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    self.callback(self.tempItems);
    self.tempItems = nil;
}

@end // AppleNewsItemParserDelegate
