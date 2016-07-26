//
//  ViewController.m
//  UITableView折叠
//
//  Created by xiaozai on 15/11/24.
//  Copyright (c) 2015年 xiaozai. All rights reserved.
//

#import "ViewController.h"
#import "GroupModel.h"

/*
    折叠的思路:  
        1,每一个组的组头视图应该可以响应点击
        2,对每个组头视图的点击应变切换一个状态(收起或展开,所以需要一个变量(放在组数据模型中)记录这个状态)
        3, 在代理方法 -(NSUInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSUInteger)section   
            中根据状态来返回组中的数据行数
            如果收起状态，就返回0
            否则返回正常的行数
 */

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataModel;
}

@property (nonatomic ,assign)NSInteger page;
@property (nonatomic ,strong)NSMutableArray *isopenArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isopenArr = [NSMutableArray array];
    [self initData];
    [self initUI];
}

-(void)initData{
    _dataModel=[NSMutableArray new];
    for (char section='A'; section<='Z'; section++) {
        GroupModel* group =[GroupModel new];
        
        for (int row=0; row<10; row++) {
            [group.contents addObject:[NSString stringWithFormat:@"%c%i",section,row]];
        }
        [_dataModel addObject:group];
    }
    //只展示一行的逻辑
    for (int i =0 ;i < _dataModel.count; i++) {
        [self.isopenArr addObject:[NSNumber numberWithBool:NO]];
    }
}

-(void)initUI{
    CGRect frame =self.view.bounds;
    frame.origin.y+=20;
    frame.size.height-=20;
    _tableView =[[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
}

#pragma mark -定制组头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIButton* button =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.backgroundColor=[UIColor colorWithRed:0.149 green:1.000 blue:0.942 alpha:1.000]
    ;
    button.frame=CGRectMake(0, 0, tableView.bounds.size.width, 44);
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:[[_dataModel[section] contents][0] substringToIndex:1] forState:UIControlStateNormal];
    // 让button带了section传入事件方法中
    button.tag=section;
    NSLog(@"dianzhongl :%ld",(long)button.tag);
    return button;
}

#pragma mark -返回组标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    GroupModel* group =_dataModel[section];
    NSString* firstData =group.contents[0];
    return [firstData substringToIndex:1];
}

-(void)buttonClicked:(UIButton*)btn{
    NSLog(@"点击了第%ld个",(long)btn.tag);
    NSLog(@"section %ld",(long)self.page);
    btn.selected = !btn.selected;
 //展示多行的逻辑
//    GroupModel *group =_dataModel[btn.tag];
//    [group setSpreadOut:!group.isSpreadOut];
    
    NSNumber *number = self.isopenArr[btn.tag];
    //    btn.selected = !btn.selected;
    if (number.boolValue) {
        NSNumber *numerNO = [NSNumber numberWithBool:NO];
        self.isopenArr[btn.tag] = numerNO;
    } else {
        for (int i = 0; i < self.isopenArr.count; i ++) {
            if ( i == btn.tag) {
                NSNumber *numYES = [NSNumber numberWithBool:YES];
                self.isopenArr[btn.tag] = numYES;
            } else {
                NSNumber *numNO = [NSNumber numberWithBool:NO];
                self.isopenArr[i] =numNO;
            }
        }
    }
    
    [_tableView reloadData];
}

#pragma mark -必备的代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* identifier =@"cell";
    UITableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text=[_dataModel[indexPath.section] contents][indexPath.row];
    return cell;
}

#pragma mark -返回每组的行数(折叠效果的逻辑主要是在这里)
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//[_dataModel[section] isSpreadOut ]
    NSNumber *num = self.isopenArr[section];
    if (num.boolValue) {
        // 否则返回0 表示收起
        return [[_dataModel[section] contents] count];
        
    }else{
        // 如果是展开， 返回正常行数
        return 0;
    }
}

#pragma mark -分组样式需要实现的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataModel.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
