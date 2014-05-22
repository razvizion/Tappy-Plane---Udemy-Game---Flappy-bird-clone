//
//  TPScrollingLayer.h
//  Tappy Plane
//
//  Created by Michał Kozak on 15.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import "TPScrollingNode.h"

@interface TPScrollingLayer : TPScrollingNode

-(id)initWithTiles:(NSArray*)tileSpriteNodes;

-(void)layoutTiles;

@end
