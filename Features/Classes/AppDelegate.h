/*
 * Copyright (c) 2011 Yeecco Limited
 */

#import <UIKit/UIKit.h>

@interface AppDelegate : NSObject <UIApplicationDelegate>

@property(nonatomic, retain) IBOutlet UIWindow    * window;
@property(nonatomic, assign) IBOutlet UILabel     * messageLabel;
@property(nonatomic, assign) IBOutlet UILabel     * backKeyLabel;

- (void) applicationDidFinishLaunching: (UIApplication *) application;
- (void) applicationWillResignActive: (UIApplication *) application;
- (void) applicationDidBecomeActive: (UIApplication *) application;
- (void) applicationWillTerminate: (UIApplication *) application;

- (IBAction) sendMessageToJava;
- (IBAction) doBilling;
- (void) receivedMessageFromJava: (NSString *) message;

@end

