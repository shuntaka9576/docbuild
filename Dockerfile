FROM htakeuchi/docker-asciidoctor-jp

ARG HOME=/root
ARG NVM_VERSION=v0.33.11
ARG NODE_VERSION=v12.13.0

ENV PATH $HOME/.nvm/versions/node/$NODE_VERSION/bin:$PATH

RUN apk --update-cache \
    add python3 \
    python3-dev \
    git \
    jq \
    nodejs \
    perl
RUN pip3 install awscli
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh | bash
RUN bash -c "source ~/.nvm/nvm.sh;nvm install $NODE_VERSION;nvm use $NODE_VERSION;"
RUN npm install --ignore-scripts -g redoc-cli
