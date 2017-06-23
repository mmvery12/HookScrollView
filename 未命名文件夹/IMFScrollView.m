//
//  ArticleScrollView.m
//  Template
//
//  Created by liyuchang on 16/3/15.
//  Copyright © 2016年 liyuchang. All rights reserved.
//

#import "IMFScrollView.h"
#import <objc/runtime.h>
#import "Mash.h"
const NSString * HTxIqaUIoasxPidentifier = @"HTxIqaUIoasxPidentifier";
const NSString * PTxIqaUIoasxPidentifier = @"PTxIqaUIoasxPidentifier";
const NSString * KTxIqaUIoasxPidentifier = @"KTxIqaUIoasxPidentifier";


@interface IMFScrollView ()<UIScrollViewDelegate,CAAnimationDelegate>
{
    
    dispatch_queue_t scrollqueue;
    
    NSMutableDictionary *reuseCellsIdentifierDictionary;
    NSMutableDictionary *reuseUnReuseCellsIdentifierDictionary;
    NSMutableDictionary *reuseHeaderIdentifierDictionary;
    NSMutableDictionary *reuseFooterIdentifierDictionary;
    
    NSUInteger numberOfSections;
    NSMutableArray *numberOfRows;
    
    NSMutableSet *usingMashArray;
    
    NSMutableSet * usingCellsArray;
    NSMutableSet * usingSectionHeaderArray;
    NSMutableSet * usingSectionFooterArray;
    
    NSMutableSet *unusingCellsArray;
    NSMutableSet *unusingSectionHeaderArray;
    NSMutableSet *unusingSectionFooterArray;
    
    ScrollMash *scrollMash;

    BOOL isLoad;
    Range *animaterange;
    
    BOOL know;
}

@end

@implementation IMFScrollView

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


-(NSMutableSet *)usingMashArray_
{
    if (!usingMashArray) {
        usingMashArray = [NSMutableSet new];
    }
    return usingMashArray;
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
    return 0;
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
    [self catchUI:nil];
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
    if (self.imfScrollDatasource) {
        [self scrollMash_].imfScroll = self;
        __weak typeof(self) wf = self;
        [self scrollMash_].offblock = ^(SubMash *submash) {
            if (submash && submash.loaded == NeedUnload) {
                [wf endDisplayMash:submash];
            }
        };
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
        [self endDisplayMash:[[self scrollMash_] _scrollHeader]];
        [self endDisplayMash:[[self scrollMash_] _scrollFooter]];
        
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
        
        // 5. load each section header and cell and setion footer all height
        SubMash *scrollheadermash = [SubMash new];
        scrollheadermash.type = SCROLL_Header;
        scrollheadermash.height = CGRectGetHeight(self.imfScrollViewHeader.bounds);
        [[self scrollMash_] addScrollHeader:scrollheadermash];
        
        for (int section = 0; section<numberOfSections; section++) {
            SectionMash *sms = [self addNewSection:section animate:UITableViewRowAnimationNone];
            [[self scrollMash_] addScrollSection:sms];
        }
        
        SubMash *scrollfootermash = [SubMash new];
        scrollfootermash.type = SCROLL_Footer;
        scrollfootermash.height = CGRectGetHeight(self.imfScrollViewFooter.bounds);
        [[self scrollMash_] addScrollFooter:scrollfootermash];
        
        self.contentSize = [[self scrollMash_] contentSize];
        
        [self catchUI:nil];
    }
}



-(void)catchUI:(NSArray <SubMash *>*)submashArr;
{
    CGFloat offsety = 0;
    if (self.contentOffset.y>0) {
        offsety = self.contentOffset.y;
    }
    CGFloat topline = offsety + self.contentInset.top;
    CGFloat bottomline = self.frame.size.height + topline;
    
    NSMutableArray * nearestleft = [self nearestLefttop:topline bot:bottomline];
    NSMutableArray *arr1 = nearestleft[0];
    NSMutableArray *arr2 = nearestleft[1];
    NSMutableArray *arr3 = nearestleft[2];
//    if (submashArr) {
//        [arr1 addObjectsFromArray:submashArr];
//    }
    for (SubMash *neadload in arr1) {
        [self willLoadMash:neadload];
        [[self usingMashArray_] addObject:neadload];
    }
    for (SubMash *didload in arr3) {
        [[self scrollMash_] loadMashAnimate:didload];
    }
    for (SubMash *neadunload in arr2) {
        [self willUnLoadMash:neadunload];
        [[self usingMashArray_] removeObject:neadunload];
    }
}



-(void)willLoadMash:(SubMash *)mash
{
    UIView *view = nil;
    switch (mash.type) {
        case SCROLL_Header:
            view = self.scrollViewHeader;
            [self willDispalyScrollHeader:view];
            break;
        case SCROLL_Footer:
            view = self.scrollViewFooter;
            [self willDispalyScrollFooter:view];
            break;
        case SECTION_Header:
            view = [self getHeaderViewFromDataSource:mash.indexPath.section];
            [self willDispalySectionHeader:view section:mash.indexPath.section];
            break;
        case SECTION_Footer:
            view = [self getFooterViewFromDataSource:mash.indexPath.section];
            [self willDispalySectionFooter:view section:mash.indexPath.section];
            break;
        case SECTION_Cell:
            view = [self getCellViewFromDataSource:mash.indexPath];
            [self willDispalyCell:view indexPath:mash.indexPath];
            break;
        default:
            break;
    }
    mash.content = view;
    [self displayMash:mash];
}

-(void)willUnLoadMash:(SubMash *)mash
{
    switch (mash.type) {
        case SCROLL_Header:
            [self endDispalyScrollHeader:mash.content];
            break;
        case SCROLL_Footer:
            [self endDispalyScrollFootder:mash.content];
            break;
        case SECTION_Header:
            [self endDispalyScrollHeader:mash.content];
            break;
        case SECTION_Footer:
            [self endDispalyScrollFootder:mash.content];
            break;
        case SECTION_Cell:
            [self endDispalycell:mash.content indexPath:mash.indexPath];
            break;
        default:
            break;
    }
    [self endDisplayMash:mash];
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
-(SectionMash *)addNewSection:(NSUInteger)section animate:(UITableViewRowAnimation)animate
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
        mash.animate = (int)animate;
    }
    
    
    { // section cells
        NSUInteger numofrowsinsection = [[[self numberOfRows_] objectAtIndex:section] integerValue];
        for (int row = 0; row<numofrowsinsection; row++) {
            SubMash *mash = [self addNewCell:row section:section animate:animate];
            [semash.cells addObject:mash];
            mash.animate = (int)animate;
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
        mash.animate = (int)animate;
    }
    return semash;
}

-(SubMash *)addNewCell:(NSUInteger)row section:(NSUInteger)section  animate:(UITableViewRowAnimation)animate
{
    CGFloat sectoncellheight = [self getCellViewHeightFromDataSource:[NSIndexPath indexPathForRow:row inSection:section]];
    UIEdgeInsets sectioncellinsert = [self getCellViewInsertFromDataSource:[NSIndexPath indexPathForRow:row inSection:section]];
    SubMash *mash = [SubMash new];
    mash.height = sectoncellheight;
    mash.type = SECTION_Cell;
    mash.insert = sectioncellinsert;
    mash.indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    mash.animate = (int)animate;
    return mash;
}


#pragma mark -
-(void)displayMash:(SubMash *)mash
{
    UIView *content = mash.content;
    NSString *identifier = nil;
    NSString* classname = nil;
    if (mash) {
        switch (mash.type) {
            case SECTION_Header:
                identifier = objc_getAssociatedObject(content, &PTxIqaUIoasxPidentifier);
                classname = [[self reuseCellsIdentifierDictionary_] objectForKey:identifier];
                if ([content isKindOfClass:NSClassFromString(classname)]) {
                    [[self unusingSectionHeaderArray_] removeObject:mash.content];
                    [[self usingSectionHeaderArray_] addObject:mash.content];
                }
                break;
            case SECTION_Footer:
                identifier = objc_getAssociatedObject(content, &KTxIqaUIoasxPidentifier);
                classname = [[self reuseCellsIdentifierDictionary_] objectForKey:identifier];
                if ([content isKindOfClass:NSClassFromString(classname)]) {
                    [[self unusingSectionFooterArray_] removeObject:mash.content];
                    [[self usingSectionFooterArray_] addObject:mash.content];
                }
                break;
            case SECTION_Cell:
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
            mash.content.frame = mash.rect;
            [self addSubview:mash.content];
        }
        
        mash.loaded = DidLoad;
    }
}




-(void)endDisplayMash:(SubMash *)mash
{
    if (mash && (mash.type == NeedUnload) && !mash.animating) {
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
            [mash stopAnimate];
            [mash.content removeFromSuperview];
            mash.content = nil;
        }
        mash.loaded = NeedLoad;
    }
}



#pragma mark -



-(void)willDispalyScrollHeader:(UIView *)header
{
    if (self.ifmScrollDelegate && [self.imfScrollDatasource respondsToSelector:@selector(imfScroll:willDisplayScrollHeader:)] && header) {
        [self.ifmScrollDelegate imfScroll:self willDisplayScrollHeader:header];
    }
}
-(void)endDispalyScrollHeader:(UIView *)header
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

-(void)endDispalyScrollFootder:(UIView *)footer;
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

-(void)endDispalySectionHeader:(UIView *)header section:(NSUInteger)section
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

-(void)endDispalySectionFooter:(UIView *)footer section:(NSUInteger)section
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

-(void)endDispalycell:(UIView *)cell indexPath:(NSIndexPath *)indexPath
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
    SubMash *scrollheadermash = [SubMash new];
    scrollheadermash.type = SCROLL_Header;
    scrollheadermash.height = CGRectGetHeight(self.imfScrollViewHeader.bounds);
    scrollheadermash.content = imfScrollViewHeader;
    [[self scrollMash_] addScrollHeader:scrollheadermash];
}

-(void)setImfScrollViewFooter:(UIView *)imfScrollViewFooter
{
    SubMash *scrollfootermash = [SubMash new];
    scrollfootermash.type = SCROLL_Footer;
    scrollfootermash.height = CGRectGetHeight(self.imfScrollViewFooter.bounds);
    scrollfootermash.content = imfScrollViewFooter;
    [[self scrollMash_] addScrollFooter:scrollfootermash];
}

-(UIView *)imfScrollViewHeader
{
    return [[self scrollMash_] _scrollHeader].content;
}

-(UIView *)imfScrollViewFooter
{
    return [[self scrollMash_] _scrollFooter].content;
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
        SectionMash *sms = [self addNewSection:idx animate:animation];
        [[self scrollMash_] insertScrollSection:sms atIndex:idx];
        [tempArr addObject:sms.header];
        [tempArr addObjectsFromArray:sms.cells];
        [tempArr addObject:sms.footer];
    }];
    self.contentSize = [[self scrollMash_] contentSize];
    [self catchUI:tempArr];
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
{
    NSMutableArray *tempArr = [NSMutableArray new];
    numberOfSections = [self getNumberOfSectionsFromDataSource];
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        SectionMash *sms = [[self scrollMash_] scrollMashSections_][idx];
        [tempArr addObject:sms.header];
        sms.header.animate = (int)animation;
        sms.header.loaded = NeedUnload;
        [tempArr addObjectsFromArray:sms.cells];
        for (SubMash *sub in sms.cells) {
            sub.animate = (int)animation;
            sub.loaded = NeedUnload;
        }
        [tempArr addObject:sms.footer];
        sms.header.animate = (int)animation;
        sms.footer.loaded = NeedUnload;
        [[self scrollMash_] deleteScrollSectionAtIndex:idx];
    }];

    self.contentSize = [[self scrollMash_] contentSize];
    [self catchUI:tempArr];
}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
{
    
    NSMutableArray *tempArr = [NSMutableArray new];
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger numrows = [self getNumberOfRowsInSectionFromDataSource:idx];
        [[self numberOfRows_] replaceObjectAtIndex:idx withObject:@(numrows)];
        SectionMash *sms = [self addNewSection:idx animate:animation];
        [[self scrollMash_] replaceScrollSection:sms atIndex:idx];
        
        [tempArr addObject:sms.header];
        [tempArr addObjectsFromArray:sms.cells];
        [tempArr addObject:sms.footer];
    }];

    self.contentSize = [[self scrollMash_] contentSize];
    [self catchUI:tempArr];
}

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
{
    NSMutableArray *tempArr = [NSMutableArray new];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger numrows = [self getNumberOfRowsInSectionFromDataSource:obj.section];
        [[self numberOfRows_] replaceObjectAtIndex:obj.section withObject:@(numrows)];
        
        SubMash *mash = [self addNewCell:obj.row section:obj.section animate:animation];
        [[self scrollMash_] insertScrollCell:mash atIndexPath:obj];
        [tempArr addObject:mash];
    }];

    self.contentSize = [[self scrollMash_] contentSize];
    [self catchUI:tempArr];
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
        sm.animate = (int)animation;
    }];
    self.contentSize = [[self scrollMash_] contentSize];
    [self catchUI:tempArr];
}

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
{
    NSMutableArray *tempArr = [NSMutableArray new];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger numrows = [self getNumberOfRowsInSectionFromDataSource:obj.section];
        [[self numberOfRows_] replaceObjectAtIndex:obj.section withObject:@(numrows)];
        SubMash *mash = [self addNewCell:obj.row section:obj.section animate:animation];
        [[self scrollMash_] replaceScrollCell:mash atIndexpath:obj];
        [tempArr addObject:mash];
        mash.animate = (int)animation;
    }];
    self.contentSize = [[self scrollMash_] contentSize];
    [self catchUI:tempArr];
}

#pragma mark - important


-(NSMutableArray *)nearestLefttop:(CGFloat)topline bot:(CGFloat)bottomline
{
    NSMutableArray *temp = [NSMutableArray new];
    NSMutableArray *temp1 = [NSMutableArray new];
    NSMutableArray *temp2 = [NSMutableArray new];
    NSMutableArray *temp3 = [NSMutableArray new];
    [temp addObject:temp1];
    [temp addObject:temp2];
    [temp addObject:temp3];
    
    //1
    //真实地址，修正地址
    //在可见范围内有修正地址但是真实地址不再范围内的时候，也应该加载，这样可以通过真实地址作出驱动动画，反之，更应作出动画，总结，真实和修正在范围内，都应动画，
    //修正地址通过变更范围的总高度，和时间过度所应完成动画的高度得出，不同区间范围有不同的修正地址
    //如何在不具备第二哥layer的情况下，记录下动画的情况？如何记录隐式动画？
    //2
    //只有在动画cell同屏的时候才显示下面cell可能会上啦的动画
    //3
    //insert reload delete的时候，显示的cell才动画，一旦cell不在可视区域，取消动画，再次加载的时候没有动画
    NSInteger i=0;
    CGFloat centerT = fabs((bottomline-topline)/2.);
    NSUInteger left = [self binary_search_left:total top:topline bot:bottomline];
    NSUInteger right = [self binary_search_right:total top:topline bot:bottomline];
    
    for (i=left; i<right; i++) {
        SubMash *msh = total[i];
        CGFloat centerC = fabs((msh.range.bottomline-msh.range.topline)/2.);
        CGFloat maxO = (fabs(fmin(msh.range.topline, topline)-fmax(msh.range.bottomline, bottomline)))/2.;
        if ((centerT+centerC)>=maxO) {
            if (msh.loaded==NeedLoad)// nead load
            {
                [temp1 addObject:msh];
            }
        }
    }
    
    for (SubMash *msh in [self usingMashArray_]) {
        CGFloat centerC = fabs((msh.range.bottomline-msh.range.topline)/2.);
        CGFloat maxO = (fabs(fmin(msh.range.topline, topline)-fmax(msh.range.bottomline, bottomline)))/2.;
        if ((centerT+centerC)<maxO && msh.loaded==DidLoad) {// unload
            msh.loaded = NeedUnload;
            [temp2 addObject:msh];
        }
    }
    return temp;
}

-(NSInteger)binary_search_left:(NSArray <SubMash *>*)total top:(CGFloat)topline bot:(CGFloat)bottomline{
    if(total.count==0)
        return -1;
    NSInteger left=0;
    NSInteger right =total.count-1;
    NSInteger min_left=-1;
    while(left<=right)
    {
        NSInteger mid=(left+right)/2;
        
        if(total[mid].range.topline<topline){
            left=mid+1;
            continue;
        }
        if(total[mid].range.bottomline>bottomline){
            right=mid-1;
            continue;
        }
        min_left=mid;
        right=mid-1;
        if (right<0) {
            return 0;
        }
    }
    return min_left-1;
}
-(NSInteger)binary_search_right:(NSArray <SubMash *>*)total top:(CGFloat)topline bot:(CGFloat)bottomline{
    if(total.count==0)
        return -1;
    NSInteger left=0;
    NSInteger right =total.count-1;
    NSInteger max_right=-1;
    while(left<=right)
    {
        NSInteger mid=(left+right)/2;
        
        if(total[mid].range.topline<topline){
            left=mid+1;//mid+1
            continue;
        }
        
        if(total[mid].range.bottomline>bottomline){
            
            right=mid-1;
            continue;
        }
        max_right=mid;
        left=mid+1;
    }
    if (max_right+2>=total.count) {
        return total.count-1;
    }
    return max_right+2;
}




@end
