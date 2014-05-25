//
//  TPBitmapFontLabel.h
//  Tappy Plane
//
//  Created by Michał Kozak on 22.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TPBitmapFontLabel : SKNode

@property (nonatomic) NSString* fontName;
@property (nonatomic) NSString* text;
@property (nonatomic) CGFloat letterSpacing;

-(instancetype)initWithText:(NSString *)text andFrontName:(NSString*)fontName;

@end
