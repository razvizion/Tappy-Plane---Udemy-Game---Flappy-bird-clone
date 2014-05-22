//
//  TPScrollingNode.h
//  Tappy Plane
//
//  Created by Michał Kozak on 15.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TPScrollingNode : SKNode

@property (nonatomic) CGFloat horizontalScrollSpeed; // Distance to scroll per second
@property (nonatomic) BOOL scrolling;

-(void)updateWithTimeElapsed:(NSTimeInterval)timeElapsed;


@end
