//
//  GameScene.h
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "InterfaceLayer.h"
#import "Cannon.h"
#import "EnemyController.h"

#define LAND_HEIGHT 22 // 地面の高さ（画像の高さと一致しないためここで定義）

@interface GameScene : CCScene {
    CCLayer *baseLayer;     // ベースレイヤー
    Cannon *player;         // 自機
    CCLayer *enemyLayer;    // 敵を配置するレイヤー
    CCLayer *beamLayer;     // 弾を配置するレイヤー
    CCLabelTTF *scoreLabel; // スコア表示
    
    InterfaceLayer *interfaceLayer;  // 入力を受け付けるレイヤー
    EnemyController *enemyController;   // 敵の管理クラス
    
    NSInteger score;    // プレイスコア
}
@property (nonatomic, retain)CCLayer *baseLayer;
@property (nonatomic, retain)Cannon *player;
@property (nonatomic, retain)CCLayer *enemyLayer;
@property (nonatomic, retain)CCLayer *beamLayer;

@property (nonatomic, retain)CCLabelTTF *scoreLabel;
@property (nonatomic, retain)InterfaceLayer *interfaceLayer;
@property (nonatomic, retain)EnemyController *enemyController;

// シングルトンオブジェクトを返すメソッド
+ (GameScene *)sharedInstance;

// ゲームを開始/停止する
- (void)startGame;
- (void)stopGame;

// ゲームを一時停止/再開する
- (void)pause;
- (void)resume;

// ゲームオーバーの処理を行う
- (void)gameover;

// スコアを加算する（スコア表示も更新）
- (void)addScore:(NSInteger)reward;
// スコアのリセット
- (void)resetScore;
@end

