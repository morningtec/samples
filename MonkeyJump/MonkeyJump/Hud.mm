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

#import "Hud.h"
#import "Monkey.h"
#import "GMath.h"

@implementation Hud

-(id) init
{    
    self = [super initWithFile:@"jungle.pvr.ccz" capacity:20];
    
    if(self)
    {
        // create banana sprites for the energy hud
        for(int i=0; i<MAX_HEALTH_TOKENS; i++)
        {
            const float ypos = 290.0f;
            const float margin = 40.0f;
            const float spacing = 20.0f;
            
            healthTokens[i] = [CCSprite spriteWithSpriteFrameName:@"hud/banana.png"];
            healthTokens[i].position = ccp(margin+i*spacing, ypos);
            healthTokens[i].visible = NO;
            [self addChild:healthTokens[i]];            
        }        

        // cache sprite frames for the digits
        CCSpriteFrameCache *sfc = [CCSpriteFrameCache sharedSpriteFrameCache];
        for(int i=0; i<10; i++)
        {
            digitFrame[i] = [sfc spriteFrameByName:
                             [NSString stringWithFormat:@"numbers/%d.png", i]];
        }
        
        // init digit sprites
        for(int i=0; i<MAX_DIGITS; i++)
        {
            digits[i] = [CCSprite spriteWithSpriteFrame:digitFrame[0]];
            digits[i].position = ccp(345+i*25, 290);
            [self addChild:digits[i]];
        }
    }
    
    return self;
}

-(void) setHealth:(float) health
{
    // Change current health
    float healthChangeRate = 2.0f;
    
    // slowly adjust displayed health to monkey's real health
    if(currentHealth < health-0.01f)
    {
        // increase health - but limit to maximum
        currentHealth = MIN(currentHealth+healthChangeRate, health);
    }
    else if(currentHealth > health+0.01f)
    {
        // reduce health - but don't let it drop below 0
        currentHealth = MAX(currentHealth-healthChangeRate, 0.0f);
    }
    currentHealth = clamp(currentHealth, 0.0f, MONKEY_MAX_HEALTH);
    
    // Get number of bananas to display
    int numBananas = round(MAX_HEALTH_TOKENS * currentHealth / MONKEY_MAX_HEALTH);
    
    // Set visible health tokens
    int i=0;
    for(; i<numBananas; i++)
    {
        if(!healthTokens[i].visible)
        {
            healthTokens[i].visible = YES;
            healthTokens[i].scale = 0.6f;
            healthTokens[i].opacity = 0.0f;
            // fade in and scale
            [healthTokens[i] runAction:
             [CCSpawn actions:
              [CCFadeIn actionWithDuration:0.3f],
              [CCScaleTo actionWithDuration:0.3f scale:1.0f],
              nil]];
        }
    }
    
    // Set invisible health tokens
    for(; i<MAX_HEALTH_TOKENS; i++)
    {
        if(healthTokens[i].visible && (healthTokens[i].numberOfRunningActions == 0) )
        {
            // fade out, scale to 0, hide when done
            [healthTokens[i] runAction:
             [CCSequence actions:
              [CCSpawn actions:
               [CCFadeOut actionWithDuration:0.3f],
               [CCScaleTo actionWithDuration:0.3f scale:0.0f],
               nil],
              [CCHide action]
              , nil]
             ];
        }
    }
    
}

-(void) setScore:(float) score
{
    char strbuf[MAX_DIGITS+1];
    memset(strbuf, 0, MAX_DIGITS+1);
    
    snprintf(strbuf, MAX_DIGITS+1, "%*d", MAX_DIGITS, (int)roundf(score));
    int i=0;
    for(; i<MAX_DIGITS; i++)
    {
        if(strbuf[i] != ' ')
        {
            [digits[i] setDisplayFrame:digitFrame[strbuf[i]-'0']];
            [digits[i] setVisible:YES];
        }
        else
        {
            [digits[i] setVisible:NO];
        }
    }
}

@end
