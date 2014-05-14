//
//  TPGameScene.m
//  Tappy Plane
//
//  Created by Michał Kozak on 14.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import "TPGameScene.h"
#import "TPPlane.h"

@interface TPGameScene ()
@property (nonatomic) TPPlane *player;
@property (nonatomic) SKNode *world;

@end


@implementation TPGameScene

-(id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size]){
        
        //Setup world
        _world = [SKNode node];
        [self addChild:_world];
        
        //Setup player
        _player = [[TPPlane alloc]init];
        _player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
        [_world addChild:_player];
    }
    return self;
}

@end
