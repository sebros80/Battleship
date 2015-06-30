//
// This Software (the "Software") is supplied to you by Openmind Networks
// Limited ("Openmind") your use, installation, modification or
// redistribution of this Software constitutes acceptance of this disclaimer.
// If you do not agree with the terms of this disclaimer, please do not use,
// install, modify or redistribute this Software.
//
// TO THE MAXIMUM EXTENT PERMITTED BY LAW, THE SOFTWARE IS PROVIDED ON AN
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER
// EXPRESS OR IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR
// CONDITIONS OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Each user of the Software is solely responsible for determining the
// appropriateness of using and distributing the Software and assumes all
// risks associated with use of the Software, including but not limited to
// the risks and costs of Software errors, compliance with applicable laws,
// damage to or loss of data, programs or equipment, and unavailability or
// interruption of operations.
//
// TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW OPENMIND SHALL NOT
// HAVE ANY LIABILITY FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, WITHOUT LIMITATION,
// LOST PROFITS, LOSS OF BUSINESS, LOSS OF USE, OR LOSS OF DATA), HOWSOEVER 
// CAUSED UNDER ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
// LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
// WAY OUT OF THE USE OR DISTRIBUTION OF THE SOFTWARE, EVEN IF ADVISED OF
// THE POSSIBILITY OF SUCH DAMAGES.
//
//
//  AppDelegate.m
//  Battleship
//
//  Created by Sebastian Rosner on 20/11/2014.
//  Copyright (c) 2014 Sebastian Rosner. All rights reserved.
//

#import "AppDelegate.h"
#import "BattleshipSvcGen.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    
#if DEBUG
    NSLog(@"Using setDevPushToken");
    [Golgi setDevPushToken:deviceToken];
#else
    NSLog(@"Using setProdPushToken");
    [Golgi setProdPushToken:deviceToken];
#endif
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo  fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if([Golgi isGolgiPushData:userInfo]){
        NSLog(@"Golgi Received notification(1): %@", userInfo);
        [Golgi pushReceived:userInfo withCompletionHandler:completionHandler];
    } else {
        //
        // Not a PUSH for Golgi, handle as normal in the application
        //
        NSLog(@"Application received a Remote Notification not for Golgi");
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if(launchOptions != nil) {
        // Launched from push notification
        NSDictionary *d = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        if(d != nil){
            //
            // Ok, launched into the background, setup Golgi
            //
            
            [Golgi enteringBackground];
            [Golgi useEphemeralConnection];
        }
    }
    
    //
    // Lifted from StackOverflow, how to register for push
    // in a backwards compatible way
    //
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //
    // GOLGI: Tell the framework that we are going into the background
    //
    NSLog(@"applicationDidEnterBackground()");
    [Golgi enteringBackground];
    [Golgi useEphemeralConnection];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //
    // GOLGI: Tell the framework that we are active again
    //
    
    NSLog(@"applicationDidBecomeActive()");
    [Golgi enteringForeground];
    [Golgi usePersistentConnection];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
