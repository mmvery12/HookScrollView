//
//  Mash.m
//  Demo4
//
//  Created by JD on 2017/6/19.
//  Copyright © 2017年 LYC. All rights reserved.
//

#import "Mash.h"

#pragma mark -
@implementation CellContainer
@end
#pragma mark -
@implementation Range
@end
#pragma mark -

@interface SubMash ()
//@property (nonatomic,assign)CGFloat originY;
@property (nonatomic,strong)Range *tempRange;
@end
@implementation SubMash

-(instancetype)init
{
    if (self = [super init]) {
        _insert = UIEdgeInsetsZero;
        _animate = SubMashRowAnimationNone;
        _loaded = NeedLoad;
    }
    return self;
}
-(NSTimeInterval)animateTimeInterval
{
    return self.container.layer.timeOffset;
}
-(Range *)tempRange
{
    if (!_tempRange) {
        _tempRange = [Range new];
    }
    return _tempRange;
}

-(Range *)estimatedRange
{
    if (!self.estimatedRange) {
        self.estimatedRange = [Range new];
    }
    
    return self.estimatedRange;
}
-(CGFloat)setMashRangeWithBotm:(CGFloat)botm
{
    CGFloat top = botm + self.insert.top;
    CGFloat bot = self.range.topline + self.height;
    if (self.range.topline!=top || self.range.bottomline!=bot) {
        self.tempRange.topline = self.range.topline;
        self.tempRange.bottomline = self.range.bottomline;
    }
    self.range.topline = botm + self.insert.top;
    self.range.bottomline = self.range.topline + self.height;
    
    return self.range.bottomline + self.insert.bottom;
}

-(CellContainer *)container
{
    if (!_container) {
        _container = [CellContainer new];
    }
    return _container;
}
-(Range *)range
{
    if (!_range) {
        _range = [Range new];
    }
    return _range;
}

#pragma mark -
-(void)animationFadeFrome:(NSInteger)frome to:(NSInteger)to
{
    self.animating = YES;
    CABasicAnimation *anio = [CABasicAnimation defaultValueForKey:@"alpha"];
    anio.removedOnCompletion = NO;
    anio.fillMode = kCAFillModeForwards;
    anio.duration = ANIMATE_TIME;
    anio.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anio.fromValue = [NSNumber numberWithFloat:frome];
    anio.toValue = [NSNumber numberWithFloat:to];
    anio.delegate = self;
    [self.container.layer addAnimation:anio forKey:ANIMATE_NAME];
//    [self resumeLayer];
}

-(void)animationRightFrome:(CATransform3D)frome to:(CATransform3D)to
{
    self.animating = YES;
    CABasicAnimation *anio = [CABasicAnimation defaultValueForKey:@"transform"];
    anio.removedOnCompletion = NO;
    anio.duration = ANIMATE_TIME;
    anio.fillMode = kCAFillModeForwards;
    anio.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anio.fromValue = [NSValue valueWithCATransform3D:frome];
    anio.toValue = [NSValue valueWithCATransform3D:to];
    anio.delegate = self;
    [self.container.layer addAnimation:anio forKey:ANIMATE_NAME];
//    [self resumeLayer];
}

-(void)animationLeftFrome:(CATransform3D)frome to:(CATransform3D)to
{
    self.animating = YES;
    CABasicAnimation *anio = [CABasicAnimation defaultValueForKey:@"transform"];
    anio.removedOnCompletion = NO;
    anio.duration = ANIMATE_TIME;
    anio.fillMode = kCAFillModeForwards;
    anio.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anio.fromValue = [NSValue valueWithCATransform3D:frome];
    anio.toValue = [NSValue valueWithCATransform3D:to];
    anio.delegate = self;
    [self.container.layer addAnimation:anio forKey:ANIMATE_NAME];
//    [self resumeLayer];
}

-(void)animationTopFrome:(CATransform3D)frome to:(CATransform3D)to
{
    self.animating = YES;
    CABasicAnimation *anio = [CABasicAnimation defaultValueForKey:@"transform"];
    anio.removedOnCompletion = NO;
    anio.duration = ANIMATE_TIME;
    anio.fillMode = kCAFillModeForwards;
    anio.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anio.fromValue = [NSValue valueWithCATransform3D:frome];
    anio.toValue = [NSValue valueWithCATransform3D:to];
    anio.delegate = self;
    [self.container.layer addAnimation:anio forKey:ANIMATE_NAME];
//    [self resumeLayer];
}
-(void)animationBottomFrome:(CATransform3D)frome to:(CATransform3D)to
{
    self.animating = YES;
    CABasicAnimation *anio = [CABasicAnimation defaultValueForKey:@"transform"];
    anio.removedOnCompletion = NO;
    anio.duration = ANIMATE_TIME;
    anio.fillMode = kCAFillModeForwards;
    anio.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anio.fromValue = [NSValue valueWithCATransform3D:frome];
    anio.toValue = [NSValue valueWithCATransform3D:to];
    anio.delegate = self;
    [self.container.layer addAnimation:anio forKey:ANIMATE_NAME];
//    [self resumeLayer];
}

-(void)animationMiddleFrome:(CATransform3D)frome to:(CATransform3D)to
{
    self.animating = YES;
    CABasicAnimation *anio = [CABasicAnimation defaultValueForKey:@"transform"];
    anio.removedOnCompletion = NO;
    anio.duration = ANIMATE_TIME;
    anio.fillMode = kCAFillModeForwards;
    anio.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anio.fromValue = [NSValue valueWithCATransform3D:frome];
    anio.toValue = [NSValue valueWithCATransform3D:to];
    anio.delegate = self;
    [self.container.layer addAnimation:anio forKey:ANIMATE_NAME];
//    [self resumeLayer];
}

-(void)animationNone
{
    self.animating = YES;
    [self animationDidStop:(id)ANIMATE_NAME finished:YES];
    //    [self resumeLayer];
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([self.content.layer animationForKey:ANIMATE_NAME]==anim || ([anim isKindOfClass:[NSString class]] && [(NSString *)anim isEqualToString:ANIMATE_NAME])) {
        if (self.afterAnimateBlock && flag) {
            self.animating = NO;
            self.afterAnimateBlock();
            [self stopAnimate];
        }
        
    }
}

-(void)animationRefresh
{
    if (!(self.range.topline==self.tempRange.topline && self.tempRange.bottomline==self.range.bottomline)) {
        self.animating = YES;
        CABasicAnimation *anio = [CABasicAnimation defaultValueForKey:@"transform"];
        anio.removedOnCompletion = NO;
        anio.duration = ANIMATE_TIME;
        anio.fillMode = kCAFillModeForwards;
        anio.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        anio.fromValue = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeTranslation(0, self.tempRange.topline)];
        anio.toValue = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeTranslation(0, self.range.topline)];
        anio.delegate = self;
        [self.container.layer addAnimation:anio forKey:ANIMATE_NAME];
//        [self resumeLayer];
    }
}

-(void)stopAnimate
{
//    [self pauseLayer];
//    [self.container.layer removeAnimationForKey:ANIMATE_NAME];
//    self.afterAnimateBlock = nil;
}

//-(void)pauseLayer
//{
//    CFTimeInterval pausedTime = [self.content.layer convertTime:CACurrentMediaTime() fromLayer:nil];
//    self.container.layer.speed               = 0.0;
//    self.container.layer.timeOffset          = pausedTime;
//    self.container.layer.timeOffset        = pausedTime;
//}
//
//-(void)resumeLayer
//{
//    CFTimeInterval pausedTime     = [self.container.layer timeOffset];
//    self.content.layer.speed                   = 1.0;
//    self.content.layer.timeOffset              = 0.0;
//    self.content.layer.beginTime               = 0.0;
//    CFTimeInterval timeSincePause = [self.content.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
//    self.content.layer.beginTime               = timeSincePause;
//}

@end


#pragma mark -
@interface SectionMash ()

@end
@implementation SectionMash
-(NSMutableArray<SubMash *> *)cells
{
    if (!_cells) {
        _cells = [NSMutableArray new];
    }
    return _cells;
}
@end




#pragma mark -
@interface ScrollMash ()
{
    NSMutableArray *totalMashs;
    NSMutableArray <SectionMash *>*_setcionMashs;
    SubMash *_scrollHeader;
    SubMash *_scrollFooter;
    NSMutableDictionary *blocks;
}
@end

@implementation ScrollMash
-(instancetype)init
{
    if (self = [super init]) {
        totalMashs = [NSMutableArray new];
    }
    return self;
}

-(SubMash *)scrollHeader
{
    if (!_scrollHeader) {
        _scrollHeader = [SubMash new];
    }
    return _scrollHeader;
}
-(SubMash *)scrollFooter
{
    if (!_scrollFooter) {
        _scrollFooter = [SubMash new];
    }
    return _scrollFooter;
}

-(void)addScrollHeader:(SubMash *)scrollHeader;{
    _scrollHeader = scrollHeader;
}

-(void)addScrollFooter:(SubMash *)scrollFooter;{
    _scrollFooter = scrollFooter;
}

-(void)addScrollSection:(SectionMash *)scrollSection;{
    [self.scrollMashSections_ addObject:scrollSection];
}

-(void)insertScrollSection:(SectionMash *)scrollSection atIndex:(NSUInteger)section;{
    [self.scrollMashSections_ insertObject:scrollSection atIndex:section];
}

-(void)replaceScrollSection:(SectionMash *)scrollSection atIndex:(NSUInteger)section;{
    [self.scrollMashSections_ replaceObjectAtIndex:section withObject:scrollSection];
}

-(void)deleteScrollSectionAtIndex:(NSUInteger)section;{
    [self.scrollMashSections_ removeObjectAtIndex:section];
}

-(void)insertScrollCell:(SubMash *)scrollCell atIndexPath:(NSIndexPath *)indexpath;{
    [[self scrollMashSections_][indexpath.section].cells insertObject:scrollCell atIndex:indexpath.row];
}

-(void)replaceScrollCell:(SubMash *)scrollCell atIndexpath:(NSIndexPath *)indexpath;{
    [[self scrollMashSections_][indexpath.section].cells replaceObjectAtIndex:indexpath.row withObject:scrollCell];
}

-(void)deleteScrollCellAtIndexPath:(NSIndexPath *)indexpath;{
    [[self scrollMashSections_][indexpath.section].cells removeObjectAtIndex:indexpath.row];
}

-(NSMutableArray <SubMash *>*)scrollMashTotal_
{
    return totalMashs;
}

-(void)refreshTotal
{
    //在这里就开始动画了
    NSMutableArray *temp = [NSMutableArray new];
    [temp addObject:self.scrollHeader];
    self.scrollHeader.indexPath = [NSIndexPath indexPathForRow:INT_MAX inSection:INT_MAX];
    NSInteger section = 0;
    for (SectionMash *sms in _setcionMashs) {
        NSInteger row = 0;
        [temp addObject:sms.header];
        sms.header.indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        for (SubMash *submash in sms.cells) {
            [temp addObject:submash];
            submash.indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            row++;
        }
        [temp addObject:sms.footer];
        sms.footer.indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        section++;
    }
    [temp addObject:self.scrollFooter];
    self.scrollFooter.indexPath = [NSIndexPath indexPathForRow:INT_MAX inSection:INT_MAX];
    totalMashs = temp;
    
}


-(NSMutableArray <SectionMash *>*)scrollMashSections_
{
    if (!_setcionMashs) {
        _setcionMashs = [NSMutableArray new];
    }
    return _setcionMashs;
}

-(void)clear
{
    _scrollHeader = _scrollFooter = nil;
    _setcionMashs = nil;
}
@end
