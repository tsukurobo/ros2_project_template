# ROS 2 Project Template

ROS 2 Jazzy 向けのプロジェクトテンプレートです。
Dev Container、GitHub Actions、`just` による開発コマンドを含んでいます。

## 前提

- ROS 2 Jazzy
- Ubuntu 24.04 または Dev Container
- `colcon`
- `rosdep`
- `vcs`
- `just`

Dev Container を使う場合は、VS Code でこのリポジトリを開き、コンテナ内で作業してください。

## セットアップ

1. このリポジトリをテンプレートとして新しいリポジトリを作成します。
2. リポジトリ名を `{project_name}_ros2` にします。
3. ROS パッケージは `{project_name}` を接頭辞として、このワークスペース直下に追加します。
4. 外部リポジトリ依存がある場合は、`build_depends.repos` に追加します。
5. 必要に応じて git submodule を追加します。
6. ワークスペースをセットアップします。

```bash
just setup
```

`just setup` は、git submodule の初期化と外部リポジトリ依存の取得、rosdep による依存パッケージのインストールをまとめて実行します。

## 依存関係の管理

このテンプレートでは、依存の種類に応じて管理方法を分けます。

- 自分たちで管理する基幹ライブラリ: git submodule
- apt で入らない外部 ROS パッケージや既成ドライバ: `build_depends.repos`
- apt で入るシステム依存: 各 ROS パッケージの `package.xml` と rosdep

git submodule を追加した場合は、以下で初期化できます。

```bash
just submodules
```

外部 ROS パッケージや既成ドライバは、`build_depends.repos` に追加します。

```yaml
repositories:
  drivers/some_driver:
    type: git
    url: https://github.com/example/some_driver.git
    version: main
```

## よく使うコマンド

```bash
# 利用できるコマンドを表示
just

# 初回セットアップ
just setup

# git submodule を初期化
just submodules

# 依存関係を取得し、rosdep で依存パッケージをインストール
just deps

# 全パッケージをビルド
just build

# 指定したパッケージだけビルド
just build <package_name>

# テストを実行
just test

# 指定したパッケージだけテスト
just test <package_name>

# launch ファイルを実行
just run <launch_name>

# フォーマット
just format

# 生成物を削除
just clean
```

`just run <launch_name>` は、`{project_name}_bringup` パッケージ内の
`<launch_name>.launch.yaml` を実行します。

## 命名規則

このテンプレートでは、リポジトリ名とパッケージ名を以下の規則に固定しています。

- リポジトリ名: `{project_name}_ros2`
- パッケージ接頭辞: `{project_name}`
- bringup パッケージ: `{project_name}_bringup`
- msg パッケージ: `{project_name}_msgs`

`just` と CI は、リポジトリ名から末尾の `_ros2` を除いた値を `{project_name}` として扱います。

## フォーマットとテスト

このテンプレートでは `.clang-format`、`setup.cfg`、`.pre-commit-config.yaml` を用意しています。
`just format`、pre-commit、CI は C/C++ に `ament_clang_format`、Python に `isort` と `black` を使います。

```bash
pre-commit install
pre-commit run --all-files
```

CI では ROS 2 Jazzy 環境で依存関係のインストール、フォーマット、ビルド、テストを実行します。

## ディレクトリ構成

```text
.
├── .devcontainer/          # ROS 2 Jazzy 用 Dev Container
├── .github/workflows/      # GitHub Actions CI
├── build_depends.repos     # vcs import 用の外部リポジトリ依存
├── justfile                # 開発コマンド
├── .clang-format           # C/C++ フォーマット設定
└── .pre-commit-config.yaml # pre-commit 設定
```

## テンプレート利用時に見直すもの

- リポジトリ名
- パッケージ名
- `build_depends.repos` の依存リポジトリ
- git submodule として含める基幹ライブラリ
