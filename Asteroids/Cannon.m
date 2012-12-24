//
//  Cannon.m
//  Asteroids
//
//  Created by Murayama Kunshiro on 12/12/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Cannon.h"
#import "GameScene.h"

@implementation Cannon
@synthesize sprite;

- (id)init{
    self = [super init];
    if(self){
        started = NO;
        
        // 画像データを読み込みスプライトとして配置
        self.sprite = [CCSprite spriteWithFile:@"cannon.png"];
        self.sprite.position = ccp(0, self.sprite.contentSize.height/2+LAND_HEIGHT);
        [self addChild:sprite];
        
        state = kCannonIsStopped;
    }
    return self;
}

- (void)start {
    // 移動するためのイベントを動かし始める
    life = 5;
    [self scheduleUpdate];
    started = YES;
}

- (void)stop {
    started = NO;
    // startとは逆にイベントをスケジューラから解除
    [self unscheduleUpdate];
}

- (void)dealloc {
    self.sprite = nil;
    // スケジューリングしてたイベントを全て停止してから終了
    [self unscheduleAllSelectors];
    [self unscheduleUpdate];
    
    [super dealloc];
}

#pragma mark 移動イベント
// 移動の指示を他のクラスから受け取る。
// 指示が有ったらすぐ動くのではなく、状態だけを変更しておき、
// 実際の位置情報は更新メソッドupdate:で行うのがポイント
- (void)moveLeft{
    state = kCannonIsMovingToLeft;
}
- (void)moveRight{
    state = kCannonIsMovingToRight;
}
- (void)stopMoving{
    state = kCannonIsStopped;
}

- (void)update:(ccTime)dt{
    float dx = 0;   // 横方法への移動ポイント量
    // プレイヤーの操作状態によって移動方向を変化
    switch (state) {
        case kCannonIsMovingToLeft:
            dx = -240 * dt;
            break;
        case kCannonIsMovingToRight:
            dx = 240 * dt;
            break;
        default:
            break;
    }
    float newX = self.position.x + dx;
    if (newX<0.0f){
        newX = 0;
    }else if(newX>480.0f){
        newX = 480;
    }
    self.position = ccp(newX, 0);
}
@end