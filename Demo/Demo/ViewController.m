//
//  ViewController.m
//  Demo
//
//  Created by admin on 2017/5/9.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ViewController.h"
#import "EncryptedStorageUtils.h"

@interface MyClass : NSObject<NSCoding>

@property(nonatomic,strong)NSString *message;

@end

@implementation MyClass

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.message forKey:@"MyClass_message"];
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (aDecoder) {
        _message=[aDecoder decodeObjectForKey:@"MyClass_message"];
    }
    return self;
}

@end

@interface MyCustomClass : NSObject<EncryptedStorageUtilsProtocolToData>

@property(nonatomic,strong)NSString *message;

@end

@implementation MyCustomClass

-(NSData *)customEncryptedData{
    if (self) {
        return [_message dataUsingEncoding:NSUTF8StringEncoding];
    }
    return nil;
}

-(id)customDeCryptedData:(NSData*)data{
    if (data) {
        self.message=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return self;
    }
    return nil;
}


@end


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyClass *myclass=[[MyClass alloc] init];
    myclass.message=@"asdfdsfas";
    
    [EncryptedStorageUtils saveDocumentData:myclass withFileName:@"1111"];
    
    MyClass *getData=[EncryptedStorageUtils readDocumentDataWithFileName:@"1111"];
    NSLog(@"==%@===",getData.message);
    
    
    MyCustomClass *mycustomclass=[[MyCustomClass alloc] init];
    mycustomclass.message=@"lkljklkj";
    
    [EncryptedStorageUtils saveDocumentData:mycustomclass withFileName:@"1111"];
    
    MyCustomClass *getcustomData=[EncryptedStorageUtils readDocumentDataWithFileName:@"1111"];
    NSLog(@"==%@===",getcustomData.message);
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
