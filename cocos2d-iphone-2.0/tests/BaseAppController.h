/*
 * Copyright (c) 2013 MorningTec Limited
 */

#import <Foundation/Foundation.h>

#import "cocos2d.h"

#ifdef __CC_PLATFORM_IOS


@class UIWindow, UINavigationController;

@interface BaseAppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
        UIWindow *window_;
        UINavigationController *navController_;

        BOOL			useRetinaDisplay_;
        CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end
#endif
