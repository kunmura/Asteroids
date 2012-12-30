//
//  PauseLayer.m
//  Asteroids
//
//  Created by Murayama Kunshiro on 12/12/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "PauseLayer.h"
#import "GameScene.h"

@implementation PauseLayer

- (id)init{
    self = [super init];
    if(self){
        // 暗めの色で画面を覆う
        CCLayerColor *shade = [CCLayerColor layerWithColor:ccc4(30, 30, 30, 200)];
        [self addChild:shade];
        // ゲームへの戻りかたを画面に記す
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap to resume." fontName:@"Helvetica" fontSize:48];
        CGSize winsize = [[CCDirector sharedDirector]winSize];
        label.position = ccp(winsize.width/2, winsize.height/2);
        [self addChild:label];
    }
    return self;
}

// 本クラスがアクティブなレイヤーに登録されている期間だけで、
// タッチベントの受信開始・受信停止を宣言します。
- (void)onEnter{
    [[[CCDirector sharedDirector]touchDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
- (void)onExit{
    [[[CCDirector sharedDirector]touchDispatcher]removeDelegate:self];
}
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    // タッチイベントを扱う場合、ccTouchBeganは必須
    return YES;
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    // 画面がタップされたらresume
    [self removeFromParentAndCleanup:YES];
    [[GameScene sharedInstance]resume];
}

@end
