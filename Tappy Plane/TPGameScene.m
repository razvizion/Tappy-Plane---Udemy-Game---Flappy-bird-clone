//
//  TPGameScene.m
//  Tappy Plane
//
//  Created by Michał Kozak on 14.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import "TPGameScene.h"

@implementation TPGameScene

-(id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size]){
        NSLog(@"size: %f %f",size.width,size.height);
    }
    return self;
}

@end
