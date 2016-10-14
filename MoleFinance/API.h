//
//  API.h
//  MoleFinance
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#ifndef MoleFinance_API_h
#define MoleFinance_API_h

#define API_NEWS @"http://newsapi.eastmoney.com/kuaixun/v2/api/yw?banner=banner&encode=ywjh&limit=%ld"

#define API_ME @"http://newsapi.eastmoney.com/kuaixun/v2/api/yw?banner=banner&encode=dpfx&limit=%ld"
#define API_ME_CLICK @"http://newsapi.eastmoney.com/kuaixun/v2/api/content?newsid=%@&newstype=%@"

#define API_LIVE @"http://newsapi.eastmoney.com/kuaixun/v2/api/list?column=zhibo&limit=%ld"
#define API_LIVE_CLICK @"http://newsapi.eastmoney.com/kuaixun/v2/api/content?newsid=20151013APPGPcHyQdBEIndustry&newstype=4"

#define API_DARK @"http://newsapi.eastmoney.com/kuaixun/v2/api/yw?banner=banner&encode=ggdj&limit=%ld"
#define API_DARK_CLICK @"http://newsapi.eastmoney.com/kuaixun/v2/api/content?newsid=%@&newstype=%@"

#endif
