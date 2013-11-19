//
//  GameLayer.h
//  MonkeyJump
//
//  Created by Andreas Löw on 10.11.11.
//  Copyright codeandweb.de 2011. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class GameObject;
@class Monkey;
@class Hud;

// GameLayer
@interface GameLayer : CCLayer
{
    CCSprite *background;                   //!< weak reference
    CCSprite *floorBackground;              //!< weak reference 
    CCSpriteBatchNode* objectLayer;         //!< weak reference
    
    CCSprite *leftFrame;                    //!< weak reference
    CCSprite *rightFrame;                   //!< weak reference
    
    ccTime nextDrop;                        //!< delay until next item drop
    ccTime dropDelay;                       //!< delay between drops

    GameObject *nextObject;                     //!< weak reference    
    
    Monkey *monkey;                         //!< weak reference

    float highestObjectY;                   //!< y position of the highest object
    
    ccTime gameOverTimer;                   //!< timer for restart of the level

    Hud *hud;                               //!< weak reference
    
    CCLayerColor *objectHint;               //!< weak reference
}

@property (nonatomic, readonly) float highestObjectY;

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;

@end
