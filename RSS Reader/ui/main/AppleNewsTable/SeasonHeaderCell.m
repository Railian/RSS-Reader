//
//  SeasonHeaderCellTableViewCell.m
//  RSS Reader
//
//  Created by Evgeniy Raylyan on 7/20/15.
//  Copyright (c) 2015 Evgeniy Raylyan. All rights reserved.
//

#import "SeasonHeaderCell.h"
#import "DateUtils.h"

@interface SeasonHeaderCell ()

typedef enum {
    SeasonWinter = 12,
    SeasonSpring = 3,
    SeasonSummer = 6,
    SeasonAutumn = 9
} Season;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewSeason;
@property (weak, nonatomic) IBOutlet UILabel *labelName;

@end

@implementation SeasonHeaderCell

#define SEASON_NAME_KEY @"SEASON_NAME"
#define IMAGE_NAME_KEY @"IMAGE_NAME"

- (void)configureWithDate:(NSDate *)date {
    static const NSDictionary *seasonsInfo = nil;
    if (!seasonsInfo) seasonsInfo = @{
                                      @(SeasonWinter): @{SEASON_NAME_KEY:@"Winter", IMAGE_NAME_KEY:@"season_winter"},
                                      @(SeasonSpring): @{SEASON_NAME_KEY:@"Spring", IMAGE_NAME_KEY:@"season_spring"},
                                      @(SeasonSummer): @{SEASON_NAME_KEY:@"Summer", IMAGE_NAME_KEY:@"season_summer"},
                                      @(SeasonAutumn): @{SEASON_NAME_KEY:@"Autumn", IMAGE_NAME_KEY:@"season_autumn"}
                                      };
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    calendar.timeZone = timeZone;
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    NSDictionary *seasonInfo = [seasonsInfo objectForKey:@(components.month)];
    self.labelName.text = [NSString stringWithFormat:@"%@, %lu", [seasonInfo valueForKey:SEASON_NAME_KEY], components.year];;
    self.imageViewSeason.image = [UIImage imageNamed:[seasonInfo valueForKey:IMAGE_NAME_KEY]];
}

@end
