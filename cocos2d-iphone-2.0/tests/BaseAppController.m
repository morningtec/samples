/*
 * Copyright (c) 2013 MorningTec Limited
 */

#import "BaseAppController.h"

// CLASS IMPLEMENTATIONS
#ifdef __CC_PLATFORM_IOS

#import <UIKit/UIKit.h>

#import "cocos2d.h"
@implementation BaseAppController

@synthesize window=window_, navController=navController_, director=director_;

-(id) init
{
        if( (self=[super init]) ) {
                useRetinaDisplay_ = YES;
        }

        return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        // Main Window
        window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

        // Director
        director_ = (CCDirectorIOS*)[CCDirector sharedDirector];
        [director_ setDisplayStats:NO];
        [director_ setAnimationInterval:1.0/60];

        // GL View
        CCGLView *__glView = [CCGLView viewWithFrame:[window_ bounds]
        								 pixelFormat:kEAGLColorFormatRGB565
        								 depthFormat:0 /* GL_DEPTH_COMPONENT24_OES */
        						  preserveBackbuffer:NO
        								  sharegroup:nil
        							   multiSampling:NO
        							 numberOfSamples:0
        					  ];

        [director_ setView:__glView];
        [director_ setDelegate:self];
        director_.wantsFullScreenLayout = YES;

        // Retina Display ?
        [director_ enableRetinaDisplay:useRetinaDisplay_];

        // Navigation Controller
        navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
        navController_.navigationBarHidden = YES;

        // AddSubView doesn't work on iOS6
        [window_ addSubview:navController_.view];
        //	[window_ setRootViewController:navController_];

        [window_ makeKeyAndVisible];

        return YES;
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
    if( [navController_ visibleViewController] == director_ )
    	[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[director_ purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[director_ setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];

	[super dealloc];
}
@end
#endif


