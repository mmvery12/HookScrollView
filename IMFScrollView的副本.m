//
//  ArticleScrollView.m
//  Template
//
//  Created by liyuchang on 16/3/15.
//  Copyright © 2016年 liyuchang. All rights reserved.
//

#import "IMFScrollView.h"
#import <objc/runtime.h>

#define ANIMATE_TIME .5
const NSString * HTxIqaUIoasxPidentifier = @"HTxIqaUIoasxPidentifier";
const NSString * PTxIqaUIoasxPidentifier = @"PTxIqaUIoasxPidentifier";
const NSString * KTxIqaUIoasxPidentifier = @"KTxIqaUIoasxPidentifier";

typedef NS_ENUM(NSInteger,SubMashType) {
    SCROLL_Header,
    SCROLL_Footer,
    SECTION_Header,
    SECTION_Footer,
    SECTION_Cell
};

typedef NS_ENUM(NSInteger,SubMashAnimate) {
    SubMashRowAnimationFade,
    SubMashRowAnimationRight,
    SubMashRowAnimationLeft,
    SubMashRowAnimationTop,
    SubMashRowAnimationBottom,
    SubMashRowAnimationNone,
    SubMashRowAnimationNormal,
    SubMashRowAnimationMiddle,
    SubMashRowAnimationAutomatic = 100
};


@interface CellContainer : UIView
@end
@implementation CellContainer
@end

@interface Range : NSObject
@property (nonatomic,assign)CGFloat topline;
@property (nonatomic,assign)CGFloat bottomline;
@end
@implementation Range
@end


@interface SubMash : NSObject
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,strong)CellContainer *container;
@property (nonatomic,strong)UIView *content;
@property (nonatomic,assign)UIEdgeInsets insert;//下间距
@property (nonatomic,strong)NSString *identifier;
@property (nonatomic,assign)CGFloat originY;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)Range *range;
@property (nonatomic,assign)SubMashType type;

@property (nonatomic,assign)BOOL appear;
@property (nonatomic,assign)SubMashAnimate animate;


@property (nonatomic,assign)BOOL loaded;
@end
@implementation SubMash

-(instancetype)init
{
    if (self = [super init]) {
        _insert = UIEdgeInsetsZero;
        _appear = YES;
    }
    return self;
}

-(CGFloat)setMashRangeWithBotm:(CGFloat)botm
{
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

@end

@interface SectionMash : NSObject
@property (nonatomic,strong)SubMash *header;
@property (nonatomic,strong)SubMash *footer;
@property (nonatomic,strong)NSMutableArray<SubMash *> *cells;
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

@interface ScrollMash : NSObject

-(NSMutableArray <SubMash *>*)scrollMashTotal_;
-(NSMutableArray <SectionMash *>*)scrollMashSections_;
-(void)clear;
-(void)addScrollHeader:(SubMash *)scrollHeader;
-(void)addScrollFooter:(SubMash *)scrollFooter;

-(void)addScrollSection:(SectionMash *)scrollSection;
-(void)insertScrollSection:(SectionMash *)scrollSection atIndex:(NSUInteger)section;
-(void)replaceScrollSection:(SectionMash *)scrollSection atIndex:(NSUInteger)section;
-(void)deleteScrollSectionAtIndex:(NSUInteger)section;

-(void)insertScrollCell:(SubMash *)scrollCell atIndexPath:(NSIndexPath *)indexpath;
-(void)replaceScrollCell:(SubMash *)scrollCell atIndexpath:(NSIndexPath *)indexpath;
-(void)deleteScrollCellAtIndexPath:(NSIndexPath *)indexpath;
@end

@interface ScrollMash ()
{
    NSMutableArray *totalMashs;
    NSMutableArray <SectionMash *>*_setcionMashs;
    SubMash *_scrollHeader;
    SubMash *_scrollFooter;
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
#pragma mark -
-(void)addScrollHeader:(SubMash *)scrollHeader;{
    _scrollHeader = scrollHeader;
    [self refreshTotal];
}
-(void)addScrollFooter:(SubMash *)scrollFooter;{
    _scrollFooter = scrollFooter;
    [self refreshTotal];
}

-(void)addScrollSection:(SectionMash *)scrollSection;{
    [self.scrollMashSections_ addObject:scrollSection];
    [self refreshTotal];
}
-(void)insertScrollSection:(SectionMash *)scrollSection atIndex:(NSUInteger)section;{
    [self.scrollMashSections_ insertObject:scrollSection atIndex:section];
    [self refreshTotal];
}
-(void)replaceScrollSection:(SectionMash *)scrollSection atIndex:(NSUInteger)section;{
    [self.scrollMashSections_ replaceObjectAtIndex:section withObject:scrollSection];
    [self refreshTotal];
}
-(void)deleteScrollSectionAtIndex:(NSUInteger)section;{
    [self.scrollMashSections_ removeObjectAtIndex:section];
    [self refreshTotal];
}

-(void)insertScrollCell:(SubMash *)scrollCell atIndexPath:(NSIndexPath *)indexpath;{
    [[self scrollMashSections_][indexpath.section].cells insertObject:scrollCell atIndex:indexpath.row];
    [self refreshTotal];
}
-(void)replaceScrollCell:(SubMash *)scrollCell atIndexpath:(NSIndexPath *)indexpath;{
    [[self scrollMashSections_][indexpath.section].cells replaceObjectAtIndex:indexpath.row withObject:scrollCell];
    [self refreshTotal];
}
-(void)deleteScrollCellAtIndexPath:(NSIndexPath *)indexpath;{
    [[self scrollMashSections_][indexpath.section].cells removeObjectAtIndex:indexpath.row];
    [self refreshTotal];
}

#pragma mark -
-(NSMutableArray <SubMash *>*)scrollMashTotal_
{
    return totalMashs;
}

-(void)refreshTotal
{
    NSMutableArray *temp = [NSMutableArray new];
    [temp addObject:self.scrollHeader];
    for (SectionMash *sms in _setcionMashs) {
        [temp addObject:sms.header];
        [temp addObjectsFromArray:sms.cells];
        [temp addObject:sms.footer];
    }
    [temp addObject:self.scrollFooter];
    
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



@interface IMFScrollView ()<UIScrollViewDelegate>
{
    
    dispatch_queue_t scrollqueue;
    
    NSMutableDictionary *reuseCellsIdentifierDictionary;
    NSMutableDictionary *reuseUnReuseCellsIdentifierDictionary;
    NSMutableDictionary *reuseHeaderIdentifierDictionary;
    NSMutableDictionary *reuseFooterIdentifierDictionary;
    
    NSUInteger numberOfSections;
    NSMutableArray *numberOfRows;
    
    NSMutableSet *originMashVisibleCellsArray;
    NSMutableSet *originMashVisibleHeadersArray;
    NSMutableSet *originMashVisibleFootersArray;
    
    NSMutableSet * usingCellsArray;
    NSMutableSet * usingSectionHeaderArray;
    NSMutableSet * usingSectionFooterArray;
    
    NSMutableSet *unusingCellsArray;
    NSMutableSet *unusingSectionHeaderArray;
    NSMutableSet *unusingSectionFooterArray;
    
    ScrollMash *scrollMash;
    NSMutableSet *exchangeSet;
    BOOL isLoad;
}
@property (nonatomic,assign)CGPoint nearPoint;
@property (nonatomic,assign)CGFloat scrollheight;

@property (nonatomic,strong) UIView *scrollViewHeader;
@property (nonatomic,strong) UIView *scrollViewFooter;
@end

@implementation IMFScrollView
@synthesize nearPoint = nearPoint;
@synthesize scrollheight = scrollheight;
- (void)dealloc
{
    
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.alwaysBounceVertical = YES;
    }
    return self;
}

-(NSMutableSet *)exchangeSet_
{
    if (!exchangeSet) {
        exchangeSet = [NSMutableSet new];
    }
    return exchangeSet;
}

-(NSMutableDictionary *)reuseHeaderIdentifierDictionary_
{
    if (!reuseHeaderIdentifierDictionary) {
        reuseHeaderIdentifierDictionary = [NSMutableDictionary dictionary];
    }
    return reuseHeaderIdentifierDictionary;
}

-(NSMutableDictionary *)reuseFooterIdentifierDictionary_
{
    if (!reuseFooterIdentifierDictionary) {
        reuseFooterIdentifierDictionary = [NSMutableDictionary dictionary];
    }
    return reuseFooterIdentifierDictionary;
}


-(NSMutableDictionary *)reuseCellsIdentifierDictionary_
{
    if (!reuseCellsIdentifierDictionary) {
        reuseCellsIdentifierDictionary = [NSMutableDictionary dictionary];
    }
    return reuseCellsIdentifierDictionary;
}
-(NSMutableDictionary *)reuseUnReuseCellsIdentifierDictionary_
{
    if (!reuseUnReuseCellsIdentifierDictionary) {
        reuseUnReuseCellsIdentifierDictionary = [NSMutableDictionary dictionary];
    }
    return reuseUnReuseCellsIdentifierDictionary;
}

-(NSMutableSet *)unusingCellsArray_
{
    if (self.disableReuseCells) {
        return nil;
    }
    if (!unusingCellsArray) {
        unusingCellsArray = [NSMutableSet set];
    }
    return unusingCellsArray;
}

-(NSMutableSet *)unusingSectionHeaderArray_
{
    if (self.disableReuseCells) {
        return nil;
    }
    if (!unusingSectionFooterArray) {
        unusingSectionFooterArray = [NSMutableSet set];
    }
    return unusingSectionFooterArray;
}

-(NSMutableSet *)unusingSectionFooterArray_
{
    if (self.disableReuseCells) {
        return nil;
    }
    if (!unusingSectionHeaderArray) {
        unusingSectionHeaderArray = [NSMutableSet set];
    }
    return unusingSectionHeaderArray;
}

-(ScrollMash *)scrollMash_
{
    if (!scrollMash) {
        scrollMash = [ScrollMash new];
    }
    return scrollMash;
}

-(NSMutableArray *)numberOfRows_
{
    if (!numberOfRows) {
        numberOfRows = [NSMutableArray array];
    }
    return numberOfRows;
}

-(NSMutableSet *)usingCellsArray_
{
    if (self.disableReuseCells) {
        return nil;
    }
    if (!usingCellsArray) {
        usingCellsArray = [NSMutableSet set];
    }
    return usingCellsArray;
}

-(NSMutableSet *)usingSectionHeaderArray_
{
    if (self.disableReuseCells) {
        return nil;
    }
    if (!usingSectionHeaderArray) {
        usingSectionHeaderArray = [NSMutableSet set];
    }
    return usingSectionHeaderArray;
}

-(NSMutableSet *)usingSectionFooterArray_
{
    if (self.disableReuseCells) {
        return nil;
    }
    if (!usingSectionFooterArray) {
        usingSectionFooterArray = [NSMutableSet set];
    }
    return usingSectionFooterArray;
}


-(void)queueAdd:(dispatch_block_t)block
{
    if (!scrollqueue) {
        scrollqueue = dispatch_queue_create("123", DISPATCH_QUEUE_SERIAL);
    }
    dispatch_async(scrollqueue, block);
}



-(CGFloat)scrollheight
{
    if (self.imfScrollViewHeader) {
        scrollheight += self.imfScrollViewHeader.frame.size.height;
    }
    if (self.imfScrollViewFooter) {
        scrollheight += self.imfScrollViewFooter.frame.size.height;
    }
    return scrollheight;
}

-(void)willMoveToWindow:(UIWindow *)newWindow
{
    if (isLoad) {
        return;
    }
    isLoad = YES;
    self.delegate = self;
    [self reloadData];
}


-(void)resetViewFrame:(UIView *)view height:(CGFloat)height point:(CGPoint)point
{
    CGRect frame = view.frame;
    frame.origin.x = point.x;
    frame.origin.y = point.y;
    frame.size.height = height;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    view.frame = frame;
}

#pragma mark --
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self catchUI:nil animate:UITableViewRowAnimationNone appear:YES];
    if (self.imfScrollDatasource && [self.imfScrollDatasource respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.imfScrollDatasource performSelector:@selector(scrollViewDidScroll:) withObject:scrollView];
    }else
        if (self.imfScrollDatasource && [self.imfScrollDatasource respondsToSelector:@selector(scrollViewDidScroll:)]) {
            [self.imfScrollDatasource performSelector:@selector(scrollViewDidScroll:) withObject:scrollView];
        }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.imfScrollDatasource && [self.imfScrollDatasource respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        SEL selector = @selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:);
        NSMethodSignature *methodSignature = [self methodSignatureForSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:self.imfScrollDatasource];
        [invocation setSelector:selector];
        UIScrollView *argument1 = scrollView;
        CGPoint argument2 = velocity;
        CGPoint *argument3 = targetContentOffset;
        [invocation setArgument:&argument1 atIndex:2];
        [invocation setArgument:&argument2 atIndex:3];
        [invocation setArgument:&argument3 atIndex:4];
        [invocation retainArguments];
        [invocation invoke];
    }else
        if (self.imfScrollDatasource && [self.imfScrollDatasource respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
            SEL selector = @selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:);
            NSMethodSignature *methodSignature = [self methodSignatureForSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            [invocation setTarget:self.imfScrollDatasource];
            [invocation setSelector:selector];
            UIScrollView *argument1 = scrollView;
            CGPoint argument2 = velocity;
            CGPoint *argument3 = targetContentOffset;
            [invocation setArgument:&argument1 atIndex:2];
            [invocation setArgument:&argument2 atIndex:3];
            [invocation setArgument:&argument3 atIndex:4];
            [invocation retainArguments];
            [invocation invoke];
        }
}




#pragma mark --
-(void)reloadData;
{
    @synchronized (self) {
        if (self.imfScrollDatasource) {
            // 1. clear
            for (SubMash *mash in [self usingCellsArray_]) {
                [self endDisplayMash:mash];
            }
            for (SubMash *mash in [self usingSectionHeaderArray_]) {
                [self endDisplayMash:mash];
            }
            for (SubMash *mash in [self usingSectionFooterArray_]) {
                [self endDisplayMash:mash];
            }
            [self endDisplayMash:[[[self scrollMash_] scrollMashTotal_] firstObject]];
            [self endDisplayMash:[[[self scrollMash_] scrollMashTotal_] lastObject]];
            
            [[self usingCellsArray_] removeAllObjects];
            [[self usingSectionFooterArray_] removeAllObjects];
            [[self usingSectionHeaderArray_] removeAllObjects];
            [[self numberOfRows_] removeAllObjects];
            
            [[self scrollMash_] clear];
            
            // 2. load section numbers
            numberOfSections = [self getNumberOfSectionsFromDataSource];
            // 3. load cells number of each section
            for (int i = 0; i<numberOfSections; i++) {
                NSUInteger numrows = [self getNumberOfRowsInSectionFromDataSource:i];
                [[self numberOfRows_] addObject:@(numrows)];
            }
            
            CGFloat totalheight = 0;
            // 5. load each section header and cell and setion footer all height
            SubMash *scrollheadermash = [SubMash new];
            scrollheadermash.type = SCROLL_Header;
            scrollheadermash.height = CGRectGetHeight(self.imfScrollViewHeader.bounds);
            totalheight = [scrollheadermash setMashRangeWithBotm:totalheight];
            [[self scrollMash_] addScrollHeader:scrollheadermash];
            
            for (int section = 0; section<numberOfSections; section++) {
                SectionMash *sms = [self addNewSection:section];
                [[self scrollMash_] addScrollSection:sms];

                totalheight = [sms.header setMashRangeWithBotm:totalheight];
                for (SubMash *submash in sms.cells) {
                    totalheight = [submash setMashRangeWithBotm:totalheight];
                }
                totalheight = [sms.footer setMashRangeWithBotm:totalheight];
            }
            
            SubMash *scrollfootermash = [SubMash new];
            scrollfootermash.type = SCROLL_Footer;
            scrollfootermash.height = CGRectGetHeight(self.imfScrollViewFooter.bounds);
            totalheight = [scrollfootermash setMashRangeWithBotm:totalheight];
            self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), totalheight);
            [[self scrollMash_] addScrollFooter:scrollfootermash];
            
            [self catchUI:nil animate:UITableViewRowAnimationNone appear:YES];
        }

    }
}



-(void)catchUI:(NSArray <SubMash *>*)submashArr animate:(UITableViewRowAnimation)animateType appear:(BOOL)appear;
{
    CGFloat offsety = 0;
    if (self.contentOffset.y>0) {
        offsety = self.contentOffset.y;
    }
    CGFloat topline = offsety + self.contentInset.top;
    CGFloat bottomline = self.frame.size.height + topline;
    
    
    //delete ，reload ，insert 的submash单独处理
    for (SubMash *sm in submashArr) {
        CGFloat centerC = fabs((sm.range.bottomline-sm.range.topline)/2.);
        CGFloat centerT = fabs((bottomline-topline)/2.);
        CGFloat maxO = (fabs(fmin(sm.range.topline, topline)-fmax(sm.range.bottomline, bottomline)))/2.;
        if (!((centerT+centerC)>=maxO && sm.loaded)) {
            
        }else
        {
            sm.animate = (int)animateType;
            sm.appear = appear;
            [self displayMash:sm];;
        }
    }
    

    NSArray *scrollMashTotal = [[self scrollMash_] scrollMashTotal_];
    
    NSMutableArray * nearestleft = [self nearestLeft:scrollMashTotal top:topline bot:bottomline];
    NSMutableArray *arr1 = nearestleft.firstObject;
    NSMutableArray *arr2 = nearestleft.lastObject;
    if (submashArr) {
        [arr1 addObject:submashArr];
    }
    for (NSMutableArray *neadload in arr1) {
        
    }
    for (NSMutableArray *neadunload in arr1) {
        
    }
    for (NSInteger i=nearestleft; i<scrollMashTotal.count; i++) {
        
        SubMash *msh = scrollMashTotal[i];;
        
        CGFloat centerC = fabs((msh.range.bottomline-msh.range.topline)/2.);
        CGFloat centerT = fabs((bottomline-topline)/2.);
        CGFloat maxO = (fabs(fmin(msh.range.topline, topline)-fmax(msh.range.bottomline, bottomline)))/2.;
        
        
        if ((centerT+centerC)>=maxO && msh.loaded && submashArr && submashArr.count!=0) { //did load msh, while insert，delete，reload with animate
            msh.animate = SubMashRowAnimationNormal;
            msh.appear = YES;
            [self displayMash:msh];
            
        }
        if ((centerT+centerC)>=maxO && !msh.loaded) { //shoule load msh
            UIView *view = nil;
            switch (msh.type) {
                case SCROLL_Header:
                    view = self.scrollViewHeader;
                    [self willDispalyScrollHeader:view];
                    break;
                case SCROLL_Footer:
                    view = self.scrollViewFooter;
                    [self willDispalyScrollFooter:view];
                    break;
                case SECTION_Header:
                    view = [self getHeaderViewFromDataSource:msh.indexPath.section];
                    [self willDispalySectionHeader:view section:msh.indexPath.section];
                    break;
                case SECTION_Footer:
                    view = [self getFooterViewFromDataSource:msh.indexPath.section];
                    [self willDispalySectionFooter:view section:msh.indexPath.section];
                    break;
                case SECTION_Cell:
                    view = [self getCellViewFromDataSource:msh.indexPath];
                    [self willDispalyCell:view indexPath:msh.indexPath];
                    break;
                default:
                    break;
            }
            msh.content = view;
            msh.appear = YES;
            msh.animate = submashArr.count?SubMashRowAnimationBottom:SubMashRowAnimationNone;
            
            [self displayMash:msh];
            [[self exchangeSet_] addObject:msh];
        }
        
        if ((centerT+centerC)<maxO && msh.loaded) {
            switch (msh.type) {
                case SCROLL_Header:
                    [self didDispalyScrollHeader:msh.content];
                    break;
                case SCROLL_Footer:
                    [self didDispalyScrollFootder:msh.content];
                    break;
                case SECTION_Header:
                    [self didDispalyScrollHeader:msh.content];
                    break;
                case SECTION_Footer:
                    [self didDispalyScrollFootder:msh.content];
                    break;
                case SECTION_Cell:
                    [self didDispalycell:msh.content indexPath:msh.indexPath];
                    break;
                default:
                    break;
            }
            [self endDisplayMash:msh];
        }
        if ((centerT+centerC)<maxO && !msh.loaded) {
            NSLog(@"for run repeat count %ld,nearestleft %ld,cut %ld",i,nearestleft,i-nearestleft);
            break;
        }
    }
}

- (UIView *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
{
    SubMash *sm = [[self scrollMash_] scrollMashSections_][indexPath.section].cells[indexPath.row];
    if (sm.content && self.disableReuseCells) {
        return sm.content;
    }
    NSString* classname = [[self reuseCellsIdentifierDictionary_] objectForKey:identifier];
    for (UIView *view in [self unusingCellsArray_]) {
        if ([objc_getAssociatedObject(view, &HTxIqaUIoasxPidentifier) isEqualToString:identifier]) {
            return view;
        }
    }
    id obj = [NSClassFromString(classname) new];
    objc_setAssociatedObject(obj, &HTxIqaUIoasxPidentifier, identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return obj;
}

- (UIView *)dequeueReusableHeaderViewWithIdentifier:(NSString *)identifier forSection:(NSUInteger)section
{
    SubMash *sm = [[self scrollMash_] scrollMashSections_][section].header;
    if (sm.content && self.disableReuseCells) {
        return sm.content;
    }
    NSString *classname = [[self reuseHeaderIdentifierDictionary_] objectForKey:identifier];
    for (UIView *view in [self unusingSectionHeaderArray_]) {
        if ([objc_getAssociatedObject(view, &PTxIqaUIoasxPidentifier) isEqualToString:identifier]) {
            return view;
        }
    }
    id obj = [NSClassFromString(classname) new];
    objc_setAssociatedObject(obj, &PTxIqaUIoasxPidentifier, identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return obj;
}

- (UIView *)dequeueReusableFooterViewWithIdentifier:(NSString *)identifier forSection:(NSUInteger)section
{
    SubMash *sm = [[self scrollMash_] scrollMashSections_][section].footer;
    if (sm.content && self.disableReuseCells) {
        return sm.content;
    }
    NSString *classname = [[self reuseFooterIdentifierDictionary_] objectForKey:identifier];
    for (UIView *view in [self unusingSectionHeaderArray_]) {
        if ([objc_getAssociatedObject(view, &KTxIqaUIoasxPidentifier) isEqualToString:identifier]) {
            return view;
        }
    }
    id obj = [NSClassFromString(classname) new];
    objc_setAssociatedObject(obj, &KTxIqaUIoasxPidentifier, identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return obj;
}

- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
{
    [[self reuseCellsIdentifierDictionary_] setObject:NSStringFromClass(cellClass) forKey:identifier];
}

- (void)registerClass:(nullable Class)aClass forHeaderViewReuseIdentifier:(NSString *)identifier;
{
    [[self reuseHeaderIdentifierDictionary_] setObject:NSStringFromClass(aClass) forKey:identifier];
}

- (void)registerClass:(nullable Class)aClass forFooterViewReuseIdentifier:(NSString *)identifier;
{
    [[self reuseFooterIdentifierDictionary_] setObject:NSStringFromClass(aClass) forKey:identifier];
}

- (void)registerClassUnReuse:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
{
    [[self reuseUnReuseCellsIdentifierDictionary_] setObject:NSStringFromClass(cellClass) forKey:identifier];
}

#pragma mark -
-(SectionMash *)addNewSection:(NSUInteger)section
{
    SectionMash *semash = [SectionMash new];
    { //section header
        CGFloat sectionHeaderHeight = [self getHeaderViewHeightFromDataSource:section];
        SubMash *mash = [SubMash new];
        mash.height = sectionHeaderHeight;
        mash.type = SECTION_Header;
        mash.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        mash.insert = UIEdgeInsetsZero;
        semash.header = mash;
    }
    
    
    { // section cells
        NSUInteger numofrowsinsection = [[[self numberOfRows_] objectAtIndex:section] integerValue];
        for (int row = 0; row<numofrowsinsection; row++) {
            SubMash *mash = [self addNewCell:row section:section];
            [semash.cells addObject:mash];
        }
    }
    
    { // section footer
        CGFloat sectionFooterHeight = [self getFooterViewHeightFromDataSource:section];
        SubMash *mash = [SubMash new];
        mash.height = sectionFooterHeight;
        mash.type = SECTION_Header;
        mash.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        mash.insert = UIEdgeInsetsZero;
        semash.footer = mash;
    }
    return semash;
}

-(SubMash *)addNewCell:(NSUInteger)row section:(NSUInteger)section
{
    CGFloat sectoncellheight = [self getCellViewHeightFromDataSource:[NSIndexPath indexPathForRow:row inSection:section]];
    UIEdgeInsets sectioncellinsert = [self getCellViewInsertFromDataSource:[NSIndexPath indexPathForRow:row inSection:section]];
    SubMash *mash = [SubMash new];
    mash.height = sectoncellheight;
    mash.type = SECTION_Cell;
    mash.insert = sectioncellinsert;
    mash.indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    return mash;
}

#pragma mark -
-(void)displayMash:(SubMash *)mash
{
    UIView *content = mash.content;
    NSString *identifier = nil;
    NSString* classname = nil;
    CGRect rect = CGRectZero;
    if (mash) {
        mash.loaded = YES;
        switch (mash.type) {
            case SCROLL_Header:
                rect.origin.x = 0;
                rect.origin.y = mash.range.topline;
                rect.size.width = CGRectGetWidth(self.bounds);
                rect.size.height = mash.height;
                mash.content.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
                mash.container.frame = rect;
                [mash.container addSubview:mash.content];
                
                break;
            case SCROLL_Footer:
                rect.origin.x = 0;
                rect.origin.y = mash.range.topline;
                rect.size.width = CGRectGetWidth(self.bounds);
                rect.size.height = mash.height;
                mash.content.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
                mash.container.frame = rect;
                [mash.container addSubview:mash.content];
                
                break;
            case SECTION_Header:
                rect.origin.x = 0;
                rect.origin.y = mash.range.topline;
                rect.size.width = CGRectGetWidth(self.bounds);
                rect.size.height = mash.height;
                mash.content.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
                mash.container.frame = rect;
                [mash.container addSubview:mash.content];
                identifier = objc_getAssociatedObject(content, &PTxIqaUIoasxPidentifier);
                classname = [[self reuseCellsIdentifierDictionary_] objectForKey:identifier];
                if ([content isKindOfClass:NSClassFromString(classname)]) {
                    [[self unusingSectionHeaderArray_] removeObject:mash.content];
                    [[self usingSectionHeaderArray_] addObject:mash.content];
                }
                break;
            case SECTION_Footer:
                rect.origin.x = 0;
                rect.origin.y = mash.range.topline;
                rect.size.width = CGRectGetWidth(self.bounds);
                rect.size.height = mash.height;
                mash.content.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
                mash.container.frame = rect;
                [mash.container addSubview:mash.content];
                
                identifier = objc_getAssociatedObject(content, &KTxIqaUIoasxPidentifier);
                classname = [[self reuseCellsIdentifierDictionary_] objectForKey:identifier];
                if ([content isKindOfClass:NSClassFromString(classname)]) {
                    [[self unusingSectionFooterArray_] removeObject:mash.content];
                    [[self usingSectionFooterArray_] addObject:mash.content];
                }
                break;
            case SECTION_Cell:
                
                rect.origin.x = mash.insert.left;
                rect.origin.y = mash.range.topline;
                rect.size.width = CGRectGetWidth(self.bounds)-mash.insert.left-mash.insert.right;
                rect.size.height = mash.height;
                mash.content.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
                mash.container.frame = rect;
                [mash.container addSubview:mash.content];
                
                identifier = objc_getAssociatedObject(content, &HTxIqaUIoasxPidentifier);
                classname = [[self reuseCellsIdentifierDictionary_] objectForKey:identifier];
                if ([content isKindOfClass:NSClassFromString(classname)]) {
                    [[self unusingCellsArray_] removeObject:mash.content];
                    [[self usingCellsArray_] addObject:mash.content];
                }
                break;
            default:
                break;
        }
        
        if (mash.content)
        {
            [mash.container addSubview:mash.content];
            [self addSubview:mash.container];
        }
        
        
        ///////////insert,reload,delete 动画
        CGFloat offsety = 0;
        CGFloat topline = offsety + self.contentInset.top;
        CGFloat bottomline = self.frame.size.height + topline;
        if (mash.appear) {
            switch (mash.animate) {
                case SubMashRowAnimationFade:
                    mash.content.alpha = 0;
                    break;
                case SubMashRowAnimationRight:
                    mash.content.transform = CGAffineTransformMakeTranslation(self.frame.size.width, 0);
                    break;
                case SubMashRowAnimationLeft:
                    mash.content.transform = CGAffineTransformMakeTranslation(-self.frame.size.width, 0);
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
            if (mash.animate!=UITableViewRowAnimationNone) {
                [UIView animateWithDuration:ANIMATE_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    mash.content.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    
                }];
            }else
                mash.content.transform = CGAffineTransformIdentity;
            
        }
        else
        {
            if (mash.animate==UITableViewRowAnimationNone) {
                [self endDisplayMash:mash];
            }else
            {
                [UIView animateWithDuration:ANIMATE_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    switch (mash.animate) {
                        case SubMashRowAnimationFade:
                            mash.content.alpha = 0;
                            break;
                        case SubMashRowAnimationRight:
                            mash.content.transform = CGAffineTransformMakeTranslation(self.frame.size.width, 0);
                            break;
                        case SubMashRowAnimationLeft:
                            mash.content.transform = CGAffineTransformMakeTranslation(-self.frame.size.width, 0);
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
                    [self endDisplayMash:mash];
                }];
            }
        }
    }
    
}

-(void)endDisplayMash:(SubMash *)mash
{
    if (mash) {
        mash.loaded = NO;
        UIView *content = mash.content;
        NSString *identifier = nil;
        NSString* classname = nil;
        switch (mash.type) {
            case SECTION_Header:
                identifier = objc_getAssociatedObject(content, &PTxIqaUIoasxPidentifier);
                classname = [[self reuseCellsIdentifierDictionary_] objectForKey:identifier];
                if ([content isKindOfClass:NSClassFromString(classname)]) {
                    [[self usingSectionHeaderArray_] removeObject:mash.content];
                    [[self unusingSectionHeaderArray_] addObject:mash.content];
                }
                break;
            case SECTION_Footer:
                identifier = objc_getAssociatedObject(content, &KTxIqaUIoasxPidentifier);
                classname = [[self reuseCellsIdentifierDictionary_] objectForKey:identifier];
                if ([content isKindOfClass:NSClassFromString(classname)]) {
                    [[self usingSectionFooterArray_] removeObject:mash.content];
                    [[self unusingSectionFooterArray_] addObject:mash.content];
                }
                break;
            case SECTION_Cell:
                identifier = objc_getAssociatedObject(content, &HTxIqaUIoasxPidentifier);
                classname = [[self reuseCellsIdentifierDictionary_] objectForKey:identifier];
                if ([content isKindOfClass:NSClassFromString(classname)]) {
                    [[self usingCellsArray_] removeObject:mash.content];
                    [[self unusingCellsArray_] addObject:mash.content];
                }
                break;
            default:
                break;
        }
        if (!self.disableReuseCells) {
            [mash.container removeFromSuperview];
            [mash.content removeFromSuperview];
            mash.content = nil;
        }
    }
    
}

#pragma mark -
-(void)willDispalyScrollHeader:(UIView *)header
{
    if (self.ifmScrollDelegate && [self.imfScrollDatasource respondsToSelector:@selector(imfScroll:willDisplayScrollHeader:)] && header) {
        [self.ifmScrollDelegate imfScroll:self willDisplayScrollHeader:header];
    }
}
-(void)didDispalyScrollHeader:(UIView *)header
{
    if (self.ifmScrollDelegate && [self.imfScrollDatasource respondsToSelector:@selector(imfScroll:didEndDisplayScrollHeader:)] && header) {
        [self.ifmScrollDelegate imfScroll:self didEndDisplayScrollHeader:header];
    }
}

-(void)willDispalyScrollFooter:(UIView *)footer;
{
    if (self.ifmScrollDelegate && [self.imfScrollDatasource respondsToSelector:@selector(imfScroll:willDisplayScrollFooter:)] && footer) {
        [self.ifmScrollDelegate imfScroll:self willDisplayScrollFooter:footer];
    }
}

-(void)didDispalyScrollFootder:(UIView *)footer;
{
    if (self.ifmScrollDelegate && [self.imfScrollDatasource respondsToSelector:@selector(imfScroll:didEndDisplayScrollFooter:)] && footer) {
        [self.ifmScrollDelegate imfScroll:self didEndDisplayScrollFooter:footer];
    }
}

-(void)willDispalySectionHeader:(UIView *)header section:(NSUInteger)section
{
    if (self.ifmScrollDelegate && [self.imfScrollDatasource respondsToSelector:@selector(imfScroll:willDisplaySectionHeaderView:forSection:)] && header) {
        [self.ifmScrollDelegate imfScroll:self willDisplaySectionHeaderView:header forSection:section];
    }
}

-(void)didDispalySectionHeader:(UIView *)header section:(NSUInteger)section
{
    if (self.ifmScrollDelegate && [self.imfScrollDatasource respondsToSelector:@selector(imfScroll:didEndDisplayingSectionHeaderView:forSection:)] && header) {
        [self.ifmScrollDelegate imfScroll:self didEndDisplayingSectionHeaderView:header forSection:section];
    }
}

-(void)willDispalySectionFooter:(UIView *)footer section:(NSUInteger)section
{
    if (self.ifmScrollDelegate && [self.imfScrollDatasource respondsToSelector:@selector(imfScroll:willDisplaySectionFooterView:forSection:)] && footer) {
        [self.ifmScrollDelegate imfScroll:self willDisplaySectionFooterView:footer forSection:section];
    }
}

-(void)didDispalySectionFooter:(UIView *)footer section:(NSUInteger)section
{
    if (self.ifmScrollDelegate && [self.imfScrollDatasource respondsToSelector:@selector(imfScroll:didEndDisplayingSectionFooterView:forSection:)] && footer) {
        [self.ifmScrollDelegate imfScroll:self didEndDisplayingSectionFooterView:footer forSection:section];
    }
}



-(void)willDispalyCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath
{
    if (self.ifmScrollDelegate && [self.imfScrollDatasource respondsToSelector:@selector(imfScroll:willDisplayCell:forRowAtIndexPath:)] && cell) {
        [self.ifmScrollDelegate imfScroll:self willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

-(void)didDispalycell:(UIView *)cell indexPath:(NSIndexPath *)indexPath
{
    if (self.ifmScrollDelegate && [self.imfScrollDatasource respondsToSelector:@selector(imfScroll:didEndDisplayingCell:forRowAtIndexPath:)] && cell) {
        [self.ifmScrollDelegate imfScroll:self didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}

#pragma mark -
-(CGFloat)getHeaderViewHeightFromDataSource:(NSUInteger)section
{
    if ([self.imfScrollDatasource respondsToSelector:@selector(imfScroll:heightForHeaderInSection:)])
        return [self.imfScrollDatasource imfScroll:self heightForHeaderInSection:section];
    return 0;
}

-(UIView *)getHeaderViewFromDataSource:(NSUInteger)section
{
    if ([self.imfScrollDatasource respondsToSelector:@selector(imfScroll:viewForHeaderInSection:)])
        return [self.imfScrollDatasource imfScroll:self viewForHeaderInSection:section];
    return nil;
}


-(CGFloat)getFooterViewHeightFromDataSource:(NSUInteger)section;
{
    if ([self.imfScrollDatasource respondsToSelector:@selector(imfScroll:heightForFooterInSection:)])
        return [self.imfScrollDatasource imfScroll:self heightForFooterInSection:section];
    return 0;
}

-(UIView *)getFooterViewFromDataSource:(NSUInteger)section;
{
    if ([self.imfScrollDatasource respondsToSelector:@selector(imfScroll:viewForFooterInSection:)]) {
        return [self.imfScrollDatasource imfScroll:self viewForFooterInSection:section];
    }
    return nil;
}



-(CGFloat)getCellViewHeightFromDataSource:(NSIndexPath *)indexpath
{
    if ([self.imfScrollDatasource respondsToSelector:@selector(imfScroll:heightForRowAtIndexPath:)]) {
        return [self.imfScrollDatasource imfScroll:self heightForRowAtIndexPath:indexpath];;
    }
    return 0;
}

-(UIView *)getCellViewFromDataSource:(NSIndexPath *)indexpath
{
    if ([self.imfScrollDatasource respondsToSelector:@selector(imfScroll:cellForRowAtIndexPath:)]) {
        return [self.imfScrollDatasource imfScroll:self cellForRowAtIndexPath:indexpath];
    }
    return nil;
}

-(UIEdgeInsets)getCellViewInsertFromDataSource:(NSIndexPath *)indexpath
{
    if ([self.imfScrollDatasource respondsToSelector:@selector(imfScroll:cellInsertAtIndexPath:)]) {
        return [self.imfScrollDatasource imfScroll:self cellInsertAtIndexPath:indexpath];
    }
    return UIEdgeInsetsZero;
}

-(NSUInteger)getNumberOfSectionsFromDataSource
{
    if ([self.imfScrollDatasource respondsToSelector:@selector(numberOfSectionsInimfScroll:)]) {
        return [self.imfScrollDatasource numberOfSectionsInimfScroll:self];
    }
    return 1;
}

-(NSUInteger)getNumberOfRowsInSectionFromDataSource:(NSUInteger)section
{
    if ([self.imfScrollDatasource respondsToSelector:@selector(imfScroll:numberOfRowsInSection:)])
    {
        return [self.imfScrollDatasource imfScroll:self numberOfRowsInSection:section];
    }
    return 0;
}

#pragma mark -
-(void)setImfScrollViewHeader:(UIView *)imfScrollViewHeader
{
    self.scrollViewHeader = imfScrollViewHeader;
}

-(void)setImfScrollViewFooter:(UIView *)imfScrollViewFooter
{
    self.scrollViewFooter = imfScrollViewFooter;
}

-(UIView *)imfScrollViewHeader
{
    return self.scrollViewHeader;
}

-(UIView *)imfScrollViewFooter
{
       return self.scrollViewFooter;
}


#pragma mark -
-(NSArray *)visibleCells;
{
    return [self usingCellsArray_].allObjects;
}
-(NSArray *)visibleHeaders;
{
    return [self usingSectionHeaderArray_].allObjects;
}
-(NSArray *)visibleFooters;
{
    return [self usingSectionFooterArray_].allObjects;
}
-(NSIndexPath *)indexPathForCell:(UIView *)cell;
{
    for (SubMash *msh in [[self scrollMash_] scrollMashTotal_]) {
        if (msh.content==cell) {
            return msh.indexPath;
        }
    }
    return nil;
}

- (UIView *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    SubMash *mash = [[self scrollMash_] scrollMashSections_][indexPath.section].cells[indexPath.row];
    return (id)mash.content;
}

-(NSUInteger)numberOfRowsInSection:(NSInteger)section;
{
    NSUInteger numofrowsinsection = [[[self numberOfRows_] objectAtIndex:section] integerValue];
    return numofrowsinsection;
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
{
    SubMash *mash = [[self scrollMash_] scrollMashSections_][indexPath.section].cells[indexPath.row];
    CGPoint point = self.contentOffset;
    CGRect frame = CGRectMake(0, mash.range.topline, self.bounds.size.width, mash.height);
    switch (scrollPosition) {
        case UITableViewScrollPositionNone:
            return;
            break;
        case UITableViewScrollPositionTop:
            point.y = CGRectGetMinY(frame)-self.contentInset.top;
            break;
        case UITableViewScrollPositionMiddle:
            point.y = CGRectGetMidY(frame)-CGRectGetMidY(self.frame)-self.contentInset.top;
            break;
        case UITableViewScrollPositionBottom:
            point.y =  CGRectGetMaxY(frame)-CGRectGetHeight(self.frame)-self.contentInset.top                         ;
            break;
        default:
            break;
    }
    [self setContentOffset:point animated:animated];
}

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
{
    NSMutableArray *tempArr = [NSMutableArray new];
    numberOfSections = [self getNumberOfSectionsFromDataSource];
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger numrows = [self getNumberOfRowsInSectionFromDataSource:idx];
        [[self numberOfRows_] insertObject:@(numrows) atIndex:idx];
        SectionMash *sms = [self addNewSection:idx];
        [[self scrollMash_] insertScrollSection:sms atIndex:idx];
        [tempArr addObject:sms.header];
        [tempArr addObjectsFromArray:sms.cells];
        [tempArr addObject:sms.footer];
    }];
    CGFloat totalheight = 0;
    for (SubMash *sm in [[self scrollMash_] scrollMashTotal_]) {
        totalheight = [sm setMashRangeWithBotm:totalheight];
    }
    for (int section = 0; section<[[self scrollMash_] scrollMashSections_].count; section++) {
        SubMash *header = [[self scrollMash_] scrollMashSections_][section].header;
        header.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        for (int row = 0; row<[[self scrollMash_] scrollMashSections_][section].cells.count; row++) {
            SubMash *sm = [[self scrollMash_] scrollMashSections_][section].cells[row];
            sm.indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        }
        SubMash *footer = [[self scrollMash_] scrollMashSections_][section].footer;
        footer.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    }
    self.contentSize = CGSizeMake(self.bounds.size.width, totalheight);
    [self catchUI:tempArr animate:animation appear:YES];
    
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
{
    NSMutableArray *tempArr = [NSMutableArray new];
    numberOfSections = [self getNumberOfSectionsFromDataSource];
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        SectionMash *sms = [[self scrollMash_] scrollMashSections_][idx];
        [tempArr addObject:sms.header];
        [tempArr addObjectsFromArray:sms.cells];
        [tempArr addObject:sms.footer];
        
        [[self scrollMash_] deleteScrollSectionAtIndex:idx];
    }];
    CGFloat totalheight = 0;
    for (SubMash *sm in [[self scrollMash_] scrollMashTotal_]) {
        totalheight = [sm setMashRangeWithBotm:totalheight];
    }
    for (int section = 0; section<[[self scrollMash_] scrollMashSections_].count; section++) {
        SubMash *header = [[self scrollMash_] scrollMashSections_][section].header;
        header.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        for (int row = 0; row<[[self scrollMash_] scrollMashSections_][section].cells.count; row++) {
            SubMash *sm = [[self scrollMash_] scrollMashSections_][section].cells[row];
            sm.indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        }
        SubMash *footer = [[self scrollMash_] scrollMashSections_][section].footer;
        footer.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    }
    self.contentSize = CGSizeMake(self.bounds.size.width, totalheight);
    [self catchUI:tempArr animate:animation appear:NO];
}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
{
    NSMutableArray *tempArr = [NSMutableArray new];
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger numrows = [self getNumberOfRowsInSectionFromDataSource:idx];
        [[self numberOfRows_] replaceObjectAtIndex:idx withObject:@(numrows)];

        SectionMash *sms = [self addNewSection:idx];
        [[self scrollMash_] replaceScrollSection:sms atIndex:idx];
        
        [tempArr addObject:sms.header];
        [tempArr addObjectsFromArray:sms.cells];
        [tempArr addObject:sms.footer];
    }];
    
    CGFloat totalheight = 0;
    for (SubMash *sm in [[self scrollMash_] scrollMashTotal_]) {
        totalheight = [sm setMashRangeWithBotm:totalheight];
    }
    for (int section = 0; section<[[self scrollMash_] scrollMashSections_].count; section++) {
        SubMash *header = [[self scrollMash_] scrollMashSections_][section].header;
        header.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        for (int row = 0; row<[[self scrollMash_] scrollMashSections_][section].cells.count; row++) {
            SubMash *sm = [[self scrollMash_] scrollMashSections_][section].cells[row];
            sm.indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        }
        SubMash *footer = [[self scrollMash_] scrollMashSections_][section].footer;
        footer.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    }
    self.contentSize = CGSizeMake(self.bounds.size.width, totalheight);
    [self catchUI:tempArr animate:animation appear:YES];
}

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
{
    NSMutableArray *tempArr = [NSMutableArray new];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger numrows = [self getNumberOfRowsInSectionFromDataSource:obj.section];
        [[self numberOfRows_] replaceObjectAtIndex:obj.section withObject:@(numrows)];
        
        SubMash *mash = [self addNewCell:obj.row section:obj.section];
        [[self scrollMash_] insertScrollCell:mash atIndexPath:obj];
        [tempArr addObject:mash];
    }];
    
    CGFloat totalheight = 0;
    for (SubMash *sm in [[self scrollMash_] scrollMashTotal_]) {
        totalheight = [sm setMashRangeWithBotm:totalheight];
    }
    for (int section = 0; section<[[self scrollMash_] scrollMashSections_].count; section++) {
        SubMash *header = [[self scrollMash_] scrollMashSections_][section].header;
        header.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        for (int row = 0; row<[[self scrollMash_] scrollMashSections_][section].cells.count; row++) {
            SubMash *sm = [[self scrollMash_] scrollMashSections_][section].cells[row];
            sm.indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        }
        SubMash *footer = [[self scrollMash_] scrollMashSections_][section].footer;
        footer.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    }
    self.contentSize = CGSizeMake(self.bounds.size.width, totalheight);
    [self catchUI:tempArr animate:animation appear:YES];
}

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
{
    NSMutableArray *tempArr = [NSMutableArray new];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger numrows = [self getNumberOfRowsInSectionFromDataSource:obj.section];
        [[self numberOfRows_] replaceObjectAtIndex:obj.section withObject:@(numrows)];
        SubMash *sm = [[self scrollMash_] scrollMashSections_][obj.section].cells[obj.row];
        [tempArr addObject:sm];
        [[self scrollMash_] deleteScrollCellAtIndexPath:obj];
    }];
    
    CGFloat totalheight = 0;
    for (SubMash *sm in [[self scrollMash_] scrollMashTotal_]) {
        totalheight = [sm setMashRangeWithBotm:totalheight];
    }
    for (int section = 0; section<[[self scrollMash_] scrollMashSections_].count; section++) {
        SubMash *header = [[self scrollMash_] scrollMashSections_][section].header;
        header.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        for (int row = 0; row<[[self scrollMash_] scrollMashSections_][section].cells.count; row++) {
            SubMash *sm = [[self scrollMash_] scrollMashSections_][section].cells[row];
            sm.indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        }
        SubMash *footer = [[self scrollMash_] scrollMashSections_][section].footer;
        footer.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    }
    self.contentSize = CGSizeMake(self.bounds.size.width, totalheight);
    [self catchUI:tempArr animate:animation appear:NO];
}

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
{
    NSMutableArray *tempArr = [NSMutableArray new];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger numrows = [self getNumberOfRowsInSectionFromDataSource:obj.section];
        [[self numberOfRows_] replaceObjectAtIndex:obj.section withObject:@(numrows)];
        SubMash *mash = [self addNewCell:obj.row section:obj.section];
        [[self scrollMash_] replaceScrollCell:mash atIndexpath:obj];
        [tempArr addObject:mash];
    }];
    
    CGFloat totalheight = 0;
    for (SubMash *sm in [[self scrollMash_] scrollMashTotal_]) {
        totalheight = [sm setMashRangeWithBotm:totalheight];
    }
    for (int section = 0; section<[[self scrollMash_] scrollMashSections_].count; section++) {
        SubMash *header = [[self scrollMash_] scrollMashSections_][section].header;
        header.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        for (int row = 0; row<[[self scrollMash_] scrollMashSections_][section].cells.count; row++) {
            SubMash *sm = [[self scrollMash_] scrollMashSections_][section].cells[row];
            sm.indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        }
        SubMash *footer = [[self scrollMash_] scrollMashSections_][section].footer;
        footer.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    }
    self.contentSize = CGSizeMake(self.bounds.size.width, totalheight);
    [self catchUI:tempArr animate:animation appear:YES];
}

#pragma mark - important
-(NSMutableArray *)nearestLeft:(NSArray *)total top:(CGFloat)topline bot:(CGFloat)bottomline
{
    NSMutableArray *temp = [NSMutableArray new];
    NSMutableArray *temp1 = [NSMutableArray new];
    NSMutableArray *temp2 = [NSMutableArray new];
    [temp addObject:temp1];
    [temp addObject:temp2];
    for (NSInteger i=0; i<total.count; i++) {
        SubMash *msh = total[i];
        CGFloat centerC = fabs((msh.range.bottomline-msh.range.topline)/2.);
        CGFloat centerT = fabs((bottomline-topline)/2.);
        CGFloat maxO = (fabs(fmin(msh.range.topline, topline)-fmax(msh.range.bottomline, bottomline)))/2.;
        
        if ((centerT+centerC)>=maxO && !msh.loaded) {// nead load
            [temp1 addObject:msh];
        }
        if ((centerT+centerC)<maxO && msh.loaded) { // nead unload
            [temp2 addObject:msh];
        }
        if ((centerT+centerC)<maxO && !msh.loaded) { //none
            
        }
    }
    return temp;
}

@end
