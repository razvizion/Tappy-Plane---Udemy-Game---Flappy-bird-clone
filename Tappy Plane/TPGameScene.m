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
#import "TPGetReadyMenu.h"
#import "TPWeatherLayer.h"
#import "SoundManager.h"

typedef enum : NSUInteger {
    GameReady,
    GameRunning,
    GameOver,
} GameState;

@interface TPGameScene ()
@property (nonatomic) TPPlane *player;
@property (nonatomic) SKNode *world;
@property (nonatomic) TPObstacleLayer *obstacles;
@property (nonatomic) TPScrollingLayer *background;
@property (nonatomic) TPScrollingLayer *foreground;
@property (nonatomic) TPBitmapFontLabel *scoreLabel;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger bestScore;
@property (nonatomic) TPGameOverMenu *gameOverMenu;
@property (nonatomic) TPGetReadyMenu *getReadyMenu;
@property (nonatomic) GameState gameState;
@property (nonatomic) TPWeatherLayer *weather;


@end

static const CGFloat kMinFPS = 10.0 / 60.0;
static NSString *const kTPKeyBestScore = @"BestScore";

@implementation TPGameScene

-(id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size]){
        
        //Init audio
        
        [[SoundManager sharedManager] prepareToPlayWithSound:@"Crunch.caf"];
        
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
        
        // Setup weather.
        _weather = [[TPWeatherLayer alloc]initWithSize:self.size];
        
        [_world addChild:_weather];
        
        
        
        // Setup score label.
        _scoreLabel = [[TPBitmapFontLabel alloc] initWithText:@"0" andFrontName:@"number"];
        _scoreLabel.position = CGPointMake(self.size.width * 0.5, self.size.height - 100);
        [self addChild:_scoreLabel];
        
        // Load best score.
        self.bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:kTPKeyBestScore];
        
        // setup game over menu
        
        _gameOverMenu = [[TPGameOverMenu alloc]initWithSize:size];
        
        _gameOverMenu.delegate=self;
        
        
        //Setup get ready menu
        
        _getReadyMenu = [[TPGetReadyMenu alloc]initWithSize:size andPlanePosition:CGPointMake(self.size.width * 0.3, self.size.height * 0.5)];
        [self addChild:_getReadyMenu];
        
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

-(void)pressedStartNewGameButton
{
    SKSpriteNode *blackRectangle = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:self.size];
    blackRectangle.anchorPoint = CGPointZero;
    blackRectangle.alpha = 0;
    [self addChild:blackRectangle];
    
    SKAction *startNewGame = [SKAction runBlock:^{
        [self newGame];
        [self.gameOverMenu removeFromParent];
        [self.getReadyMenu show];
    }];
    
    SKAction *fadeTransition = [SKAction sequence:@[[SKAction fadeInWithDuration:0.4],startNewGame,[SKAction fadeOutWithDuration:0.4]]];
    [blackRectangle runAction:fadeTransition];
    
    
    
}

-(void)newGame
{
    
    //Randomize tileser
    [[TPTilesetTextureProvider getProvider] ranodmizeTileset];
    
    // Set weather condditions
    
    NSString *tilesetName = [TPTilesetTextureProvider getProvider].currentTilesetName;
    self.weather.conditions = WeatherClear;
    
    if([tilesetName isEqualToString:kTPTilesetIce] || [tilesetName isEqualToString:kTPTilesetSnow])
    {
        if(arc4random_uniform(2)==0){
            self.weather.conditions = WeatherSnowing;
        }
    }
    
    if([tilesetName isEqualToString:kTPTilesetGrass] || [tilesetName isEqualToString:kTPTilesetDirt])
    {
        if(arc4random_uniform(3)==0){
            self.weather.conditions = WeatherRaining;
        }
    }
    
    
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
    self.scoreLabel.alpha = 1.0;
    
    //reset plane
    self.player.position = CGPointMake(self.size.width * 0.3, self.size.height * 0.5);
    self.player.physicsBody.affectedByGravity = NO;
    
    [self.player reset];
    
    
    // Set Game ready state
    self.gameState = GameReady;
}
-(void)gameOver
{
    // Update game state
    self.gameState = GameOver;
    //Fade out score displau
    [self.scoreLabel runAction:[SKAction fadeOutWithDuration:0.4]];
    // Show game over menu. Set properties
    self.gameOverMenu.score = self.score;
    
    self.gameOverMenu.medal = [self getMedalForCurrentScore];
    //Update best score
    if(self.score > self.bestScore){
        self.bestScore = self.score;
        [[NSUserDefaults standardUserDefaults] setInteger:self.bestScore forKey:kTPKeyBestScore];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.gameOverMenu.bestScore = self.bestScore;
    [self addChild:self.gameOverMenu];
    [self.gameOverMenu show];
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
   
  
    if (self.gameState == GameReady) {
        [self.getReadyMenu hide];
        self.player.physicsBody.affectedByGravity = YES;
        self.obstacles.scrolling = YES;
        self.gameState = GameRunning;
    }
    if(self.gameState == GameRunning)
    {
        self.player.accelerating = YES;
    }
        
      
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.gameState == GameRunning){
        self.player.accelerating = NO;
    }
    
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

-(void)bump
{
    SKAction *bump = [SKAction sequence:@[[SKAction moveBy:CGVectorMake(-5, -4) duration:0.1],
                                          [SKAction moveTo:CGPointZero duration:0.1]]];
    [self.world runAction:bump];
}

-(void)update:(NSTimeInterval)currentTime{
    static NSTimeInterval lassCallTime;
    
    NSTimeInterval timeElapsed = currentTime - lassCallTime;
    if(timeElapsed > kMinFPS){
        timeElapsed = kMinFPS;
    }
    lassCallTime = currentTime;
    
    
    [self.player update];
    
    if(self.gameState == GameRunning && self.player.crashed)
    {
        [self bump];
        [self gameOver];
    }
    
    if (self.gameState != GameOver) {
        [self.background updateWithTimeElapsed:timeElapsed];
        [self.foreground updateWithTimeElapsed:timeElapsed];
        [self.obstacles updateWithTimeElapsed:timeElapsed];
    }

}

-(MedalType)getMedalForCurrentScore
{
    NSInteger adjustedScore = self.score - (self.bestScore /5);
    if (adjustedScore >= 45){
        return MedalGold;
    }else if (adjustedScore >= 25)
    {
        return MedalSilver;
    }
    else if (adjustedScore >= 10){
        return MedalBronze;
    }
    return MedalNone;
}

@end
