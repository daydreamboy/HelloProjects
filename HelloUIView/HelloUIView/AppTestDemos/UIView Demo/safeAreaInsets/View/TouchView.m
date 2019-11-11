//
//  TouchView.m
//  HelloUIView
//
//  Created by wesley_chen on 2019/11/11.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "TouchView.h"

#import "WCViewTool.h"

#define LONG_TEXT @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. In mattis eu nunc sit amet posuere. Aliquam dignissim vel dui vel dapibus. Mauris fermentum iaculis eros vitae scelerisque. Nunc vel lobortis quam. Nulla suscipit nibh consequat ex rhoncus consequat. Cras scelerisque vitae quam sit amet dignissim. Pellentesque mattis tincidunt lectus. In scelerisque nisl sed nisl aliquet, nec semper leo pulvinar. Cras interdum lorem leo, ut tincidunt lacus interdum eu. Vestibulum vitae eros vehicula, lobortis ligula sed, ultrices quam. Duis rutrum facilisis consequat. Curabitur ultricies fringilla felis et suscipit. Phasellus ac nisi blandit, pharetra nisi vel, egestas augue. Vivamus volutpat, ligula sit amet varius venenatis, purus nunc scelerisque risus, quis suscipit velit purus non orci. Quisque tortor massa, lobortis vitae tellus vitae, fringilla pulvinar augue. Phasellus in sodales quam. Vestibulum fermentum ullamcorper lectus. Nullam venenatis, ipsum a pellentesque blandit, ex mi cursus lorem, sed congue diam quam a mauris. Fusce mollis dolor ut convallis imperdiet. Mauris varius dictum dictum. Sed laoreet vehicula nisl a auctor. Aliquam eu ipsum dui. Phasellus lacinia lobortis dui vitae scelerisque. Donec faucibus feugiat varius. Nunc at congue metus. Morbi blandit a ante eget blandit. Praesent eu purus sed lectus rutrum posuere. Suspendisse pulvinar vitae orci in tristique. Nunc quis lectus in enim lobortis pharetra. Etiam et dui a mi suscipit vehicula in at tellus. Integer vitae magna ultrices, tristique augue ut, rutrum orci. Sed eget feugiat felis. Maecenas sapien risus, auctor nec elit in, commodo euismod justo. Vestibulum eget egestas metus. Suspendisse potenti. Pellentesque ultricies commodo metus, ultrices dictum mi vehicula non. Nulla facilisi. Phasellus quis diam tincidunt, viverra elit sit amet, faucibus enim. Aliquam pharetra in augue eu dapibus. Pellentesque gravida dui feugiat justo semper ultricies. Fusce eu diam eget tortor rutrum gravida. Donec viverra vel massa ut condimentum. Integer quis diam lacinia, tempus elit vitae, dignissim metus. Aenean ac nunc nec mi consectetur pretium. Donec sed libero sollicitudin enim scelerisque mollis at id nibh. Nam varius magna sed ipsum egestas, vitae malesuada ante suscipit. Nulla tristique iaculis ipsum et porta. Nullam ac ex nec elit tincidunt ultricies sed ut dui. Ut aliquet ullamcorper eros, et dignissim ligula laoreet at. Fusce lorem felis, tristique eget dui in, euismod tincidunt ligula. Phasellus imperdiet, justo a auctor venenatis, risus libero suscipit odio, ac ullamcorper dolor nulla vel ipsum. Vestibulum nec lacus scelerisque, feugiat magna nec, consectetur risus. Morbi dignissim elementum purus, et vehicula nulla fermentum sed. Donec euismod lobortis tincidunt. Phasellus nec nisl et ligula tincidunt congue ut sit amet lacus. Duis fermentum metus quis dui sagittis, non ultricies ipsum dictum. Donec vestibulum vestibulum orci in euismod. Curabitur auctor venenatis dignissim. Donec sed tristique metus. Integer id tincidunt erat. Pellentesque blandit leo elit, sed egestas odio dapibus vel. Vestibulum scelerisque pulvinar libero quis auctor. Suspendisse pretium purus quis mollis fermentum. Ut pretium ante sit amet risus tincidunt rhoncus. Donec vestibulum odio vel lacus vestibulum, eu tristique velit pulvinar. Sed dignissim placerat mauris ut lacinia. Cras tempus commodo ornare. In vitae varius nibh. Suspendisse semper porttitor nulla suscipit rutrum. Sed laoreet, mauris ut congue laoreet, leo erat efficitur eros, sollicitudin auctor erat tellus vitae nulla. Donec lobortis blandit luctus. Fusce interdum condimentum vehicula. Sed et magna nec dui faucibus vulputate eu in orci. Vestibulum quis ornare orci, ac varius tortor. Cras tristique, diam ut luctus consequat, arcu nisl pellentesque turpis, ac tristique tortor purus sed dolor. Etiam egestas lacus et sapien fermentum, ac condimentum metus egestas. Vivamus mi augue, sagittis id commodo eu, fermentum at justo. Donec sed pharetra tellus. Praesent at risus suscipit, congue ipsum vitae, eleifend nisi.Phasellus laoreet laoreet finibus. Sed mattis velit ac turpis pretium dictum. Nulla faucibus iaculis nisi non vulputate. Vestibulum porttitor euismod semper. In ut faucibus dolor, nec volutpat turpis. Suspendisse id ipsum eleifend, porta dui in, dapibus massa. Nam tincidunt metus id interdum volutpat. Quisque imperdiet lacus nec volutpat vulputate. Etiam ut sodales erat. Nunc magna dolor, rhoncus eu nulla tincidunt, semper hendrerit orci. Morbi malesuada orci vulputate purus molestie, et egestas libero vestibulum.Curabitur ac finibus nisl, ut cursus tortor. Nulla pulvinar at enim sed malesuada. Duis quis ex ut enim scelerisque consectetur. Quisque suscipit ac orci nec fermentum. Etiam eleifend convallis est, quis auctor enim lobortis vel. Nunc ac odio venenatis, eleifend mauris sed, sollicitudin quam. Donec et tortor dignissim, vulputate risus eget, convallis odio. Nullam malesuada ultricies enim ut condimentum. Proin elementum nunc eget lobortis blandit. Phasellus vitae fermentum quam, nec auctor metus. Curabitur ornare, lacus quis eleifend pellentesque, lorem purus eleifend nisi, at hendrerit nulla libero id eros. Maecenas facilisis faucibus eros, in sollicitudin tellus pharetra sit amet. Praesent venenatis, dolor vel hendrerit faucibus, quam metus tempor ante, non venenatis sem leo ac nunc. Mauris nec neque lorem. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec vestibulum, lorem vitae cursus ornare, elit nunc efficitur eros, sit amet convallis massa ligula a dolor."

@interface TouchView ()
@property (nonatomic, strong) UILabel *labelText;
@property (nonatomic, strong) UILabel *labelInsets;
@end

@implementation TouchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        
        _labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelText.textColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3];
        _labelText.numberOfLines = 0;
        _labelText.font = [UIFont systemFontOfSize:16];
        _labelText.text = LONG_TEXT;
        _labelText.backgroundColor = [UIColor colorWithRed:255.0 / 255.0 green:190.0 / 255.0 blue:118.0 / 255.0 alpha:1];
        
        [self addSubview:_labelText];
        
        _labelInsets = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _labelInsets.numberOfLines = 0;
        _labelInsets.textColor = [UIColor blueColor];
        _labelInsets.font = [UIFont boldSystemFontOfSize:14];
        _labelInsets.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_labelInsets];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
    self.labelText.frame = self.safeAreaLayoutGuide.layoutFrame;
#pragma GCC diagnostic pop
    
    NSLog(@"safeAreaLayoutGuide.layoutFrame: %@", NSStringFromCGRect(self.labelText.frame));
    
    self.labelInsets.text = NSStringFromUIEdgeInsets([WCViewTool safeAreaInsetsWithView:self]);
    
    CGRect frame = [WCViewTool safeAreaFrameWithParentView:self];
    NSLog(@"frame: %@", NSStringFromCGRect(frame));
}

@end
