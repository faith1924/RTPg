//
//  episodeVC.m
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "episodeVC.h"

@interface episodeVC ()<JYBasicViewControllerDelegate,JYTableViewDataSource>

@property (strong , nonatomic)  JYBasicTableView * bodyView;

@property (strong , nonatomic) UIView * headerView;

@end

@implementation episodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadDelegate = self;
    // Do any additional setup after loading the view.
}
- (void)setupUIWithData:(id)data{
    _headerView = [JYCommonKits getViewLineWithFrame:CGRectMake(0, 0, JYScreenW, tableHeaderSpaceH) andJoinView:nil];
    
    _bodyView = [[JYBasicTableView alloc]initWithFrame:CGRectMake(0,0, JYScreenW, JYScreenH - self.viewNavigationBar.bottom - 65*JYScaleH) withDelegate:self];
    _bodyView.dataDelegate = self;
    _bodyView.emptyTitle = @"暂未添加地址";
    [self addSubview:_bodyView];
}
#pragma mark WDLBasicViewControllerDelegate
-(NSString *)getUrl{
    return @"https://www.apiopen.top/satinApi";
}
-(NSMutableDictionary *)getParams{
    return @{@"type":"1",@"page":"1"};
}
#pragma mark WDLTableViewListDelegate
- (NSString *)getTableViewUrl{
    return @"https://www.apiopen.top/satinApi";
}
- (NSString *)getTableViewParams{
    return @{@"type":"1",@"page":"1"};
}
#pragma mark WDLTableViewDataSource
- (episodeCell *)listContentView:(JYBasicTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    episodeCell * cell = nil;
    static NSString * cellStr = @"cellStr";
    if (cell == nil) {
        cell = [[episodeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    return cell;
}
- (void)listContentView:(JYBasicTableView *)listContentView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.completeBlock) {
        self.completeBlock(self.bodyView.listArray[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIView *)listContentHeaderView:(JYBasicTableView *)tableView{
    return _headerView;
}
-(CGFloat)listContentHeaderHeightView:(JYBasicTableView *)tableView{
    return _headerView.height;
}
-(NSArray<UITableViewRowAction *> *)listContentView:(JYBasicTableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    CashAddressViewModel * model = (CashAddressViewModel *)self.bodyView.listModel[indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        new_Dic(params);
        PARAMS(params,@"address_id",model.address_id);
        WDLGetWeakSelf;
        [self submitDataWithParams:params withUrl:ABAMineAssetDeleteAddress withBlock:^(id data, BOOL status) {
            if (status == YES) {
                //移除数据源
                [weakSelf.bodyView.listArray removeObjectAtIndex:indexPath.row];
                [weakSelf.bodyView.listModel removeObjectAtIndex:indexPath.row];
                
                //移除表格评论
                [UIView setAnimationsEnabled:NO];
                [weakSelf.bodyView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [UIView setAnimationsEnabled:YES];
                
                if (weakSelf.bodyView.listModel.count == 0) {
                    [weakSelf.bodyView updateData];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:NSReloadCashAddressOperation object:@{@"type":@"delete",@"address_id":model.address_id}];
            }
        }];
    }];
    return @[deleteAction];
}
-(UITableViewCellEditingStyle)listContentView:(JYBasicTableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(BOOL)listContentView:(JYBasicTableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)addNewAddressAction{
    new_ControllerWithOutPush(ABAAddCashAddressViewController);
    controller.property_type = self.property_type;
    [self presentViewController:controller animated:YES completion:nil];
}
#pragma mark 需要重写以下方法
- (CashAddressViewModel *)getModelWithObj:(id)obj{
    NSError * error = nil;
    CashAddressViewModel * model = [[CashAddressViewModel alloc]initWithDictionary:obj error:&error];
    if ([model.address_remark isEqualToString:self.address_remark] || [model.address_id isEqualToString:self.address_id]) {
        model.status = YES;
    }else{
        model.status = NO;
    }
    if (error) {
        NSLog(@"error = %@",error);
        model = [[CashAddressViewModel alloc]init];
        model.status = 0;
    }
    return model;
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
@interface episodeCell ()
@property (strong,nonatomic) UIButton * image;
@property (strong,nonatomic) UILabel * address_remark;
@property (strong,nonatomic) UILabel * address;
@property (strong, nonatomic) UIView * lineView;
@end

@implementation episodeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    _image = [WDLCommonKits initButtonnWithButtonTitle:@"" andLabelColor:nil andLabelFont:0 andSuperView:self.contentView andFrame:CGRectMake(15*SCREEN_WIDTH_375, 0, 17*SCREEN_HEIGHT_667, 17*SCREEN_HEIGHT_667)];
    [_image setImage:[UIImage imageNamed:@"subscription_select@2x"] forState:UIControlStateNormal];
    [_image setImage:[UIImage imageNamed:@"subscription_selected@2x"] forState:UIControlStateSelected];
    
    _address_remark = [WDLCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:ABALightNoteColor andLabelFont:16*SCREEN_HEIGHT_667 andLabelFrame:CGRectMake(_image.right+14*SCREEN_WIDTH_375, 20*SCREEN_HEIGHT_667, 1, 16*SCREEN_HEIGHT_667) andJoinView:self.contentView];
    _address = [WDLCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:ABADeepTitleColor andLabelFont:12*SCREEN_HEIGHT_667 andLabelFrame:CGRectMake(_address_remark.left,_address_remark.bottom+9*SCREEN_HEIGHT_667, 1, 12*SCREEN_HEIGHT_667) andJoinView:self.contentView];
    _lineView = [WDLCommonKits getViewLineWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5*SCREEN_HEIGHT_667) andJoinView:self.contentView];
}
-(void)setModel:(ABANewModel *)model{
    [super setModel:model];
    CashAddressViewModel * newModel = (CashAddressViewModel *)model;
    _image.selected = newModel.status;
    
    _address_remark.text = newModel.address_remark;
    [_address_remark sizeToFit];
    
    _address.text = newModel.address;
    [_address sizeToFit];
    _address.top = _address_remark.bottom+9*SCREEN_HEIGHT_667;
    _lineView.top = _address.bottom + 20*SCREEN_HEIGHT_667;
    
    self.height = _lineView.bottom;
    model.cellHeight = self.height ;
    _image.centerY = self.height/2;
}
@end
@implementation CashAddressViewModel
@end
