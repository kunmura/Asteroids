//
//  Beam.m
//  Asteroids
//
//  Created by Murayama Kunshiro on 12/12/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Beam.h"
#import "EnemyController.h"
#import "GameScene.h"

@implementation Beam
@synthesize sprite, isStaged;

- (id)init {
    self = [super init];
    if(self) {
        self.sprite = [CCSprite spriteWithFile:@"beam.png"];
        [self addChild:self.sprite];
        isStaged = NO;
    }
    return self;
}

- (void)dealloc{
    self.sprite = nil;
    [super dealloc];
}

- (void)goFrom:(CGPoint)position layer:(CCLayer *)layer {
    self.position = position;
    [layer addChild:self];
    isStaged = YES;
    
    [self scheduleUpdate];
}

- (void)update:(ccTime)dt{
    // 画面から出たらレイヤから取り除く
    CGSize size = [[CCDirector sharedDirector]winSize];
    if(self.position.y > size.height + self.sprite.contentSize.height/2){
        [self removeFromParentAndCleanup:YES];  // スケジュールも解除
        isStaged = NO;
        return;
    }

    // あたり判定のチェック
    BOOL isHit = [[GameScene sharedInstance].enemyController checkCollision:self.position];
    if(isHit) {
        [self removeFromParentAndCleanup:YES];
        isStaged = NO;
        return;
    }

    // 新しい座標を計算
    float newY = self.position.y + 320*dt;
    self.position = ccp(self.position.x, newY);
}

@end
