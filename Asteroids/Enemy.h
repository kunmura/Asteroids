//
//  Enemy.h
//  Asteroids
//
//  Created by Murayama Kunshiro on 12/12/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// 敵キャラクターのサイズ（半径）のデフォルト
// asteroid.pngの画像サイズと、意図するあたり判定のサイズが
// 異なるため、ここで値を定義
#define ENEMY_DEFAULT_RADIUS 40

// 敵キャラクターを表現するクラス
@interface Enemy : CCNode {
    CCSprite *sprite;
    BOOL isStaged;
    
    // 敵キャラクターのプロパティ
    float radius;       // 大きさ（半径）
    NSInteger life;     // 耐久力
    float speed;        // 移動スピード
}
@property (nonatomic, retain)CCSprite *sprite;
@property (nonatomic, readonly)BOOL isStaged;
@property (nonatomic, readonly)float radius;

// 指定したプロパティレイヤー上で動作開始
- (void)moveFrom: (CGPoint)position
           scale:(float)scale
        velocity:(float)velocity
           layer:(CCLayer *)layer;

// 指定された座標に対して衝突しているかどうか判定
- (BOOL)hitIfCollided:(CGPoint)position;
@end
