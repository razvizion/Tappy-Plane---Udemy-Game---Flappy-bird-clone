//
//  TPGameScene.m
//  Tappy Plane
//
//  Created by Michał Kozak on 14.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import "TPGameScene.h"
#import "TPPlane.h"
#import "TPScrollingLayer.h"
#import "TPConstants.h"
#import "TPObstacleLayer.h"
#import "TPBitmapFontLabel.h"
#import "TPTilesetTextureProvider.h"

@interface TPGameScene ()
@property (nonatomic) TPPlane *player;
@property (nonatomic) SKNode *world;
@property (nonatomic) TPObstacleLayer *obstacles;
@property (nonatomic) TPScrollingLayer *background;
@property (nonatomic) TPScrollingLayer *foreground;
@property (nonatomic) TPBitmapFontLabel *scoreLabel;
@property (nonatomic) NSInteger score;


@end

static const CGFloat kMinFPS = 10.0 / 60.0;

@implementation TPGameScene

-(id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size]){
        
        //Set background coloe
        
        self.backgroundColor = [SKColor colorWithRed:0.835294118 green:0.929411765 blue:0.968627451 alpha:1.0];
        
        // Get atlas file.
        SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
        
        
        //Setup physics
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.5);
        self.physicsWorld.contactDelegate = self;
        
        
        //Setup world
        _world = [SKNode node];
        [self addChild:_world];
        
        //Setup background
        NSMutableArray *backgorundTiles = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < 3; i++) {
            [backgorundTiles addObject:[SKSpriteNode spriteNodeWithTexture:[graphics textureNamed: @"background"]]];
            
        }
        
        _background = [[TPScrollingLayer alloc]initWithTiles:backgorundTiles];

        _background.horizontalScrollSpeed = -60;
        _background.scrolling = YES;
        [_world addChild:_background];
        
        
        
        
        //Setup obstacle layer.
        _obstacles = [[TPObstacleLayer alloc]init];
        _obstacles.collectableDelegate = self;
        _obstacles.horizontalScrollSpeed = -80;
        _obstacles.scrolling = YES;
        _obstacles.floor = 0.0;
        _obstacles.ceiling = self.size.height;
        
        [_world addChild:_obstacles];
        
        //Setup foreground
        
        _foreground = [[TPScrollingLayer alloc]initWithTiles:@[[self generateGroundTile],
                                                               [self generateGroundTile],
                                                               [self generateGroundTile]]];
       
        _foreground.horizontalScrollSpeed = -80;
        _foreground.scrolling = YES;
        [_world addChild:_foreground];
        
        //Setup player
        _player = [[TPPlane alloc]init];
        _player.physicsBody.affectedByGravity = NO;
        [_world addChild:_player];
        
        // Setup score label.
        _scoreLabel = [[TPBitmapFontLabel alloc] initWithText:@"0" andFrontName:@"number"];
        _scoreLabel.position = CGPointMake(self.size.width * 0.5, self.size.height - 100);
        [self addChild:_scoreLabel];
        
        //Start a new game
        [self newGame];
        

    }
    return self;
}

-(SKSpriteNode *)generateGroundTile
{
    SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
    SKSpriteNode *sprite =  [SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"groundGrass"]];
    sprite.anchorPoint = CGPointZero;
    CGFloat offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
    CGFloat offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 403 - offsetX, 15 - offsetY);
    CGPathAddLineToPoint(path, NULL, 367 - offsetX, 35 - offsetY);
    CGPathAddLineToPoint(path, NULL, 329 - offsetX, 34 - offsetY);
    CGPathAddLineToPoint(path, NULL, 287 - offsetX, 7 - offsetY);
    CGPathAddLineToPoint(path, NULL, 235 - offsetX, 11 - offsetY);
    CGPathAddLineToPoint(path, NULL, 205 - offsetX, 28 - offsetY);
    CGPathAddLineToPoint(path, NULL, 168 - offsetX, 20 - offsetY);
    CGPathAddLineToPoint(path, NULL, 122 - offsetX, 33 - offsetY);
    CGPathAddLineToPoint(path, NULL, 76 - offsetX, 31 - offsetY);
    CGPathAddLineToPoint(path, NULL, 46 - offsetX, 11 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 16 - offsetY);
    sprite.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path];
    sprite.physicsBody.categoryBitMask = kTPCategoryGround;
    
    
   // SKShapeNode *bodyShape = [SKShapeNode node];
   // bodyShape.path = path;
   // bodyShape.strokeColor = [SKColor redColor];
   // bodyShape.lineWidth = 1.0;
   // [sprite addChild:bodyShape];
    return sprite;
}

-(void)newGame
{
    
    //Randomize tileser
    [[TPTilesetTextureProvider getProvider] ranodmizeTileset];
    
    //Reset layers
    self.foreground.position = CGPointZero;
    
    for (SKSpriteNode *node in self.foreground.children) {
        node.texture = [[TPTilesetTextureProvider getProvider] getTextureForKey:@"ground"];
    }
    
    
    [self.foreground layoutTiles];
    
    self.obstacles.position = CGPointZero;
    [self.obstacles reset];
    
    self.background.position = CGPointZero;
    [self.background layoutTiles];
    
    self.obstacles.scrolling = NO;
    
    //reset score
    self.score = 0;

    
    //reset plane
    self.player.position = CGPointMake(self.size.width * 0.3, self.size.height * 0.5);
    self.player.physicsBody.affectedByGravity = NO;
    
    [self.player reset];
}
-(void)wasCollected:(TPCollectable *)collectable
{
    self.score += collectable.pointValue;
}

-(void)setScore:(NSInteger)score
{
    _score=score;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)score];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   
        
        if(self.player.crashed){
            //Reset
            [self newGame];
        }else
        {
            _player.physicsBody.affectedByGravity = YES;
            self.player.accelerating = YES;
            self.obstacles.scrolling = YES;
        }
        
      
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
        self.player.accelerating = NO;
    
}
-(void)didBeginContact:(SKPhysicsContact *)contact
{
    if(contact.bodyA.categoryBitMask == kTPCategoryPlane){
        [self.player collide:contact.bodyB];
    }
    else if (contact.bodyB.categoryBitMask == kTPCategoryPlane){
        [self.player collide:contact.bodyA];
    }
}

-(void)update:(NSTimeInterval)currentTime{
    static NSTimeInterval lassCallTime;
    
    NSTimeInterval timeElapsed = currentTime - lassCallTime;
    if(timeElapsed > kMinFPS){
        timeElapsed = kMinFPS;
    }
    lassCallTime = currentTime;
        
    [self.player update];
    if (!self.player.crashed) {
        [self.background updateWithTimeElapsed:timeElapsed];
        [self.foreground updateWithTimeElapsed:timeElapsed];
        [self.obstacles updateWithTimeElapsed:timeElapsed];
    }

}

@end
