//
//  TPConstants.m
//  Tappy Plane
//
//  Created by Michał Kozak on 19.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import "TPConstants.h"

@implementation TPConstants

const uint32_t kTPCategoryPlane         = 0x1 << 0;
const uint32_t kTPCategoryGround        = 0x1 << 1;
const uint32_t kTPCategoryCollectable   = 0x1 << 2;

NSString *const kTPTilesetGrass = @"Grass";
NSString *const kTPTilesetDirt = @"Dirt";
NSString *const kTPTilesetIce = @"Ice";
NSString *const kTPTilesetSnow = @"Snow";
@end
