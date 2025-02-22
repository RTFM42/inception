# Inception
## Introduction
このプロジェクトは、Dockerを使ってシステム管理の知識を広げることを目的としています。いくつかのDockerイメージを仮想化し、新しい個人用仮想マシンに作成します。

## General guidelines
- プロジェクトは仮想マシン上で行う必要があります。 
- プロジェクトのコンフィギュレーションに必要なファイルは、すべて`srcs`フォルダに置く必要があります。 
- ルートディレクトリにMakefileが必要です。Makefileはアプリケーション全体をセットアップする必要があります。（つまり、docker-compose.ymlを使ってDockerイメージをビルドする必要があります。）
- この課題では、あなたのこれまでの学習状況によってはまだ習得していない概念を実践する必要があります。Dockerの使用方法や関連ドキュメント、その他課題完遂に役立つ資料を積極的に参照してください。

## Mandatory part
このプロジェクトでは、特定のルールに基づいて異なるサービスから構成される小規模なインフラストラクチャを構築してもらいます。  
プロジェクト全体は仮想マシン上で実施し、`docker compose` を使用してください。

- 各Dockerイメージは、対応するサービスと同じ名前でなければなりません。  
- 各サービスは専用のコンテナで実行してください。  
- パフォーマンス向上のため、コンテナは最新安定版の一つ前のバージョンの**Alpine**または**Debian**からビルドしてください（選択は任意です）。  
- 各サービスごとに独自の**Dockerfile**を作成してください。これらのDockerfileは、Makefileを通じて `docker-compose.yml` 内で呼び出される必要があります。  
  → つまり、プロジェクトのDockerイメージは自分でビルドしなければなりません。既製のDockerイメージをプルすることや、DockerHubなどのサービス（ただしAlpine/Debianは除く）の使用は禁止されています。

次に、以下の設定を行ってください：

- **NGINX** を含み、**TLSv1.2** または **TLSv1.3** のみを使用するDockerコンテナ  
- **WordPress** と **php-fpm**（インストールおよび設定済み）を含むDockerコンテナ（NGINXは含まない）  
- **MariaDB** のみを含むDockerコンテナ（NGINXは含まない）  
- WordPressデータベースを格納するためのボリューム  
- WordPressウェブサイトのファイルを格納するための第二のボリューム  
- コンテナ間の接続を確立する**docker-network**

また、以下の点にも注意してください：

- コンテナはクラッシュ時に自動再起動するよう設定すること。  
- Dockerコンテナは仮想マシンではないため、`tail -f` などのハック的な手法を用いてコンテナを実行するのは推奨されません。デーモンの動作や適切な実装方法について学んでください。

さらに、以下の禁止事項があります：

- `network: host` や `--link`、`links:` の使用は禁止です。  
  - ※ `docker-compose.yml` には必ずネットワークの設定行を記述してください。  
- コンテナは無限ループするコマンド（エントリポイントやエントリポイントスクリプトで使用されるものも含む）で起動してはいけません。  
  - 禁止例: `tail -f`, `bash`, `sleep infinity`, `while true`  
- **PID 1** の扱いおよびDockerfileのベストプラクティスについて学んでください。

**WordPressデータベースに関しては：**

- 2つのユーザー（うち1つは管理者）が存在する必要があります。  
- 管理者のユーザー名には「admin」「Admin」や「administrator」「Administrator」といった文字列を含めてはいけません（例：admin、administrator、Administrator、admin-123 などは不可）。

**その他の設定：**

- ボリュームは、Dockerを利用してホストマシンの `/home/login/data` ディレクトリ内で利用可能になります（`login` は各自のユーザー名に置き換えてください）。  
- ドメイン名を設定し、ローカルIPアドレスを指すようにしてください。  
  - このドメイン名は `login.42.fr` となる必要があります（例：ユーザー名が `wil` の場合は `wil.42.fr` となり、対応するIPアドレスにリダイレクトされます）。  
- `latest` タグの使用は禁止です。  
- Dockerfile内にパスワードを直接記載してはいけません。  
- 環境変数の使用は必須です。  
  - また、環境変数は `.env` ファイルに保存すること、そして機密情報はDockerシークレットを利用して保管することが強く推奨されます。  
- **NGINXコンテナ** は、TLSv1.2またはTLSv1.3プロトコルを使用し、ポート443のみを通じてインフラストラクチャへの唯一のエントリポイントとなるよう設定してください。

---

### 例: 期待される結果のダイアグラム

以下は、期待される結果の例としてのダイアグラムです：  
（※実際のダイアグラムは図示されていません）

---

### 期待されるディレクトリ構造の例

以下は、期待されるディレクトリ構造の例です：

```bash
$> ls -alR
total XX
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 .
drwxrwxrwt 17 wil wil 4096 avril 42 20:42 ..
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 Makefile
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 secrets
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 srcs
```

```bash
./secrets:
total XX
drwxrwxr-x 2 wil wil 4096 avril 42 20:42 .
drwxrwxr-x 6 wil wil 4096 avril 42 20:42 ..
-rw-r--r-- 1 wil wil XXXX avril 42 20:42 credentials.txt
-rw-r--r-- 1 wil wil XXXX avril 42 20:42 db_password.txt
-rw-r--r-- 1 wil wil XXXX avril 42 20:42 db_root_password.txt
```

```bash
./srcs:
total XX
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 .
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 ..
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 docker-compose.yml
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 .env
drwxrwxr-x 5 wil wil 4096 avril 42 20:42 requirements
```

```bash
./srcs/requirements:
total XX
drwxrwxr-x 5 wil wil 4096 avril 42 20:42 .
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 ..
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 bonus
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 mariadb
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 nginx
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 tools
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 wordpress
```

```bash
./srcs/requirements/mariadb:
total XX
drwxrwxr-x 4 wil wil 4096 avril 42 20:45 .
drwxrwxr-x 5 wil wil 4096 avril 42 20:42 ..
drwxrwxr-x 2 wil wil 4096 avril 42 20:42 conf
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 Dockerfile
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 .dockerignore
drwxrwxr-x 2 wil wil 4096 avril 42 20:42 tools
[...]
```

```bash
./srcs/requirements/nginx:
total XX
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 .
drwxrwxr-x 5 wil wil 4096 avril 42 20:42 ..
drwxrwxr-x 2 wil wil 4096 avril 42 20:42 conf
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 Dockerfile
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 .dockerignore
drwxrwxr-x 2 wil wil 4096 avril 42 20:42 tools
[...]
```

```bash
$> cat srcs/.env
DOMAIN_NAME=wil.42.fr
# MYSQL SETUP
MYSQL_USER=XXXXXXXXXXXX
[...]
$>
```

> **注意:** セキュリティ上の理由から、認証情報、APIキー、パスワードなどの機密情報は各自のローカル環境に保存し、Gitには含めないようにしてください。公開された認証情報はプロジェクトの失敗につながります。

また、環境変数（例：ドメイン名）は `.env` ファイルなどに保存することが可能です。

---

## 第V章 ボーナスパート

本プロジェクトのボーナスパートは、シンプルな追加課題を目指しています。

- 各追加サービスに対して**Dockerfile**を作成し、各サービスは専用のコンテナ内で実行され、必要に応じて専用のボリュームを持ちます。

**ボーナスリスト:**

- WordPressウェブサイトのキャッシュ管理を適切に行うため、**Redisキャッシュ**を設定する。  
- WordPressウェブサイトのボリュームを指す**FTPサーバーコンテナ**を設定する。  
- PHP以外の任意の言語でシンプルな静的ウェブサイトを作成する（※PHPは除外されます）。例として、ポートフォリオサイトや履歴書の紹介サイトなど。  
- **Adminer**を設定する。  
- あなたが有用と考える任意のサービスを設定する（防衛時にその選択理由を説明する必要があります）。

ボーナスパートを完了するため、必要に応じて追加のサービスを設定し、適切なポートを開放しても構いません。

**重要:** ボーナスパートは、必須パートが完全に実装され、正常に動作している場合にのみ評価されます。必須パートの要件がすべて満たされていない場合、ボーナスパートは評価されません。

---

## 第VI章 提出と相互評価

通常通り、Gitリポジトリに課題を提出してください。  
防衛時には、リポジトリ内の作業内容のみが評価対象となります。  
フォルダ名やファイル名が正しいかどうか、十分に確認してください。

---

### 提出時の識別コード

```
16D85ACC441674FBA2DF65190663EC3C3C258FEA065D090A715F1B62F5A57F0B75403
61668BD6823E2F873124B7E59B5CE94BB7ABD71CD01F65B959E14A3838E414F1E871
F7D91730B
```

---

### 目次（再掲）

- 序文  
- はじめに  
- 一般的なガイドライン  
- 必須パート  
- ボーナスパート  
- 提出と相互評価

---

以上が、PDFの内容を日本語に翻訳しMarkdown形式に整形したものです。