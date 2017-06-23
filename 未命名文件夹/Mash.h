
#define ANIMATE_NAME @"ANIMATE_NAME"
#define ANIMATE_TIME 15
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
    
    SubMashRowAnimationMiddle,
    SubMashRowAnimationAutomatic = 100,
    SubMashRowAnimationNormal = 300
};
@class SubMash;
#pragma mark Range-
@interface Range : NSObject
@property (nonatomic,weak)SubMash *partnerMash;
@property (nonatomic,assign)CGFloat topline;
@property (nonatomic,assign)CGFloat bottomline;
@end



typedef NS_ENUM(NSUInteger,SubMashLoadStatus)
{
    NeedLoad,
    DidLoad,
    NeedUnload
};
@class ScrollMash,SubMash;
typedef void(^SubMashAnimateOffBlock)(SubMash *);

#pragma mark SubMash-
@interface SubMash : NSObject<CAAnimationDelegate>
@property (nonatomic,weak)ScrollMash *grandFather;
@property (nonatomic,weak)SubMash *fatherMash;
@property (nonatomic,weak)SubMash *childerMash;
@property (nonatomic,copy)SubMashAnimateOffBlock offblock;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,assign)CGRect rect;
@property (nonatomic,strong)UIView *content;
@property (nonatomic,assign)UIEdgeInsets insert;//下间距
@property (nonatomic,strong)NSString *identifier;

@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)Range *range;
@property (nonatomic,assign)SubMashType type;

@property (nonatomic,assign)SubMashAnimate animate;

@property (nonatomic,assign)SubMashLoadStatus loaded;

@property (nonatomic,assign)BOOL animating;
@property (nonatomic,strong)Range *estimatedRange;


-(void)stopAnimate;
//-(void)animationNone;
//-(void)animationFadeFrome:(NSInteger)frome to:(NSInteger)to;
//-(void)animationRightFrome:(CATransform3D)frome to:(CATransform3D)to;
//-(void)animationLeftFrome:(CATransform3D)frome to:(CATransform3D)to;
//-(void)animationTopFrome:(CATransform3D)frome to:(CATransform3D)to;
//-(void)animationBottomFrome:(CATransform3D)frome to:(CATransform3D)to;
//-(void)animationMiddleFrome:(CATransform3D)frome to:(CATransform3D)to;
@end

#pragma mark SectionMash -
@interface SectionMash : NSObject
@property (nonatomic,strong)SubMash *header;
@property (nonatomic,strong)SubMash *footer;
@property (nonatomic,strong)NSMutableArray<SubMash *> *cells;
@end


#pragma mark ScrollMash-
@interface ScrollMash : NSObject
@property (nonatomic,strong)NSMutableArray *totalMash;
@property (nonatomic,copy)SubMashAnimateOffBlock offblock;
@property (nonatomic,weak)UIScrollView *imfScroll;
@property (nonatomic,assign)CGSize contentSize;
@property (nonatomic,readonly)    SubMash *_scrollHeader;
@property (nonatomic,readonly)    SubMash *_scrollFooter;
-(void)setUpMash:(SubMash *)mash;
-(void)loadMashAnimate:(SubMash *)mash;

-(NSMutableArray <SectionMash *>*)scrollMashSections_;
-(SubMash *)indexPathOfMash:(NSIndexPath *)indexPath;
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

-(void)deleteSectionHeaderFooter:(SubMash *)mash atSection:(NSInteger)section;
-(void)deleteSectionCell:(SubMash *)mash atIndexPath:(NSIndexPath *)indexPath;
@end


