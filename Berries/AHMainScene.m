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

CGFloat kSpacingBetweenCamps = 12.0;
CGFloat kBerrySize = 15.0;
CGFloat kScoreBarheight = 55.0;
AHDifficulty kDifficulty = AHDifficultyHard;

@interface AHMainScene ()
@property (nonatomic, strong) NSMutableArray *berryNodes;
@property (nonatomic, weak) AHBerries *draggedBerry;
@property (nonatomic, strong) SKSpriteNode *scoreBar;
@property (nonatomic, strong) NSArray *camps;
@property (nonatomic, strong) AHCamp *blueCamp;
@property (nonatomic, strong) AHCamp *redCamp;
@property (nonatomic, strong) AHCamp *greyCamp;
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
        _scoreBar = [[SKSpriteNode alloc] initWithColor:[SKColor greenColor] size:CGSizeMake(self.size.width, kScoreBarheight)];
        [_scoreBar setPosition:CGPointMake(self.size.width / 2,
                                               self.size.height - kScoreBarheight / 2)];
        self.scoreBar.name = @"scoreBar";
    }
    return _scoreBar;
}

- (NSArray *)camps
{
    if (!_camps) {
        CGFloat campHeight;
        CGFloat campWidth;
        AHCamp *greyCamp;
        
        if (kDifficulty == AHDifficultyEasy) {
            campHeight = (self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps * 4) / 3;
            campWidth = self.size.width - 2 * kSpacingBetweenCamps;
            
            AHCamp *topCamp = [[AHCamp alloc] initWithColor:[SKColor blueColor] size:CGSizeMake(campWidth, campHeight)];
            topCamp.position = CGPointMake(self.size.width / 2,
                                             self.size.height - self.scoreBar.size.height- kSpacingBetweenCamps - campHeight / 2);
            
            AHCamp *bottomCamp = [[AHCamp alloc] initWithColor:[SKColor redColor] size:CGSizeMake(campWidth, campHeight)];
            bottomCamp.position = CGPointMake(self.size.width / 2,
                                              self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - 2 * (kSpacingBetweenCamps + campHeight ) - campHeight / 2);
            
            greyCamp = [[AHCamp alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(campWidth, campHeight)];
            greyCamp.position = CGPointMake(self.size.width / 2,
                                            self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - (kSpacingBetweenCamps + campHeight ) - campHeight / 2);
            
            return @[greyCamp, topCamp, bottomCamp];
        }
        
        campHeight = (self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps * 4) / 3;
        campWidth = (self.size.width - 3 * kSpacingBetweenCamps) / 2;
        
        AHCamp *topLeftCamp = [[AHCamp alloc] initWithColor:[SKColor blueColor] size:CGSizeMake(campWidth, campHeight)];
        topLeftCamp.position = CGPointMake(kSpacingBetweenCamps + campWidth / 2,
                                           self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - campHeight / 2);
        
        AHCamp *topRightCamp = [[AHCamp alloc] initWithColor:[SKColor redColor] size:CGSizeMake(campWidth, campHeight)];
        topRightCamp.position = CGPointMake(kSpacingBetweenCamps + campWidth + kSpacingBetweenCamps + campWidth / 2,
                                            self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - campHeight / 2);
        
        AHCamp *bottomLeftCamp = [[AHCamp alloc] initWithColor:[SKColor orangeColor] size:CGSizeMake(campWidth, campHeight)];
        bottomLeftCamp.position = CGPointMake(kSpacingBetweenCamps + campWidth / 2,
                                              self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - 2 * (kSpacingBetweenCamps + campHeight) - campHeight / 2);
        
        AHCamp *bottomRightCamp = [[AHCamp alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(campWidth, campHeight)];
        bottomRightCamp.position = CGPointMake(kSpacingBetweenCamps + campWidth + kSpacingBetweenCamps + campWidth / 2,
                                               self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - 2 * (kSpacingBetweenCamps + campHeight) - campHeight / 2);
        if (kDifficulty == AHDifficultyMedium) {
            greyCamp = [[AHCamp alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(campWidth * 2 + kSpacingBetweenCamps, campHeight)];
            greyCamp.position = CGPointMake(self.size.width / 2,
                                            self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - (kSpacingBetweenCamps + campHeight) - campHeight / 2);
            
            return @[greyCamp, topLeftCamp, topRightCamp, bottomLeftCamp, bottomRightCamp];
        }
        
        AHCamp *leftCamp;
        AHCamp *rightCamp;
                
        if (kDifficulty == AHDifficultyHard) {
            CGFloat greyCampWidth = (self.size.width - 4 * kSpacingBetweenCamps) / 3;
            leftCamp = [[AHCamp alloc] initWithColor:[SKColor whiteColor] size:CGSizeMake(greyCampWidth, campHeight)];
            leftCamp.position = CGPointMake(kSpacingBetweenCamps + greyCampWidth / 2,
                                            self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - (kSpacingBetweenCamps + campHeight) - campHeight / 2);
            
            rightCamp = [[AHCamp alloc] initWithColor:[SKColor cyanColor] size:CGSizeMake(greyCampWidth, campHeight)];
            rightCamp.position = CGPointMake(kSpacingBetweenCamps + 2 * (greyCampWidth + kSpacingBetweenCamps) + greyCampWidth / 2,
                                             self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - (kSpacingBetweenCamps + campHeight) - campHeight / 2);
            
            greyCamp = [[AHCamp alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(greyCampWidth, campHeight)];
            greyCamp.position = CGPointMake(kSpacingBetweenCamps + (greyCampWidth + kSpacingBetweenCamps) + greyCampWidth / 2,
                                            self.size.height - self.scoreBar.size.height - kSpacingBetweenCamps - (kSpacingBetweenCamps + campHeight) - campHeight / 2);
            
            return @[greyCamp, topLeftCamp, topRightCamp, bottomLeftCamp, bottomRightCamp, leftCamp, rightCamp];
        }
    }
    return _camps;
}

- (void)createScene
{
    [self addChild:self.scoreBar];
    for (AHCamp *camp in self.camps) {
        [self addChild:camp];
    }
    
    [self createBerryAtLocation:[self randomLocationForBerry]];
    [self createBerryAtLocation:[self randomLocationForBerry]];
    [self createBerryAtLocation:[self randomLocationForBerry]];
    [self createBerryAtLocation:[self randomLocationForBerry]];
}

- (CGPoint)randomLocationForBerry
{
    CGFloat x = - self.greyCamp.size.width / 2 + kBerrySize / 2 + arc4random() % (int)(self.greyCamp.size.width - kBerrySize);
    CGFloat y = - self.greyCamp.size.height / 2 + kBerrySize / 2 + arc4random() % (int)(self.greyCamp.size.height - kBerrySize);
    return CGPointMake(x, y);
}

- (AHBerries *)createBerryAtLocation:(CGPoint)location
{
    CGSize berrySize = CGSizeMake(kBerrySize, kBerrySize);
    
    SKPhysicsBody *berryPhysics = [SKPhysicsBody bodyWithRectangleOfSize:berrySize];
    berryPhysics.dynamic = YES;
    berryPhysics.affectedByGravity = NO;
    berryPhysics.mass = 0;
    
    AHBerries *berry = [[AHBerries alloc] initWithColor:[SKColor purpleColor] size:berrySize];
    [berry setPosition:location];
    berry.lastPosition = location;
    berry.physicsBody = berryPhysics;
    berry.name = @"berry";
    
    [self.greyCamp addChild:berry];
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
    }
}

- (AHCamp *)berryIsInCamp:(AHBerries *)berry
{
    //Check all nodes under touch
    //If the node is a camp, return it
    //Otherwise return nil
    for (SKNode *node in [self nodesAtPoint:berry.position]) {
        if ([node isKindOfClass:[AHCamp class]]) {
            NSLog(@"%@", node.name);
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
        if (destinationCamp) {
            
            //Remove from MainScene
            [self.draggedBerry removeFromParent];
            
            //Change location to in camp
            CGPoint location = [[touches anyObject] locationInNode:destinationCamp];
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
