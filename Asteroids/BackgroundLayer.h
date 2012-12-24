//
//  BackgroundLayer.h
//  Asteroids
//
//  Created by Murayama Kunshiro on 12/12/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BackgroundLayer : CCLayer {
    CCParticleSystem *space;    //  背景の星
}

@property (nonatomic, retain)CCParticleSystem *space;

@end
