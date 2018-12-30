FROM rust

LABEL maintainer="tmtmtoo <tmtmt2209@gmail.com>"
LABEL version="0.2.29"
LABEL description="The Rust wasm-bindgen environment"

# install chrome
RUN apt-get update && apt-get install -y unzip && \
    CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ && \
    unzip ~/chromedriver_linux64.zip -d ~/ && \
    rm ~/chromedriver_linux64.zip && \
    chown root:root ~/chromedriver && \
    chmod 755 ~/chromedriver && \
    mv ~/chromedriver /usr/bin/chromedriver && \
    sh -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && apt-get install -y google-chrome-stable

# install node.js
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

# enable rust nightly and enable the wasm32-unknown-unknown toolchain
RUN rustup update && rustup install nightly && rustup default nightly && rustup target add wasm32-unknown-unknown --toolchain nightly

# install wasm-bindgen
RUN cargo +nightly install --vers 0.2.29 wasm-bindgen-cli
