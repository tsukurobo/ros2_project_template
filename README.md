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
2. 必要に応じて、ROS パッケージをこのワークスペース直下に追加します。
3. 外部リポジトリ依存がある場合は、`build_depends.repos` に追加します。
4. 依存関係を取得します。

```bash
just deps
```

## よく使うコマンド

```bash
# 利用できるコマンドを表示
just

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

`just run <launch_name>` は、既定では `${ROS_PROJECT_NAME}_bringup` パッケージ内の
`<launch_name>.launch.yaml` を実行します。

## 環境変数

必要に応じて以下の環境変数を設定できます。

- `ROS_PROJECT_NAME`: プロジェクト名。未設定時は `ros2_project_template`
- `ROS_PACKAGE_PREFIX`: CI で対象パッケージを絞るための接頭辞
- `ROS_BRINGUP_PACKAGE`: launch 実行時に使う bringup パッケージ名
- `ROS_MSGS_PACKAGE`: CI で先にビルドする msg パッケージ名

Dev Container では、`ROS_PROJECT_NAME` と `ROS_PACKAGE_PREFIX` はワークスペースのフォルダ名から設定されます。

## フォーマットとテスト

このテンプレートでは `.clang-format` と `.pre-commit-config.yaml` を用意しています。

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

- リポジトリ名と `ROS_PROJECT_NAME`
- パッケージ名の接頭辞
- `build_depends.repos` の依存リポジトリ
- bringup パッケージ名
- GitHub Actions の repository variables
