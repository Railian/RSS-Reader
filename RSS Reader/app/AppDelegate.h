//
//  AppDelegate.h
//  RSS Reader
//
//  Created by Evgeniy Raylyan on 7/16/15.
//  Copyright (c) 2015 Evgeniy Raylyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;

- (void)prepareNavigationControllerFrom:(UIViewController *)from to:(UIViewController *)to;

@end