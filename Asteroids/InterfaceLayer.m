//
//  InterfaceLayer.m
//  Asteroids
//
//  Created by Murayama Kunshiro on 12/12/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "InterfaceLayer.h"
#import "GameScene.h"

@implementation InterfaceLayer

- (id)init{
    self = [super init];
    if(self){
    }
    return self;
}

// 本クラスがアクティブなレイヤーに登録されたタイミングで、
// タッチイベントの受信を開始
// 非アクティブになったら受信しないようにCCTouchDispatcherから取り除く
- (void)onEnter{
    [[[CCDirector sharedDirector]touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
- (void)onExit{
    [[[CCDirector sharedDirector]touchDispatcher] removeDelegate:self];
}

#pragma mark タッチイベントの取り扱い
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {              // タッチされたとき
    // タッチされたポイントの座標をcocos2dの座標系（原点：左下）に変換
    CGPoint locationInView = [touch locationInView:[touch view]];
    CGPoint location = [[CCDirector sharedDirector]convertToGL:locationInView];
    
    if(location.x < 240){
        // 左への移動指示を出す
        GameScene *scene = [GameScene sharedInstance];
        [scene.player moveLeft];
    }else{
        if(location.y > 280){
            // ポーズ用
            [[GameScene sharedInstance]pause];
        }else{
            // 右への移動指示を出す
            GameScene *scene = [GameScene sharedInstance];
            [scene.player moveRight];
        }
    }
    // タッチイベントをこのメソッドで終える
    // （他のレイヤーのデリゲートメソッドを呼ばない）
    return YES;
}
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {              // タッチが移動しているとき
    // タッチエリアが変わったら移動の命令を切り替える
    // タッチされたポイントの座標系をcocos2d座標系に変換
    CGPoint locationInView = [touch locationInView:[touch view]];
    CGPoint location = [[CCDirector sharedDirector]convertToGL:locationInView];
    
    if(location.x < 240){
        // 左への移動指示を出す
        GameScene *scene = [GameScene sharedInstance];
        [scene.player moveLeft];
    }else{
        // 右への移動指示を出す
        GameScene *scene = [GameScene sharedInstance];
        [scene.player moveRight];
    }
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {              // タッチが終了したとき
    // 移動停止の指示を出す
    GameScene *scene = [GameScene sharedInstance];
    [scene.player stopMoving];
}
- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {        // タッチが電話などでキャンセルされたとき
    // 移動停止の指示を出す
    GameScene *scene = [GameScene sharedInstance];
    [scene.player stopMoving];
}

@end
