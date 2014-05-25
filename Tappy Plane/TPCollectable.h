//
//  TPCollectable.h
//  Tappy Plane
//
//  Created by Michał Kozak on 22.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class TPCollectable;

@protocol TPCollectableDelegate <NSObject>

-(void)wasCollected:(TPCollectable *)collectable;

@end

@interface TPCollectable : SKSpriteNode

@property (nonatomic, weak) id<TPCollectableDelegate> delegate;
@property (nonatomic) NSInteger pointValue;
-(void)collect;

@end
