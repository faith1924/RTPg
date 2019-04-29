//
//  CGScoreTB.m
//  CGColorGame
//
//  Created by md212 on 2019/4/18.
//  Copyright © 2019年 cyg. All rights reserved.
//

#import "CGScoreTB.h"
#import "JYCommonObjc.h"

#define cellID @"cellID"

@interface CGScoreTB ()

@property (strong , nonatomic) NSMutableArray * dataArr;

@property (strong , nonatomic) NSMutableDictionary * dataDic;

@property (strong , nonatomic) UIBarButtonItem * rightBarBtn;

@property (assign) BOOL isUser;

@end

@implementation CGScoreTB

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isUser = YES;
    
    UIImage * rightImage = [UIImage imageNamed:@"subscription_article_detail_more"];
    rightImage = [rightImage imageWithRenderingMode:UIImageRenderingModeAutomatic];
    
    _rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"排行榜" style:UIBarButtonItemStylePlain target:self action:@selector(shareList)];
    self.navigationItem.rightBarButtonItem = _rightBarBtn;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"历史得分";
    _dataArr = [JYCommonObjc getScoreArr:[JYCommonObjc getUserName]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:[CGScoreTBCell class] forCellReuseIdentifier:cellID];
    
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
    footView.backgroundColor = [UIColor grayColor];
    self.tableView.tableFooterView = footView;
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
    headerView.backgroundColor = [UIColor grayColor];
    self.tableView.tableHeaderView = headerView;
}

- (void)shareList{
    NSString * title = @"";
    NSString * btnTitle = @"";
    _isUser = !_isUser;
    if (_isUser == YES) {
        title = @"历史得分";
        btnTitle = @"排行榜";
        _dataArr = [JYCommonObjc getScoreArr:[JYCommonObjc getUserName]];
    }else{
        title = @"排行榜";
        btnTitle = @"历史得分";
        _dataArr = [JYCommonObjc getTopScoreUserArr];
    }
    self.navigationItem.title = title;
    _rightBarBtn.title = btnTitle;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellStr = cellID;
    CGScoreTBCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CGScoreTBCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }

    cell.desc.text = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row][@"time"]];
    cell.score.text = [NSString stringWithFormat:@"%@ 分",_dataArr[indexPath.row][@"score"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
@interface CGScoreTBCell ()

@end

@implementation CGScoreTBCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _score = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-15, 45)];
        _score.textColor = [UIColor redColor];
        _score.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:_score];
        
        _desc = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width-15, 45)];
        _desc.textColor = [UIColor blackColor];
        _desc.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:_desc];
        
    }
    return self;
}

@end
