//
//  Beam.h
//  Asteroids
//
//  Created by Murayama Kunshiro on 12/12/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Beam : CCNode {
    CCSprite *sprite;   // テクスチャを保持
    BOOL isStaged;      // 画面に表示されているか
}
@property (nonatomic, retain)CCSprite *sprite;
@property (nonatomic, readonly)BOOL isStaged;

- (void)goFrom:(CGPoint)position layer:(CCLayer *)layer;
@end
