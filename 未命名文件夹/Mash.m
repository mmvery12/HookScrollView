//
//  Mash.m
//  Demo4
//
//  Created by JD on 2017/6/19.
//  Copyright © 2017年 LYC. All rights reserved.
//

#import "Mash.h"

#pragma mark -
@implementation Range
-(CGFloat)topline
{
    return self.partnerMash.fatherMash.range.bottomline+self.partnerMash.fatherMash.insert.bottom+self.partnerMash.insert.top;
}

-(CGFloat)bottomline
{
    return self.partnerMash.fatherMash.range.topline+self.partnerMash.height;
}
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
        self.range.partnerMash = self;
    }
    return self;
}

-(void)setUpWithGrandFatherMash:(ScrollMash *)grandfathermash father:(SubMash *)father
{
    self.fatherMash = father;
    father.childerMash = self;
    self.grandFather = grandfathermash;
    
    CGRect rect = CGRectZero;
    rect.origin.x = self.insert.left;
    rect.origin.y = self.range.topline;
    rect.size.width = CGRectGetWidth(self.grandFather.imfScroll.bounds)-self.insert.left-self.insert.right;
    rect.size.height = self.height;
    self.rect = rect;
    
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
        if (_tempRange) {
            self.tempRange.topline = self.range.topline;
            self.tempRange.bottomline = self.range.bottomline;
        }else
        {
            self.tempRange.topline = botm + self.insert.top;
            self.tempRange.bottomline = self.range.topline + self.height;
        }
    }
    self.range.topline = botm + self.insert.top;
    self.range.bottomline = self.range.topline + self.height;
    
    return self.range.bottomline + self.insert.bottom;
}



-(Range *)range
{
    if (!_range) {
        _range = [Range new];
    }
    return _range;
}

//#pragma mark -
//-(void)animationFadeFrome:(NSInteger)frome to:(NSInteger)to
//{
//    self.content.alpha = 0;
//    self.animating = YES;
//    CABasicAnimation *anio = [CABasicAnimation defaultValueForKey:@"alpha"];
//    anio.removedOnCompletion = NO;
//    anio.fillMode = kCAFillModeForwards;
//    anio.duration = ANIMATE_TIME;
//    anio.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    anio.fromValue = [NSNumber numberWithFloat:frome];
//    anio.toValue = [NSNumber numberWithFloat:to];
//    anio.delegate = self;
//    [self.container.layer addAnimation:anio forKey:ANIMATE_NAME];
//}
//
//-(void)animationRightFrome:(CATransform3D)frome to:(CATransform3D)to
//{
//    self.animating = YES;
//    CABasicAnimation *anio = [CABasicAnimation defaultValueForKey:@"transform"];
//    anio.removedOnCompletion = NO;
//    anio.duration = ANIMATE_TIME;
//    anio.fillMode = kCAFillModeForwards;
//    anio.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    anio.fromValue = [NSValue valueWithCATransform3D:frome];
//    anio.toValue = [NSValue valueWithCATransform3D:to];
//    anio.delegate = self;
//    [self.container.layer addAnimation:anio forKey:ANIMATE_NAME];
//}
//
//-(void)animationLeftFrome:(CATransform3D)frome to:(CATransform3D)to
//{
//    self.animating = YES;
//    CABasicAnimation *anio = [CABasicAnimation defaultValueForKey:@"transform"];
//    anio.removedOnCompletion = NO;
//    anio.duration = ANIMATE_TIME;
//    anio.fillMode = kCAFillModeForwards;
//    anio.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    anio.fromValue = [NSValue valueWithCATransform3D:frome];
//    anio.toValue = [NSValue valueWithCATransform3D:to];
//    anio.delegate = self;
//    [self.container.layer addAnimation:anio forKey:ANIMATE_NAME];
//}
//
//-(void)animationTopFrome:(CATransform3D)frome to:(CATransform3D)to
//{
//    self.animating = YES;
//    CABasicAnimation *anio = [CABasicAnimation defaultValueForKey:@"transform"];
//    anio.removedOnCompletion = NO;
//    anio.duration = ANIMATE_TIME;
//    anio.fillMode = kCAFillModeForwards;
//    anio.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    anio.fromValue = [NSValue valueWithCATransform3D:frome];
//    anio.toValue = [NSValue valueWithCATransform3D:to];
//    anio.delegate = self;
//    [self.container.layer addAnimation:anio forKey:ANIMATE_NAME];
//}
//-(void)animationBottomFrome:(CATransform3D)frome to:(CATransform3D)to
//{
//    self.animating = YES;
//    CABasicAnimation *anio = [CABasicAnimation defaultValueForKey:@"transform"];
//    anio.removedOnCompletion = NO;
//    anio.duration = ANIMATE_TIME;
//    anio.fillMode = kCAFillModeForwards;
//    anio.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    anio.fromValue = [NSValue valueWithCATransform3D:frome];
//    anio.toValue = [NSValue valueWithCATransform3D:to];
//    anio.delegate = self;
//    [self.container.layer addAnimation:anio forKey:ANIMATE_NAME];
//}
//
//-(void)animationMiddleFrome:(CATransform3D)frome to:(CATransform3D)to
//{
//    self.animating = YES;
//    CABasicAnimation *anio = [CABasicAnimation defaultValueForKey:@"transform"];
//    anio.removedOnCompletion = NO;
//    anio.duration = ANIMATE_TIME;
//    anio.fillMode = kCAFillModeForwards;
//    anio.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    anio.fromValue = [NSValue valueWithCATransform3D:frome];
//    anio.toValue = [NSValue valueWithCATransform3D:to];
//    anio.delegate = self;
//    [self.container.layer addAnimation:anio forKey:ANIMATE_NAME];
//}
//
//-(void)animationNone
//{
//    self.animating = YES;
//    [self animationDidStop:(id)ANIMATE_NAME finished:YES];
//
//}
//
//-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    if ([self.content.layer animationForKey:ANIMATE_NAME]==anim || ([anim isKindOfClass:[NSString class]] && [(NSString *)anim isEqualToString:ANIMATE_NAME])) {
//        if (flag) {
//            self.animating = NO;
//            if (self.offblock) {
//                self.offblock(self);
//            }
//            [self stopAnimate];
//        }
//        
//    }
//}
//
//-(void)animationRefresh
//{
//    if (!(self.range.topline==self.tempRange.topline && self.tempRange.bottomline==self.range.bottomline)) {
//        self.animating = YES;
//        CABasicAnimation *anio = [CABasicAnimation defaultValueForKey:@"transform"];
//        anio.removedOnCompletion = NO;
//        anio.duration = ANIMATE_TIME;
//        anio.fillMode = kCAFillModeForwards;
//        anio.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//        anio.fromValue = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeTranslation(0, self.tempRange.topline)];
//        anio.toValue = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeTranslation(0, self.range.topline)];
//        anio.delegate = self;
//        [self.container.layer addAnimation:anio forKey:ANIMATE_NAME];
////        [self resumeLayer];
//    }
//}
//
-(void)stopAnimate
{
//    [self pauseLayer];
//    [self.container.layer removeAnimationForKey:ANIMATE_NAME];
//    self.afterAnimateBlock = nil;
    self.tempRange.topline = self.range.topline;
    self.tempRange.bottomline = self.range.bottomline;
    [self.content.layer removeAllAnimations];
}
//
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
{
    
}
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

#define SectionIndexPathString []
@interface ScrollMash ()
{
    NSMutableArray <SectionMash *>*_setcionMashs;
    SubMash *_scrollHeader;
    SubMash *_scrollFooter;
    NSMutableDictionary *blocks;
    SubMash  * _father;
    NSMutableDictionary *mashDict;
}
@end

@implementation ScrollMash
-(instancetype)init
{
    if (self = [super init]) {
        self.totalMash = [NSMutableArray new];
        mashDict = [NSMutableDictionary new];
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
    [mashDict setObject:scrollHeader forKey:@"ScrollHeader"];
}

-(void)addScrollFooter:(SubMash *)scrollFooter;{
    _scrollFooter = scrollFooter;
    [mashDict setObject:scrollFooter forKey:@"ScrollFooter"];
}
#define KSectionIndex(_indexPath) [NSString stringWithFormat:@"section%ld",_indexPath.section]
#define KSecHeaderIndex(_indexPath) [NSString stringWithFormat:@"sectionHeader%ld",_indexPath.section]
#define KSecFooterIndex(_indexPath) [NSString stringWithFormat:@"sectionFooter%ld",_indexPath.section]
#define KSecCellIndex(_indexPath) [NSString stringWithFormat:@"cell%ld%ld",_indexPath.section,_indexPath.row]
-(void)addScrollSection:(SectionMash *)scrollSection;{
    [self.scrollMashSections_ addObject:scrollSection];
    
    [mashDict setObject:scrollSection forKey:KSectionIndex(scrollSection.header.indexPath)];
    [mashDict setObject:scrollSection.header forKey:KSecHeaderIndex(scrollSection.header.indexPath)];
    [mashDict setObject:scrollSection.footer forKey:KSecFooterIndex(scrollSection.footer.indexPath)];
    for (SubMash *sub in scrollSection.cells) {
        [mashDict setObject:scrollSection.footer forKey:KSecCellIndex(sub.indexPath)];
    }
}

-(void)insertQian:(SubMash *)qian hou:(SubMash *)hou mash:(SubMash *)mash
{
    
}

-(void)reloadQian:(SubMash *)qian hou:(SubMash *)hou mash:(SubMash *)mash
{
}

-(void)deleteQian:(SubMash *)qian hou:(SubMash *)hou mash:(SubMash *)mash
{
}

-(void)insertScrollSection:(SectionMash *)scrollSection atIndex:(NSUInteger)section;{

    [self.scrollMashSections_ insertObject:scrollSection atIndex:section];
    SectionMash *oldMash = mashDict[KSectionIndex([NSIndexPath indexPathForRow:0 inSection:section])];
    if (oldMash) {
        oldMash.header.fatherMash.childerMash = scrollSection.header;
        scrollSection.header.fatherMash = oldMash.header.fatherMash;
        scrollSection.footer.childerMash = oldMash.header;
        oldMash.header.fatherMash = scrollSection.footer;
    }else
    if (!oldMash && section==0) {
        self._scrollHeader.childerMash = scrollSection.header;
        scrollSection.header.fatherMash = self._scrollHeader;
        self._scrollFooter.fatherMash = scrollSection.footer;
        scrollSection.footer.childerMash = self._scrollFooter;
    }
}

-(void)replaceScrollSection:(SectionMash *)scrollSection atIndex:(NSUInteger)section;{
    SubMash *qianqu = nil;
    SubMash *houji = nil;
    SectionMash *temp = [self.scrollMashSections_ objectAtIndex:section];
    [self.scrollMashSections_ replaceObjectAtIndex:section withObject:scrollSection];
    SectionMash *oldMash = mashDict[KSectionIndex([NSIndexPath indexPathForRow:0 inSection:section])];
    if (oldMash) {
        oldMash.header.fatherMash.childerMash = scrollSection.header;
        scrollSection.header.fatherMash = oldMash.header.fatherMash;
        scrollSection.footer.childerMash = oldMash.header;
        oldMash.header.fatherMash = scrollSection.footer;
    }else
    if (!oldMash && section==0)
    {
        self._scrollHeader.childerMash = scrollSection.header;
        scrollSection.header.fatherMash = self._scrollHeader;
        self._scrollFooter.fatherMash = scrollSection.footer;
        scrollSection.footer.childerMash = self._scrollFooter;
    }
    
    qianqu = temp.header.fatherMash;
    houji = temp.footer.childerMash;
    
    _father = qianqu;
    [self setUpMash:scrollSection.header];
    for (SubMash *sub in scrollSection.cells) {
        [self setUpMash:sub];
    }
    [self setUpMash:scrollSection.footer];
    [self setUpMash:houji];
}

-(void)deleteScrollSectionAtIndex:(NSUInteger)section;
{
    SubMash *qianqu = nil;
    SubMash *houji = nil;
    SectionMash *temp = [self.scrollMashSections_ objectAtIndex:section];
    [self.scrollMashSections_ removeObjectAtIndex:section];
    qianqu = temp.header.fatherMash;
    houji = temp.footer.childerMash;
    
    qianqu.childerMash = houji;
    houji.fatherMash = qianqu;
}

-(void)insertScrollCell:(SubMash *)scrollCell atIndexPath:(NSIndexPath *)indexpath;{
    
    SubMash *qianqu = nil;
    SubMash *houji = nil;
    [[self scrollMashSections_][indexpath.section].cells insertObject:scrollCell atIndex:indexpath.row];
    if ([self scrollMashSections_][indexpath.section].cells.lastObject==scrollCell) {
        if ([self scrollMashSections_][indexpath.section].cells.firstObject!=scrollCell) {//中间有其他
            SubMash *temp = [self scrollMashSections_][indexpath.section].cells[indexpath.row-1];
            qianqu = temp;
            houji = temp.childerMash;
        }
        else{
            SectionMash *temp = [self scrollMashSections_][indexpath.section];
            qianqu = temp.header;
            houji = temp.footer;
        }
    }else
    {
        SubMash *temp = [self scrollMashSections_][indexpath.section].cells[indexpath.row+1];
        qianqu = temp.fatherMash;
        houji = temp;
    }
    
    _father = qianqu;
    [self setUpMash:qianqu];
    [self setUpMash:houji];
}

-(void)replaceScrollCell:(SubMash *)scrollCell atIndexpath:(NSIndexPath *)indexpath;{
    SubMash *temp = [self scrollMashSections_][indexpath.section].cells[indexpath.row];
    [[self scrollMashSections_][indexpath.section].cells replaceObjectAtIndex:indexpath.row withObject:scrollCell];
    temp.fatherMash.childerMash = scrollCell;
    scrollCell.fatherMash = temp.fatherMash;
    scrollCell.childerMash = temp.childerMash;
    temp.childerMash.fatherMash = scrollCell;
}

-(void)deleteScrollCellAtIndexPath:(NSIndexPath *)indexpath;{
    SubMash *temp = [self scrollMashSections_][indexpath.section].cells[indexpath.row];
    [[self scrollMashSections_][indexpath.section].cells removeObjectAtIndex:indexpath.row];
    temp.fatherMash.childerMash = temp.childerMash;
    temp.childerMash.fatherMash = temp.fatherMash;
}

-(void)setUpMash:(SubMash *)mash;
{
    [mash setUpWithGrandFatherMash:self father:_father];
    _father = mash;
}






-(CGSize)contentSize
{
    return CGSizeMake(0, _scrollFooter.range.bottomline+_scrollFooter.insert.bottom);
}


-(void)loadMashAnimate:(SubMash *)mash
{
    if (mash) {
        __weak typeof(self) wf = self;
        mash.offblock = ^(SubMash *mash)
        {
            if (wf.offblock) {
                wf.offblock(mash);
            }
        };
    }
    
    if (mash) {
        if (mash.range.topline!=mash.tempRange.topline && mash.range.bottomline!=mash.tempRange.bottomline) {
            
            [UIView animateWithDuration:ANIMATE_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
                } completion:^(BOOL finished) {
                    if (finished && self.offblock) {
                        self.offblock(mash);
                    }
                }];
        }
    }
    
    if (mash &&mash.loaded == NeedLoad ) {
        
 
        ///////////insert,reload 动画
        CGFloat offsety = 0;
        CGFloat topline = offsety + _imfScroll.contentInset.top;
        CGFloat bottomline = _imfScroll.frame.size.height + topline;
        
//        switch (mash.animate) {
//            case SubMashRowAnimationFade:
//                [mash animationFadeFrome:0 to:1];
//                break;
//            case SubMashRowAnimationRight:
//                [mash animationRightFrome:CATransform3DMakeTranslation(_imfScroll.frame.size.width, 0, 0) to:CATransform3DIdentity];
//                break;
//            case SubMashRowAnimationLeft:
//                [mash animationLeftFrome:CATransform3DMakeTranslation(-_imfScroll.frame.size.width, 0, 0) to:CATransform3DIdentity];
//                break;
//            case SubMashRowAnimationTop:
//                [mash animationTopFrome:CATransform3DMakeTranslation(0, -mash.range.bottomline,0) to:CATransform3DIdentity];
//                break;
//            case SubMashRowAnimationBottom:
//                [mash animationBottomFrome:CATransform3DMakeTranslation(0, bottomline+mash.height,0) to:CATransform3DIdentity];
//                break;
//            case SubMashRowAnimationNone:
//                break;
//            case SubMashRowAnimationMiddle:
//                [mash animationMiddleFrome:CATransform3DMakeScale(1, 0, 0) to:CATransform3DIdentity];
//                break;
//            default:
//                break;
//        }
        switch (mash.animate) {
            case SubMashRowAnimationFade:
                mash.content.alpha = 0;
                break;
            case SubMashRowAnimationRight:
                mash.content.transform = CGAffineTransformMakeTranslation(_imfScroll.frame.size.width, 0);
                break;
            case SubMashRowAnimationLeft:
                mash.content.transform = CGAffineTransformMakeTranslation(-_imfScroll.frame.size.width, 0);
                break;
            case SubMashRowAnimationTop:
                mash.content.transform = CGAffineTransformMakeTranslation(0, -mash.range.bottomline);
                break;
            case SubMashRowAnimationBottom:
                mash.content.transform = CGAffineTransformMakeTranslation(0, bottomline+mash.height);
                break;
            case SubMashRowAnimationNone:
                break;
            case SubMashRowAnimationMiddle:
                mash.content.transform = CGAffineTransformMakeScale(1, 0);
                break;
            default:
                break;
        }

        [UIView animateWithDuration:ANIMATE_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            mash.content.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (finished && self.offblock) {
                self.offblock(mash);
            }
        }];
    }
    if (mash && mash.loaded == NeedUnload) {
        CGFloat offsety = 0;
        CGFloat topline = offsety + _imfScroll.contentInset.top;
        CGFloat bottomline = _imfScroll.frame.size.height + topline;
        
//        switch (mash.animate) {
//            case SubMashRowAnimationFade:
//                [mash animationFadeFrome:1 to:0];
//                break;
//            case SubMashRowAnimationRight:
//                [mash animationRightFrome:CATransform3DIdentity to:CATransform3DMakeTranslation(_imfScroll.frame.size.width, 0,0)];
//                break;
//            case SubMashRowAnimationLeft:
//                [mash animationLeftFrome:CATransform3DIdentity to:CATransform3DMakeTranslation(-_imfScroll.frame.size.width, 0,0)];
//                break;
//            case SubMashRowAnimationTop:
//                [mash animationTopFrome:CATransform3DIdentity to:CATransform3DMakeTranslation(0, -mash.range.bottomline,0)];
//                break;
//            case SubMashRowAnimationBottom:
//                [mash animationBottomFrome:CATransform3DIdentity to:CATransform3DMakeTranslation(0, bottomline+mash.height,0)];
//                break;
//            case SubMashRowAnimationNone:
//                [mash animationNone];
//                break;
//            case SubMashRowAnimationMiddle:
//                [mash animationMiddleFrome:CATransform3DIdentity to:CATransform3DMakeScale(1, .1,0)];
//                break;
//            default:
//                break;
//        }
        [UIView animateWithDuration:ANIMATE_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            switch (mash.animate) {
                case SubMashRowAnimationFade:
                    mash.content.alpha = 0;
                    break;
                case SubMashRowAnimationRight:
                    mash.content.transform = CGAffineTransformMakeTranslation(_imfScroll.frame.size.width, 0);
                    break;
                case SubMashRowAnimationLeft:
                    mash.content.transform = CGAffineTransformMakeTranslation(-_imfScroll.frame.size.width, 0);
                    break;
                case SubMashRowAnimationTop:
                    mash.content.transform = CGAffineTransformMakeTranslation(0, -mash.range.bottomline);
                    break;
                case SubMashRowAnimationBottom:
                    mash.content.transform = CGAffineTransformMakeTranslation(0, bottomline+mash.height);
                    break;
                case SubMashRowAnimationNone:
                    break;
                case SubMashRowAnimationMiddle:
                    mash.content.transform = CGAffineTransformMakeScale(1, .1);
                    break;
                default:
                    break;
            }
        } completion:^(BOOL finished) {
            if (finished && self.offblock) {
                self.offblock(mash);
            }
        }];
    }

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
