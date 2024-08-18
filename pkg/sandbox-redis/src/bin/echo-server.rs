// SPDX-License-Identifier: GPL-3.0

use tokio::io;
use tokio::net::TcpListener;

#[tokio::main]
async fn main() -> io::Result<()> {
    let listener = TcpListener::bind("127.0.0.1:6142").await?;

    loop {
        let (mut socket, _) = listener.accept().await?;
        tokio::spawn(async move {
            let (mut rx, mut tx) = socket.split();
            if io::copy(&mut rx, &mut tx).await.is_err() {
                eprintln!("failed to copy");
            }
        });
    }
}
