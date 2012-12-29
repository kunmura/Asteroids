//
//  EnemyController.m
//  Asteroids
//
//  Created by Murayama Kunshiro on 12/12/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "EnemyController.h"
#import "Enemy.h"
#import "GameScene.h"

// プライベートメソッドを、クラスエクステンションによって
// 外部に見えないよう宣言します。
@interface EnemyController ()
// 敵をステージ上に配置するメソッド
- (void)stageEnemy;
@end

@implementation EnemyController
@synthesize enemies;

- (id)init{
    self = [super init];
    if(self){
        self.enemies = [NSMutableArray arrayWithCapacity:20];
        // 敵キャラクターを先にストックしておき、
        // ゲームプレイ時に余計な処理を行わない様にしておきます
        for (int i=0; i<20; i++){
            Enemy *enemy = [Enemy node];
            [self.enemies addObject:enemy];
        }
        enemyPos = 0;
    }
    return self;
}

- (void)dealloc{
    self.enemies = nil;
    [super dealloc];
}

- (void)startController {
    // 初回の敵出現タイミングを2秒後にセット
    [self schedule:@selector(stageEnemy) interval:2.0f];
}

- (void)stopController {
    // イベントスケジューラーから解除し、
    // 画面表示している敵キャラクターを全て取り除く
    [self unschedule:@selector(stageEnemy)];
    for(Enemy *e in self.enemies){
        if(e.isStaged){
            [e removeFromParentAndCleanup:YES];
        }
    }
}

- (void)stageEnemy{
    // 敵の種類をこの時点で決定し、
    // ストックしておいた敵キャラクターの１つを個性付けした上で
    // レイヤーに配置
    Enemy *e = [self.enemies objectAtIndex:enemyPos];
    
    // オブジェクトが既に配置されている場合は、何もせず次のタイミングを待つ
    if(!e.isStaged){
        float scale = CCRANDOM_0_1()+0.5;
        float velocity = 20;
        CGSize winSize = [[CCDirector sharedDirector]winSize];
        
        // 画面に唐突に表示されないよう、画面外に少し余裕を持たせて配置
        CGPoint position = ccp(CCRANDOM_0_1() * winSize.width,
                               winSize.height + e.radius*scale*1.1);
        [e moveFrom:position scale:scale velocity:velocity layer:[GameScene sharedInstance].enemyLayer];
        enemyPos = (enemyPos +1)%20;
    }
    
    //次の出現タイミングを再スケジュール
    ccTime nextTime = 1;
    [self unschedule:@selector(stageEnemy)];
    [self schedule:@selector(stageEnemy) interval:nextTime];
}

- (BOOL)checkCollision:(CGPoint)position {
    BOOL isHit = NO;
    for (Enemy *e in self.enemies) {
        // 画面に配置されていなければチェックしないようにして、無駄な処理を省きます。
        if (e.isStaged) {
            isHit = [e hitIfCollided:position];
            // 当たっていればチェック終了
            if (isHit) {
                break;
            }
        }
    }
    return isHit;
}
@end
