//
//  AppDelegate.h
//  RTPg
//
//  Created by atts on 2019/4/2.
//  Copyright © 2019年 atts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

- (void)confuseTest;
    
@end

