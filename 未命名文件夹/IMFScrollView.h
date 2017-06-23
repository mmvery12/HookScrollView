//
//  ArticleScrollView.h
//  Template
//
//  Created by liyuchang on 16/3/15.
//  Copyright © 2016年 liyuchang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMFScrollView;

@protocol ArticleScrollDelegate <NSObject>

@optional

- (void)imfScroll:(IMFScrollView *)imfScroll willDisplayScrollHeader:(UIView *)header;
- (void)imfScroll:(IMFScrollView *)imfScroll willDisplayScrollFooter:(UIView *)header;
- (void)imfScroll:(IMFScrollView *)imfScroll willDisplayCell:(UIView *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)imfScroll:(IMFScrollView *)imfScroll willDisplaySectionHeaderView:(UIView *)view forSection:(NSInteger)section;
- (void)imfScroll:(IMFScrollView *)imfScroll willDisplaySectionFooterView:(UIView *)view forSection:(NSInteger)section;

- (void)imfScroll:(IMFScrollView *)imfScroll didEndDisplayingCell:(UIView *)cell forRowAtIndexPath:(NSIndexPath*)indexPath;
- (void)imfScroll:(IMFScrollView *)imfScroll didEndDisplayingSectionHeaderView:(UIView *)view forSection:(NSInteger)section;
- (void)imfScroll:(IMFScrollView *)imfScroll didEndDisplayingSectionFooterView:(UIView *)view forSection:(NSInteger)section;
- (void)imfScroll:(IMFScrollView *)imfScroll didEndDisplayScrollHeader:(UIView *)header;
- (void)imfScroll:(IMFScrollView *)imfScroll didEndDisplayScrollFooter:(UIView *)header;


@end

@protocol ArticleScrollDataSource <NSObject>
@required
- (NSInteger)imfScroll:(IMFScrollView *)imfScroll numberOfRowsInSection:(NSInteger)section;

- (UIView *)imfScroll:(IMFScrollView *)imfScroll cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (UIEdgeInsets)imfScroll:(IMFScrollView *)imfScroll cellInsertAtIndexPath:(NSIndexPath *)indexpath;

- (NSInteger)numberOfSectionsInimfScroll:(IMFScrollView *)imfScroll;

- (CGFloat)imfScroll:(IMFScrollView *)imfScroll heightForRowInterset:(NSIndexPath *)indexPath;
- (CGFloat)imfScroll:(IMFScrollView *)imfScroll heightForHeaderInSection:(NSInteger)section;
- (CGFloat)imfScroll:(IMFScrollView *)imfScroll heightForFooterInSection:(NSInteger)section;

- (UIView *)imfScroll:(IMFScrollView *)imfScroll viewForHeaderInSection:(NSInteger)section;
- (UIView *)imfScroll:(IMFScrollView *)imfScroll viewForFooterInSection:(NSInteger)section;

- (CGFloat)imfScroll:(IMFScrollView *)imfScroll heightForRowAtIndexPath:(NSIndexPath *)indexPath;


@end

@interface IMFScrollView : UIScrollView
@property (nonatomic,weak)id<ArticleScrollDelegate> ifmScrollDelegate;
@property (nonatomic,weak)id<ArticleScrollDataSource> imfScrollDatasource;
@property (nonatomic,strong) UIView *imfScrollViewHeader;
@property (nonatomic,strong) UIView *imfScrollViewFooter;
@property (nonatomic,copy)  UIColor *cellTinColor;
@property (nonatomic,assign)BOOL disableReuseCells;

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
- (UIView *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

- (void)registerClass:(Class)aClass forHeaderViewReuseIdentifier:(NSString *)identifier;
- (UIView *)dequeueReusableHeaderViewWithIdentifier:(NSString *)identifier forSection:(NSUInteger)section;

- (void)registerClass:(Class)aClass forFooterViewReuseIdentifier:(NSString *)identifier;
- (UIView *)dequeueReusableFooterViewWithIdentifier:(NSString *)identifier forSection:(NSUInteger)section;

-(void)reloadData;

-(NSArray *)visibleCells;

-(NSArray *)visibleHeaders;

-(NSArray *)visibleFooters;

-(NSIndexPath *)indexPathForCell:(UIView *)cell;
- (UIView *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;

-(NSUInteger)numberOfRowsInSection:(NSInteger)section;

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;


- (void)registerClassUnReuse:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;


- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;


@end
