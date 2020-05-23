//
//  TYWJDriverLaunchedHeaderView.m
//  TYWJBus
//
//  Created by Harley He on 2018/8/2.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJDriverLaunchedHeaderView.h"
#import "TYWJBorderButton.h"
#import "TYWJSubRouteList.h"
#import "TYWJSoapTool.h"
#import "TYWJPeopleNum.h"

#import <MJExtension.h>
#import "SpeechSynthesizer.h"


@interface TYWJDriverLaunchedHeaderView()<AVSpeechSynthesizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *stationLabel;
@property (weak, nonatomic) IBOutlet UILabel *getupNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *getdownNumLabel;
@property (weak, nonatomic) IBOutlet TYWJBorderButton *lastStationBtn;
@property (weak, nonatomic) IBOutlet TYWJBorderButton *nextStationBtn;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;


/* dateFormatter */
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
/* numData */
@property (strong, nonatomic) TYWJPeopleNum *numData;

@end

@implementation TYWJDriverLaunchedHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    return _dateFormatter;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.contentView setRoundView];
    [self.contentView setBorderWithColor:ZLNavTextColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.stationLabel.font = [UIFont boldSystemFontOfSize:18.f];
    self.effectView.alpha = 0.85f;
}

- (IBAction)lastStationClicked:(id)sender {
    ZLFuncLog;
    if (self.lastStationClicked) {
        self.lastStationClicked();
    }
}

- (IBAction)nextStationClicked:(TYWJBorderButton *)sender {
    ZLFuncLog;
    if (self.nextStationClicked) {
        self.nextStationClicked();
    }
}

- (void)setListInfo:(TYWJSubRouteListInfo *)listInfo {
    if ([_listInfo isEqual:listInfo]) {
        return;
    }
    
    _listInfo = listInfo;
    
    self.stationLabel.text = listInfo.station;
    [self requestGetupAndDownPeopleNum];
    
}

- (void)requestGetupAndDownPeopleNum {
    //TYWJRequestUploadDiverLocation
    WeakSelf;
    NSString *date = [self.dateFormatter stringFromDate:[NSDate date]];
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <rq>%@</rq>\
                              <xl>%@</xl>\
                              <zm>%@</zm>\
                              </%@>",TYWJRequestGetStaionPassengerNum,TYWJRequestService,date,self.listInfo.routeNum,self.listInfo.stationNum,TYWJRequestGetStaionPassengerNum];
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:soapBodyStr success:^(id responseObject) {
        NSDictionary *dataDic = responseObject[0][@"NS1:getchezhanrenshuResponse"][@"zhanrenshuList"];
        if (dataDic.count > 1) {
            weakSelf.numData = [TYWJPeopleNum mj_objectWithKeyValues:dataDic[@"chrq"]];
            weakSelf.getupNumLabel.text = [NSString stringWithFormat:@"本站应上车%@人",weakSelf.numData.numInfo.getupPassengers];
            weakSelf.getdownNumLabel.text = [NSString stringWithFormat:@"本站应下车%@人",weakSelf.numData.numInfo.getdownPassengers];
        }else {
            weakSelf.getupNumLabel.text = @"本站应上车0人";
            weakSelf.getdownNumLabel.text = @"本站应下车0人";
        }
        NSString *station = nil;
        if (self.isTheLastStation) {
            station = [NSString stringWithFormat:@"终点站:%@",self.listInfo.station];
        }else {
            station = [NSString stringWithFormat:@"%@:",self.listInfo.station];
        }
        [weakSelf speechWithString:[NSString stringWithFormat:@"当前站点%@,%@,%@",station,self.getupNumLabel.text,self.getdownNumLabel.text]];
    } failure:^(NSError *error) {
        ZLLog(@"网络差");
    }];
}

- (void)setIsTheLastStation:(BOOL)isTheLastStation {
    _isTheLastStation = isTheLastStation;
    
    if (isTheLastStation) {
        [self.nextStationBtn setTitle:@"收车" forState:UIControlStateNormal];
    }else {
        [self.nextStationBtn setTitle:@"下一站" forState:UIControlStateNormal];
    }
}

- (void)speechWithString:(NSString *)speechString {
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:speechString];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView setRoundView];
}

@end
