//
//  TPScrollingNode.m
//  Tappy Plane
//
//  Created by Michał Kozak on 15.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import "TPScrollingNode.h"

@implementation TPScrollingNode

-(void)updateWithTimeElapsed:(NSTimeInterval)timeElapsed
{
    if(self.scrolling){
        self.position = CGPointMake(self.position.x + (self.horizontalScrollSpeed * timeElapsed), self.position.y);
    }
}



@end
