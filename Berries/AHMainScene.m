//
//  AHMainScene.m
//  Berries
//
//  Created by Adrian Hamelink on 10/02/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHMainScene.h"
#import "AHBerries.h"
#import "AHCamp.h"

CGFloat kScoreBarheight = 44.0;
AHDifficulty kDifficulty = AHDifficultyEasy;

@interface AHMainScene ()
@property (nonatomic, strong) NSMutableArray *berryNodes;
@property (nonatomic, weak) AHBerries *draggedBerry;
@property (nonatomic, strong) SKSpriteNode *scoreBar;
@property (nonatomic, strong) NSArray *camps;
@property (nonatomic, readonly, strong) AHCamp *greyCamp;
@property (nonatomic, strong) SKLabelNode *scoreLabel;
@property (nonatomic, strong) SKLabelNode *timeLabel;
@property (nonatomic) NSUInteger score;
@property (nonatomic, strong) NSTimer *time;
@property (nonatomic, strong) NSDate *startTime;
@end

@implementation AHMainScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [self createScene];
    }
    return self;
}

- (void)createScene
{
    self.time = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimeLabel:) userInfo:nil repeats:YES];
    self.startTime = [NSDate date];
    
    [self addChild:self.scoreBar];
    [self.scoreBar addChild:self.timeLabel];
    [self.scoreBar addChild:self.scoreLabel];
    
    for (AHCamp *camp in self.camps) {
        camp.zPosition = 1;
        [self addChild:camp];
    }
    for (int i = 0; i < 15; i++) {
        [self createBerryAtLocation:[self randomLocationForBerryInCamp:self.greyCamp]];
    }
}

- (void)endGame
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"EndGame" object:nil userInfo:@{ @"date" : [NSDate date],
                                                                   @"score" : @(self.score),
                                                                   @"time" : @(- self.startTime.timeIntervalSinceNow)}];
}

#pragma mark Create Berries

- (AHBerries *)createBerryAtLocation:(CGPoint)location
{
    AHCamp *randomCamp = self.camps[1 + arc4random_uniform((u_int32_t) self.camps.count - 1)];
    return [self createBerryAtLocation:location withType:randomCamp.berryType];
}

- (AHBerries *)createBerryAtLocation:(CGPoint)location withType:(AHBerryType)type
{
    AHBerries *berry = [AHBerries spriteNodeWithBerryType:type];
    
    berry.position = location;
    berry.position = [self pointForBerry:berry inCamp:self.greyCamp];
    berry.lastPosition = self.position;
    
    //Start in minimized mode
    [berry setScale:0];
    
    [self.greyCamp addChild:berry];
    
    //Make berry appear, then animate up and down
    SKAction *group = [SKAction group:@[[SKAction scaleTo:1 duration:1], [SKAction repeatActionForever:[SKAction sequence:@[[SKAction rotateToAngle:M_PI/10 duration:.75], [SKAction rotateToAngle:-M_PI/10 duration:.75]]]]]];
    [berry runAction:group];
    
    [self.berryNodes addObject:berry];
    
    berry.zPosition = 2;
    return berry;
}

#pragma mark Score Bar

- (SKSpriteNode *)scoreBar
{
    if (!_scoreBar) {
        _scoreBar = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(self.size.width, kScoreBarheight)];
        _scoreBar.position = CGPointMake(self.size.width / 2,
                                         self.size.height - kScoreBarheight / 2);
        self.scoreBar.name = @"scoreBar";
    }
    return _scoreBar;
}

- (SKLabelNode *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [SKLabelNode labelNodeWithText:@"0"];
        _scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        _scoreLabel.fontName = @"TrebuchetMS-Bold";
        _scoreLabel.fontSize = 20;
        _scoreLabel.position = CGPointZero;
    }
    return _scoreLabel;
}

- (void)setScore:(NSUInteger)score
{
    self.scoreLabel.text = [NSString stringWithFormat:@"%i", score];
    _score = score;
}

- (SKLabelNode *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [SKLabelNode labelNodeWithText:@"0:00"];
        _timeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        _timeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        _timeLabel.fontName = @"TrebuchetMS-Bold";
        _timeLabel.fontSize = 20;
        _timeLabel.position = CGPointMake(- ((self.size.width / 2) - 15), 0);
    }
    return _timeLabel;
}

- (void)updateTimeLabel:(NSTimer *)timer
{
    NSTimeInterval elapsed = - self.startTime.timeIntervalSinceNow;
    int seconds = (int) elapsed % 60;
    int minutes = (elapsed - seconds) / 60;
    self.timeLabel.text = [NSString stringWithFormat:@"%i:%.2i", minutes, seconds];
}

#pragma mark Camps

- (NSArray *)camps
{
    if (!_camps) {
        switch (kDifficulty) {
            case AHDifficultyEasy:
            {
                CGFloat campHeight = (self.size.height - self.scoreBar.size.height) / 3;
                CGFloat campWidth = self.size.width;
                CGSize campSize = CGSizeMake(campWidth, campHeight);
                
                AHCamp *orange = [AHCamp spriteNodeWithBerryType:AHBerryTypeOrange size:campSize];
                orange.position = CGPointMake(self.size.width / 2,
                                               self.size.height - self.scoreBar.size.height - campHeight / 2);
                
                AHCamp *lemon = [AHCamp spriteNodeWithBerryType:AHBerryTypeLemon size:campSize];
                lemon.position = CGPointMake(self.size.width / 2,
                                                  self.size.height - self.scoreBar.size.height - 2 * campHeight - campHeight / 2);
                
                AHCamp *greyCamp = [AHCamp spriteNodeWithColor:[SKColor grayColor] size:campSize];
                greyCamp.position = CGPointMake(self.size.width / 2,
                                                self.size.height - self.scoreBar.size.height - campHeight - campHeight / 2);
                
                _camps = @[greyCamp, orange, lemon];
                break;
            }
            case AHDifficultyMedium:
            {
                CGFloat campHeight = (self.size.height - self.scoreBar.size.height) / 3;
                CGFloat smallCampWidth = self.size.width / 2;
                CGFloat bigCampWidth = self.size.width;
                CGSize smallCampSize = CGSizeMake(smallCampWidth, campHeight);
                CGSize bigCampSize = CGSizeMake(bigCampWidth, campHeight);
                
                AHCamp *strawberry = [AHCamp spriteNodeWithBerryType:AHBerryTypeStrawberry size:smallCampSize];
                strawberry.position = CGPointMake(smallCampWidth / 2,
                                                  self.size.height - self.scoreBar.size.height - campHeight / 2);
                
                AHCamp *lemon = [AHCamp spriteNodeWithBerryType:AHBerryTypeLemon size:smallCampSize];
                lemon.position = CGPointMake(smallCampWidth + smallCampWidth / 2,
                                             self.size.height - self.scoreBar.size.height - campHeight / 2);
                
                AHCamp *orange = [AHCamp spriteNodeWithBerryType:AHBerryTypeOrange size:bigCampSize];
                orange.position = CGPointMake(self.size.width / 2,
                                              self.size.height - self.scoreBar.size.height - 2 * campHeight - campHeight / 2);
                
                AHCamp *greyCamp = [AHCamp spriteNodeWithColor:[SKColor grayColor] size:bigCampSize];
                greyCamp.position = CGPointMake(self.size.width / 2,
                                                self.size.height - self.scoreBar.size.height - campHeight - campHeight / 2);
                
                _camps = @[greyCamp, strawberry, lemon, orange];
                break;
            }
            case AHDifficultyHard:
            {
                CGFloat campHeight = (self.size.height - self.scoreBar.size.height) / 3;
                CGFloat campWidth = self.size.width / 2;
                CGSize campSize = CGSizeMake(campWidth, campHeight);
                
                AHCamp *strawberry = [AHCamp spriteNodeWithBerryType:AHBerryTypeStrawberry size:campSize];
                strawberry.position = CGPointMake(campWidth / 2,
                                                  self.size.height - self.scoreBar.size.height - campHeight / 2);
                
                AHCamp *lemon = [AHCamp spriteNodeWithBerryType:AHBerryTypeLemon size:campSize];
                lemon.position = CGPointMake(campWidth + campWidth / 2,
                                             self.size.height - self.scoreBar.size.height - campHeight / 2);
                
                AHCamp *orange = [AHCamp spriteNodeWithBerryType:AHBerryTypeOrange size:campSize];
                orange.position = CGPointMake(campWidth / 2,
                                              self.size.height - self.scoreBar.size.height - 2 * campHeight - campHeight / 2);
                
                AHCamp *banana = [AHCamp spriteNodeWithBerryType:AHBerryTypeBanana size:campSize];
                banana.position = CGPointMake(campWidth + campWidth / 2,
                                              self.size.height - self.scoreBar.size.height - 2 * campHeight - campHeight / 2);
                
                AHCamp *greyCamp = [AHCamp spriteNodeWithColor:[SKColor grayColor] size:CGSizeMake(campWidth * 2, campHeight)];
                greyCamp.position = CGPointMake(self.size.width / 2,
                                                self.size.height - self.scoreBar.size.height - campHeight - campHeight / 2);
                
                _camps = @[greyCamp, strawberry, lemon, orange, banana];
            }
        }
    }
    return _camps;
}

- (AHCamp *)greyCamp
{
    return (AHCamp *) self.camps[0];
}

#pragma mark Random Methods

- (AHCamp *)berryIsInCamp:(AHBerries *)berry
{
    //Check all nodes under touch
    //If the node is a camp, return it
    //Otherwise return nil
    for (SKNode *node in [self nodesAtPoint:berry.position]) {
        if ([node isKindOfClass:[AHCamp class]]) {
            return (AHCamp *)node;
        }
    }
    return nil;
}

- (CGPoint)pointForBerry:(AHBerries *)berry inCamp:(AHCamp *)camp
{
    CGPoint newPosition = berry.position;
    if (berry.position.x - berry.size.width / 2 < - camp.size.width / 2) {
        newPosition.x = - camp.size.width / 2 + berry.size.width / 2;
    }
    if (berry.position.x + berry.size.width / 2 > camp.size.width / 2) {
        newPosition.x = camp.size.width / 2 - berry.size.width / 2;
    }
    if (berry.position.y - berry.size.height / 2 < - camp.size.height / 2) {
        newPosition.y = - camp.size.height / 2 + berry.size.height / 2;
    }
    if (berry.position.y + berry.size.height / 2 > camp.size.height / 2) {
        newPosition.y = camp.size.height / 2 - berry.size.height / 2;
    }
    return newPosition;
}

- (CGPoint)randomLocationForBerryInCamp:(AHCamp *)camp
{
    //Remove half the size to start at 0, then add a random number inside the size.
    CGFloat x = - camp.size.width / 2 + arc4random() % (int)(camp.size.width);
    CGFloat y = - camp.size.height / 2 + arc4random() % (int)(camp.size.height);
    return CGPointMake(x, y);
}

#pragma mark UITouch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *nodeAtTouch = [self nodeAtPoint:location];
    
    //Move berry
    if (!self.draggedBerry) {
        if ([nodeAtTouch isKindOfClass:[AHBerries class]]) {
            //Set draggedBerry
            AHBerries *touchedBerry = (AHBerries *) nodeAtTouch;
            
            //Make sure that the berry is not already sorted
            if (!touchedBerry.success) {
                self.draggedBerry = (AHBerries *) touchedBerry;
            
                //Remove from Grey Camp
                [self.draggedBerry removeFromParent];
                
                //Add berry to AHMainScene and set lastPosition for reset
                self.draggedBerry.lastPosition = [touch locationInNode:self.greyCamp];
                self.draggedBerry.position = location;
                [self addChild:self.draggedBerry];
            }
        } else if ([self nodeAtPoint:location] == self.greyCamp) {
            //Debug for creating berries
            [self createBerryAtLocation:[self convertPoint:location toNode:self.greyCamp]];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    //Check if we stopped touching a berry
    if ([[self nodeAtPoint:self.draggedBerry.position] isKindOfClass:[AHBerries class]]) {
        
        //Check if berry is in a camp
        AHCamp *destinationCamp = [self berryIsInCamp:self.draggedBerry];
        if (destinationCamp && (destinationCamp.berryType == self.draggedBerry.berryType || destinationCamp == self.greyCamp)) {
        
            //Remove from MainScene
            [self.draggedBerry removeFromParent];
            
            //Change location to in camp
            self.draggedBerry.position = [[touches anyObject] locationInNode:destinationCamp];
            self.draggedBerry.position = [self pointForBerry:self.draggedBerry inCamp:destinationCamp];
            
            self.draggedBerry.lastPosition = self.draggedBerry.position;
            
            //Add to Camp
            [destinationCamp addChild:self.draggedBerry];
            
            //Block moving if berry is on good camp
            if (destinationCamp.berryType == self.draggedBerry.berryType) {
                self.draggedBerry.success = YES;
                [self.draggedBerry removeAllActions];
                SKAction *disappear = [SKAction sequence:@[[SKAction group:@[[SKAction moveTo:CGPointZero duration:.5], [SKAction fadeOutWithDuration:.5]]], [SKAction removeFromParent]]];
                [self.draggedBerry runAction:disappear];
                self.score++;
            }
            
            self.draggedBerry = nil;
            
        } else if (destinationCamp.berryType != self.draggedBerry.berryType) {
            [self endGame];
        } else {
            //Cancel the event
            [self touchesCancelled:touches withEvent:event];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    if ([[self nodeAtPoint:self.draggedBerry.position] isKindOfClass:[AHBerries class]]) {
        
        //Same as above
        //No location changing
        //Using the berries lastPosition
        [self.draggedBerry removeFromParent];
        self.draggedBerry.position = self.draggedBerry.lastPosition;
        [self.greyCamp addChild:self.draggedBerry];
        self.draggedBerry = nil;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    //If we're moving a berry, set its position to our touch's location
    if (self.draggedBerry) {
        self.draggedBerry.position = location;
    }
}

@end
