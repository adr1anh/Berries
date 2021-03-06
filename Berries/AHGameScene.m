//
//  AHGameScene.m
//  Berries
//
//  Created by Adrian Hamelink on 10/02/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHGameScene.h"

@interface AHGameScene ()

@property (nonatomic, weak) AHBerrySprite *draggedBerry;
@property (nonatomic, strong) NSArray *berryCamps;
@property (nonatomic, strong) AHGame *game;

@end

@implementation AHGameScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.name = @"GameScene";
        [self createScene];
    }
    return self;
}

//Scene initialization
- (void)createScene
{
    
    //listen for notifications
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(spawnBerry:) name:@"spawnBerry" object:nil];
    [center addObserver:self selector:@selector(endGame:) name:@"endGame" object:nil];
    
    //set anchor point to lower left
    self.anchorPoint = CGPointMake(0, 0);
    
    //clear background to show the parent's background
    self.backgroundColor = [SKColor clearColor];
    
    //Add all camps to the scene
    for (AHCampSprite *berryCamp in self.berryCamps) {
        berryCamp.zPosition = 1;
        [self addChild:berryCamp];
    }
    
    [self showIntro];
}

- (void)showIntro
{
    SKSpriteNode *darkBackground = [SKSpriteNode spriteNodeWithColor:[SKColor darkGrayColor] size:self.size];
    darkBackground.anchorPoint = CGPointMake(0, 0);
    darkBackground.position = CGPointMake(0, 0);
    darkBackground.name = @"darkBackground";
    darkBackground.zPosition = 2;
    darkBackground.alpha = 0;

    [self addChild:darkBackground];
    
    AHCampSprite *aCamp = (AHCampSprite *) self.berryCamps[0];
    AHCampSprite *bCamp = (AHCampSprite *) self.berryCamps[1];
    
    AHBerrySprite *aBerry = [AHBerrySprite spriteNodeWithBerryType:aCamp.berryType];
    AHBerrySprite *bBerry = [AHBerrySprite spriteNodeWithBerryType:bCamp.berryType];
    
    aBerry.alpha = 0;
    bBerry.alpha = 0;
    
    aBerry.scale *= 1.25;
    bBerry.scale *= 1.25;
    
    aBerry.position = CGPointMake(CGRectGetMidX(aCamp.frame),
                                  self.frame.size.height / 2);
    bBerry.position = CGPointMake(CGRectGetMidX(bCamp.frame),
                                  self.frame.size.height / 2);
    
    aBerry.name = @"aBerry";
    bBerry.name = @"bBerry";
    
    [aBerry setTexture:[aBerry.texture textureByApplyingCIFilter:[CIFilter filterWithName:@"CIPhotoEffectNoir"]]];
    [bBerry setTexture:[bBerry.texture textureByApplyingCIFilter:[CIFilter filterWithName:@"CIPhotoEffectNoir"]]];
    
    aBerry.zPosition = 3;
    bBerry.zPosition = 3;
    
    aBerry.dragable = NO;
    bBerry.dragable = NO;
    
    [self addChild:aBerry];
    [self addChild:bBerry];
    
    SKAction *aAction = [SKAction sequence:@[[AHBerrySprite appear],
                                             [SKAction waitForDuration:.25],
                                             [AHBerrySprite disappearToPoint:CGPointMake(CGRectGetMidX(aCamp.frame),
                                                                                         CGRectGetMaxY(aCamp.frame))]]];
    SKAction *bAction = [SKAction sequence:@[[AHBerrySprite appear],
                                             [SKAction waitForDuration:.25],
                                             [AHBerrySprite disappearToPoint:CGPointMake(CGRectGetMidX(bCamp.frame),
                                                                                         CGRectGetMaxY(bCamp.frame))]]];
    
    [self runAction:[SKAction sequence:@[[SKAction runAction:[SKAction fadeAlphaTo:.5 duration:1] onChildWithName:@"darkBackground"],
                                         [SKAction runAction:aAction onChildWithName:@"aBerry"],
                                         [SKAction waitForDuration:1],
                                         [SKAction runAction:bAction onChildWithName:@"bBerry"],
                                         [SKAction runAction:[SKAction fadeOutWithDuration:1] onChildWithName:@"darkBackground"],
                                         [SKAction waitForDuration:1],
                                         [SKAction runBlock:^(void){self.game = [[AHGame alloc] init];}]]]];
    
    
}

//Quite self explanitory
- (void)endGame:(NSNotification *)notification
{
    //remove listener
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //make all berries disappear
    for (SKSpriteNode *childNode in [self children]) {
        if ([childNode isKindOfClass:[AHBerrySprite class]]) {
            AHBerrySprite *remainingBerry = (AHBerrySprite *)childNode;
            if (![remainingBerry actionForKey:kBerryActionDisappear] && ![remainingBerry actionForKey:kBerryActionExplode]) {
                [remainingBerry runAction:[AHBerrySprite disappear]
                                  withKey:kBerryActionDisappear];
            }
        }
    }
}

#pragma mark Notifications

//berry creation method
- (void)spawnBerry:(NSNotification *)notification
{
    //static variable to make the berries appear on top of the last one
    
    //get one of the two camps and use it's type for the berry
    AHCampSprite *randomCamp = (AHCampSprite *) self.berryCamps[arc4random_uniform((u_int32_t) self.berryCamps.count)];
    AHBerrySprite *berry = [AHBerrySprite spriteNodeWithBerryType:randomCamp.berryType];
    
    //increment the static zPosition
    berry.zPosition = 1;
    
    //make sure the berry only spawns in the zone without the carpets
    CGPoint berryPosition;
    
    //if the position we create already contains a berry, retry
    do {
        CGFloat campSize = self.frame.size.width / 2;
        CGFloat spawnWidth = self.size.width - berry.size.width;
        CGFloat spawnHeight = self.size.height - campSize - berry.size.height;
        
        CGFloat x = berry.size.width / 2 + arc4random_uniform((u_int32_t) spawnWidth);
        CGFloat y = berry.size.height / 2 + arc4random_uniform((u_int32_t) spawnHeight);
        
        berryPosition = CGPointMake(x, y);
    } while ([self nodeAtPoint:berryPosition ofClass:[AHBerrySprite class]]);
    
    //start it hidden
    berry.alpha = 0;
    berry.position = berryPosition;
    
    [self addChild:berry];
    
    //animate it
    [berry runAction:[SKAction sequence:@[[AHBerrySprite appear],
                                          [SKAction performSelector:@selector(startRotting) onTarget:berry]]]
             withKey:kBerryActionAppear];
}

#pragma mark Camps

//array with both camps, lazy instantiation
- (NSArray *)berryCamps
{
    if (!_berryCamps) {
        
        //margin between the camps
        CGFloat spacing = 15;
        CGFloat campSize = (self.size.width - 3 * spacing) / 2;
        
        //get both different random types
        AHBerryType firstFruitType = arc4random_uniform(5);
        AHBerryType secondFruitType;
        do {
            secondFruitType = arc4random_uniform(5);
        } while (secondFruitType == firstFruitType);
        
        //create first camp
        AHCampSprite *firstCamp = [AHCampSprite berryCampWithType:firstFruitType size:campSize];
        firstCamp.zPosition = 0;
        firstCamp.position = CGPointMake(spacing,
                                         self.size.height - spacing);
        
        //second
        AHCampSprite *secondCamp = [AHCampSprite berryCampWithType:secondFruitType size:campSize];
        secondCamp.zPosition = 0;
        secondCamp.position = CGPointMake(firstCamp.size.width + 2 * spacing,
                                          self.size.height - spacing);
        _berryCamps = @[firstCamp, secondCamp];
    }
    return _berryCamps;
}

#pragma mark Random Methods

//find the node of a certain class, at the point specified
- (SKNode *)nodeAtPoint:(CGPoint)point ofClass:(Class)class
{
    //go through all nodes at point
    for (SKNode *node in [self nodesAtPoint:point]) {
        
        //check if the class matches and return it
        if ([node isMemberOfClass:class])
            return (SKNode *)node;
    }
    
    //if nothing fits, return nil
    return nil;
}

#pragma mark UITouch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    //make sure another berry isn't being moved
    if (!self.draggedBerry) {
        
        //find the berry at our touch location
        AHBerrySprite *touchedBerry = (AHBerrySprite *) [self nodeAtPoint:location ofClass:[AHBerrySprite class]];
        
        //if there is one
        if (touchedBerry) {
            
            if (touchedBerry.dragable) {
                //make sure it isnt't already saved, and make it out dragged berry
                if (touchedBerry.rottingStage != AHRottingStageSaved)
                    self.draggedBerry = touchedBerry;
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    if (self.draggedBerry) {
        
        BOOL intersectsSame = NO;
        BOOL intersectsOther = NO;
        AHCampSprite *destination;
        
        //check if intersects with good camp
        for (AHCampSprite *destinationCamp in self.berryCamps) {
            
            //only check the image
            if ([self.draggedBerry.imageSprite intersectsNode:destinationCamp]) {
                
                if (destinationCamp.berryType == self.draggedBerry.berryType) {
                    destination = destinationCamp;
                    intersectsSame = YES;
                    break;
                }
                else {
                    intersectsOther = YES;
                }
            }
        }
        
        if (intersectsSame) {
            //save it, make it disappear and add a point
            self.draggedBerry.rottingStage = AHRottingStageSaved;
            CGPoint center = CGPointMake(CGRectGetMidX(destination.frame),
                                         CGRectGetMidY(destination.frame));
            [self.draggedBerry removeActionForKey:kBerryActionJitter];
            [self.draggedBerry runAction:[AHBerrySprite disappearToPoint:center]
                                 withKey:kBerryActionDisappear];
            [self.game addPoint];
        }
        
        if (!intersectsSame && intersectsOther) {
            SKAction *lose = [SKAction sequence:@[[AHBerrySprite explode],
                                                  [SKAction runBlock:^(void){[[NSNotificationCenter defaultCenter] postNotificationName:@"gameLost" object:nil];}]]];
            [self.draggedBerry runAction:lose
                                 withKey:kBerryActionExplode];
            
        }
    }
    
    //reset the dragged berry
    self.draggedBerry = nil;
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
