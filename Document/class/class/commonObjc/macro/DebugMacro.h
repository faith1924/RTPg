//
//  DebugMacro.h
//  RTPg
//
//  Created by md212 on 2019/4/10.
//  Copyright © 2019年 atts. All rights reserved.
//

#ifndef DebugMacro_h
#define DebugMacro_h

// =================

#ifdef DEBUG

#ifndef JYLog
#define JYLog(fmt, ...) NSLog((@"[%s Line %d]" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif

#else

#ifndef JYLog
#define JYLog(fmt, ...) // NSLog((@"[%s Line %d]" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif

#define NSLog // NSLog

#endif
#endif


