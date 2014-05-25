//
//  TPGameScene.h
//  Tappy Plane
//
//  Created by Michał Kozak on 14.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TPCollectable.h"

@interface TPGameScene : SKScene <SKPhysicsContactDelegate, TPCollectableDelegate>

@end
