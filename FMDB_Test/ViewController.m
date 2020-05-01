//
//  ViewController.m
//  FMDB_Test
//
//  Created by 张影 on 2020/4/15.
//  Copyright © 2020 张影. All rights reserved.
//

#import "ViewController.h"

#import <FMDB/FMDB.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建数据库
    [self createDB];
    
}
#pragma mark - 创建数据库
-(void)createDB {
    //获取沙河地址;
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //设置数据库名字
    NSString *fileName = [docPath stringByAppendingPathComponent:@"student.sqlite"];
    //Users/lixiaolu/Library/Developer/CoreSimulator/Devices/CA32D9C5-77D0-4CA6-A7EC-DA24455BAB00/data/Containers/Data/Application/9F52F443-12AA-48BE-AF1A-359C099E675E/Documents/student.sqlite
    
    //创建并获取数据库信息，如果表存在，则使用该表，不存在则重新创建
    FMDatabase *fmdb = [FMDatabase databaseWithPath:fileName];
    
    //打开数据库
    [fmdb open];
    
    if ([fmdb isOpen]) {
        NSLog(@"数据库打开成功！");
        //NSLog(@"数据库路径为：%@", fmdb.databasePath);
        //创建数据库表
        [self creatTable:fmdb];
    }else {
        NSLog(@"数据库打开失败！");
    }
    
    
    //删除数据库的表
    //[self deleteTable:fmdb];
    
    //关闭数据库
    [self closeDB:fmdb];
    
}
#pragma mark - 创建数据库表
-(void)creatTable:(FMDatabase *)fmdb {
    
    //如果表存在，则使用该表，不存在则重新创建
    BOOL creatTable = [fmdb executeUpdate:@"create table if not exists t_student (id integer primary key autoincrement, name text not null, age integer not null, sex text not null);"];
    if (creatTable) {
        NSLog(@"创建表成功");
        
        //插入数据到数据库的表中
        //[self insertData:fmdb];
        
        //删除数据库中的数据
        //[self deleteData:fmdb];
        
        //修改数据库中的数据
        //[self updateData:fmdb];
        
        //查询数据库中的数据
        //[self selectData:fmdb];
        
    } else {
        NSLog(@"创建表失败");
    }
}


#pragma mark - 插入数据到数据库的表中
-(void)insertData:(FMDatabase *)fmdb{
    BOOL installData = [fmdb executeUpdate:@"insert into t_student (name, age, sex) values (?, ?, ?)", @"王五", @(18), @"男"];
    if (installData) {
        NSLog(@"插入成功");
    }else {
        NSLog(@"插入失败");
    }
}

#pragma mark - 删除数据库中的数据
-(void)deleteData:(FMDatabase *)fmdb{
    BOOL deleteData = [fmdb executeUpdate:@"delete from t_student where id = ?", @(3)];
    if (deleteData) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

#pragma mark - 修改数据库中的数据
-(void)updateData:(FMDatabase *)fmdb{
    BOOL updateData = [fmdb executeUpdate:@"update t_student set name = ?, age = ?, sex = ? where id = ?", @"贾玲", @(16), @"女", @(2)];
    if (updateData) {
        NSLog(@"修改成功");
    } else {
        NSLog(@"修改失败");
    }
}

#pragma mark - 查询数据库中的数据
-(void)selectData:(FMDatabase *)fmdb{
    
    //FMResultSet *resultSet = [fmdb executeQuery:@"select * from t_student"];//查询所有
    FMResultSet *resultSet = [fmdb executeQuery:@"select * from t_student where id = ?", @(1)];
    while ([resultSet next]) {
        NSString *name = [resultSet stringForColumn:@"name"];
        int age = [resultSet intForColumn:@"age"];
        NSString *sex = [resultSet stringForColumn:@"sex"];
        
        NSLog(@"姓名：%@， 年龄：%@， 性别：%@", name, sex, @(age));
    }
    
}


#pragma mark - 删除数据库中的表
-(void)deleteTable:(FMDatabase *)fmdb{
    //如果表格存在 则销毁
    BOOL deleteTable = [fmdb executeUpdate:@"drop table if exists t_student"];
    if (deleteTable) {
        NSLog(@"删除表成功");
    } else {
        NSLog(@"删除表失败");
    }
}

#pragma mark - 关闭数据库
-(void)closeDB:(FMDatabase *)fmdb{
    //关闭数据库
    [fmdb close];
    if ([fmdb close]) {
        NSLog(@"数据库关闭成功！");
    }else {
        NSLog(@"数据库关闭失败！");
    }
}


@end
