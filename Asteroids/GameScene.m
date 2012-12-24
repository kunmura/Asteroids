//
//  GameScene.m
//  Asteroids
//
//  Created by Murayama Kunshiro on 12/12/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "BackgroundLayer.h"

//  プライベートメソッドを、クラスエクステンションによって
//  外部に見えないよう宣言。
@interface GameScene ()
//  乱数のタネを現在時刻で初期化するメソッド
- (void)initRandom;
@end

@implementation GameScene
@synthesize baseLayer;
@synthesize player;

static GameScene *scene_ = nil;

+ (GameScene *)sharedInstance{
    if(scene_ == nil){
        scene_ = [GameScene node];
    }
    return scene_;
}

- (id)init {
    self = [super init];
    if (self){
        [self initRandom];
        
        // 背景を配置する処理
        BackgroundLayer *background = [BackgroundLayer node];
        [self addChild:background z:-1];
        
        // 背景以外のオブジェクトを配置するレイヤー
        self.baseLayer = [CCLayer node];
        [self addChild:baseLayer z:0];
        
        // 地面をbaseLayer上に配置
        CCSprite *land = [CCSprite spriteWithFile:@"land.png"];
        land.anchorPoint = ccp(0,0);        // land自身の座標を中心から左下に
        land.position = ccp(0,0);           // landの位置を画面の左下に
        [self.baseLayer addChild:land z:40];
        
        // 自機を配置
        self.player = [Cannon node];
        self.player.position = ccp(240,0);
        [self.baseLayer addChild:player z:10];
        
        // ユーザーインタフェースを担当するクラスを起動・baseLayer上に配置
        self.interfaceLayer = [InterfaceLayer node];
        [self.baseLayer addChild:self.interfaceLayer z:100];
        
        // 敵を表示するレイヤーをbaseLayer上に配置
        self.enemyLayer = [CCLayer node];
        [self.baseLayer addChild:self.enemyLayer z:20];
        
        // 弾を表示するレイヤーをbaseLayer上に配置
        self.beamLayer = [CCLayer node];
        [self.baseLayer addChild:self.beamLayer z:30];
        
    }
    return self;
}

- (void)dealloc{
    // 保持していたメンバー変数を解放
    self.baseLayer = nil;
    self.enemyLayer = nil;
    self.beamLayer = nil;
    
    scene_ = nil;
    [super dealloc];
}

- (void)initRandom{
    struct timeval t;
    gettimeofday(&t, nil);
    unsigned int i;
    i = t.tv_sec;
    i += t.tv_usec;
    srandom(i);
}
@end
