//
//  GameScene.h
//  Asteroids
//
//  Created by Murayama Kunshiro on 12/12/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Cannon.h"
#import "InterfaceLayer.h"

#define LAND_HEIGHT 22          // 地面の高さとして記述

@interface GameScene : CCScene {
    CCLayer *baseLayer;         // ベースとなるレイヤー
    Cannon *player;             // 自機
    CCLayer *enemyLayer;        // 敵キャラクター配置用レイヤー
    CCLayer *beamLayer;         // 弾を配置するレイヤー
    
    InterfaceLayer *interfaceLayer;    // 入力を受け付けるレイヤー
}
@property (nonatomic, retain)CCLayer *baseLayer;
@property (nonatomic, retain)Cannon *player;
@property (nonatomic, retain)CCLayer *enemyLayer;
@property (nonatomic, retain)CCLayer *beamLayer;
@property (nonatomic, retain)InterfaceLayer *interfaceLayer;

// シングルトンオブジェクトを返すメソッド
+ (GameScene *)sharedInstance;
@end
