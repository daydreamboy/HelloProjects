//
//  ScopedMutex.h
//  HelloNSThread
//
//  Created by wesley_chen on 2019/5/21.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#ifndef ScopedMutex_h
#define ScopedMutex_h

#import <pthread.h>
#import <UIKit/UIKit.h>

#define TIME_LOCKER 0

#if defined(__cplusplus) && defined(__GNUC__)
#define PERF_NOTHROW __attribute__((nothrow))
#else
#define PERF_NOTHROW
#endif

// This MUST always execute, even when assertions are disabled. Otherwise all lock operations become no-ops!
// (To be explicit, do not turn this into an NSAssert, assert(), or any other kind of statement where the
// evaluation of x_ can be compiled out.)
#define PERF_THREAD_ASSERT_ON_ERROR(x_) do { \
_Pragma("clang diagnostic push"); \
_Pragma("clang diagnostic ignored \"-Wunused-variable\""); \
volatile int res = (x_); \
assert(res == 0); \
_Pragma("clang diagnostic pop"); \
} while (0)


namespace PERF {
    template<class T>
    class Locker
    {
        T &_l;
#if TIME_LOCKER
        CFTimeInterval _ti;
        const char *_name;
#endif
    public:
#if !TIME_LOCKER
        Locker(T &l) PERF_NOTHROW : _l(l) {
            _l.lock();
        }
        
        ~Locker() {
            _l.unlock();
        }
        
        // non-copyable
        Locker(const Locker<T>&) = delete;
        Locker &operator=(const Locker<T>&) = delete;
#else
        Locker(T &l, const char *name = NULL) PERF_NOTHROW : _l(l), _name(name) {
            _ti = CACurrentMediaTime();
            _l.lock();
        }
        
        ~Locker() {
            _l.unlock();
            if (_name) {
                printf(_name, NULL);
                printf(" dt:%f\n", CACurrentMediaTime() - _ti);
            }
        }
#endif
    };
    
    struct Mutex
    {
        // Constructs a non-recursive mutext (the default)
        Mutex() : Mutex (false) {}
        
        ~Mutex() {
            PERF_THREAD_ASSERT_ON_ERROR(pthread_mutex_destroy(&_m));
        }
        
        Mutex(const Mutex&) = delete;
        Mutex &operator=(const Mutex&) = delete;
        
        void lock() {
            PERF_THREAD_ASSERT_ON_ERROR(pthread_mutex_lock(this->mutex()));
        }
        
        void unlock() {
            PERF_THREAD_ASSERT_ON_ERROR(pthread_mutex_unlock(this->mutex()));
        }
        
        pthread_mutex_t* mutex() {
            return &_m;
        }
    protected:
        explicit Mutex(bool recursive) {
            if (!recursive) {
                PERF_THREAD_ASSERT_ON_ERROR(pthread_mutex_init(&_m, NULL));
            }
            else {
                pthread_mutexattr_t attr;
                PERF_THREAD_ASSERT_ON_ERROR(pthread_mutexattr_init(&attr));
                PERF_THREAD_ASSERT_ON_ERROR(pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE));
                PERF_THREAD_ASSERT_ON_ERROR(pthread_mutex_init(&_m, &attr));
                PERF_THREAD_ASSERT_ON_ERROR(pthread_mutexattr_destroy(&attr));
            }
        }
    private:
        pthread_mutex_t _m;
    };
    
    typedef Locker<Mutex> MutexLocker;
}

#endif /* ScopedMutex_h */
