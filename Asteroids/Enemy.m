//
//  Enemy.m
//  Asteroids
//
//  Created by Murayama Kunshiro on 12/12/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"
#import "GameScene.h"

// プライベートメソッドを、クラスエクステンションによって
// 外部に見えないよう宣言します。
@interface Enemy ()
// 弾が自分に当たったときのイベントを扱うメソッド
- (void)gotHit:(CGPoint)position;
@end

@implementation Enemy
@synthesize sprite, isStaged;
@synthesize radius;

- (id)init{
    self = [super init];
    if(self){
        self.sprite = [CCSprite spriteWithFile:@"asteroid.png"];
        [self addChild:self.sprite];
        radius = ENEMY_DEFAULT_RADIUS;
        
        isStaged = NO;
    }
    return self;
}

- (void)dealloc{
    self.sprite = nil;
    [super dealloc];
}

- (void)moveFrom:(CGPoint)position scale:(float)scale velocity:(float)velocity layer:(CCLayer *)layer {
    // 渡されたプロパティで敵キャラクターを特徴づける
    self.position = position;
    self.scale = scale;
    radius *= scale;
    life = scale * 2.5f;    // 耐久力は大きさで決定
    
    // ゲームがにぎやかになるよう、スプライトに色を重ねる
    self.sprite.color = ccc3(CCRANDOM_0_1()*255, CCRANDOM_0_1()*255, CCRANDOM_0_1()*255);
    
    // 回転を続けるアニメーションを作成
    float rotateDuration = CCRANDOM_0_1() * 10 +1;  // 回転スピード
    id rotateForever = [CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:rotateDuration angle:360]];
    
    // 画面下部へ移動するアニメーションを作成
    float winHeight = [[CCDirector sharedDirector]winSize].height;
    float duration = winHeight / velocity;          // 移動スピード
    id moveDown = [CCMoveTo actionWithDuration:duration position:ccp(position.x,-radius)];
    
    // アニメーションを自分自身に設定し、レイヤー上で動作開始
    [self runAction:rotateForever];
    [self runAction:moveDown];
    
    // スケジュールのアップデートを有効に
    [self scheduleUpdate];
    
    [layer addChild:self];
    isStaged = YES;
}

- (void)update:(ccTime)dt {
    // 地面に激突したかどうかを自機クラスに判定してもらう
    // self.positionだと隕石の中心になるため、半径を引いて下幅で判定
    CGPoint position = ccp(self.position.x, self.position.y-radius);
    BOOL isHit = [[GameScene sharedInstance].player hitIfCollided:position];

    if(isHit){
        [self removeFromParentAndCleanup:YES];
    }
}

- (void)removeFromParentAndCleanup:(BOOL)cleanup {
    // 画面から除外するときに、プロパティもリセット
    self.position = CGPointZero;
    self.scale = 1.0f;
    radius = ENEMY_DEFAULT_RADIUS;
    isStaged = NO;
    
    NSLog(@"cleanup");
    
    // リセット後、オーバーライドした元の処理を呼び出す
    [super removeFromParentAndCleanup:cleanup];
}

- (BOOL)hitIfCollided:(CGPoint)position {
    // 座標との距離が自分のサイズよりも小さい場合は当たったとみなします
    BOOL isHit = ccpDistance(self.position, position) < radius;
    if (isHit) {
        [self gotHit:position];
    }
    return isHit;
}

- (void)gotHit:(CGPoint)position {
    life--;
    if (life<=0) {
        // 爆破エフェクトをGameSceneのbaseLayerで表示します。
        // CCParticleSunをベースにパラメータを調整して爆発を表現します。
        // (自分自身は上の処理で画面上から取り除かれているためselfではなく
        //  baseLayerに直接配置しています)
        CCParticleSystem *bomb = [CCParticleSun node];
        bomb.duration = 0.3f;
        bomb.life = 0.5f;
        bomb.speed = 40;
        bomb.scale = self.scale * 2.0f;
        bomb.position = self.position;
        bomb.autoRemoveOnFinish = YES;
        [[GameScene sharedInstance].baseLayer addChild:bomb z:100];
        
        // 大きさに応じたスコアを計算し、加算
        NSInteger score = 100 * self.scale;
        [[GameScene sharedInstance]addScore:score];
        
        // オブジェクトの削除
        [self removeFromParentAndCleanup:YES];
    }
}
@end
