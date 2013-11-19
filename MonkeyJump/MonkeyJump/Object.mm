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
#import "Object.h"
#import "GB2Contact.h"
#import "SimpleAudioEngine.h"
#import "GMath.h"

@implementation GameObject

@synthesize objName;

-(id) initWithObject:(NSString*)theObjName
{    
    self = [super initWithDynamicBody:theObjName 
                      spriteFrameName:[NSString stringWithFormat:@"objects/%@.png", theObjName]];
    if(self)
    {
        self.objName = theObjName;
    }
    return self;
}

-(void) dealloc
{
    [objName release];
    [super dealloc];
}

+(GameObject*) randomObject
{
    NSString *objName;
    switch(rand() % 18)
    {
        case 0:
            // create own object for bananas - for separate collision detection
            return [[[Banana alloc] initWithObject:@"banana"] autorelease];
            
        case 1:
            // create own object for banana packs - for separate collision detection
            return [[[BananaBunch alloc] initWithObject:@"bananabunch"] autorelease];
            
        case 2: case 3: case 5:
            objName = @"backpack";
            break;
            
        case 6: case 7: case 8:
            objName = @"canteen";
            break;
            
        case 9: case 10: case 11:
            objName = @"hat";
            break;
            
        case 12: case 13: case 14:
            objName = @"statue";
            break;
            
        default:    
            objName = @"pineapple";
            break;            
    }
    return [[[self alloc] initWithObject:objName] autorelease];            
}

-(void) beginContactWithGameObject:(GB2Contact*)contact
{
    b2Vec2 velocity = [self linearVelocity];
    
    // play the sound only when the impact is high
    if(velocity.LengthSquared() > 3.0)
    {
        // play the item hit sound
        // pan it depending on the position of the collision
        // add some randomness to the pitch
        [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"%@.caf", objName]
                                               pitch:gFloatRand(0.8,1.2)
                                                 pan:(self.ccNode.position.x-240.0f) / 240.0f 
                                                gain:1.0 ];    
        
    }
}

-(void) beginContactWithFloor:(GB2Contact*)contact
{
    // just treat the contact with the floor 
    // in the same way as contact with another object
    [self beginContactWithGameObject:contact];
}

@end


@implementation ConsumableObject

-(void) presolveContactWithMonkey:(GB2Contact*)contact
{
    [contact setEnabled:NO];
}

-(void) consume
{
    if(!consumed)
    {
        // set consumed
        consumed = YES;
        
        // fade & shrink object
        // and delete after animation
        [self runAction:
         [CCSequence actions:
          [CCSpawn actions:
           [CCFadeOut actionWithDuration:0.1],
           [CCScaleTo actionWithDuration:0.2 scale:0.0],
           nil],
          [CCCallFunc actionWithTarget:self selector:@selector(deleteNow)],
          nil]
         ];
        
        // play the item consumed sound
        // pan it depending on the position of the monkey
        // add some randomness to the pitch
        [[SimpleAudioEngine sharedEngine] playEffect:@"gulp.caf"
                                               pitch:gFloatRand(0.8,1.2)
                                                 pan:(self.ccNode.position.x-240.0f) / 240.0f
                                                gain:1.0 ];
    }
}

@end

@implementation Banana
-(void) beginContactWithMonkey:(GB2Contact*)contact
{
    if(!consumed)
    {
        Monkey *monkey = (Monkey *)contact.otherObject;
        [monkey restoreHealth:20];
        [self consume];
    }
}
@end

@implementation BananaBunch
-(void) beginContactWithMonkey:(GB2Contact*)contact
{
    if(!consumed)
    {
        Monkey *monkey = (Monkey *)contact.otherObject;
        [monkey restoreHealth:60];
        [self consume];
    }
}
@end
