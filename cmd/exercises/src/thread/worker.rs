// SPDX-License-Identifier: GPL-3.0

use std::sync::{mpsc, Arc, Mutex};
use std::thread;

pub type Job = Box<dyn FnOnce() + Send + 'static>;

#[derive(Debug)]
pub struct Worker {
    pub id: usize,
    pub thread: thread::JoinHandle<()>,
}

impl Worker {
    pub fn new(id: usize, receiver: Arc<Mutex<mpsc::Receiver<Job>>>) -> Worker {
        let thread = thread::spawn(move || loop {
            let job = receiver.lock().unwrap().recv().unwrap();
            println!("Worker {id} got a job! Executing...");
            job();
        });
        Worker { id, thread }
    }
}
