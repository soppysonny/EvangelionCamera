#import <Masonry.h>
#import "TextToPicViewController.h"
#define STATUSBARHEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
@interface TextToPicViewController ()

@end

@implementation TextToPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView = [UITextView new];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make){        make.edges.mas_equalTo(UIEdgeInsetsMake(STATUSBARHEIGHT+40, 0, 39, 0));
    }];
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
