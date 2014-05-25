//
//  TPGameOverMenu.h
//  Tappy Plane
//
//  Created by Michał Kozak on 25.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    MedalNone,
    MedalBronze,
    MedalSilver,
    MedalGold,
} MedalType;

@interface TPGameOverMenu : SKNode


@property (nonatomic) CGSize size;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger bestScore;
@property (nonatomic) MedalType medal;

-(instancetype)initWithSize:(CGSize)size;
-(void)show;


@end
