//
//  TPCollectable.m
//  Tappy Plane
//
//  Created by Michał Kozak on 22.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import "TPCollectable.h"

@implementation TPCollectable

-(void)collect
{
    [self runAction:[SKAction removeFromParent]];
    if(self.delegate){
        [self.delegate wasCollected:self];
    }
}

@end
