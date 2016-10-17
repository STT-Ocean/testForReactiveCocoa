//
//  AppDelegate.h
//  testForReactiveCocoa
//
//  Created by Ocean on 10/14/16.
//  Copyright © 2016 Ocean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

