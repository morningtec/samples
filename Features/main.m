/*
 * Copyright (c) 2011 Yeecco Limited
 */

#import <UIKit/UIKit.h>

int main (int argc, char *argv[])
{
        NSAutoreleasePool     * pool    = [[NSAutoreleasePool alloc] init];
    #if defined (__STELLA_VERSION_MAX_ALLOWED)
        [UIScreen mainScreen].currentMode   = [UIScreen mainScreen].iPhone3GEmulationMode;
    #endif
        int     retval  = UIApplicationMain (argc, argv, nil, nil);

        [pool release];

        return retval;
}
