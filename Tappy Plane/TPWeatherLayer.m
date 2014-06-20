//
//  TPWeatherLayer.m
//  Tappy Plane
//
//  Created by Michał Kozak on 28.05.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import "TPWeatherLayer.h"
#import "SoundManager.h"

@interface TPWeatherLayer()

@property (nonatomic) SKEmitterNode *rainEmitter;
@property (nonatomic) SKEmitterNode *snowEmitter;
@property (nonatomic) Sound *rainSound;

@end

@implementation TPWeatherLayer

-(instancetype)initWithSize:(CGSize)size
{
    self = [super init];
    if(self){
        _size = size;
        
        //Load rain effect.
        NSString *rainEffectPath = [[NSBundle mainBundle] pathForResource:@"RainEffect" ofType:@"sks"];
        _rainEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:rainEffectPath];
        _rainEmitter.position = CGPointMake(size.width * 0.5 + 32, size.height+5);
        
        // Setup Rain sound
        
        _rainSound = [Sound soundNamed:@"Rain.caf"];
        _rainSound.looping = YES;
        
        //Load rain effect.
        NSString *snowEffectPath = [[NSBundle mainBundle] pathForResource:@"SnowEffect" ofType:@"sks"];
        _snowEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:snowEffectPath];
        _snowEmitter.position = CGPointMake(size.width * 0.5, size.height+5);
        
        
    }
    return self;
}
-(void)setConditions:(WeatherType)conditions
{
    if(_conditions != conditions){
        _conditions = conditions;
        
        // Remove existing weather condidition
        
        [self removeAllChildren];
        
        if(self.rainSound.playing)
        {
            [self.rainSound fadeOut:1.0];
        }
        
        //Stop any existing sound from playing
        
        switch (conditions) {
            case WeatherRaining:
                [self addChild:self.rainEmitter];
                [self.rainSound fadeIn:1.0];
                [self.rainSound play];
                [self.rainEmitter advanceSimulationTime:5];
                break;
            case WeatherSnowing:
                [self addChild:self.snowEmitter];
                [self.snowEmitter advanceSimulationTime:5];
                break;
            default:
                break;
        }
        
    }
    
}


@end
