//
//  ViewController.m
//  WeakRefArrayDemo
//
//  Created by 金龙潘 on 2017/12/8.
//  Copyright © 2017年 金龙潘. All rights reserved.
//

#import "ViewController.h"
#import "LPMWeakRefArray.h"

@interface ViewController ()
@property (nonatomic, strong) LPMWeakRefArray *weakArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSObject *str1 = [NSObject new];
    NSObject *str2 = [NSObject new];
    self.weakArr = [LPMWeakRefArray array];
    [self.weakArr addObject:str1];
    [self.weakArr addObject:str2];
    NSLog(@"%@",self.weakArr);

    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)clickButton:(id)sender {
    NSLog(@"%@",self.weakArr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
