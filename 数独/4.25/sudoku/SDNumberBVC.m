#import "SDNumberBVC.h"
#import "UIView+ZHView.h"
#import "SDData.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define JYScale_Width            [[UIScreen mainScreen] bounds].size.width/375.00
#define JYScale_Height           [[UIScreen mainScreen] bounds].size.height/667.00

#define SafeAreaBottomHeight (([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896) ? 34 : 0)
#define SafeAreaTopHeight (([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896) ? 88 : 64)
#define SafeNaviTopHeight (([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896) ? 24 : 0)
#define SafeTabbarBottomHeight (([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896) ? 83 : 49)
#define StatusBarHeight (([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896) ? 44 : 20)


#define seleBgColor [UIColor colorWithRed:137.0f/255.0f green:104.0f/255.0f blue:205.0f/255.0f
#define buttonTitleColor [UIColor colorWithRed:106.0f/255.0f green:90.0f/255.0f blue:205.0f/255.0f alpha:1]
#define promptTitleColor [UIColor colorWithRed:106.0f/255.0f green:90.0f/255.0f blue:205.0f/255.0f alpha:1]
#define buttonLayerColor


UILabel * timerLabel;
NSInteger integerTime;

//存储数独的数组9*9
int a[9][9]={0};

//将数组数据经过挖空几个的数据存储数组
int b[9][9]={0};
void digBlank(int n){//挖孔n个
    
    //将数组a复制到数组b
    for (int i=0; i<9; i++) {
        for (int j=0; j<9; j++) {
            b[i][j]=a[i][j];
        }
    }
    
    //如果挖孔个数不合理,返回
    if(n>=81||n<=0)return;
    
    //开始随机挖孔
    int x,y;
    for(int i=0;i<n;i++){
        
        //随机产生x,y坐标
        x=arc4random()%9;
        y=arc4random()%9;
        
        //如果这个坐标点上的数据已经被挖了,就重新找新的孔
        while (b[x][y]==0) {
            x=arc4random()%9;
            y=arc4random()%9;
        }
        b[x][y]=0;//挖孔
    }
}

//C语言

int one[9]={1,2,3,4,5,6,7,8,9};
int able[9][9]={0};
int able_count[9]={0};
void display_able();
void display();
int judge();

/**将数据初始化*/
void chushihua(){
    for (int i=0; i<9; i++) {
        for (int j=0; j<9; j++) {
            a[i][j]=0;
            able[i][j]=0;
        }
        able_count[i]=0;
    }
}

/**生成第一行*/
void row_one(){
    
    int x,y,temp;
    
    //将第一行的数据打乱,这样可以产生随机的效果
    for(int i=0;i<9;i++){
        x=arc4random()%9;
        y=arc4random()%9;
        temp=one[x];
        one[x]=one[y];
        one[y]=temp;
    }
    
    for (int i=0; i<9; i++) {
        a[0][i]=one[i];
    }
    
}

/**判断某一行上是否已经存在(填了)某个数字*/
int hang(int i,int value){
    
    for (int k=0; k<9; k++) {
        if(a[i][k]==value)return 0;
    }
    return 1;
    
}

/**判断某一列上是否已经存在(填了)某个数字*/
int lie(int j,int value){
    for (int k=0; k<9; k++) {
        if(a[k][j]==value)return 0;
    }
    return 1;
}

/**判断某个局域的九宫格内是否已经存在(填了)某个数字*/
int rongqi(int i,int j,int value){
    
    i=i/3*3;
    j=j/3*3;
    
    for (int k=i; k<i+3; k++) {
        for (int p=j; p<j+3; p++) {
            if(a[k][p]==value)return 0;
        }
    }
    
    return 1;
}

/**判断某一行上是否已经存在(填了)某个数字*/
int hang_b(int i,int value){
    
    for (int k=0; k<9; k++) {
        if(b[i][k]==value)return 0;
    }
    return 1;
    
}

/**判断某一列上是否已经存在(填了)某个数字*/
int lie_b(int j,int value){
    for (int k=0; k<9; k++) {
        if(b[k][j]==value)return 0;
    }
    return 1;
}

/**判断某个局域的九宫格内是否已经存在(填了)某个数字*/
int rongqi_b(int i,int j,int value){
    
    i=i/3*3;
    j=j/3*3;
    
    for (int k=i; k<i+3; k++) {
        for (int p=j; p<j+3; p++) {
            if(b[k][p]==value)return 0;
        }
    }
    
    return 1;
}

/**当一行产生了某个可能的数字数组顺序时,也许是出于填入不能得到正确的结果,而要将其随机打乱顺序*/
void daluan(){
    
    int x,y,temp;
    
    for (int i=0; i<9; i++) {
        for (int j=0;j<able_count[i];j++) {
            x=arc4random()%able_count[i];
            y=arc4random()%able_count[i];
            temp=able[i][x];
            able[i][x]=able[i][y];
            able[i][y]=temp;
        }
    }
    
}

/**清空数独数组某一行数据*/
void qingkong(int n){
    for (int p=0; p<9; p++)a[n][p]=0;
}

/**判断测试某一行在填写完后是否真正的将九个数字全部填入了*/
int tiaozheng(int n){//n代表第几行
    
    int have_zero=0;
    int index=0;
    int value=0;
    int k;
    int count=0;
    
    //测试任意一行是否有多少行存在
    for (int j=1; j<=9; j++) {
        for (k=0; k<9; k++) {
            if(a[n][k]==j)
                break;
        }
        //如果一行找到最后,都没有发现某个数字,说明这一行有问题,count++;
        if(k==9){value=j;count++;}
    }
    
    for (int j=0; j<9; j++) {
        if(a[n][j]==0){have_zero=1;index=j;}
    }
    
    //如果发现了某一行存在某个数字没有填完整:进行调整
    if(have_zero==1){
        
        //NSLog(@"%d行有%d个0存在,不存在数字%d",n+1,count,value);
        
        int p;
        for (p=0; p<9; p++) {
            if(a[n][p]!=0){
                
                //这里在尝试将这个为0的数据和另外的某个数据交换,看是否存在交换完成后达成目的的效果
                //但是这样有个缺点:就是当这一行中不止存在1个0
                if(lie(p, value)&&rongqi(n, p, value)&&lie(index, a[n][p])&&rongqi(n, index, a[n][p])){//NSLog(@"%d----%d被替换",a[n][p],value);
                    a[n][index]=a[n][p];a[n][p]=value; break;
                }
                
            }
        }
        
        if(p==9)return 0;//说明这行填写失败，重新填写
    }
    return 1;
}

/**尝试将某一行填入经过计算后可能的情况顺序*/
void kaishi(int n){//n代表第几行
    for (int i=0; i<9; i+=3) {
        for (int j=0; j<able_count[i]; j++) {
            if(hang(n, able[i][j])&&lie(i, able[i][j])&&rongqi(n, i, able[i][j]))
                a[n][i]=able[i][j];
        }
    }
    for (int i=1; i<9; i+=3) {
        for (int j=0; j<able_count[i]; j++) {
            if(hang(n, able[i][j])&&lie(i, able[i][j])&&rongqi(n, i, able[i][j]))
                a[n][i]=able[i][j];
        }
    }
    for (int i=2; i<9; i+=3) {
        for (int j=0; j<able_count[i]; j++) {
            if(hang(n, able[i][j])&&lie(i, able[i][j])&&rongqi(n, i, able[i][j]))
                a[n][i]=able[i][j];
        }
    }
}

/**根据已经填入过的数据,来挑选出当前填入得这行可能可以选择那些数字*/
void tiaoxuan(int i,int j){//挑选
    able_count[j]=0;
    for (int value=1; value<=9; value++) {
        if(hang(i, value)&&lie(j, value)&&rongqi(i, j, value))
            able[j][able_count[j]++]=value;
    }
}

/**填写第n行开始*/
void row_two(int n){
    //挑选出可能顺序
    for (int i=0; i<9; i++) {
        tiaoxuan(n, i);
    }
    //将顺序打乱
    daluan();
    //开始填入
    kaishi(n);
}

/**开始生产数独数组*/
void newDataArr(){
    chushihua();
    row_one();
    int shunxu[]={1,2,6,7,8,3,4,5};
    int count=0;
    
    for (int i=0; i<8; i++) {
        row_two(shunxu[i]);
        if(i==7)break;
        while(tiaozheng(shunxu[i])==0){
            count++;
            qingkong(shunxu[i]);
            row_two(shunxu[i]);
            if(count>=1000){
                NSLog(@"自动跳出");
                chushihua();
                i=9;
                break;
            }
        }
        
    }
    
    //如果失败,就重新生成
    if(judge()==0){
        newDataArr();
    }
}

/**打印数独数据*/
void display(){
    printf("\n\n");
    NSLog(@"-----------------------------a数组");
    for(int i=0;i<9;i++){
        for(int j=0;j<9;j++){
            printf("%d  ",a[j][i]);
        }
        printf("\n");
    }
    NSLog(@"-----------------------------b数组");
    for(int i=0;i<9;i++){
        for(int j=0;j<9;j++){
            printf("%d  ",b[j][i]);
        }
        printf("\n");
    }
}

int checkRight(){
    for(int i=0;i<9;i++){
        for(int j=0;j<9;j++){
            if (a[i][j]!=0&&b[i][j]!=0&&a[i][j]!=b[i][j]) {
                NSLog(@"%d:%d:%d",i,j,a[i][j]);
                return 1;
            }
        }
    }
    return 0;
}

/**打印可能的顺序:便于调试*/
void display_able(){
    for (int i=0; i<9; i++) {
        for(int j=0;j<able_count[i];j++){
            printf("%d ",able[i][j]);
        }
        printf("\n");
    }
}

/**简单判断数独是否每个数字都填写完成:不包括数独原则错误检验*/
int judge(){
    for (int i=0; i<9; i++) {
        for(int j=0;j<9;j++){
            if(a[i][j]==0)return 0;
        }
    }
    return 1;
}

/**判断用户填写某个数字后是否全部填写完成:赢了或还没有填完*/
int win(){
    for (int i=0; i<9; i++) {
        for (int j=0; j<9; j++) {
            if(a[i][j]!=b[i][j])return 0;
        }
    }
    return 1;
}


//OC语言
@interface SDNumberBVC ()<UIAlertViewDelegate>

@property (strong , nonatomic) NSTimer * timer;

@property (strong , nonatomic) UIImageView * contentView;

@end


@implementation SDNumberBVC

/**挖孔个数*/
int coverBlank=40;

long tap_x,tap_y;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    self.navigationItem.title = @"数独";
    
    UIImage * backImage = [UIImage imageNamed:@"icon-return"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAutomatic];
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight - 40*JYScale_Height, 40*JYScale_Width, 50*JYScale_Width)];
    [backBtn setImage:backImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchDown];
    
    UIImage * reStartImage = [UIImage imageNamed:@"restart"];
    reStartImage = [reStartImage imageWithRenderingMode:UIImageRenderingModeAutomatic];
    UIButton * restartBarBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50*JYScale_Width, SafeAreaTopHeight - 40*JYScale_Height, 40*JYScale_Width, 50*JYScale_Width)];
    [restartBarBtn setImage:reStartImage forState:UIControlStateNormal];
    [restartBarBtn addTarget:self action:@selector(restartAction) forControlEvents:UIControlEventTouchDown];
   
    UIImage * promptImage = [UIImage imageNamed:@"prompt"];
    promptImage = [promptImage imageWithRenderingMode:UIImageRenderingModeAutomatic];
    UIButton * promptBarBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100*JYScale_Width, SafeAreaTopHeight - 40*JYScale_Height, 40*JYScale_Width, 50*JYScale_Width)];
    [promptBarBtn setImage:promptImage forState:UIControlStateNormal];
    [promptBarBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchDown];
 
    [self.contentView addSubview:backBtn];
    [self.contentView addSubview:restartBarBtn];
    [self.contentView addSubview:promptBarBtn];
    
    newDataArr();
    if(_level == 0){
        coverBlank = 30;
    }else if (_level == 1){
        coverBlank = 40;
    }else if (_level == 2){
        coverBlank = 50;
    }
    digBlank(coverBlank);
//    display();
    [self creat];
    [self showView];
    [self beginTimer];
}

- (UIImageView *)contentView{
    if (!_contentView) {
        _contentView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_Detail"]];
        _contentView.userInteractionEnabled = YES;
        _contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _contentView;
}
- (void)beginTimer{
    //开启定时器
    integerTime = 0;
    
    if (timerLabel == nil) {
        timerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight + 15*JYScale_Height, SCREEN_WIDTH, 40*JYScale_Height)];
        timerLabel.textAlignment = NSTextAlignmentCenter;
        timerLabel.textColor = [UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1];
        timerLabel.font = [UIFont systemFontOfSize:38*JYScale_Height];
        timerLabel.center = CGPointMake(timerLabel.center.x, (SCREEN_HEIGHT/2 - 4.5*(38*JYScale_Height) - SafeAreaTopHeight)/2 + SafeAreaTopHeight);
    }
    timerLabel.text = @"00:00:00";
    [self.contentView addSubview:timerLabel];
    
    if(_timer == nil){
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            integerTime++;
            timerLabel .text = [SDData getTimeInter:integerTime];
        }];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
}
- (void)stopTime{
    integerTime = 0;
    [_timer invalidate];
    _timer = nil;
}

- (void)showView{
    UIButton *button;
    for (int i=0; i<9; i++) {
        for (int j=0; j<9; j++) {
            button=(id)[self.view viewWithTag:i*9+j+1];
            if(button.tag!=0&&b[i][j]!=0){
                [button setTitle:[NSString stringWithFormat:@"%d",b[i][j]] forState:(UIControlStateNormal)];
                [button setTitleColor:buttonTitleColor forState:(UIControlStateNormal)];
            }
            else{ [button setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];[button setTitle:@"" forState:(UIControlStateNormal)];}
        }
    }
}

- (void)creat{
    int sideSize = 38 * JYScale_Width;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-9*sideSize)/2.0, SafeAreaTopHeight + 15*JYScale_Height, 9*sideSize, 9*sideSize)];
    view.backgroundColor=[UIColor whiteColor];
    view.userInteractionEnabled = YES;
    view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [self.contentView addSubview:view];
    
    int count=1;
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            for (int k=0; k<3; k++) {
                for (int p=0; p<3; p++) {
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                    button.frame = CGRectMake(sideSize*3*i+k*sideSize, sideSize*3*j+p*sideSize, sideSize, sideSize);
                    [button addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [button addUILongPressGestureRecognizerWithTarget:self withAction:@selector(longPress:) withMinimumPressDuration:1];
                    button.layer.cornerRadius = 2.0f;
                    button.layer.borderWidth = 1.0f; // 边框的宽度;
                    button.layer.borderColor = [UIColor colorWithRed:139.0f/255.0f green:137.0f/255.0f blue:137.0f/255.0f alpha:1].CGColor;
                    [view addSubview:button];
                    
                    button.tag=count++;
                    if((button.tag>=10&&button.tag<=18)||(button.tag>=28&&button.tag<=36)||(button.tag>=64&&button.tag<=72)||(button.tag>=46&&button.tag<=54))
                        button.backgroundColor=[UIColor colorWithRed:255.0f/255.0f green:218.0f/255.0f blue:185.0f/255.0f alpha:1];
                    else button.backgroundColor=[UIColor whiteColor];
                    button.titleLabel.font = [UIFont systemFontOfSize:24];
                }
            }
        }
    }
    [self zhuanhuan];
    
    UIButton *tempBtn = nil;
    for (NSInteger i=0; i<9; i++) {
        tempBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        tempBtn.frame = CGRectMake(sideSize*i+16, CGRectGetMaxY(view.frame) + 30*JYScale_Height, sideSize, sideSize);
        [tempBtn addTarget:self action:@selector(inputNum:) forControlEvents:UIControlEventTouchUpInside];
        tempBtn.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:218.0f/255.0f blue:185.0f/255.0f alpha:1];
        [tempBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [tempBtn setTitle:[NSString stringWithFormat:@"%ld",(long)i+1] forState:UIControlStateNormal];
        tempBtn.layer.cornerRadius = 2.0f;
        tempBtn.layer.borderWidth = 1.0f; // 边框的宽度;
        tempBtn.layer.borderColor = [UIColor colorWithRed:139.0f/255.0f green:137.0f/255.0f blue:137.0f/255.0f alpha:1].CGColor; // 边框的颜色;
        tempBtn.tag=101+i;
        [self.contentView addSubview:tempBtn];
    }
}

/**因为在创建textFiled时用的for循环太多,导致tag值不对应,在这进行人工调整*/
- (void)zhuanhuan{
    UIButton *button1,*button2;
    NSInteger temp=0;
    int s1[]={4,5,6,7,8,9,16,17,18,31,32,33,34,35,36,43,44,45,58,59,60,61,62,63,70,71,72};//9
    int s2[]={10,11,12,19,20,21,22,23,24,37,38,39,46,47,48,49,50,51,64,65,66,73,74,75,76,77,78};
    for (int i=0; i<27; i++) {
        button1=(id)[self.view viewWithTag:s1[i]];
        button2=(id)[self.view viewWithTag:s2[i]];
        temp=button1.tag;
        button1.tag=button2.tag;
        button2.tag=temp;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    [self restartAction];
}

- (void)initButtonsColor{
    for (int i=0; i<9; i++) {
        for (int j=0; j<9; j++) {
            UIButton *button =(id)[self.view viewWithTag:i*9+1+j];
            if((i>=3&&i<=5&&j>=0&&j<=2)||(i>=3&&i<=5&&j>=6&&j<=8)||(i>=0&&i<=2&&j>=3&&j<=5)||(i>=6&&i<=8&&j>=3&&j<=5)){
                button.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:218.0f/255.0f blue:185.0f/255.0f alpha:1];
            }
            else
            {
                button.backgroundColor=[UIColor whiteColor];
            }
            if ([button.titleLabel.textColor isEqual:[UIColor colorWithRed:137.0f/255.0f green:104.0f/255.0f blue:205.0f/255.0f alpha:0.6]]) {
                [button setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
            }
        }
    }
}

//显示这一行的颜色
- (void)colorHang:(int)hang{
    for (int j=0; j<9; j++) {
        UIButton *button =(id)[self.view viewWithTag:hang*9+1+j];
        button.backgroundColor=[UIColor colorWithRed:137.0f/255.0f green:104.0f/255.0f blue:205.0f/255.0f alpha:0.6];
    }
}

//显示着一列的颜色
- (void)colorLie:(int)lie{
    for (int i=0; i<9; i++) {
        UIButton *button =(id)[self.view viewWithTag:i*9+1+lie];
        button.backgroundColor=[UIColor colorWithRed:137.0f/255.0f green:104.0f/255.0f blue:205.0f/255.0f alpha:0.6];
    }
}

//显示这个小九宫格的颜色
- (void)colorRongQi:(int)hang Lie:(int)lie{
    hang=hang/3*3;
    lie=lie/3*3;
    
    for (int k=hang; k<hang+3; k++) {
        for (int p=lie; p<lie+3; p++) {
            UIButton *button =(id)[self.view viewWithTag:k*9+1+p];
            button.backgroundColor=[UIColor colorWithRed:137.0f/255.0f green:104.0f/255.0f blue:205.0f/255.0f alpha:0.6];
        }
    }
}

//点击某一个空格按钮的着色
- (void)clickNullButtonWithPointX:(int)pointX PointY:(int)pointY{
    //显示这一行的颜色
    [self colorHang:pointX];
    //显示着一列的颜色
    [self colorLie:pointY];
    
    //显示这个小九宫格的颜色
    [self colorRongQi:pointX Lie:pointY];
    
}

//点击一个数字按钮的着色
- (void)clickNumButtonWithPointX:(int)pointX PointY:(int)pointY value:(int)value{
    for (int i=0; i<9; i++) {
        for (int j=0; j<9; j++) {
            if (b[i][j]==value) {
                [self colorHang:i];
                [self colorLie:j];
            }else if (b[i][j]!=0){
                UIButton *button =(id)[self.view viewWithTag:i*9+1+j];
                button.backgroundColor=[UIColor colorWithRed:137.0f/255.0f green:104.0f/255.0f blue:205.0f/255.0f alpha:0.6];
            }
        }
    }
}

#pragma mark 智能提醒

- (void)tapBtn:(UIButton *)button{
    [self initButtonsColor];
    tap_x=(button.tag-1)/9;tap_y=(button.tag-1)%9;
    if (b[tap_x][tap_y]!=0) {
        [self setCanChooseButton:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]];
        [self clickNumButtonWithPointX:(int)tap_x PointY:(int)tap_y value:b[tap_x][tap_y]];
        tap_x=-1;tap_y=-1;
        return;
    }
    [self clickNullButtonWithPointX:(int)tap_x PointY:(int)tap_y];
    NSArray *canChooseNums=[self getCanChooseNumWithPointX:(int)tap_x PointY:(int)tap_y];
    [self setCanChooseButton:canChooseNums];
}

//长按后触发该方法
-(void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        UIButton *button=(UIButton *)gestureRecognizer.view;
        if ([button.titleLabel.textColor isEqual:[UIColor blackColor]]) {
            return;
        }
        tap_x=(button.tag-1)/9;tap_y=(button.tag-1)%9;
        if (b[tap_x][tap_y]!=0) {
            b[tap_x][tap_y]=0;
            [button setTitle:@"" forState:(UIControlStateNormal)];
            tap_x=-1;tap_y=-1;
        }
    }
}

- (void)inputNum:(UIButton *)button{
    [self initButtonsColor];
    if (tap_x==-1||tap_y==-1) {
        return;
    }
    UIButton *targetButton=(id)[self.view viewWithTag:tap_x*9+1+tap_y];
    b[tap_x][tap_y]=(int)button.tag-100;
    [targetButton setTitle:[NSString stringWithFormat:@"%ld",button.tag-100] forState:(UIControlStateNormal)];
    if ([self checkWin]) return;
}

- (void)setCanChooseButton:(NSArray *)canChooseNum{
    for (NSInteger i=1; i<=9; i++) {
        UIButton *targetButton=(id)[self.view viewWithTag:100+i];
        if ([canChooseNum containsObject:[NSString stringWithFormat:@"%ld",i]]) {
            targetButton.backgroundColor=[UIColor colorWithRed:137.0f/255.0f green:104.0f/255.0f blue:205.0f/255.0f alpha:0.6];
            targetButton.enabled=YES;
        }else{
            targetButton.backgroundColor=[UIColor colorWithRed:255.0f/255.0f green:218.0f/255.0f blue:185.0f/255.0f alpha:1];
            targetButton.enabled=NO;
        }
    }
}

- (void)restartAction{
    [self stopTime];
    newDataArr();
    digBlank(coverBlank);
    display();
    [self showView];//显示数独到数组上
    tap_x=-1;tap_y=-1;
    [self beginTimer];
}

- (BOOL)checkWin{
    if (checkRight()) {
//        NSLog(@"%@",@"出现错误");
    }
    if(win()==1){
        //记录成绩
        [SDData setBestScore:integerTime];
        [SDData setLastScore:integerTime];
        
        //通知刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadScore" object:nil];
        
        //停止计时
        [self stopTime];

        __weak typeof(self) weakSelf = self;
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"太厉害啦" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"重新开始" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf beginTimer];
            [weakSelf restartAction];
        }];
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:sureAction];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:YES completion:nil];
        return YES;
    }
    return NO;
}
/**简单判断某个位置的可填数字*/
- (NSArray *)getCanChooseNumWithPointX:(int)pointX PointY:(int)pointY{
    NSMutableArray *arrM=[NSMutableArray array];
    for (int value=1; value<=9; value++) {
        if (hang_b(pointX, value)&&lie_b(pointY, value)&&rongqi_b(pointX, pointY, value)) {
            [arrM addObject:[NSString stringWithFormat:@"%d",value]];
        }
    }
    return arrM;
}

- (NSString *)tips{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    for (int i=0; i<9; i++) {
        for (int j=0; j<9; j++) {
            if (b[i][j]==0) {
                int i_temp=i/3*3;
                int j_temp=j/3*3;
                
                NSMutableDictionary *subDicM=[NSMutableDictionary dictionary];
                NSMutableArray *canChooseNums=[NSMutableArray arrayWithArray:[self getCanChooseNumWithPointX:i PointY:j]];
                [subDicM setValue:canChooseNums forKey:[NSString stringWithFormat:@"%d:%d",i,j]];
                
                if (dicM[[NSString stringWithFormat:@"%d:%d",i_temp,j_temp]]==nil) {
                    NSMutableArray *arrM=[NSMutableArray array];
                    [arrM addObject:subDicM];
                    dicM[[NSString stringWithFormat:@"%d:%d",i_temp,j_temp]]=arrM;
                }else{
                    NSMutableArray *arrM=dicM[[NSString stringWithFormat:@"%d:%d",i_temp,j_temp]];
                    [arrM addObject:subDicM];
                }
            }
        }
    }
    
//    单独某个小九宫格分析 可包括余数法 和 摒除法(简单)
    for (NSString *str in dicM) {
        NSMutableArray *arrM=dicM[str];
        NSMutableArray *numArrM=[NSMutableArray array];
        for (NSMutableDictionary *subDicM in arrM) {
            for (NSString *subStr in subDicM) {
                NSMutableArray *subArrM=subDicM[subStr];
                for (NSString *numStr in subArrM) {
                    [numArrM addObject:numStr];
                }
            }
        }
        
        for (NSMutableDictionary *subDicM in arrM) {
            for (NSString *subStr in subDicM) {
                NSMutableArray *subArrM=subDicM[subStr];
                for (NSString *numStr in subArrM) {
                    if ([self getTargetStr:numStr CountFromArr:numArrM]==1) {
                        return [subStr stringByAppendingFormat:@":%@",numStr];
                    }
                }
            }
        }
    }
    
    //分析全局
    NSString *result=[self tipsAllNum:dicM];
    if (result.length>0) {
        return result;
    }
    
    return @"";
}

- (NSString *)tipsAllNum:(NSMutableDictionary *)dicM{
    
    //先收集横竖上的所有空格点的所有可能
    NSMutableDictionary *hengDicM=[NSMutableDictionary dictionary];
    NSMutableDictionary *shuDicM=[NSMutableDictionary dictionary];
    
    NSMutableArray *allHengShuArrM=[NSMutableArray array];
    for (NSString *str in dicM) {
        NSMutableArray *arrM=dicM[str];
        [allHengShuArrM addObjectsFromArray:arrM];
    }
    
    for (NSMutableDictionary *subDic in allHengShuArrM) {
        for (NSString *str in subDic) {
            NSString *shu=[str substringToIndex:1];
            NSString *heng=[str substringFromIndex:2];
            
            if (hengDicM[heng]==nil) {
                NSMutableArray *subHengArrM=[NSMutableArray array];
                hengDicM[heng]=subHengArrM;
                [subHengArrM addObjectsFromArray:subDic[str]];
            }else{
                NSMutableArray *subHengArrM=hengDicM[heng];
                [subHengArrM addObjectsFromArray:subDic[str]];
            }
            
            if (shuDicM[shu]==nil) {
                NSMutableArray *subShuArrM=[NSMutableArray array];
                shuDicM[shu]=subShuArrM;
                [subShuArrM addObjectsFromArray:subDic[str]];
            }else{
                NSMutableArray *subShuArrM=shuDicM[shu];
                [subShuArrM addObjectsFromArray:subDic[str]];
            }
        }
    }
    
    NSString *hengStr=@"";
    NSString *shuStr=@"";
    NSString *numStr=@"";
    //再分析所有行和竖,如果这个行或者竖中某一个数值存在一个,那么这个数字所在的空,就一定是填这个数
    for (int i=0; i<9; i++) {
        NSString *key=[NSString stringWithFormat:@"%d",i];
        NSArray *hengArr=hengDicM[key];
        for (int j=1; j<=9; j++) {
            if ([self getTargetStr:[NSString stringWithFormat:@"%d",j] CountFromArr:hengArr]==1) {
                hengStr=[NSString stringWithFormat:@"%d",i];
                numStr=[NSString stringWithFormat:@"%d",j];
            }
        }
        
        NSArray *shuArr=shuDicM[key];
        for (int j=1; j<=9; j++) {
            if ([self getTargetStr:[NSString stringWithFormat:@"%d",j] CountFromArr:shuArr]==1) {
                shuStr=[NSString stringWithFormat:@"%d",i];
                numStr=[NSString stringWithFormat:@"%d",j];
            }
        }
    }
    
    if (numStr.length>0) {
        for (NSMutableDictionary *subDic in allHengShuArrM) {
            for (NSString *str in subDic) {
                NSString *shu=[str substringToIndex:1];
                NSString *heng=[str substringFromIndex:2];
                
                if (hengStr.length>0) {
                    if ([heng isEqualToString:hengStr]) {
                        NSArray *hengArrTemp=subDic[str];
                        if ([hengArrTemp containsObject:numStr]) {
                            return [str stringByAppendingFormat:@":%@",numStr];
                        }
                    }
                }else if (shuStr.length>0){
                    if ([shu isEqualToString:shuStr]) {
                        NSArray *shuArrTemp=subDic[str];
                        if ([shuArrTemp containsObject:numStr]) {
                            return [str stringByAppendingFormat:@":%@",numStr];
                        }
                    }
                }
            }
        }
    }
    return @"";
}

- (int)getTargetStr:(NSString *)targetStr CountFromArr:(NSArray *)arr{
    int count=0;
    for (NSString *str in arr) {
        if ([str isEqualToString:targetStr]) {
            count++;
        }
    }
    return count;
}

- (void)nextStep{
    [self initButtonsColor];
    for (int i=0; i<9; i++) {
        for (int j=0; j<9; j++) {
            if (b[i][j]==0) {
                NSArray *canChooseNums=[self getCanChooseNumWithPointX:i PointY:j];
                if (canChooseNums.count==1) {
                    NSString *value=[canChooseNums firstObject];
                    UIButton *targetButton=(id)[self.view viewWithTag:i*9+1+j];
                    b[i][j]=[value intValue];
                    [targetButton setTitle:value forState:(UIControlStateNormal)];
                    [targetButton setTitleColor:[UIColor colorWithRed:137.0f/255.0f green:104.0f/255.0f blue:205.0f/255.0f alpha:0.6] forState:(UIControlStateNormal)];
                    [self checkWin];
                    return;
                }
            }
        }
    }
    
    NSString *tips=[self tips];
    if (tips.length>0) {
        NSArray *arr=[tips componentsSeparatedByString:@":"];
        if (arr.count==3) {
            NSString *value=[arr lastObject];
            int i=[arr[0] intValue];
            int j=[arr[1] intValue];
            UIButton *targetButton=(id)[self.view viewWithTag:i*9+1+j];
            b[i][j]=[value intValue];
            [targetButton setTitle:value forState:(UIControlStateNormal)];
            [targetButton setTitleColor:[UIColor colorWithRed:137.0f/255.0f green:104.0f/255.0f blue:205.0f/255.0f alpha:0.6] forState:(UIControlStateNormal)];
            [self checkWin];
            return;
        }
    }
    
    if ([self checkWin]) return;
    
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"没有可提示" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [a show];
}
- (void)dealloc{
    NSLog(@"dealloc success");
    [self stopTime];
}
- (void)backBtnAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
