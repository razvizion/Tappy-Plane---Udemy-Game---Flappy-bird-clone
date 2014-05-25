//
//  TPObstacleLayer.h
//  Tappy Plane
//
//  Created by Michał Kozak on 20.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import "TPScrollingLayer.h"
#import "TPCollectable.h"

@interface TPObstacleLayer : TPScrollingLayer

@property (nonatomic) CGFloat floor;
@property (nonatomic) CGFloat ceiling;
@property (nonatomic, weak) id<TPCollectableDelegate> collectableDelegate;

-(void)reset;

@end
