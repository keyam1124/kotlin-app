# Eclipse Temurin 21 JDKをベースイメージとして使用
FROM eclipse-temurin:21-jdk

# 環境変数としてUIDとGIDを設定します。実際の値に置き換えてください。
ARG UID=1000
ARG GID=1000
ARG USERNAME=devuser

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# ユーザーとグループを作成
RUN groupadd -g ${GID} ${USERNAME} \
    && useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME} \
    && echo "${USERNAME}:${USERNAME}" | chpasswd \
    && adduser ${USERNAME} sudo

# 作業ディレクトリを設定
WORKDIR /app

# Gradleラッパーの実行権限を設定
COPY gradlew .
COPY gradle gradle
RUN chmod +x ./gradlew

# ビルドに必要なファイルをコピー
COPY build.gradle.kts settings.gradle.kts ./

# 依存関係をダウンロード
RUN ./gradlew --no-daemon dependencies

# アプリケーションのソースコードをコピー
COPY src src

# アプリケーションをビルド（テストをスキップ）
RUN ./gradlew build -x test

# アプリケーションを実行
CMD ["java", "-jar", "build/libs/*.jar"]

USER ${USERNAME}
