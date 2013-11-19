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

#define MAX_HEALTH_TOKENS 10
#define MAX_DIGITS 5

@interface Hud : CCSpriteBatchNode
{
    CCSprite *healthTokens[MAX_HEALTH_TOKENS]; // weak references
    float currentHealth;
    CCSprite *digits[MAX_DIGITS];  // weak references
    CCSpriteFrame *digitFrame[10]; // weak references
}

-(id) init;

/**
 * Set the energy (displayed as bananas)
 * @param health - monkey's health
 */
-(void) setHealth:(float) health;

/**
 * Set the score
 * @param score the score to display
 */
-(void) setScore:(float) score;

@end
