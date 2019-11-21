FROM htakeuchi/docker-asciidoctor-jp

ARG HOME=/root
ARG NVM_VERSION=v0.33.11
ARG NODE_VERSION=v12.13.0

ENV PATH $HOME/.nvm/versions/node/$NODE_VERSION/bin:$PATH
ENV PATH $HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH
ENV GRADLE_VERSION=2.14.1
ENV SWAGGER2MARKUP_CLI_VERSION=1.3.3

RUN apk --update-cache \
    add python3 \
    python3-dev \
    git \
    jq \
    nodejs \
    perl \
    openjdk8
RUN pip3 install awscli
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh | bash
RUN bash -c "source ~/.nvm/nvm.sh;nvm install $NODE_VERSION;nvm use $NODE_VERSION;"
RUN npm install --ignore-scripts -g redoc-cli
RUN set -ex \
      && apk --no-cache add --virtual build-dependencies curl unzip \
      && apk --no-cache add bash libstdc++ \
      && cd /usr/lib \
      && curl -O --location --silent --show-error https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip \
      && unzip -q gradle-${GRADLE_VERSION}-bin.zip \
      && ln -s /usr/lib/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/ \
      && rm -rf gradle-${GRADLE_VERSION}-bin.zip \
          gradle-${GRADLE_VERSION}/bin/gradle.bat \
          gradle-${GRADLE_VERSION}/getting-started.html \
          gradle-${GRADLE_VERSION}/media \
          /opt/jdk/*src.zip \
      && apk del --purge build-dependencies
RUN mkdir /tools
RUN git clone -b v${SWAGGER2MARKUP_CLI_VERSION} --depth 1 https://github.com/Swagger2Markup/swagger2markup-cli.git /tools/swagger2markup-cli \
      && cd /tools/swagger2markup-cli \
      && gradle assemble \
      && cp /tools/swagger2markup-cli/build/libs/swagger2markup-cli-${SWAGGER2MARKUP_CLI_VERSION}.jar /tools \
      && rm -rf /tools/swagger2markup-cli
