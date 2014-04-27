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

CGFloat kSpacingBetweenCamps = 15.0;
CGFloat kBerrySize = 33.0;
CGFloat kScoreBarheight = 44.0;
AHDifficulty kDifficulty = AHDifficultyMedium;

@interface AHMainScene ()
@property (nonatomic, strong) NSMutableArray *berryNodes;
@property (nonatomic, weak) AHBerries *draggedBerry;
@property (nonatomic, strong) SKSpriteNode *scoreBar;
@property (nonatomic, strong) NSArray *camps;
@property (nonatomic, readonly, strong) AHCamp *greyCamp;

@end

@implementation AHMainScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [self createScene];
    }
    return self;
}

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

- (NSArray *)camps
{
    if (!_camps) {
        switch (kDifficulty) {
            case AHDifficultyEasy:
            {
                CGFloat campHeight = (self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps * 4) / 3;
                CGFloat campWidth = self.size.width - 2 * kSpacingBetweenCamps;
                CGSize campSize = CGSizeMake(campWidth, campHeight);
                
                AHCamp *apple = [AHCamp spriteNodeWithBerryType:AHBerryTypeApple size:campSize];
                apple.position = CGPointMake(self.size.width / 2,
                                               self.size.height - self.scoreBar.size.height- kSpacingBetweenCamps - campHeight / 2);
                
                AHCamp *lemon = [AHCamp spriteNodeWithBerryType:AHBerryTypeLemon size:campSize];
                lemon.position = CGPointMake(self.size.width / 2,
                                                  self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - 2 * (kSpacingBetweenCamps + campHeight ) - campHeight / 2);
                
                AHCamp *greyCamp = [AHCamp spriteNodeWithColor:[SKColor grayColor] size:campSize];
                greyCamp.position = CGPointMake(self.size.width / 2,
                                                self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - (kSpacingBetweenCamps + campHeight ) - campHeight / 2);
                
                _camps = @[greyCamp, apple, lemon];
                break;
            }
            case AHDifficultyMedium:
            {
                CGFloat campHeight = (self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps * 4) / 3;
                CGFloat smallCampWidth = (self.size.width - 3 * kSpacingBetweenCamps) / 2;
                CGFloat bigCampWidth = self.size.width - 2 * kSpacingBetweenCamps;
                CGSize smallCampSize = CGSizeMake(smallCampWidth, campHeight);
                CGSize bigCampSize = CGSizeMake(bigCampWidth, campHeight);
                
                AHCamp *apple = [AHCamp spriteNodeWithBerryType:AHBerryTypeApple size:smallCampSize];
                apple.position = CGPointMake(kSpacingBetweenCamps + smallCampWidth / 2,
                                                   self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - campHeight / 2);
                
                AHCamp *lemon = [AHCamp spriteNodeWithBerryType:AHBerryTypeLemon size:smallCampSize];
                lemon.position = CGPointMake(kSpacingBetweenCamps + smallCampWidth + kSpacingBetweenCamps + smallCampWidth / 2,
                                                    self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - campHeight / 2);
                
                AHCamp *orange = [AHCamp spriteNodeWithBerryType:AHBerryTypeOrange size:smallCampSize];
                orange.position = CGPointMake(self.size.width / 2,
                                              self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - 2 * (kSpacingBetweenCamps + campHeight) - campHeight / 2);
                
                AHCamp *greyCamp = [AHCamp spriteNodeWithColor:[SKColor grayColor] size:bigCampSize];
                greyCamp.position = CGPointMake(self.size.width / 2,
                                                self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - (kSpacingBetweenCamps + campHeight) - campHeight / 2);
                
                _camps = @[greyCamp, apple, lemon, orange];
                break;
            }
            case AHDifficultyHard:
            {
                CGFloat campHeight = (self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps * 4) / 3;
                CGFloat campWidth = (self.size.width - 3 * kSpacingBetweenCamps) / 2;
                CGSize campSize = CGSizeMake(campWidth, campHeight);
                
                AHCamp *apple = [AHCamp spriteNodeWithBerryType:AHBerryTypeApple size:campSize];
                apple.position = CGPointMake(kSpacingBetweenCamps + campWidth / 2,
                                                   self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - campHeight / 2);
                
                AHCamp *lemon = [AHCamp spriteNodeWithBerryType:AHBerryTypeLemon size:campSize];
                lemon.position = CGPointMake(kSpacingBetweenCamps + campWidth + kSpacingBetweenCamps + campWidth / 2,
                                                    self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - campHeight / 2);
                
                AHCamp *orange = [AHCamp spriteNodeWithBerryType:AHBerryTypeOrange size:campSize];
                orange.position = CGPointMake(kSpacingBetweenCamps + campWidth / 2,
                                                      self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - 2 * (kSpacingBetweenCamps + campHeight) - campHeight / 2);
                
                AHCamp *cherry = [AHCamp spriteNodeWithBerryType:AHBerryTypeCherry size:campSize];
                cherry.position = CGPointMake(kSpacingBetweenCamps + campWidth + kSpacingBetweenCamps + campWidth / 2,
                                                       self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - 2 * (kSpacingBetweenCamps + campHeight) - campHeight / 2);
                
                AHCamp *greyCamp = [AHCamp spriteNodeWithColor:[SKColor grayColor] size:CGSizeMake(campWidth * 2 + kSpacingBetweenCamps, campHeight)];
                greyCamp.position = CGPointMake(self.size.width / 2,
                                                self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - (kSpacingBetweenCamps + campHeight) - campHeight / 2);
                
                _camps = @[greyCamp, apple, lemon, orange, cherry];
            }
        }
    }
    return _camps;
}

- (AHCamp *)greyCamp
{
    return (AHCamp *) self.camps[0];
}

- (void)createScene
{
    [self addChild:self.scoreBar];
    for (AHCamp *camp in self.camps) {
        [self addChild:camp];
    }
    for (int i = 0; i < 10; i++) {
        [self createBerryAtLocation:[self randomLocationForBerryInCamp:self.greyCamp]];
    }
}

- (CGPoint)bestLocationForBerry:(CGPoint)originalPoint inCamp:(AHCamp *)camp
{
    CGPoint newPoint = originalPoint;
    
    if (originalPoint.x - kBerrySize / 2 < - camp.size.width / 2) {
        newPoint.x = - camp.size.width / 2 + kBerrySize / 2;
    }
    if (originalPoint.x + kBerrySize / 2 > camp.size.width / 2) {
        newPoint.x = camp.size.width / 2 - kBerrySize / 2;
    }
    if (originalPoint.y - kBerrySize / 2 < - camp.size.height / 2) {
        newPoint.y = - camp.size.height / 2 + kBerrySize / 2;
    }
    if (originalPoint.y + kBerrySize / 2 > camp.size.height / 2) {
        newPoint.y = camp.size.height / 2 - kBerrySize / 2;
    }
    return newPoint;
}

- (CGPoint)randomLocationForBerryInCamp:(AHCamp *)camp
{
    CGFloat x = - camp.size.width / 2 + arc4random() % (int)(camp.size.width);
    CGFloat y = - camp.size.height / 2 + arc4random() % (int)(camp.size.height);
    return [self bestLocationForBerry:CGPointMake(x, y) inCamp:camp];
}

- (AHBerries *)createBerryAtLocation:(CGPoint)location
{
    AHCamp *randomCamp = self.camps[1 + arc4random_uniform((u_int32_t) self.camps.count - 1)];
    return [self createBerryAtLocation:location withType:randomCamp.berryType];
}

- (AHBerries *)createBerryAtLocation:(CGPoint)location withType:(AHBerryType)type
{
//    CGSize berrySize = CGSizeMake(kBerrySize, kBerrySize);
    
    AHBerries *berry = [AHBerries spriteNodeWithBerryType:type];
    
    berry.position = location;
    berry.lastPosition = location;
//    [berry setScale:0];
    
    [self.greyCamp addChild:berry];
    
//    SKAction *sequence = [SKAction sequence:@[[SKAction scaleTo:1 duration:1], [SKAction repeatActionForever:[SKAction sequence:@[[SKAction moveByX:0 y:-5 duration:1], [SKAction moveByX:0 y:5 duration:1]]]]]];
//    [berry runAction:sequence];
    
    [self.berryNodes addObject:berry];
    return berry;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *nodeAtTouch = [self nodeAtPoint:location];
    
    //Move berry
    if ([nodeAtTouch isKindOfClass:[AHBerries class]]) {
        
        //Set draggedBerry
        self.draggedBerry = (AHBerries *) nodeAtTouch;
        
        //Remove from Grey Camp
        [self.draggedBerry removeFromParent];
        
        //Add berry to AHMainScene and set lastPosition for reset
        self.draggedBerry.lastPosition = [touch locationInNode:self.greyCamp];
        self.draggedBerry.position = location;
        [self addChild:self.draggedBerry];
    } else if ([self nodeAtPoint:location] == self.greyCamp) {
        [self createBerryAtLocation:[self convertPoint:location toNode:self.greyCamp]];
    }
}

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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    //Check if we stopped touching a berry
    if ([[self nodeAtPoint:self.draggedBerry.position] isKindOfClass:[AHBerries class]]) {
        
        //Check if berry is in a camp
        AHCamp *destinationCamp = [self berryIsInCamp:self.draggedBerry];
        if (destinationCamp && ([destinationCamp.color isEqual:self.draggedBerry.color] || destinationCamp == self.greyCamp)) {
        
            //Remove from MainScene
            [self.draggedBerry removeFromParent];
            
            //Change location to in camp
            CGPoint location = [self bestLocationForBerry:[[touches anyObject] locationInNode:destinationCamp] inCamp: destinationCamp];
            self.draggedBerry.position = location;
            self.draggedBerry.lastPosition = location;
            
            //Add to Camp
            [destinationCamp addChild:self.draggedBerry];
            
            //Reset dragged berry
            self.draggedBerry = nil;
            
        } else {
            //Same as above
            //No location changing
            //Using the berries lastPosition

            [self.draggedBerry removeFromParent];
            self.draggedBerry.position = self.draggedBerry.lastPosition;
            [self.greyCamp addChild:self.draggedBerry];
            self.draggedBerry = nil;
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    //Same code as touchesCancelled:withEvent:
    if ([[self nodeAtPoint:self.draggedBerry.position] isKindOfClass:[AHBerries class]]) {
        
        AHCamp *destinationCamp = [self berryIsInCamp:self.draggedBerry];
        if (destinationCamp) {
            
            [self.draggedBerry removeFromParent];
            
            UITouch *touch = [touches anyObject];
            CGPoint location = [touch locationInNode:destinationCamp];
            self.draggedBerry.position = location;
            
            self.draggedBerry.lastPosition = location;
            
            [destinationCamp addChild:self.draggedBerry];
            self.draggedBerry = nil;
            
        } else {
            
            [self.draggedBerry removeFromParent];
            self.draggedBerry.position = self.draggedBerry.lastPosition;
            [self.greyCamp addChild:self.draggedBerry];
            self.draggedBerry = nil;
        }
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
