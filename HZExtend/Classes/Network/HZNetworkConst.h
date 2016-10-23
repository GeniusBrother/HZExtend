//
//  HZNetworkConst.h
//  Pods
//
//  Created by xzh on 16/9/25.
//
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

//使用在Ctrl里viewModel的回调方法里，将HZViewModel装换成自身的viewModel类型,
#define HZNETWORK_CONVERT_VIEWMODEL(ClassForToViewModel) ClassForToViewModel *selfViewModel = (ClassForToViewModel *)viewModel

#define HZ_FILE_MIME_TYPE_KEY @"mimeType"

#define HZ_FILE_NAME_KEY @"fileName"

#define HZ_FILE_FORM_NAME_KEY @"formName"

#define HZ_FILE_DATA_KEY @"fileData"

#endif /* HZNetworkConst_h */
