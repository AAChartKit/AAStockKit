//
//  AAStockOptionsComposer.m
//  AAChartKitDemo
//
//  Created by AnAn on 2019/10/19.
//  Copyright © 2019 Danny boy. All rights reserved.
//

#import "AAStockOptionsComposer.h"

@implementation AAStockOptionsComposer

+ (AAOptions *)stockOptions {
    
//    data = data.data;
//    var ohlc = [],
//        volume = [],
//        dataLength = data.length,
//        // set the allowed units for data grouping
//        groupingUnits = [[
//            'week',                         // unit name
//            [1]                             // allowed multiples
//        ], [
//            'month',
//            [1, 2, 3, 4, 6]
//        ]],
//        i = 0;
//    for (i; i < dataLength; i += 1) {
//        ohlc.push([
//            data[i][0], // the date
//            data[i][1], // open
//            data[i][2], // high
//            data[i][3], // low
//            data[i][4] // close
//        ]);
//        volume.push([
//            data[i][0], // the date
//            data[i][5] // the volume
//        ]);
//    }

    
    NSDictionary *candlestickDataJsonDic = [self getJsonDataWithJsonFileName:@"candlestickData"];
    NSArray *data = candlestickDataJsonDic[@"data"];
    
    NSMutableArray *ohlc = [NSMutableArray array];
    NSMutableArray *volumne = [NSMutableArray array];
    NSInteger dataLength = data.count;
    
    for (int i = 0; i< dataLength; i++) {
        [ohlc addObject:@[
                    data[i][0], // the date
                    data[i][1], // open
                    data[i][2], // high
                    data[i][3], // low
                    data[i][4] // close
        ]];
        
        [volumne addObject:@[
                   data[i][0], // the date
                    data[i][5] // the volume
        ]];
    }
    
    AAChart *aaChart = AAChart.new
    .backgroundColorSet(@"#000000")
    ;
    
    AATooltip *aaTooltip = AATooltip.new
    .enabledSet(@true)
    .sharedSet(@true);
    
    
    AAYAxis *aaYAxis1 = AAYAxis.new
    .heightSet(@"65%");
    AAYAxis *aaYAxis2 = AAYAxis.new
    .topSet(@"65%")
    .heightSet(@"35%");
    
    AASeriesElement *element1 = AASeriesElement.new
    .typeSet(@"candlestick")
    .nameSet(@"平安银行")
    .colorSet(@"green")
    .dataSet(ohlc)
    ;
    
    AASeriesElement *element2 = AASeriesElement.new
    .typeSet(@"column")
    .yAxisSet(@1)
    .dataSet(volumne)
    ;
    
    return AAOptions.new
    .chartSet(aaChart)
    .tooltipSet(aaTooltip)
    .yAxisSet((id)@[aaYAxis1,aaYAxis2])
    .seriesSet(@[element1,element2])
    ;
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (id)getJsonDataWithJsonFileName:(NSString *)jsonFileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:jsonFileName ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (!jsonData || error) {
        //DLog(@"JSON解码失败");
        return nil;
    } else {
        return jsonObj;
    }
}

@end
