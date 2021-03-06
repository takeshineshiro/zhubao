//
//  addlocalgoods.m
//  zhubao
//
//  Created by johnson on 14-9-23.
//  Copyright (c) 2014年 SUNYEARS___FULLUSERNAME. All rights reserved.
//

#import "addlocalgoods.h"
#import "member.h"
#import "sqlService.h"
#import "proclassEntity.h"

@interface addlocalgoods ()

@end

@implementation addlocalgoods

@synthesize modelnoText;
@synthesize goldweightText;
@synthesize mianctText;
@synthesize miancountText;
@synthesize fitctText;
@synthesize fitcountText;
@synthesize priceText;
@synthesize typeText;
@synthesize typeTView;
@synthesize nameText;
@synthesize titleText;
@synthesize goods;
@synthesize zhengmianview;
@synthesize fanmianview;
@synthesize cemianview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    typeText.userInteractionEnabled=NO;
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    sqlService *_sqlService=[[sqlService alloc]init];
    typelist=[_sqlService GetProclassList:myDelegate.entityl.uId page:1 pageSize:1500];
    
    //typelist=[[NSArray alloc]initWithObjects:@"女戒",@"男戒",@"对戒",@"吊坠",@"项链",@"手链",@"手镯",@"耳环",@"耳钉", nil];
    
    [self loaddata];
    
    goldweightText.keyboardType=UIKeyboardTypeNumberPad;
    mianctText.keyboardType=UIKeyboardTypeNumberPad;
    miancountText.keyboardType=UIKeyboardTypeNumberPad;
    fitctText.keyboardType=UIKeyboardTypeNumberPad;
    fitcountText.keyboardType=UIKeyboardTypeNumberPad;
    priceText.keyboardType=UIKeyboardTypeNumberPad;
    
}

-(void)loaddata
{
    if (goods) {
        isupdate=1;
        titleText.text=@"修改商品";
        pic1=goods.Pro_smallpic;
        NSArray  * array= [goods.Pro_bigpic componentsSeparatedByString:@","];
        pic2=[array objectAtIndex:0];
        pic3=[array objectAtIndex:1];
        
        if (![pic1 isEqualToString:@""]) {
            self.zhengmianview.image=[UIImage imageWithContentsOfFile:pic1];
        }
        
        if (![pic3 isEqualToString:@""]) {
            self.cemianview.image=[UIImage imageWithContentsOfFile:pic3];
        }
        
        if (![pic2 isEqualToString:@""]) {
            self.fanmianview.image=[UIImage imageWithContentsOfFile:pic2];
        }
        
        if ([self isnull:goods.Pro_name]) {
            nameText.text=goods.Pro_name;
        }
        if ([self isnull:goods.Pro_model]) {
            modelnoText.text=goods.Pro_model;
        }
        
        if ([self isnull:goods.Pro_goldWeight]) {
            goldweightText.text=goods.Pro_goldWeight;
        }
        
        if ([self isnull:goods.Pro_Z_weight]) {
            mianctText.text=goods.Pro_Z_weight;
        }
        
        if ([self isnull:goods.Pro_Z_count]) {
            miancountText.text=goods.Pro_Z_count;
        }
        
        if ([self isnull:goods.Pro_f_weight]) {
            fitctText.text=goods.Pro_f_weight;
        }
        
        if ([self isnull:goods.Pro_f_count]) {
            fitcountText.text=goods.Pro_f_count;
        }
        
        if ([self isnull:goods.Pro_price]) {
            priceText.text=goods.Pro_price;
        }
        
        typevalue=goods.Pro_Class;
        if ([typelist count]!=0 && ![typevalue isEqualToString:@"(null)"]) {
            for (proclassEntity *entity in typelist) {
                NSString *name=[NSString stringWithFormat:@"%@",entity.Id];
                if ([name isEqualToString:typevalue]) {
                    typeText.text=entity.name;
                    break;
                }
            }
            
        }
        
    }else
    {
        isupdate=0;
        pic1=@"";
        pic2=@"";
        pic3=@"";
        modelnoText.text=@"";
        typeText.text=@"";
        goldweightText.text=@"";
        mianctText.text=@"";
        miancountText.text=@"";
        fitctText.text=@"";
        fitcountText.text=@"";
        priceText.text=@"";
    }
}

-(IBAction)closeaddlocalg:(id)sender
{
    [_mydelegate performSelector:@selector(closesc)];
}


//保存本地商品数据
-(IBAction)savelocalgoods:(id)sender
{
    if (isupdate==1) {
        if ([pic1 isEqualToString:@""] && [pic2 isEqualToString:@""] && [pic3 isEqualToString:@""]) {
            [[[UIAlertView alloc] initWithTitle:@"信息提示" message:@"请至少上传一张图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }else
        {
            productEntity *entity=[[productEntity alloc]init];
            entity.Id=goods.Id;
            entity.pro_name=nameText.text;
            entity.Pro_model=modelnoText.text;
            entity.Pro_goldWeight=goldweightText.text;
            entity.Pro_Z_weight=mianctText.text;
            entity.Pro_Z_count=miancountText.text;
            entity.Pro_f_weight=fitctText.text;
            entity.Pro_f_count=fitcountText.text;
            entity.Pro_price=priceText.text;
            entity.Pro_Class=typevalue;
            entity.Pro_smallpic=pic1;
            entity.Pro_bigpic=[NSString stringWithFormat:@"%@,%@",pic2,pic3];
            //entity.Pro_bigpic=pic2;
            entity.producttype=@"1";
            entity.Pro_IsDel=@"0";
            entity.Pro_Type=@"10";
            sqlService *_sqlService=[[sqlService alloc]init];
            productEntity *info=[_sqlService updateProduct:entity];
            if (info) {
                [[[UIAlertView alloc] initWithTitle:@"信息提示" message:@"更新成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                goods=info;
                [self loaddata];
                [_mydelegate performSelector:@selector(showproductDetai)];
                
            }else
            {
                [[[UIAlertView alloc] initWithTitle:@"信息提示" message:@"更新失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        }
        
    }else{
        if ([pic1 isEqualToString:@""] && [pic2 isEqualToString:@""] && [pic3 isEqualToString:@""]) {
            [[[UIAlertView alloc] initWithTitle:@"信息提示" message:@"请至少上传一张图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }else{
            
            productEntity *entity=[[productEntity alloc]init];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            entity.Id=timeSp;
            entity.pro_name=nameText.text;
            entity.Pro_model=modelnoText.text;
            entity.Pro_goldWeight=goldweightText.text;
            entity.Pro_Z_weight=mianctText.text;
            entity.Pro_Z_count=miancountText.text;
            entity.Pro_f_weight=fitctText.text;
            entity.Pro_f_count=fitcountText.text;
            entity.Pro_price=priceText.text;
            entity.Pro_Class=typevalue;
            entity.Pro_smallpic=pic1;
            entity.Pro_bigpic=[NSString stringWithFormat:@"%@,%@",pic2,pic3];
            //entity.Pro_bigpic=pic2;
            entity.producttype=@"1";
            entity.Pro_IsDel=@"0";
            entity.Pro_Type=@"10";
            sqlService *_sqlService=[[sqlService alloc]init];
            productEntity *info=[_sqlService saveProduct:entity];
            if (info) {
                [[[UIAlertView alloc] initWithTitle:@"信息提示" message:@"添加成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }else
            {
                [[[UIAlertView alloc] initWithTitle:@"信息提示" message:@"添加失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        }
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [typelist count];
    //只有一组，数组数即为行数。
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
    }
    cell.textLabel.font=[UIFont boldSystemFontOfSize:12.0f];
    NSUInteger row = [indexPath row];
    proclassEntity *entity=[typelist objectAtIndex:row];
    cell.textLabel.text = entity.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    proclassEntity *entity=[typelist objectAtIndex:[indexPath row]];
    NSString *rowString = entity.name;
    typeText.text=rowString;
    typeTView.hidden=YES;
    typevalue=entity.Id;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self.view];
    //点击其他地方消失
    if (!CGRectContainsPoint([typeTView frame], pt)) {
        //to-do
        typeTView.hidden=YES;
    }
    
}

// 款式下拉框
- (IBAction)typeselect:(id)sender
{
    typeTView.hidden=NO;
}

//重置数据
-(IBAction)resetdata:(id)sender
{
    modelnoText.text=@"";
    goldweightText.text=@"";
    mianctText.text=@"";
    miancountText.text=@"";
    fitctText.text=@"";
    fitcountText.text=@"";
    priceText.text=@"";
    nameText.text=@"";
    zhengmianview.image=[UIImage imageNamed:@"image1"];
    fanmianview.image=[UIImage imageNamed:@"image1 2"];
    cemianview.image=[UIImage imageNamed:@"image2"];
    pic1=@"";
    pic2=@"";
    pic3=@"";
}

/////////////////////////////////////////以为图片上传位置/////////////////////////////////////////////////
//选择图片
- (IBAction)chooseImage:(id)sender {
    
    UIActionSheet *sheet;
    
    sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    
    sheet.tag = 255;
    [sheet showInView:self.view];
    UIButton * btn=(UIButton *)sender;
    pictag=[btn tag];
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSString *fullPath =nil;
    //记录文件
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    if (pictag==0) {
        NSString *pic1name=[NSString stringWithFormat:@"%@1.png",timeSp];
        [self saveImage:image withName:pic1name];
        
        fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:pic1name];
        pic1=fullPath;
    }
    else if (pictag==1)
    {
        NSString *pic2name=[NSString stringWithFormat:@"%@2.png",timeSp];
        [self saveImage:image withName:pic2name];
        
        fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:pic2name];
        pic2=fullPath;
    }
    else if (pictag==2){
        
        NSString *pic3name=[NSString stringWithFormat:@"%@3.png",timeSp];
        [self saveImage:image withName:pic3name];
        
        fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:pic3name];
        pic3=fullPath;
    }
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    isFullScreen = NO;
    if (pictag==0) {
        [self.zhengmianview setImage:savedImage];
        
        self.zhengmianview.tag = 100;
    }else if (pictag==1)
    {
        [self.fanmianview setImage:savedImage];
        
        self.fanmianview.tag = 100;
    }else if (pictag==2){
        [self.cemianview setImage:savedImage];
        
        self.cemianview.tag = 100;
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                    
                case 2:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
            popoverController = popover;
            [popoverController presentPopoverFromRect:CGRectMake(0, 0, 300, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        } else {
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }
        
    }
}

-(BOOL)isnull:(NSString *)str
{
    if (str && ![str isEqualToString:@""] && ![str isEqualToString:@"(null)"]) {
        return  true;
    }else{
        return false;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
