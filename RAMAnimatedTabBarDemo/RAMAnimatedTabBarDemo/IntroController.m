//
//  ViewController.m
//
//  Copyright (c) 2013-2017 Evgeny Aleksandrov. License: MIT.

#import <EAIntroView/EAIntroView.h>
#import <SMPageControl/SMPageControl.h>

#import "IntroController.h"

static NSString * const sampleDescription1 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
static NSString * const sampleDescription2 = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
static NSString * const sampleDescription3 = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
static NSString * const sampleDescription4 = @"Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit.";

@interface ViewController () <EAIntroDelegate> {
    UIView *rootView;
    EAIntroView *_intro;
}

@end

@implementation ViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    rootView = self.navigationController.view;
    [self showIntroWithCrossDissolve];
}

#pragma mark - Demo

- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"bg1"];

    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"bg3"];

    EAIntroPage *page4 = [EAIntroPage page];
    page4.bgImage = [UIImage imageNamed:@"bg4"];

    EAIntroPage *page5 = [EAIntroPage page];
    page5.bgImage = [UIImage imageNamed:@"bg5"];
    
    EAIntroPage *page6 = [EAIntroPage page];
    page6.bgImage = [UIImage imageNamed:@"bg6"];
    
    EAIntroPage *page7 = [EAIntroPage page];
    page7.bgImage = [UIImage imageNamed:@"bg7"];
    
    EAIntroPage *page8 = [EAIntroPage page];
    page8.bgImage = [UIImage imageNamed:@"bg8"];

    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4,page5,page6,page7,page8]];
    intro.skipButtonAlignment = EAViewAlignmentCenter;
    intro.skipButtonY = 80.f;
    intro.pageControlY = 42.f;
    [intro.skipButton setTitle:@"Saltar" forState:UIControlStateNormal];
    [intro setDelegate:self];
    
    [intro showInView:rootView animateDuration:0.3];
}


#pragma mark - EAIntroView delegate

- (void)introDidFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped {
    
    //dont show intro again
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"User" forKey:@"intro"];
    [defaults synchronize];
    //Volta ao inicio
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
    ViewController *loginVC = (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"RAMAnimatedTabBarController"];
      [self presentViewController: loginVC animated:YES completion:NULL];

    
    
}

#pragma mark - Custom actions

- (IBAction)switchFlip:(id)sender {
    UISwitch *switchControl = (UISwitch *) sender;
    NSLog(@"%@", switchControl.on ? @"On" : @"Off");
    if(!switchControl.on) {
        // scroll no further selected page (can go previous pages, but not next)
        _intro.limitPageIndex = _intro.visiblePageIndex;
    } else {
        [_intro setScrollingEnabled:YES];
    }
}


@end
