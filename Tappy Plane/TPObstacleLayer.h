//
//  TPObstacleLayer.h
//  Tappy Plane
//
//  Created by Michał Kozak on 20.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import "TPScrollingLayer.h"

@interface TPObstacleLayer : TPScrollingLayer

@property (nonatomic) CGFloat floor;
@property (nonatomic) CGFloat ceiling;

-(void)reset;

@end
