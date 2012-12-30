//
//  Cannon.m
//

#import "Cannon.h"
#import "Beam.h"
#import "GameScene.h"
#import "SimpleAudioEngine.h"

// プライベートメソッドを、クラスエクステンションによって
// 外部に見えないよう宣言します。
@interface Cannon ()
// 弾を発射するメソッド
- (void)fire;
// 敵が地面に激突したイベントを扱うメソッド
- (void)gotHit:(CGPoint)position;
@end

@implementation Cannon
@synthesize sprite, cartridge;

- (id)init {
    self = [super init];
    if (self) {
        started = NO;
        
        // 画像データを読み込みスプライトとして配置します。
        // 本クラスの座標を操作するときに、y:0でちょうど地面の上に位置するよう、
        // 22(ポイント)を地面の高さとして加算します。
        self.sprite = [CCSprite spriteWithFile:@"cannon.png"];
        self.sprite.position = ccp(0, self.sprite.contentSize.height/2+LAND_HEIGHT);
        [self addChild:self.sprite];
        
        state = kCannonIsStopped;
        
        // 弾を先に作成しておき、配列(弾倉)に保存しておきます。
        // 発射する際には、この配列内の弾を使います。
        self.cartridge = [NSMutableArray arrayWithCapacity:30];
        for (int i=0; i<30; i++) {
            Beam *beam = [Beam node];
            [self.cartridge addObject:beam];
        }
        cartridgePos = 0;
        
        // 効果音を先読みしておき、初回再生時の遅延を防ぎます
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"shot.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"crash.caf"];
    }
    return self;
}
- (void)dealloc {
    self.sprite = nil;
    self.cartridge = nil;
    // スケジューリングしていたイベントを全て停止してから終了します
    [self unscheduleAllSelectors];
    [self unscheduleUpdate];
    
    [super dealloc];
}

- (void)start {
    // 移動と弾を発射するためのイベントを動かし始めます
    life = 5;
    [self scheduleUpdate];
    [self schedule:@selector(fire) interval:0.25f];
    started = YES;
}

- (void)stop {
    started = NO;
    // startとは逆にイベントをスケジューラーから解除します
    [self unschedule:@selector(fire)];
    [self unscheduleUpdate];
}
#pragma mark 移動イベント
// 移動の指示を他のクラスから受け取ります。
// 指示があったらすぐに動くのではなく、状態だけを変更しておき、
// 実際の位置変更は更新メソッドupdate:で行うのがポイントです。
- (void)moveLeft {
    state = kCannonIsMovingToLeft;
}
- (void)moveRight {
    state = kCannonIsMovingToRight;
}
- (void)stopMoving {
    state = kCannonIsStopped;
}

// 自機位置の更新メソッド。scheduleUpdateを呼んでいると、
// このupdate:メソッドが毎フレームで呼び出されます
- (void)update:(ccTime)dt {
    float dx = 0; // 横方向への移動ポイント量
    // プレイヤーの操作状態によって移動方向を変化させます。
    // 1秒間で240ポイント、つまり画面の端から端まで2秒で
    // 移動できるスピードにしています。
    switch (state) {
        case kCannonIsMovingToLeft:
            dx = -240 * dt;
            break;
        case kCannonIsMovingToRight:
            dx = 240 * dt;
            break;
        default:
            break;
    }
    float newX = self.position.x + dx;
    if (newX<0.0f) {
        newX = 0;
    } else if (newX>480.0f) {
        newX = 480;
    }
    self.position = ccp(newX, 0);
}

// 弾を発射します
- (void)fire {
    // 停止しているときだけ弾が発射されるようにします
    if (state==kCannonIsStopped) {
        Beam *b = [self.cartridge objectAtIndex:cartridgePos];
        // 砲塔の先端から弾が発射されるように、初期位置を調整した上で発射します
        CGPoint position = ccp(self.position.x,
                               self.position.y+self.sprite.contentSize.height+LAND_HEIGHT);
        [b goFrom:position layer:[GameScene sharedInstance].beamLayer];
        cartridgePos = (cartridgePos + 1)%30;
        //[[SimpleAudioEngine sharedEngine] playEffect:@"shot.caf"];
    }
}

- (BOOL)hitIfCollided:(CGPoint)position {
    // 地面の高さに到達している場合は衝突したとみなします
    BOOL isHit = position.y < LAND_HEIGHT;
    if (isHit) {
        [self gotHit:position];
    }
    return isHit;
}

- (void)gotHit:(CGPoint)position {
    life--;
    CCLOG(@"激突！残りライフ：%d", life);
    id action = [CCShaky3D actionWithRange:5 shakeZ:YES grid:ccg(10,15) duration:0.5];
    id reset = [CCCallBlock actionWithBlock:^{
        [GameScene sharedInstance].baseLayer.grid = nil;
    }];
    [[GameScene sharedInstance].baseLayer runAction:[CCSequence actions:action, reset, nil]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"crash.caf" ];
    
    if (life < 0 && started == YES) {
        [[GameScene sharedInstance] gameover];
    }
}

@end
