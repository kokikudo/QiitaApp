# Qiita App

Qiita Appは、ユーザーがQiitaという技術投稿サイトから投稿された記事を閲覧できるモバイルアプリケーションです。

## 特徴

- さまざまなユーザーがQiitaに投稿した記事を閲覧できます。
- ユーザーIDを検索することで、特定の記事を閲覧できます。

## インストール方法

1. リポジトリをローカルマシンにクローンします：

```bash
git clone https://github.com/yourusername/QiitaApp.git
```
2. プロジェクトディレクトリに移動します：

```bash
cd QiitaApp
```

3. CocoaPodsをインストールします（未インストールの場合）：

```bash
sudo gem install cocoapods
```

4. CocoaPodsを使用して必要な依存関係をインストールします：
```ruby
target 'QiitaApp' do
  # 2. ここに以下のコードを追加
  pod 'Alamofire'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxGesture'
  
  # 3. 以下のコードはそのまま
end

```
```bash
pod install
```

5. 新たに生成されたQiitaApp.xcworkspaceを開きます

## 使い方
1. iOSシミュレーターまたはデバイスでアプリを起動します。
2. 検索機能を使用してユーザーIDを入力し、記事を検索します。
3. 記事を閲覧し、興味のある記事を読むことができます。

