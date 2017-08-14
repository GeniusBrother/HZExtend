//
//  HZNetworkConst.h
//  HZNetwork
//
//  Created by xzh. on 2016/9/25.
//  Copyright (c) 2016年 xzh. All rights reserved.
//

#ifndef HZNetworkConst_h
#define HZNetworkConst_h

#define HZ_RESPONSE_LOG_FORMAT \
    @"\n\n" \
    @"------ BEGIN HZNetwork Response Error------\n" \
    @"URL: %@\n" \
    @"response: %@\n" \
    @"------ END --------------------------------\n" \
    @"\n"

#define HZ_REQUEST_LOG_FORMAT \
    @"\n\n" \
    @"------ BEGIN HZNetwork Request Error-------\n" \
    @"URL: %@\n" \
    @"error: %@\n" \
    @"------ END --------------------------------\n" \
    @"\n"

extern NSString *const kHZFileMimeType;
extern NSString *const kHZFileName;
extern NSString *const kHZFileFormName;
extern NSString *const kHZFileData;
extern NSString *const kHZFileURL;

#endif /* HZNetworkConst_h */
