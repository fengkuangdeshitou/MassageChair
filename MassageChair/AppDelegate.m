//
//  AppDelegate.m
//  MassageChair
//
//  Created by 王帅 on 2021/3/22.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = UIColor.whiteColor;
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    UIApplication * app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(),^{
            if( bgTask !=UIBackgroundTaskInvalid){
                bgTask=UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        dispatch_async(dispatch_get_main_queue(),^{
            if(bgTask !=UIBackgroundTaskInvalid){
                bgTask=UIBackgroundTaskInvalid;
            }
        });
    });
}


@end
