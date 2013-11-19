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

#import "Monkey.h"
#import "GB2Contact.h"
#import "GMath.h"
#import "Object.h"
#import "SimpleAudioEngine.h"
#import "GameLayer.h"

#define JUMP_IMPULSE 6.0f
#define WALK_FACTOR 3.0f
#define MAX_WALK_IMPULSE 0.2f
#define ANIM_SPEED 0.3f
#define MAX_VX 2.0f

@implementation Monkey

@synthesize health;
@synthesize score;

-(id) initWithGameLayer:(GameLayer*)gl
{    
    self = [super initWithDynamicBody:@"monkey"
                      spriteFrameName:@"monkey/idle/1.png"];
    
    if(self)
    {
        // do not let the monkey rotate
        [self setFixedRotation:true];
        
        // monkey uses continuous collision detection
        // to avoid sticking him into fast falling objects
        [self setBullet:YES];
        
        // store the game layer
        gameLayer = gl;
        
        // set health
        health = MONKEY_MAX_HEALTH;
    }
    
    return self;
}

-(void) walk:(float)newDirection
{
    direction = newDirection;
}

-(void) updateCCFromPhysics
{
    // call the selector of the super class
    // this updates monkey's sprite from the physics
    [super updateCCFromPhysics];
    
    // he's dead - so just let him be
    if([self isDead])
    {
        return;
    }
    
    // get the current velocity
    b2Vec2 velocity = [self linearVelocity];
    float vX = velocity.x;

    // clamp velocity
    const float maxVelocity = 5.0;
    float v = velocity.Length();
    if(v > maxVelocity)
    {
        [self setLinearVelocity:maxVelocity/v*velocity];
    }
    
    // determine direction of the monkey
    bool isLeft = (direction < 0);
    
    // determine if monkey is pushing an item
    bool isPushing =  (isLeft && (numPushLeftContacts > 0))
                   || (!isLeft && (numPushRightContacts > 0));
    
    if((isLeft && (vX > -MAX_VX)) || ((!isLeft && (vX < MAX_VX))))
    {
        // apply the directional impulse
        float impulse = clamp(-[self mass]*direction*WALK_FACTOR, 
                              -MAX_WALK_IMPULSE, 
                              MAX_WALK_IMPULSE);       
        if(isPushing)
        {
            impulse *= 2.5;
        }
        [self applyLinearImpulse:-b2Vec2(impulse,0) point:[self worldCenter]];        
    }

    // update animation phase
    animDelay -= 1.0f/60.0f;
    if(animDelay <= 0)
    {
        animDelay = ANIM_SPEED;
        animPhase++;
        if(animPhase > 2)
        {
            animPhase = 1;
        }
    }
    
    if((isLeft && (vX > -MAX_VX)) || ((!isLeft && (vX < MAX_VX))))
    {
        // apply the directional impulse
        float impulse = clamp(-[self mass]*direction*WALK_FACTOR, 
                              -MAX_WALK_IMPULSE, 
                              MAX_WALK_IMPULSE);            
        [self applyLinearImpulse:-b2Vec2(impulse,0) point:[self worldCenter]];        
    }

    // direction as string
    NSString *dir = isLeft ? @"left" : @"right";        

    // update animation phase
    const float standingLimit = 0.1;
    NSString *frameName = nil;
    if((vX > -standingLimit) && (vX < standingLimit))
    {
        if(numHeadContacts > 0)
        {
            // standing, object above head
            frameName = [NSString stringWithFormat:@"monkey/arms_up.png"];                        
        }
        else
        {
            // just standing
            frameName = [NSString stringWithFormat:@"monkey/idle/2.png"];            
        }
    }
    else
    {
        if(numFloorContacts == 0)
        {
            // jumping, in air
            frameName = [NSString stringWithFormat:@"monkey/jump/%@.png", dir];
        }
        else
        {            
            // on the floor
            NSString *action = isPushing ? @"push" : @"walk";
            
            frameName = [NSString stringWithFormat:@"monkey/%@/%@_%d.png", action, dir, animPhase];        
        }        
    }

    // set the display frame
    [self setDisplayFrameNamed:frameName];
    
    // check if monkey is stuck
    if(numHeadContacts > 0)
    {
        stuckWatchDogFrames--;
        if(stuckWatchDogFrames == 0)
        {
            // teleport the monkey above the highest object
            [self setPhysicsPosition:b2Vec2([self physicsPosition].x, 
                                            gameLayer.highestObjectY+2.0)];                
        }
    }
    else
    {
        // restart watchdog
        stuckWatchDogFrames = 120; // 2 seconds at 60fps
    }
    
    // update score
    if(numFloorContacts > 0)
    {
        float y = [self physicsPosition].y * 10;
        if(y > score)
        {
            score = y;
        }
    }
}

-(void) jump
{
    if((numFloorContacts > 0) && (![self isDead]))
    {
        float impulseFactor = 1.0;
        
        // if there is something above monkey's head make the push stronger
        if(numHeadContacts > 0)
        {
            impulseFactor = 4.5;
        }
        [self applyLinearImpulse:b2Vec2(0,[self mass]*JUMP_IMPULSE*impulseFactor) 
                           point:[self worldCenter]];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"jump.caf" 
                                               pitch:gFloatRand(0.8,1.2)
                                                 pan:(self.ccNode.position.x-240.0f) / 240.0f 
                                                gain:1.0 ];
    }
}

-(void) beginContactWithFloor:(GB2Contact*)contact
{
    numFloorContacts++;
}

-(void) endContactWithFloor:(GB2Contact*)contact
{
    numFloorContacts--;
}

-(void) beginContactWithGameObject:(GB2Contact*)contact
{
    NSString *fixtureId = (NSString *)contact.ownFixture->GetUserData();
    if([fixtureId isEqualToString:@"push_left"])
    {
        numPushLeftContacts++;
    }
    else if([fixtureId isEqualToString:@"push_right"])
    {
        numPushRightContacts++;
    }
    else if([fixtureId isEqualToString:@"head"])
    {
        numHeadContacts++;
        float vY = [contact.otherObject linearVelocity].y;
        
        if(vY < 0)
        {
            const float hurtFactor = 1.0;
            
            // reduce energy
            health += vY*[contact.otherObject mass] * hurtFactor;
            
            if([self isDead])
            {
                // set monkey to collide with floor only
                [self setCollisionMaskBits:0x0001];
                
                // release rotation lock
                [self setFixedRotation:NO];
                
                // change animation phase to dead
                [self setDisplayFrameNamed:@"monkey/dead.png"];
            }
        }        
    }
    else
    {
        // count others as floor contacts 
        numFloorContacts++;        
    }
}

-(void) endContactWithGameObject:(GB2Contact*)contact
{
    NSString *fixtureId = (NSString *)contact.ownFixture->GetUserData();
    if([fixtureId isEqualToString:@"push_left"])
    {
        numPushLeftContacts--;
    }
    else if([fixtureId isEqualToString:@"push_right"])
    {
        numPushRightContacts--;
    }
    else if([fixtureId isEqualToString:@"head"])
    {
        numHeadContacts--;
    }
    else
    {
        // count others as floor contacts 
        numFloorContacts--;        
    }
}

-(bool) isDead
{
    return health <= 0.0f;
}

-(void) restoreHealth:(float)amount
{
    health = MAX(health + amount, MONKEY_MAX_HEALTH);
}

@end


