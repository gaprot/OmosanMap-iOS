# <div align="center">Googleマイマップのサンプルアプリ</div>

<div align="center">
### ver 1.0.0
更新日：2017.04.05
</div>

## 概要

このアプリは、こちらの記事に付随するサンプルアプリです。

[Google マイマップの登録地点を表示するアプリを作る](https://www.gaprot.jp/pickup/tips/googlemaps-kml)

## 開発環境

| 環境, ツール | バージョン | 備考 |
| ------------ | ---------- | ---- |
| Xcode        | 8.2.1      | Swift3.0 に移行したバージョン |
| Cocoapods    | 1.1.1      |  ||

## 特筆事項

Googleマイマップ kml のURLは、不定期に変更される場合があるようです。
そのため、記憶したURLが動作しなくなる場合があります。
その場合は、URLの払い出しからやり直していただく必要がございます。

## ライブラリ

| 名称              | バージョン | ライセンス | 用途                    | 参照リンク |
| ----------------- | ---------- | ---------- | ----------------------- | ---------- |
| Alamofire         | 4.4.0      | MIT        | 通信処理                | [https://github.com/Alamofire/Alamofire](https://github.com/Alamofire/Alamofire) |
| AlamofireImage    | 3.2.0      | MIT        | Alamofire の画像処理    | [https://github.com/Alamofire/AlamofireImage](https://github.com/Alamofire/AlamofireImage) |
| Ji                | 2.0.1      | MIT        | XML/HTML パーサ         | [https://github.com/honghaoz/Ji](https://github.com/honghaoz/Ji) |
| SSZipArchive      | 1.7.0      | MIT        | ZIP ファイルの圧縮,解凍 | [https://github.com/ZipArchive/ZipArchive](https://github.com/ZipArchive/ZipArchive) |
| SwiftyUserDefault | 3.0.0      | MIT        | NSUserDefaults ラッパー | [https://github.com/radex/SwiftyUserDefaults](https://github.com/radex/SwiftyUserDefaults) ||

## 更新履歴

| 日付 | バージョン | 概要 |
| ------ | -------------- | ------- |
| 17.04.05 | - | Swift2.3 から Swift3.0 に移行 |
| 17.03.10 | - | READMEを追加 |
| 17.02.02 | - | URLのデフォルト値を追加 |
| 16.07.25 | 1.0.0 | 初版 |
