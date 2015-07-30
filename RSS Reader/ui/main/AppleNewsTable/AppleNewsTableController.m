//
//  AppleNewsTableController.m
//  RSS Reader
//
//  Created by Evgeniy Raylyan on 7/17/15.
//  Copyright (c) 2015 Evgeniy Raylyan. All rights reserved.
//

#import "AppleNewsTableController.h"
#import "AppleNewsItem.h"
#import "AppleNewsCell.h"
#import "SeasonHeaderCell.h"
#import "DateUtils.h"
#import "AppleNewsDetailedController.h"

@interface AppleNewsTableController ()

@property (strong, nonatomic) AppleNewsCell *sizingCell;
@property (strong, nonatomic) NSMutableDictionary *seasonsItems;
@property (strong, nonatomic) NSArray *sortedSeasons;

@end

@implementation AppleNewsTableController

static const CGFloat HEADER_HEIGHT = 85.f;
static const CGFloat FOOTER_HEIGHT = 20.f;

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView setScrollIndicatorInsets:UIEdgeInsetsMake(80, 0, 0, 0)];
    [self addItems:[AppleNewsItem appleNewsItemsFromUrl:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"]];
   }

-(void)addItems:(NSArray *)newItems {
    if (!self.seasonsItems) self.seasonsItems = [NSMutableDictionary dictionary];
    for(AppleNewsItem *item in newItems) {
        NSDate *season = [DateUtils seasonFromDate:item.pubDate];
        NSMutableArray *seasonItems = [self.seasonsItems objectForKey: season];
        if (!seasonItems) {
            seasonItems = [NSMutableArray array];
            [self.seasonsItems setObject:seasonItems forKey:season];
        }
        [seasonItems addObject:item];
    }
    
    NSSortDescriptor *seasonDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending: NO];
    self.sortedSeasons = [[self.seasonsItems allKeys] sortedArrayUsingDescriptors:@[seasonDescriptor]];
    NSSortDescriptor *itemDescriptor = [[NSSortDescriptor alloc] initWithKey:APPLE_NEWS_ITEM_PN_PUB_DATE ascending: NO];
    for(NSMutableArray *seasonItems in [_seasonsItems allValues])
        [seasonItems sortUsingDescriptors:@[itemDescriptor]];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - UITableViewDataSource

- (AppleNewsItem *)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [[_seasonsItems objectForKey:[_sortedSeasons objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sortedSeasons.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_seasonsItems objectForKey:[_sortedSeasons objectAtIndex:section]] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *HEADER_IDENTIFIER = @"HEADER";
    
    SeasonHeaderCell *header = [tableView dequeueReusableCellWithIdentifier: HEADER_IDENTIFIER];
    [header configureWithDate:[_sortedSeasons objectAtIndex:section]];
    return header;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return FOOTER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    static NSString *FOOTER_IDENTIFIER = @"FOOTER";
    UIView *footer = [tableView dequeueReusableCellWithIdentifier: FOOTER_IDENTIFIER];
    
    return footer;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CELL_IDENTIFIER = @"CELL";
    if(!_sizingCell) _sizingCell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    [_sizingCell configureWithItem:[self itemAtIndexPath:indexPath]];
    return [_sizingCell calculateHeightWithTableWidth: CGRectGetWidth(tableView.frame)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CELL_IDENTIFIER = @"CELL";
    AppleNewsCell *cell = [tableView dequeueReusableCellWithIdentifier: CELL_IDENTIFIER];
    [cell configureWithItem: [self itemAtIndexPath:indexPath]];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    static NSString *APPLE_NEWS_DETAILS_SEGUE = @"APPLE_NEWS_DETAILS_SEGUE";
    if([segue.identifier isEqualToString:APPLE_NEWS_DETAILS_SEGUE]){
        AppleNewsDetailedController *controller = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        AppleNewsItem *item = [self itemAtIndexPath:indexPath];
        controller.link = item.link;
    }
}

@end
