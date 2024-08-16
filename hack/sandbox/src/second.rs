// SPDX-License-Identifier: GPL-3.0

/// Time in seconds.
///
/// # Example
///
/// ```
/// let s = sandbox::Second::new(42);
/// assert_eq!(42, s.value());
#[derive(Default)]
pub struct Second {
    value: u64,
}

impl Second {
    // Constructs a new instance of [`Second`].
    // note: this is an associated function - no self.
    pub fn new(value: u64) -> Self {
        Self { value }
    }

    // Returns the value in seconds.
    pub fn value(&self) -> u64 {
        self.value
    }
}
