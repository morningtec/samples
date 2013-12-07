/*
 * Copyright (c) 2011 Yeecco Limited
 */

#import "AppDelegate.h"

#if defined (__STELLA_VERSION_MAX_ALLOWED) && defined (__ANDROID__)
#import <StellaKit/JNIHelper.h>

@interface JNIHelper (Hello)

- (void) sendMessageToJava;
- (void) callbackMessage: (NSString *) message;
- (void) doBilling;
- (void) backButtonPressed;

@end

@implementation JNIHelper (Test)

- (void) sendMessageToJava: (NSString *) message
{
        jstring         str_message                 =
        (*self.env)->NewStringUTF (self.env, [message cStringUsingEncoding: NSUTF8StringEncoding]);

        jclass          classID_MainHActivity       =
        [self classIDFromName: @"com/yourcompany/features/MainHActivity"];

        jmethodID       methodID_sendMessage        =
        (*self.env)->GetStaticMethodID (self.env, classID_MainHActivity, "sendMessage", "(Ljava/lang/String;)V");

        if (! methodID_sendMessage) {
                NSLog (@"failed to find jmethod: %s", "sendMessage");
        }

        (*self.env)->CallStaticObjectMethod (self.env, classID_MainHActivity, methodID_sendMessage, str_message);
        (*self.env)->DeleteLocalRef (self.env, str_message);
}

- (void) callbackMessage: (NSString *) message
{
        [[UIApplication sharedApplication].delegate receivedMessageFromJava: [[message copy] autorelease]];
}


- (void) doBilling
{
        jclass          classID_MainHActivity       =
        [self classIDFromName: @"com/yourcompany/features/MainHActivity"];

        jmethodID       methodID_doBilling          =
        (*self.env)->GetStaticMethodID (self.env, classID_MainHActivity, "doBilling", "()V");

        if (! methodID_doBilling) {
                NSLog (@"failed to find jmethod: %s", "doBilling");
        }

        (*self.env)->CallStaticObjectMethod (self.env, classID_MainHActivity, methodID_doBilling);
}

- (void) backPressed
{
        jclass          classID_MainHActivity       =
        [self classIDFromName: @"com/yourcompany/features/MainHActivity"];

        jmethodID       methodID                    =
        (*self.env)->GetStaticMethodID (self.env, classID_MainHActivity, "backPressed", "()V");

        if (! methodID) {
                NSLog (@"failed to find jmethod: %s", "backPressed");
        }

        (*self.env)->CallStaticObjectMethod (self.env, classID_MainHActivity, methodID);
}

@end

void Java_com_yourcompany_features_MainHActivity_nativeCallbackMessage (JNIEnv * env, jobject thiz, jstring str_message)
{
        jboolean        is_copy;
        const char    * utf_message     = (*env)->GetStringUTFChars (env, str_message, &is_copy);
        NSString      * message         = [NSString stringWithCString: utf_message encoding: NSUTF8StringEncoding];

        if (is_copy) {
                (*env)->ReleaseStringUTFChars (env, str_message, utf_message);
        }

        [ [JNIHelper sharedHelper] performSelectorOnMainThread: @selector(callbackMessage:)
                                                    withObject: message waitUntilDone: NO ];
}

#endif


@implementation AppDelegate

@synthesize window          = _window;
@synthesize messageLabel    = _messageLabel;
@synthesize backKeyLabel    = _backKeyLabel;

- (void) applicationDidFinishLaunching: (UIApplication *) application
{ ;
}

- (void) applicationWillResignActive: (UIApplication *) application
{ ;
}

- (void) applicationDidBecomeActive: (UIApplication *) application
{ ;
}

- (void) applicationWillTerminate: (UIApplication *) application
{ ;
}


- (IBAction) sendMessageToJava
{
    #if defined (__STELLA_VERSION_MAX_ALLOWED) && defined (__ANDROID__)
        [[JNIHelper sharedHelper] sendMessageToJava: @"sample message"];
    #endif
}

- (IBAction) doBilling
{
    #if defined (__STELLA_VERSION_MAX_ALLOWED) && defined (__ANDROID__)
        [[JNIHelper sharedHelper] doBilling];
    #endif
}

- (void) receivedMessageFromJava: (NSString *) message
{
        _messageLabel.text      = message;
}

@end


@interface UIApplication (StellaFeatures)
@end

@implementation UIApplication (StellaFeatures)
- (void) keyDown: (UIEvent *) event
{
        AppDelegate       * appDelegate     = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        appDelegate.backKeyLabel.text       = @"BackKey Down!!!";

        /* If You Want Handle The KeyDown Event in the Java, using JNI */
        [[JNIHelper sharedHelper] backPressed];
}
@end



