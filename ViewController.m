//
//  ViewController.m
//  Demo4
//
//  Created by JD on 2017/6/9.
//  Copyright © 2017年 LYC. All rights reserved.
//

#import "ViewController.h"
#import "IMFScrollView.h"
@interface ViewController ()<ArticleScrollDelegate,ArticleScrollDataSource,UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate>
{
    IMFScrollView *scroll;
    NSUInteger numsection;
    NSArray * nunrow;
    UIButton *btn;
    UITableView *table;
}
@end

@implementation ViewController


-(void)animationRightFrome:(CGAffineTransform)frome to:(CGAffineTransform)to
{
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    nunrow = @[@"5",@"5",@"5",@"5",@"5",@"5"];
    numsection = 9;
    if (1){
        scroll = [[IMFScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 500)];
//        scroll.disableReuseCells = YES;
        [self.view addSubview:scroll];
        scroll.layer.borderColor = [[UIColor redColor]CGColor];
        scroll.layer.borderWidth = 1.f;
        [scroll registerClass:[UITableViewCell class] forCellReuseIdentifier:@"123"];
        scroll.imfScrollViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 33)];
        scroll.imfScrollViewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 33)];
        scroll.imfScrollViewHeader.backgroundColor = [UIColor purpleColor];
        scroll.imfScrollViewFooter.backgroundColor = [UIColor purpleColor];
        scroll.imfScrollDatasource = self;
        scroll.ifmScrollDelegate = self;
    }else
    {
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 500) style:UITableViewStyleGrouped];
        [self.view addSubview:table];
        table.delegate = self;
        table.dataSource = self;
        table.layer.borderColor = [[UIColor redColor]CGColor];
        table.layer.borderWidth = 1.f;
        [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"123"];
        table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 33)];
        table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 33)];
        table.tableHeaderView.backgroundColor = [UIColor purpleColor];
        table.tableFooterView.backgroundColor = [UIColor purpleColor];
    }
    
    btn = [UIButton new];
    btn.frame = CGRectMake(0, 500, 44, 44);
    btn.backgroundColor = [UIColor greenColor];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(xxx) forControlEvents:UIControlEventTouchUpInside];
    CABasicAnimation *anio = [CABasicAnimation animationWithKeyPath:@"transform"];
    anio.removedOnCompletion = NO;
    anio.duration = 10;
    anio.fillMode = kCAFillModeForwards;
    anio.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anio.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 700, 0)];
    anio.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    [btn.layer addAnimation:anio forKey:@"123"];
    anio.delegate = self;
}

-(void)remove
{
    [btn removeFromSuperview];
    btn = nil;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{

}
-(void)xxx
{
    nunrow = @[@"5",@"5",@"5",@"5",@"5"];
    numsection = 9;
//    [table deleteSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationRight];
//    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:5] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    [scroll insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
//    [scroll deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
}

- (CGFloat)imfScroll:(IMFScrollView *)imfScroll heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 50;
}

- (NSInteger)imfScroll:(IMFScrollView *)imfScroll numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

-(CGFloat)imfScroll:(IMFScrollView *)imfScroll heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(UIView *)imfScroll:(IMFScrollView *)imfScroll viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

-(NSInteger)numberOfSectionsInimfScroll:(IMFScrollView *)imfScroll
{
    return numsection;
}

- (UIEdgeInsets)imfScroll:(IMFScrollView *)imfScroll cellInsertAtIndexPath:(NSIndexPath *)indexpath;
{
    return UIEdgeInsetsMake(20, 5, 10, 10);
}

- (UIView *)imfScroll:(IMFScrollView *)imfScroll cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    UIView *cell = [imfScroll dequeueReusableCellWithIdentifier:@"123" forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor greenColor].CGColor;
    cell.layer.backgroundColor = [UIColor yellowColor].CGColor;
    cell.layer.borderWidth = .5f;
    UILabel *label = [cell viewWithTag:1009];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 33)];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 1009;
        [cell addSubview:label];
    }
    label.text = [NSString stringWithFormat:@"row %ld section %ld",indexPath.row,indexPath.section];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return numsection;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 33;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"123" forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor greenColor].CGColor;
    cell.layer.backgroundColor = [UIColor yellowColor].CGColor;
    cell.layer.borderWidth = .5f;
    UILabel *label = [cell viewWithTag:1009];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 33)];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 1009;
        [cell addSubview:label];
    }
    label.text = [NSString stringWithFormat:@"row %ld section %ld",indexPath.row,indexPath.section];
    return cell;
}


@end
