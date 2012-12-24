//
//  BackgroundLayer.m
//  Asteroids
//
//  Created by Murayama Kunshiro on 12/12/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BackgroundLayer.h"


@implementation BackgroundLayer
@synthesize space;

- (id) init{
    self = [super init];
    if (self) {
        // 雨の様な表現をするCCParticleRainのパラメータを調節して、
        // 星空を表現。
        self.space = [CCParticleRain node];
        self.space.emissionRate = 10;   // パーティクルの表示数を少なく
        self.space.startSize = 2.5f;    // パーティクルのサイズを小さく
        self.space.gravity = ccp(0,0);  // 重力で加速しない（一定速度移動）
        self.space.speed = 100;          // スピードを遅く
        self.space.life = 10;           // 消滅までの時間を長く
        self.space.angleVar = 0;        // 移動中に揺れない
        self.space.radialAccelVar = 0;  // 一部のパーティクルを左右に動かす
        self.space.tangentialAccelVar = 0; // 一部のパーティクルを左右に動かす
        
        [self addChild:self.space z:0];
    }
    return self;
}

- (void) dealloc{
    self.space = nil;
    [super dealloc];
}
@end
