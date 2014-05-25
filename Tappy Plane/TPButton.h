//
//  TPButton.h
//  Tappy Plane
//
//  Created by Michał Kozak on 25.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TPButton : SKSpriteNode

@property (nonatomic) CGFloat pressedScale;
@property (nonatomic, readonly, weak) id pressedTarget;
@property (nonatomic, readonly) SEL pressedAction;

-(void)setPressedTarget:(id)pressedTarget withAction: (SEL)pressedAction;


+(instancetype)spriteNodeWithTexture:(SKTexture *)texture;

@end
