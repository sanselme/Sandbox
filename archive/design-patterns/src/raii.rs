// SPDX-License-Identifier: GPL-3.0

use std::ops::Deref;

struct Foo {}
impl Foo {
    fn foo(&self) {}
}

struct Mutex<T> {
    // We keep a reference to our data: T here.
    inner: T,
}

struct MutexGuard<'a, T: 'a> {
    data: &'a T,
}

// Locking the mutex is explicit.
impl<T> Mutex<T> {
    fn lock(&self) -> MutexGuard<T> {
        // Lock the underlying OS mutex.

        // MutexGuard keeps a reference to self
        MutexGuard { data: &self.inner }
    }
}

// Destructor for unlocking the mutex.
impl<'a, T> Drop for MutexGuard<'a, T> {
    fn drop(&mut self) {
        // Unlocking underlying os mutex.
    }
}

// Implementing Deref means we can treat MutexGuard like a pinter to T.
impl<'a, T> Deref for MutexGuard<'a, T> {
    type Target = T;

    fn deref(&self) -> &Self::Target {
        self.data
    }
}

fn baz(x: Mutex<Foo>) {
    let xx = x.lock();
    xx.foo(); // foo is a method on Foo.
              // The borrow checker ensures we can't store a reference to the underlying
              // Foo which will outlive the guard xx.

    // x is unlocked when we exit this function and xx's destructor is executed.
}
