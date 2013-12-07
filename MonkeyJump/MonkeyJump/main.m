//
//  main.m
//  MonkeyJump
//
//  Created by Andreas Löw on 10.11.11.
//  Copyright codeandweb.de 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
#if defined (__STELLA_VERSION_MAX_ALLOWED)
    [UIScreen mainScreen].currentMode   = [UIScreen mainScreen].iPhone3GEmulationMode;
#endif
    int retVal = UIApplicationMain(argc, argv, nil, @"AppController");
    [pool release];
    return retVal;
}
