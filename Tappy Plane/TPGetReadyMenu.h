//
//  TPGetReadyMenu.h
//  Tappy Plane
//
//  Created by Michał Kozak on 26.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TPGetReadyMenu : SKNode
@property (nonatomic) CGSize size;

-(instancetype)initWithSize:(CGSize)size andPlanePosition:(CGPoint)planePosition;

-(void)show;
-(void)hide;

@end
