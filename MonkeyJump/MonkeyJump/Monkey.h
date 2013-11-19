/*
 MIT License
 
 Copyright (c) 2010 Andreas Loew / www.code-and-web.de
 
 For more information about htis module visit
 http://www.PhysicsEditor.de
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#pragma once

#import "cocos2d.h"
#import "GB2Sprite.h"

#define MONKEY_MAX_HEALTH 100.0f

@class GameLayer;

@interface Monkey : GB2Sprite
{
    float direction;      //!< keeps monkey's direction (from accelerometer)
    int animPhase;        //!< the current animation phase
    ccTime animDelay;     //!< delay until the next animation phase is stated
    GameLayer *gameLayer; //!< weak reference
    int numFloorContacts; //!< number of floor contacts
    int numPushLeftContacts;  //!< number of contacts with the right sensor
    int numPushRightContacts; //!< number of contacts with the left sensor
    int numHeadContacts;      //!< number of contacts with the head
    int stuckWatchDogFrames; //!< counter detect of moneky is stuck
    float health;            //!< monkey's energy
    float score;            //!< score
}

@property (readonly) float health;
@property (readonly) bool isDead;
@property (nonatomic, readonly) float score;

/**
 * Inits the monkey with the given game layer
 * @param gl game layer
 */
-(id) initWithGameLayer:(GameLayer*)gl;

/**
 * Will be called on accelerometer change
 * @direction the accelerometer value
 */
-(void) walk:(float)direction;

/**
 * Jump
 */
-(void) jump;

/**
 * Restore monkey's health
 * @param amount amount of health to restore
 */
-(void)restoreHealth:(float)amount;

@end
