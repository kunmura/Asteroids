//
//  Cannon.h
//  Asteroids
//
//  Created by Murayama Kunshiro on 12/12/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// 現在の時期の状態を表す列挙子
typedef enum{
    kCannonIsStopped = 0,
    kCannonIsMovingToLeft,
    kCannonIsMovingToRight,
} MovingStatus;

// 自機を表すクラス
@interface Cannon : CCNode {
    BOOL started;       // 動作開始しているか
    CCSprite *sprite;   // 自機のテクスチャ
    MovingStatus state; // 自機の動作状態
    NSInteger life;     // 残りのライフ
}
@property (nonatomic, retain)CCSprite *sprite;

// 動作開始
- (void)start;
// 動作停止
- (void)stop;

// 自機に対する移動命令を扱うメソッド
- (void)moveLeft;
- (void)moveRight;
- (void)stopMooving;

@end
