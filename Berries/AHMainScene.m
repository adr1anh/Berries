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

@interface AHMainScene ()
@property (nonatomic, strong) NSMutableArray *berryNodes;
@property (nonatomic, weak) AHBerries *draggedBerry;
@property (nonatomic, strong) SKSpriteNode *scoreBar;
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

- (void)createScene
{
    CGFloat barHeight = kScoreBarheight;
    CGFloat barWidth = self.size.width;
    CGFloat campHeight = (self.size.height - barHeight - kSpacingBetweenCamps * 4) / 3;
    CGFloat campWidth = self.size.width - 2 * kSpacingBetweenCamps;
    
    self.scoreBar = [[SKSpriteNode alloc] initWithColor:[SKColor greenColor] size:CGSizeMake(barWidth, barHeight)];
    [self.scoreBar setPosition:CGPointMake(self.size.width / 2,
                                           self.size.height - barHeight / 2)];
    self.scoreBar.name = @"scoreBar";
    [self addChild:self.scoreBar];
    
    self.blueCamp = [[AHCamp alloc] initWithColor:[SKColor blueColor] size:CGSizeMake(campWidth, campHeight)];
    [self.blueCamp setPosition:CGPointMake(self.size.width / 2,
                                           self.size.height - barHeight - kSpacingBetweenCamps - campHeight / 2)];
    self.blueCamp.name = @"blueCamp";
    [self addChild:self.blueCamp];
    
    self.redCamp = [[AHCamp alloc] initWithColor:[SKColor redColor] size:CGSizeMake(campWidth, campHeight)];
    [self.redCamp setPosition:CGPointMake(self.size.width / 2,
                                          self.size.height - barHeight - kSpacingBetweenCamps * 3 - campHeight * 2 - campHeight / 2)];
    self.redCamp.name = @"redCamp";
    [self addChild:self.redCamp];
    
    self.greyCamp = [[AHCamp alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(campWidth, campHeight)];
    [self.greyCamp setPosition:CGPointMake(self.size.width / 2,
                                           self.size.height - barHeight - kSpacingBetweenCamps * 2 - campHeight - campHeight / 2)];
    self.greyCamp.name = @"greyCamp";
    [self addChild:self.greyCamp];
    
    SKPhysicsBody *greyPhysics = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.greyCamp.frame];
    greyPhysics.affectedByGravity = NO;
    greyPhysics.dynamic = YES;
    self.greyCamp.physicsBody = greyPhysics;
    
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
    
    if ([nodeAtTouch isKindOfClass:[AHBerries class]]) {
        self.draggedBerry = (AHBerries *) nodeAtTouch;
        [self.draggedBerry removeFromParent];
        self.draggedBerry.lastPosition = [touch locationInNode:self.greyCamp];
        self.draggedBerry.position = location;
        [self addChild:self.draggedBerry];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if ([[self nodeAtPoint:self.draggedBerry.position] isKindOfClass:[AHBerries class]]) {
//        NSLog(@"%@", [self nodeAtPoint:self.draggedBerry.position]);
        for (SKNode* node in [self nodesAtPoint:self.draggedBerry.position]) {
            if ([node isKindOfClass:[AHCamp class]]) {
                AHCamp *destinationCamp = (AHCamp *) node;
                [self.draggedBerry removeFromParent];
                self.draggedBerry.position = CGPointMake(self.draggedBerry.position.x - destinationCamp.frame.origin.x,
                                                         self.draggedBerry.position.y - destinationCamp.frame.origin.y);
            }
        }
        [self.draggedBerry removeFromParent];
        self.draggedBerry.position = self.draggedBerry.lastPosition;
        [self.greyCamp addChild:self.draggedBerry];
        self.draggedBerry = nil;
    }
}

//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesEnded:touches withEvent:event];
//    
//    for (SKNode *nodeAtPoint in [self nodesAtPoint:self.draggedBerry.position]) {
//        if ([nodeAtPoint isKindOfClass:[AHCamp class]]) {
//            AHCamp *destinationCamp = (AHCamp *) nodeAtPoint;
//            [self.draggedBerry removeFromParent];
//            self.draggedBerry.position = CGPointMake(self.draggedBerry.position.x - destinationCamp.position.x + destinationCamp.size.width / 2,
//                                                     self.draggedBerry.position.y - destinationCamp.position.y + destinationCamp.size.height / 2);
//            [destinationCamp addChild:self.draggedBerry];
//        } else {
//            [self.draggedBerry removeFromParent];
//            self.draggedBerry.position = self.draggedBerryOrigin;
//            [self.greyCamp addChild:self.draggedBerry];
//        }
//    }
//}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    if (self.draggedBerry) {
        self.draggedBerry.position = location;
    }
}

@end
