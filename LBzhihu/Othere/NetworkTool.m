//
//  NetToolbar.m
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "NetworkTool.h"

@implementation NetworkTool
{
    NSDate *lastDate;
}

static NetworkTool *tool;

+ (instancetype)sharedNetworkTool{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        tool  = [[self alloc] init];
    });
    return tool;
}


- (void)getThemeTypeWhensuccess:(void (^)(ThemeType *))success failure:(void (^)())failure{
    NSString *urlStr = @"http://news-at.zhihu.com/api/4/themes";
    

    lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastDate"];
    if (!lastDate) {
        lastDate = [NSDate date];
    }
   
    [self getDataWithUrlString:urlStr WithClass:[ThemeType class] success:success failure:failure];
}

- (void)getTodayStoriesWhensuccess:(void (^)(ContentList *))success failure:(void (^)())failure{
   NSString *urlStr = @"http://news-at.zhihu.com/api/4/stories/latest";
    
    [self getDataWithUrlString:urlStr WithClass:[ContentList class] success:success failure:failure];
}

- (void)getStoriesListWithDate:(NSString *)dateString success:(void (^)(ContentList *))success failure:(void (^)())failure{
    NSString *urlStr = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/stories/before/%@",dateString];
    
    [self getDataWithUrlString:urlStr WithClass:[ContentList class] success:success failure:failure];
}

- (void)getDetailsWithStoriesId:(NSString *)storiesId success:(void (^)(DetailsModel *))success failure:(void (^)())failure{
    NSString *urlStr = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%@",storiesId];
    
    [self getDataWithUrlString:urlStr WithClass:[DetailsModel class] success:success failure:failure];
}

- (void)getStoriesListWithStorieId:(NSString *)storieId success:(void (^)(ContentList *))success failure:(void (^)())failure{
    NSString *urlStr = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/theme/%@",storieId];
    
    [self getDataWithUrlString:urlStr WithClass:[ContentList class] success:success failure:failure];    
}

//评论 赞数量

- (void)getDetailsInfoWithWithStoriesId:(NSString *)storiesId success:(void (^)(DetailsInfo *))success failure:(void (^)())failure{
    NSString *urlStr = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story-extra/%@",storiesId];
    
    [self getDataWithUrlString:urlStr WithClass:[DetailsInfo class] success:success failure:failure];
}


//评论

- (void)getLongComments:(NSString *)storieId success:(void (^)(CommentsModel *))success failure:(void (^)())failure{
    NSString *urlStr = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%@/long-comments",storieId];
    [self getDataWithUrlString:urlStr WithClass:[CommentsModel class] success:success failure:failure];
}

- (void)getShortComments:(NSString *)storieId success:(void (^)(CommentsModel *))success failure:(void (^)())failure{
    NSString *urlStr = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%@/short-comments",storieId];
    [self getDataWithUrlString:urlStr WithClass:[CommentsModel class] success:success failure:failure];
}


- (void)getDataWithUrlString:(NSString *)urlString WithClass:(Class)className success:(void (^)(id data))success failure:(void (^)())failure{

    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    //如果是栏目列表，使用缓存
    if ([urlString isEqualToString: @"http://news-at.zhihu.com/api/4/themes"]) {
        request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;

        //大于等于7天,清除缓存
        if([lastDate timeIntervalSinceNow] <= -7 * 24 * 60 * 60){
            NSURLCache *cache = [NSURLCache sharedURLCache];
            [cache removeCachedResponseForRequest:request];
        }else{
            lastDate = [NSDate date];
            [[NSUserDefaults standardUserDefaults] setObject:lastDate forKey:@"lastDate"];
        }
    }
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            failure();
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            id t = [[className alloc] initWithDictionary:dic];
            if (t) {
                success(t);
            }else{
                failure();
            }
        }
    }];
    
}

@end
