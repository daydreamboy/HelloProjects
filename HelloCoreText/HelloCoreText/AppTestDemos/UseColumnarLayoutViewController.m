//
//  UseColumnarLayoutViewController.m
//  HelloCoreText
//
//  Created by wesley_chen on 2019/4/26.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseColumnarLayoutViewController.h"
#import "ColumnarLayoutView.h"

@interface UseColumnarLayoutViewController ()
@property (nonatomic, strong) ColumnarLayoutView *drawableView;
@property (nonatomic, strong) NSString *textString;
@end

@implementation UseColumnarLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.drawableView];
}

- (ColumnarLayoutView *)drawableView {
    if (!_drawableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat navMaxY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        
        _drawableView = [[ColumnarLayoutView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height - navMaxY)];
        _drawableView.backgroundColor = [UIColor whiteColor];
        _drawableView.layer.borderColor = [UIColor redColor].CGColor;
        _drawableView.layer.borderWidth = 1.0;
        _drawableView.attributedString = [[NSAttributedString alloc] initWithString:self.textString];
    }
    
    return _drawableView;
}

- (NSString *)textString {
    if (!_textString) {
        _textString = @"\
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras vitae finibus sem. Nam eu diam arcu. Sed imperdiet dui eget dui mattis euismod. Vivamus hendrerit ullamcorper neque, ac volutpat lectus sollicitudin eu. Sed id purus blandit, vestibulum enim a, consequat ligula. Quisque nunc nunc, efficitur a congue quis, viverra et ligula. Duis ligula mi, imperdiet et posuere in, fringilla vitae dolor. Mauris tincidunt fringilla lorem, nec vulputate nibh consectetur at. Nunc at pretium nisi. Vivamus auctor mi metus, ac elementum neque mattis in. Pellentesque orci ante, pellentesque facilisis ligula vehicula, tristique gravida ipsum. Quisque tortor quam, finibus sit amet diam sed, vestibulum elementum ligula.\
\
In hac habitasse platea dictumst. Nullam in scelerisque lacus. Suspendisse magna libero, sollicitudin at commodo sed, fermentum at tellus. Integer nec tincidunt erat. Praesent tempor dui mi, sit amet condimentum ex malesuada in. Donec euismod laoreet quam interdum tincidunt. Vestibulum purus nisi, maximus at erat a, pretium consequat tellus. Aliquam sit amet lectus arcu. Vivamus sollicitudin massa sem, eget elementum nibh pretium sed.\
\
Sed vitae nisi vel felis dignissim blandit. Praesent maximus, elit sit amet tempor consectetur, dui ligula blandit augue, ac finibus quam eros ac est. Aliquam lorem nibh, laoreet in vulputate ut, facilisis sit amet felis. Pellentesque ipsum neque, suscipit ac mi eget, elementum facilisis augue. Aenean vehicula viverra rutrum. Curabitur suscipit blandit odio, at condimentum dui. Duis mauris ipsum, varius vitae scelerisque et, tincidunt in mi. Aenean sit amet semper libero, eleifend mattis quam. Nunc cursus urna a leo interdum sollicitudin. Donec eget sem ut mauris aliquam faucibus quis nec risus. Vivamus auctor, tortor quis posuere rutrum, lorem felis efficitur nulla, vel pharetra mauris lorem ut nisl. Proin tristique sapien eget faucibus auctor. Praesent quis vestibulum mauris.\
\
Morbi finibus ipsum vitae lectus mollis, vitae molestie arcu faucibus. Quisque suscipit felis aliquam libero fermentum consectetur. Maecenas volutpat molestie ex, in volutpat mauris ullamcorper sit amet. Fusce nec orci hendrerit, sodales ex ut, suscipit enim. Nunc quis purus at lectus facilisis rutrum quis vel nibh. Donec eget efficitur orci. Cras at neque lacinia, condimentum tellus quis, commodo dui. Fusce lacinia erat at dui elementum pretium. Nunc sagittis, massa a dictum tincidunt, risus ipsum sagittis mi, at malesuada justo justo eget urna. Ut nec scelerisque felis. Morbi nec neque elit. Fusce a lacus eget arcu eleifend lobortis et eget purus. Donec ac risus eget odio ullamcorper interdum id lobortis tortor.\
\
Curabitur aliquam efficitur fringilla. Duis volutpat rutrum leo. Praesent vel porttitor libero. Sed tempor fermentum augue, in imperdiet neque facilisis euismod. Nunc sed scelerisque leo. Sed facilisis tempor lectus, quis feugiat nisi volutpat dapibus. Proin elementum facilisis vehicula. Aliquam sit amet dolor aliquet, maximus nisi id, mattis mauris. Morbi dictum nibh ac elit molestie hendrerit.\
        ";
    }
    
    return _textString;
}

@end
