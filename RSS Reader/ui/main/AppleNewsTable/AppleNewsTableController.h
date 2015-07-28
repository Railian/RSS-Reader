//
//  AppleNewsTableController.h
//  RSS Reader
//
//  Created by Evgeniy Raylyan on 7/17/15.
//  Copyright (c) 2015 Evgeniy Raylyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppleNewsTableController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
