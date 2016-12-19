//
//  AppDelegate.m
//  3DTouchDemo
//
//  Created by Json on 16/12/7.
//  Copyright © 2016年 Json. All rights reserved.
//

#import "AppDelegate.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "SearchViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // 这种是动态添加
    // 还有一种方法是静态添加,在info.plist中添加
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        [self add3DTouch];
    }
    
    // 解决3D Touch导致系统相册崩溃的问题
    [self preventImagePickerCrashOn3DTouch];
    
    UIApplicationShortcutItem *shortcutItem = launchOptions[UIApplicationLaunchOptionsShortcutItemKey];
    //如果是从快捷选项标签启动app,则根据不同标识执行不同操作,然后返回NO,防止调用-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
    if (shortcutItem) {
        [self application:application performActionForShortcutItem:shortcutItem completionHandler:^(BOOL succeeded) {
            //
        }];
        return NO;
    }
    return YES;
}

#pragma mark - 添加3D Touch
- (void)add3DTouch
{
    UIApplicationShortcutIcon *searchShortcutIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    UIApplicationShortcutItem *searchShortcutItem = [[UIApplicationShortcutItem alloc] initWithType:@"com.myzj.search" localizedTitle:@"搜索" localizedSubtitle:@"搜索副标题" icon:searchShortcutIcon userInfo:nil];
    [UIApplication sharedApplication].shortcutItems = @[searchShortcutItem];
}

#pragma mark - 3D Touch 跳转
//如果app在后台,通过快捷选项标签进入app,则调用该方法,如果app不在后台已杀死,则处理通过快捷选项标签进入app的逻辑在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions中
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    if ([shortcutItem.type isEqualToString:@"com.myzj.search"]) {
        // 搜索
        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
        UIViewController *firstVc = nav.viewControllers.firstObject;
        SearchViewController *searchVc = [[SearchViewController alloc] init];
        searchVc.message = @"搜索";
        [firstVc.navigationController pushViewController:searchVc animated:YES];
        if (completionHandler) {
            completionHandler(YES);
        }
    }
    if ([shortcutItem.type isEqualToString:@"com.myzj.edit"]) {
        // 编辑
        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
        UIViewController *firstVc = nav.viewControllers.firstObject;
        SearchViewController *searchVc = [[SearchViewController alloc] init];
        searchVc.message = @"编辑";
        [firstVc.navigationController pushViewController:searchVc animated:YES];
        if (completionHandler) {
            completionHandler(YES);
        }
    }
    if (completionHandler) {
        completionHandler(NO);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 解决3D Touch导致系统相册崩溃的问题
- (void)preventImagePickerCrashOn3DTouch
{
    // Load PhotosUI and bail if 3D Touch is unavailable.
    // (UIViewControllerPreviewing may be redundant,
    // as PUPhotosGridViewController only seems to exist on iOS 9,
    // but I'm being cautious.)
    NSString *photosUIPath = @"/System/Library/Frameworks/PhotosUI.framework";
    NSBundle *photosUI = [NSBundle bundleWithPath:photosUIPath];
    Class photosClass = [photosUI classNamed:@"PUPhotosGridViewController"];
    if (!(photosClass && objc_getProtocol("UIViewControllerPreviewing"))) {
        return;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    SEL selector = @selector(ab_previewingContext:viewControllerForLocation:);
    [self replaceSelectorForClass:photosClass
                 selectorOriginal:@selector(previewingContext:viewControllerForLocation:)
                  selectorReplace:selector
                        withBlock:^UIViewController *(id self, id previewingContext, CGPoint location) {
                            // Default implementation throws on iOS 9.0 and 9.1.
                            @try {
                                NSLog(@"Replace method at runtime to prevent UIImagePicker crash on 3D Touch.");
                                return ((UIViewController *(*)(id, SEL, id, CGPoint))objc_msgSend)(self, selector, previewingContext, location);
                            } @catch (NSException *e) {
                                return nil;
                            }
                        }];
    
#pragma clang diagnostic pop
}

- (void)replaceSelectorForClass:(Class)cls
               selectorOriginal:(SEL)original
                selectorReplace:(SEL)replacement
                      withBlock:(id)block
{
    IMP implementation = imp_implementationWithBlock(block);
    Method originalMethod = class_getInstanceMethod(cls, original);
    class_addMethod(cls, replacement, implementation, method_getTypeEncoding(originalMethod));
    Method replacementMethod = class_getInstanceMethod(cls, replacement);
    if (class_addMethod(cls, original, method_getImplementation(replacementMethod), method_getTypeEncoding(replacementMethod))) {
        class_replaceMethod(cls, replacement, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, replacementMethod);
    }
    
}

@end
