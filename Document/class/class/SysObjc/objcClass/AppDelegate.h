//
//  AppDelegate.h
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/2.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

