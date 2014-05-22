//
//  TPObstacleLayer.m
//  Tappy Plane
//
//  Created by Michał Kozak on 20.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import "TPObstacleLayer.h"
#import "TPConstants.h"

@interface TPObstacleLayer()

@property (nonatomic) CGFloat marker;

@end

static const CGFloat kTPMarkerBuffer = 200.0;
static const CGFloat kTPVerticalGap = 90.0;
static const CGFloat kTPSpaceBetweenObstacleSets = 180;
static NSString *const kTPKeyMountainUp = @"MountainUp";
static NSString *const kTPKeyMountainDown = @"MountainDown";

@implementation TPObstacleLayer

-(id)init{
    self = [super init];
    if (self) {
        for (int i = 0; i < 5; i++) {
            [self createObjectForKey:kTPKeyMountainUp].position = CGPointMake(-1000, 0);
            [self createObjectForKey:kTPKeyMountainDown].position = CGPointMake(-1000, 0);
        }
    }
    return self;
}

-(void)reset
{
    //Loop through child nodes and reposition for reuse.
    for (SKNode *node in self.children) {
        node.position = CGPointMake(-1000, 0);
    }
    
    // Reposition marker.
    if(self.scene){
        self.marker = self.scene.size.width + kTPMarkerBuffer;
    }
}

-(void)updateWithTimeElapsed:(NSTimeInterval)timeElapsed
{
    [super updateWithTimeElapsed:timeElapsed];
    if(self.scrolling && self.scene){
        //Find the marker location in the scene coordinates.
        CGPoint markerLocationInScene = [self convertPoint:CGPointMake(self.marker, 0) toNode:self.scene];
        //When marker comes onto screen, add new obstacles.
        if(markerLocationInScene.x - (self.scene.size.width * self.scene.anchorPoint.x)
           < self.scene.size.width + kTPMarkerBuffer){
            [self addObstacleSet];
        }
        
    }
    
}

-(SKSpriteNode *)getUnusedObjectForKey:(NSString *)key
{
    
    if(self.scene){
        //Get left edge of screen in local coordinates
        CGFloat leftEdgeInLocalCoords = [self.scene convertPoint:CGPointMake(-self.scene.size.width * self.scene.anchorPoint.x, 0) toNode:self].x;
        
        //try find object for key to the left of the screen
        
        for (SKSpriteNode * node in self.children) {
            if(node.name == key && node.frame.origin.x + node.frame.size.width < leftEdgeInLocalCoords)
            {
                return node;
            }
        }
    }
    // couldn't find an unused node with key so create a new one
    return [self createObjectForKey:key];
    
}

-(void)addObstacleSet
{
    //Get mountine nodes.
    SKSpriteNode *mountineUp = [self getUnusedObjectForKey:kTPKeyMountainUp];
    SKSpriteNode *mountineDown = [self getUnusedObjectForKey:kTPKeyMountainDown];
    
    
    //Calculate maximum variation
    
    CGFloat maxVariation = (mountineUp.size.height + mountineDown.size.height + kTPVerticalGap) - (self.ceiling - self.floor);
    
    CGFloat yAdjustment = (CGFloat)arc4random_uniform(maxVariation);
    //position mountain nodes.
    
    mountineUp.position = CGPointMake(self.marker, self.floor+ (mountineDown.size.height*0.5) - yAdjustment);
    mountineDown.position = CGPointMake(self.marker, mountineUp.position.y + mountineDown.size.height + kTPVerticalGap);
  
    //Reposition marker.
    
    self.marker += kTPSpaceBetweenObstacleSets;
    
    
}

-(SKSpriteNode *)createObjectForKey:(NSString*)key
{
    SKSpriteNode *object = nil;
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    if(key == kTPKeyMountainUp)
    {
        object = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"MountainGrass"]];
        
        CGFloat offsetX = object.frame.size.width * object.anchorPoint.x;
        CGFloat offsetY = object.frame.size.height * object.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 55 - offsetX, 199 - offsetY);
        CGPathAddLineToPoint(path, NULL, 0 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 90 - offsetX, 0 - offsetY);
        CGPathCloseSubpath(path);
        
        object.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
        object.physicsBody.categoryBitMask = kTPCategoryGround;
        
        [self addChild:object];
    }
    else if (key == kTPKeyMountainDown)
    {
        object = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"MountainGrassDown"]];
        
        CGFloat offsetX = object.frame.size.width * object.anchorPoint.x;
        CGFloat offsetY = object.frame.size.height * object.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0 - offsetX, 199 - offsetY);
        CGPathAddLineToPoint(path, NULL, 55 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 90 - offsetX, 199 - offsetY);
        CGPathCloseSubpath(path);
        
        object.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
        object.physicsBody.categoryBitMask = kTPCategoryGround;
        
        [self addChild:object];
    }
    if(object){
        object.name = key;
    }
    
    return object;
    
}

@end
