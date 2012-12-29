//
//  Cannon.m
//  Asteroids
//
//  Created by Murayama Kunshiro on 12/12/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Cannon.h"
#import "GameScene.h"

// プライベートメソッドを、クラスエクステンションによって
// 外部に見えないよう宣言します。
@interface Cannon ()
// 弾を発射するメソッド
- (void)fire;
// 敵が地面に激突したイベントを扱うメソッド
- (BOOL)hitIfCollided:(CGPoint)position;
@end

@implementation Cannon
@synthesize sprite;
@synthesize cartridge;

- (id)init{
    self = [super init];
    if(self){
        started = NO;
        
        // 画像データを読み込みスプライトとして配置
        self.sprite = [CCSprite spriteWithFile:@"cannon.png"];
        self.sprite.position = ccp(0, self.sprite.contentSize.height/2+LAND_HEIGHT);
        [self addChild:sprite];
        
        state = kCannonIsStopped;
        
        // 弾を先に作成しておき、配列(弾倉)に保存しておきます。
        // 発射する際には、この配列内の弾を使います。
        self.cartridge = [NSMutableArray arrayWithCapacity:30];
        for (int i=0; i<30; i++) {
            Beam *beam = [Beam node];
            [self.cartridge addObject:beam];
        }
        cartridgePos = 0;
    }
    return self;
}

- (void)dealloc {
    self.sprite = nil;
    self.cartridge = nil;
    // スケジューリングしてたイベントを全て停止してから終了
    [self unscheduleAllSelectors];
    [self unscheduleUpdate];
    
    [super dealloc];
}

- (void)start {
    // 移動するためのイベントを動かし始める
    life = 5;
    [self scheduleUpdate];
    [self schedule:@selector(fire) interval:0.25f];
    started = YES;
}

- (void)stop {
    started = NO;
    // startとは逆にイベントをスケジューラから解除
    [self unschedule:@selector(fire)];
    [self unscheduleUpdate];
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
    if (newX < 0.0f){
        newX = 0;
    }else if(newX > 480.0f){
        newX = 480;
    }
    self.position = ccp(newX, 0);
}

- (void)fire{
    // 停止しているときだけ弾が発射されるように
    if(state==kCannonIsStopped){
        Beam *b = [self.cartridge objectAtIndex:cartridgePos];
        // 砲台の先端から弾が発射される様に、初期位置を調整したうえで発射
        CGPoint position = ccp(self.position.x,
                               self.position.y
                               + self.sprite.contentSize.height
                               + LAND_HEIGHT);
        [b goFrom:position layer:[GameScene sharedInstance].beamLayer];
        cartridgePos = (cartridgePos +1)%30;
    }
}

- (BOOL)hitIfCollided:(CGPoint)position{
    // 地面の高さに到達している場合は衝突したとみなす
    BOOL isHit = position.y < LAND_HEIGHT;
    NSLog(@"チェック %i",isHit);
    if(isHit){
        NSLog(@"衝突");
        [self gotHit:position];
    }
    return isHit;
}

- (void)gotHit:(CGPoint)position{
    life--;
    
    // 画面を揺らしてダメージを受けたことを表示
    id action = [CCShaky3D actionWithRange:5 shakeZ:YES grid:ccg(10,15) duration:0.5];
    id reset = [CCCallBlock actionWithBlock:^{
        // CCShaky3Dの動作が終了したときに、画面の揺れを元に戻す
        [GameScene sharedInstance].baseLayer.grid = nil;
    }];
    [[GameScene sharedInstance].baseLayer runAction:[CCSequence actions:action, reset, nil]];
}
@end