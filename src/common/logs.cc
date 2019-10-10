#include "logs.h"

#include <assert.h>

// static const auto logger_deleter = [](SimpleLogger* ptr) {
//     if (!ptr) return ;

//     ptr->stop();
//     delete ptr;
// }

Logger::~Logger() {
    for (auto ll : logs) {
        if (!ll) {
            continue;
        }

        ll->stop();
        delete ll;
    }

    resetInitialized();
    SimpleLogger::shutdown(); 
}

Logger& Logger::instance() {
    static Logger logger;
    return logger;
}

bool Logger::initLogger(std::string filename,
                         SimpleLogger::Levels log_level,
                         SimpleLogger::Levels dis_level)
{
    Logger& inst = Logger::instance();
    if (!inst.setInitialized()) {
        fprintf(stderr, "logger already been initialized!"
                         "filename[%s] log_level[%d] dis_level[%d]",
                         filename.c_str(), log_level, dis_level);
        return false;
    }

    bool rc = inst.registerLogger(LogModules::DEFAULT_LOG, filename, log_level, dis_level);
    if (!rc) {
        inst.resetInitialized();
    }

    return rc;
}

bool Logger::setInitialized() {
    bool expect = false;
    if (!initialized.compare_exchange_weak(expect, true)) {
        return false;
    }

    return true;
}

SimpleLogger* Logger::getLogger() {
    Logger& inst = Logger::instance();
    if (!inst.isInitialized()) { 
        return nullptr;
    }

    return inst.getLoggerByModule(inst.curLogModule);
}

bool Logger::registerLogger(LogModules module,
                             std::string filename,
                             SimpleLogger::Levels log_level,
                             SimpleLogger::Levels dis_level)
{
    spinLock.lock();

    uint32_t expect_count = module + 1;
    if (logs.size() < expect_count) {
        // fprintf(stderr, "register_logger failed! module[%d] filename[%s] "
        //                 "log_level[%d] dis_level[%d]",
        //                 module, filename.c_str(), log_level, dis_level);
        logs.resize(expect_count);
    }

    if (logs[module]) {
        fprintf(stderr, "logger already been registered! module[%d] "
                         "filename[%s] log_level[%d] dis_level[%d]",
                         module, filename.c_str(), log_level, dis_level);
        spinLock.unlock();
        return false;
    }

    // std::shared_ptr<SimpleLogger> ll(nullptr, logger_deleter);
    // ll.reset(new SimpleLogger(filename));
    SimpleLogger* ll = new SimpleLogger(filename);
    ll->start();
    ll->setLogLevel(log_level);
    ll->setDispLevel(dis_level);

    logs[module] = ll;
    curLogModule = module;

    spinLock.unlock();
    return true;
}

SimpleLogger* Logger::getLoggerByModule(LogModules module) {
    spinLock.lock();
    uint32_t expect_count = module + 1;
    if (logs.size() < expect_count) {
        spinLock.unlock();
        return nullptr;
    }

    SimpleLogger* ll = logs[module];
    spinLock.unlock();

    return ll;
}
