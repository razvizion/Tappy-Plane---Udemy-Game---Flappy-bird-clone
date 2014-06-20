//
//  TPTilesetTextureProvider.m
//  Tappy Plane
//
//  Created by Michał Kozak on 23.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import "TPTilesetTextureProvider.h"

@interface TPTilesetTextureProvider()

@property (nonatomic) NSMutableDictionary *tilesets;
@property (nonatomic) NSDictionary *currentTileset;

@end

@implementation TPTilesetTextureProvider

+(instancetype)getProvider
{
    static TPTilesetTextureProvider* provider = nil;
    @synchronized(self){
        if(!provider){
            provider = [[TPTilesetTextureProvider alloc]init];
        }
        return provider;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadTilesets];
        [self ranodmizeTileset];
    }
    return self;
}


-(SKTexture*)getTextureForKey:(NSString *)key
{
    return [self.currentTileset objectForKey:key];
}

-(void)ranodmizeTileset
{
    NSArray *tilesetKeys = [self.tilesets allKeys];
    self.currentTilesetName = [tilesetKeys objectAtIndex:arc4random_uniform((uint)tilesetKeys.count)];
    self.currentTileset = [self.tilesets objectForKey:self.currentTilesetName];
}

-(void)loadTilesets
{
    self.tilesets = [[NSMutableDictionary alloc]init];
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    // Geth path to property list.
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"TilesetGraphics" ofType:@"plist"];
    //load contants of file
    NSDictionary *tilesetList = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    //Loop through tilesetList.
    for (NSString *tilesetKey in tilesetList) {
        //get dictionary of texture names.
        NSDictionary *textureList = [tilesetList objectForKey:tilesetKey];
        //Create dictionary to hold textures.
        NSMutableDictionary *textures = [[NSMutableDictionary alloc]init];
        
        for (NSString * textureKey in textureList) {
            // Get texture for key
            SKTexture *texture = [atlas textureNamed:[textureList objectForKey:textureKey]];
            // Insert texture to textures dictionary.
            
            [textures setObject:texture forKey:textureKey];
        }
        
        // Add textures dictionary to filesets.
        [self.tilesets setObject:textures forKey:tilesetKey];
    }
}

@end
