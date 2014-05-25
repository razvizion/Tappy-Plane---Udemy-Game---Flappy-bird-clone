//
//  TPGameOverMenu.m
//  Tappy Plane
//
//  Created by Michał Kozak on 25.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import "TPGameOverMenu.h"

@implementation TPGameOverMenu


-(instancetype)initWithSize:(CGSize)size{
    if(self =[super init])
    {
        _size = size;
        
        //Get texture atlas
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
        
        //Setup node to act as group for panel elements.
        SKNode *panelGroup = [SKNode node];
        [self addChild:panelGroup];
        
        
        // Setup background panel
        SKSpriteNode *panelBackground = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"UIbg"]];
        panelBackground.position = CGPointMake(size.width*0.5, size.height -150);
        
        panelBackground.centerRect = CGRectMake(10/panelBackground.size.width,
                                                10/panelBackground.size.height,
                                                (panelBackground.size.width - 20)/panelBackground.size.width,
                                                (panelBackground.size.height - 20)/panelBackground.size.height);
        panelBackground.xScale = 175.0 / panelBackground.size.width;
        panelBackground.yScale = 115.0 / panelBackground.size.height;
        [panelGroup addChild:panelBackground];
        
        //Score title
        SKSpriteNode *scoreTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textScore"]];
        scoreTitle.anchorPoint = CGPointMake(1.0, 1.0);
        scoreTitle.position = CGPointMake(CGRectGetMaxX(panelBackground.frame)-20, CGRectGetMaxY(panelBackground.frame)-10);
        [panelGroup addChild:scoreTitle];
        
        //Best title
        SKSpriteNode *bestTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textBest"]];
        bestTitle.anchorPoint = CGPointMake(1.0, 1.0);
        bestTitle.position = CGPointMake(CGRectGetMaxX(panelBackground.frame)-20, CGRectGetMaxY(panelBackground.frame)-60);
        [panelGroup addChild:bestTitle];
        
        //Medal title
        SKSpriteNode *medalTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textMedal"]];
        medalTitle.anchorPoint = CGPointMake(0.0, 1.0);
        medalTitle.position = CGPointMake(CGRectGetMinX(panelBackground.frame)+20, CGRectGetMaxY(panelBackground.frame)-10);
        [panelGroup addChild:medalTitle];
    }
    return self;
}

@end
