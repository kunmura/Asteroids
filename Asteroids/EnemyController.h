//
//  EnemyController.h
//  Asteroids
//
//  Created by Murayama Kunshiro on 12/12/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// 敵キャラをまとめて管理するクラス。以下の処理を行う
// - 敵キャラの全オブジェクトを保持
// - 敵キャラを画面に配置
@interface EnemyController : CCNode {
    NSMutableArray *enemies;    // 敵をストックしておく配列
    NSInteger enemyPos;         // 配列内の、次に登場させる敵の位置
}
@property (nonatomic, retain)NSMutableArray *enemies;

// 動作を開始
- (void)startController;
// 動作を停止。画面上に表示してる敵キャラを削除
- (void)stopController;

@end
