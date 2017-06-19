
#define ANIMATE_NAME @"ANIMATE_NAME"
#define ANIMATE_TIME 5
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

#pragma mark CellContainer-
@interface CellContainer : UIView
@end

#pragma mark Range-
@interface Range : NSObject
@property (nonatomic,assign)CGFloat topline;
@property (nonatomic,assign)CGFloat bottomline;
@end



typedef NS_ENUM(NSUInteger,SubMashLoadStatus)
{
    NeedLoad,
    DidLoad,
    NeedUnload
};


#pragma mark SubMash-
@interface SubMash : NSObject<CAAnimationDelegate>
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,strong)CellContainer *container;
@property (nonatomic,strong)UIView *content;
@property (nonatomic,assign)UIEdgeInsets insert;//下间距
@property (nonatomic,strong)NSString *identifier;

@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)Range *range;
@property (nonatomic,assign)SubMashType type;

@property (nonatomic,assign)SubMashAnimate animate;

@property (nonatomic,assign)SubMashLoadStatus loaded;

@property (nonatomic,copy)dispatch_block_t afterAnimateBlock;

@property (nonatomic,assign)BOOL animating;

@property (nonatomic,strong)Range *estimatedRange;

-(void)stopAnimate;
-(CGFloat)setMashRangeWithBotm:(CGFloat)botm;

-(void)animationNone;
-(void)animationFadeFrome:(NSInteger)frome to:(NSInteger)to;
-(void)animationRightFrome:(CATransform3D)frome to:(CATransform3D)to;
-(void)animationLeftFrome:(CATransform3D)frome to:(CATransform3D)to;
-(void)animationTopFrome:(CATransform3D)frome to:(CATransform3D)to;
-(void)animationBottomFrome:(CATransform3D)frome to:(CATransform3D)to;
-(void)animationMiddleFrome:(CATransform3D)frome to:(CATransform3D)to;
@end

#pragma mark SectionMash -
@interface SectionMash : NSObject
@property (nonatomic,strong)SubMash *header;
@property (nonatomic,strong)SubMash *footer;
@property (nonatomic,strong)NSMutableArray<SubMash *> *cells;
@end


#pragma mark ScrollMash-
@interface ScrollMash : NSObject
-(void)refreshTotal;
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


