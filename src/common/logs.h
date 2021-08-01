#pragma once

#include "cclogger.h"
#include "event_awaiter.h"

#include <atomic>

#define log_err(args...)        \
    do {    \
        nds::CCLogger* ll = nds::CCLogger::instance(); \
        if (ll) _log_err(ll, args); \
    } while(false)

#define log_warn(args...)        \
    do {    \
        nds::CCLogger* ll = nds::CCLogger::instance(); \
        if (ll) _log_warn(ll, args); \
    } while(false)

#define log_info(args...)        \
    do {    \
        nds::CCLogger* ll = nds::CCLogger::instance(); \
        if (ll) _log_info(ll, args); \
    } while(false)

#define log_debug(args...)        \
    do {    \
        nds::CCLogger* ll = nds::CCLogger::instance(); \
        if (ll) _log_debug(ll, args); \
    } while(false)
