//
//  ViewController.m
//  StarbucksCount
//
//  Created by Brian Tung on 11/9/14.
//  Copyright (c) 2014 Flame Co. All rights reserved.
//

#import "ViewController.h"
#import "AMViralSwitch.h"
#import "BTButton.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet BTButton *updateButton;
@property (nonatomic) NSInteger count;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://weareflame.co:8803/update_count"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"1" forHTTPHeaderField:@"shouldSendCount"];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError)
        {
            
        } else
        {
            //set placeholder text of textfield here
            NSString *count = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            _count = [count integerValue];
            _textField.placeholder = [NSString stringWithFormat:@"Currently Owed: %@", count];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateCount:(UIButton *)sender
{
    [_textField resignFirstResponder];
    if (_textField.text != nil) _count = _textField.text.integerValue;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://weareflame.co:8803/update_count"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"0" forHTTPHeaderField:@"shouldSendCount"];
    [request setValue:[NSString stringWithFormat:@"%i", (int)_count] forHTTPHeaderField:@"count"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError)
        {
            
        } else
        {
            NSString *count = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            _count = [count integerValue];
            _textField.placeholder = [NSString stringWithFormat:@"Currently Owed: %@", count];
            _textField.text = nil;
        }
    }];
}

@end
