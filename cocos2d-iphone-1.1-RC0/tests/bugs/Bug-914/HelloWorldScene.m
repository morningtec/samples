//
//  HelloWorldLayer.m
//  EAGLViewBug
//
//  Created by Wylan Werth on 7/5/10.
//  Copyright BanditBear Games 2010. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"

// HelloWorld implementation
@implementation HelloWorld

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];

	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];

	// add layer as a child to scene
	[scene addChild: layer];

	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"sceneStarted" object:nil];


		self.isTouchEnabled = YES;
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

		CCLayerColor *layer;

		for( int i=0;i < 5;i++) {
			layer = [CCLayerColor layerWithColor:ccc4(i*20, i*20, i*20,255)];
			[layer setContentSize:CGSizeMake(i*100, i*100)];
			[layer setPosition:ccp(size.width/2, size.height/2)];
			[layer setAnchorPoint:ccp(0.5f, 0.5f)];
			[layer setIsRelativeAnchorPoint:YES];
			[self addChild:layer z:-1-i];

		}

		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		CCMenuItem *item1 = [CCMenuItemFont itemFromString:@"restart" target:self selector:@selector(restart:)];

        CCMenuItem *item2 = [CCMenuItemFont itemFromString:@"re position" target:self selector:@selector(rePositionItems)];

		CCMenu *menu = [CCMenu menuWithItems:item1, item2,nil];
		[menu alignItemsVertically];
		[menu setPosition:ccp(size.width/2, 100)];

		[self addChild:menu z:2];

		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );

		// add the label as a child to this Layer
		[self addChild: label z:2];

	}
	return self;
}

- (void) rePositionItems
{
    CGSize newSize = [[CCDirector sharedDirector] winSize];
    CGSize oldSize;
    oldSize.height = newSize.width;
    oldSize.width = newSize.height;

    CCNode* child;
    CGPoint p;
    for(child in children_)
    {
        p = child.position;
        p.x = (child.position.x / oldSize.width) * newSize.width;
        p.y = (child.position.y / oldSize.height) * newSize.height;
        child.position = p;
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"Number of touches: %d", [touches count]);
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self ccTouchesMoved:touches withEvent:event];
}

-(void) restart:(id)sender
{
	[[CCDirector sharedDirector] replaceScene:[HelloWorld scene]];
}

-(void) winSize
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCLOG(@"width %f height %f",size.width,size.height);
    //to prevent release build error
    size = size;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)

	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
