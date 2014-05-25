//
//  TPTilesetTextureProvider.h
//  Tappy Plane
//
//  Created by Michał Kozak on 23.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface TPTilesetTextureProvider : NSObject

+(instancetype)getProvider;

-(void)ranodmizeTileset;
-(SKTexture *)getTextureForKey:(NSString*)key;

@end
