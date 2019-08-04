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
    //page1.title = @"Bem-vindo à Faculdade de Ciências e Tecnologias";
    //page1.desc = @"Conhece a nossa Faculdade com esta app";
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    //page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"Inúmeras funcionalidades";
    page2.desc = @"Desenhadas para te ajudar na tua vida académica";
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"introicons"]];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = sampleDescription3;
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.desc = sampleDescription4;
    page4.bgImage = [UIImage imageNamed:@"bg4"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    
    EAIntroPage *page5 = [EAIntroPage page];
    page5.title = @"This is page 5";
    page5.desc = sampleDescription2;
    page5.bgImage = [UIImage imageNamed:@"bg2"];
    page5.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    
    
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4,page5]];
    intro.skipButtonAlignment = EAViewAlignmentCenter;
    intro.skipButtonY = 80.f;
    intro.pageControlY = 42.f;
    
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

