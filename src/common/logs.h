#pragma once

#include "logger.h"
#include "event_awaiter.h"

#include <atomic>

class Logger;

#define log_sys(args...)        \
    do {    \
        Logger& inst = Logger::instance(); \
        SimpleLogger* ll = inst.getLogger();  \
        if (ll) _log_sys(ll, args); \
    } while(false)

#define log_fatal(args...)        \
    do {    \
        Logger& inst = Logger::instance(); \
        SimpleLogger* ll = inst.getLogger();  \
        if (ll) _log_fatal(ll, args); \
    } while(false)

#define log_err(args...)        \
    do {    \
        Logger& inst = Logger::instance(); \
        SimpleLogger* ll = inst.getLogger();  \
        if (ll) _log_err(ll, args); \
    } while(false)

#define log_warn(args...)        \
    do {    \
        Logger& inst = Logger::instance(); \
        SimpleLogger* ll = inst.getLogger();  \
        if (ll) _log_warn(ll, args);    \
    } while(false)

#define log_info(args...)        \
    do {    \
        Logger& inst = Logger::instance(); \
        SimpleLogger* ll = inst.getLogger();  \
        if (ll) _log_info(ll, args); \
    } while(false)

#define log_debug(args...)        \
    do {    \
        Logger& inst = Logger::instance(); \
        SimpleLogger* ll = inst.getLogger();  \
        if (ll) _log_debug(ll, args);   \
    } while(false)

#define log_trace(args...)        \
    do {    \
        Logger& inst = Logger::instance(); \
        SimpleLogger* ll = inst.getLogger();  \
        if (ll) _log_trace(ll, args);   \
    } while(false)

typedef enum LogModules : uint32_t {
    DEFAULT_LOG = 0,
    TESTS_LOG = 1
} LogModules;

class Logger {
public:
    ~Logger();

public:
    static Logger& instance();
    static bool initLogger(std::string filename,
                            SimpleLogger::Levels log_level = SimpleLogger::TRACE,
                            SimpleLogger::Levels dis_level = SimpleLogger::SYS);
    static SimpleLogger* getLogger();

private:
    bool registerLogger(LogModules module,
                         std::string filename,
                         SimpleLogger::Levels log_level = SimpleLogger::SYS,
                         SimpleLogger::Levels dis_level = SimpleLogger::SYS);
    SimpleLogger* getLoggerByModule(LogModules module);

    bool setInitialized();
    bool isInitialized() { return initialized; }
    void resetInitialized() { initialized = false; }

private:
    Logger() : initialized(false) {}
    Logger(const Logger& obj);
    Logger& operator=(const Logger& str);

private:
    std::atomic<bool> initialized;
    LogModules curLogModule;
    SpinLocker spinLock;
    //std::unordered_map<int32_t, std::shared<SimpleLoggerMgr>> logMgrs;
    std::vector<SimpleLogger*> logs;
};
