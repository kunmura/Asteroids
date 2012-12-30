//
//  GameScene.m
//

#import "GameScene.h"
#import "BackgroundLayer.h"
#import "Beam.h"
#import "PauseLayer.h"
#import "GameoverLayer.h"
#import "SimpleAudioEngine.h"

// プライベートメソッドを、クラスエクステンションによって
// 外部に見えないよう宣言します。
@interface GameScene ()
// 乱数の種を現在時刻で初期化するメソッド
- (void)initRandom;
@end

@implementation GameScene
@synthesize baseLayer;
@synthesize player;
@synthesize beamLayer, enemyLayer;
@synthesize scoreLabel;
@synthesize interfaceLayer;
@synthesize enemyController;

static GameScene *scene_ = nil;

+ (GameScene *)sharedInstance {
    if (scene_ == nil) {
        scene_ = [GameScene node];
    }
	
	return scene_;
}

- (id)init {
    self = [super init];
	if (self) {
        [self initRandom];
        // 背景を配置
        BackgroundLayer *background = [BackgroundLayer node];
        [self addChild:background z:-1];
        
        // 背景以外のオブジェクトを配置するレイヤー
        self.baseLayer = [CCLayer node];
        [self addChild:baseLayer z:0];
        
        // 地面をbaseLayer上に配置
        CCSprite *land = [CCSprite spriteWithFile:@"land.png"];
        //land.anchorPoint = ccp(0,0);
        //land.position = ccp(0,0);
        land.position = ccp(land.contentSize.width/2, land.contentSize.height/2);
        [self.baseLayer addChild:land z:40];
        
        // 自機をbaseLayer上に配置
        self.player = [Cannon node];
        self.player.position = ccp(240,0);
        [self.baseLayer addChild:self.player z:10];
        
        // ユーザーインタフェースを担当するクラスを起動・baseLayer上に配置
        self.interfaceLayer = [InterfaceLayer node];
        [self.baseLayer addChild:self.interfaceLayer z:100];
        
        // 敵を表示するレイヤーをbaseLayer上に配置
        self.enemyLayer = [CCLayer node];
        [self.baseLayer addChild:self.enemyLayer z:20];
        
        // 弾を表示するレイヤーをbaseLayer上に配置
        self.beamLayer = [CCLayer node];
        [self.baseLayer addChild:self.beamLayer z:30];
        
        // スコア初期化と表示用のラベルをbaseLayer上に配置
        score = 0;
        NSString *scoreString = [NSString stringWithFormat:@"%08d", score];
        self.scoreLabel = [CCLabelTTF labelWithString:scoreString
                                             fontName:@"Helvetica"
                                             fontSize:22];
        self.scoreLabel.position = ccp(420, LAND_HEIGHT/2);
        [self.baseLayer addChild:self.scoreLabel z:50];
        
        // 敵キャラクターを配置する管理クラスを起動
        self.enemyController = [EnemyController node];
        [self.baseLayer addChild:self.enemyController z:-1];
        
        // BGMの音量調整
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0.5f;
        
        // ゲームを開始
        [self startGame];
    }
    return self;
}

- (void)dealloc {
    self.player = nil;
    self.beamLayer = nil;
    self.enemyLayer = nil;
    self.scoreLabel = nil;
    self.interfaceLayer = nil;
    self.enemyController = nil;
    
    self.baseLayer = nil;
    scene_ = nil;
    [super dealloc];
}

- (void)initRandom {
	struct timeval t;
	gettimeofday(&t, nil);
	unsigned int i;
	i = t.tv_sec;
	i += t.tv_usec;
	srandom(i);
}

#pragma -
- (void)startGame {
    // 敵キャラクターの出現
    [self.enemyController startController];
    
    // 自機の位置をリセットして動作開始
    self.player.position = ccp(240,0);
    [self.player start];
    
    // バックグラウンドミュージックの再生開始
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music.mp3" loop:YES];
}

- (void)stopGame {
    // 敵キャラクターを除去
    [self.enemyController stopController];
    
    // 自機の動作を停止
    [self.player stop];
    
    // バックグラウンドミュージックの停止
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

- (void)pause {
    // ポーズ用のレイヤーを画面の最前面に追加します。
    [self addChild:[PauseLayer node] z:100];
    
    // 動作を止めたいオブジェクトに対してスケジュール停止と
    // アクションを一時停止するメソッドを呼びます
    [self.baseLayer pauseSchedulerAndActions];
    [self.player pauseSchedulerAndActions];
    [self.enemyController pauseSchedulerAndActions];
    CCNode *obj;
    CCARRAY_FOREACH(self.beamLayer.children, obj) {
        [obj pauseSchedulerAndActions];
    }
    CCARRAY_FOREACH(self.enemyLayer.children, obj) {
        [obj pauseSchedulerAndActions];
    }
    CCARRAY_FOREACH(self.baseLayer.children, obj) {
        [obj pauseSchedulerAndActions];
    }
}
- (void)resume {
    // 一時停止していたオブジェクトに対して、全てを再開します。
    [self.baseLayer resumeSchedulerAndActions];
    [self.player resumeSchedulerAndActions];
    [self.enemyController resumeSchedulerAndActions];
    CCNode *obj;
    CCARRAY_FOREACH(self.beamLayer.children, obj) {
        [obj resumeSchedulerAndActions];
    }
    CCARRAY_FOREACH(self.enemyLayer.children, obj) {
        [obj resumeSchedulerAndActions];
    }
    CCARRAY_FOREACH(self.baseLayer.children, obj) {
        [obj resumeSchedulerAndActions];
    }
}

- (void)gameover {
    // ゲームオーバー用のレイヤーを画面の最前面に追加します。
    [self addChild:[GameoverLayer node] z:100];
    
    [self.player stop];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

- (void)addScore:(NSInteger)reward {
    // 取得した得点を加算して、画面のスコア表示を更新します。
    score += reward;
    NSString *scoreString = [NSString stringWithFormat:@"%08d", score];
    [self.scoreLabel setString:scoreString];
}
- (void)resetScore {
    score = 0;
    [self addScore:0];
}

@end
