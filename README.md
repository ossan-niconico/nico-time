# nico-time

**MT4向け無料インジケーター** ― 時刻ライン・ピボット・キリバン・前日高値安値を一括表示

[![version](https://img.shields.io/badge/version-4.00-0ea5e9)](#)
[![platform](https://img.shields.io/badge/platform-MT4-1a2235)](#)
[![license](https://img.shields.io/badge/license-Free-22c55e)](#)

---

## 概要

FXデイトレードに必要な「時間」と「価格帯」の情報を、このインジケーター1本でまとめて表示します。

| 機能 | 内容 |
|------|------|
| 🕐 時刻ライン | 日本時間の縦線＋ラベル。東京・NYオープン（9・15・22時）はピンクで強調 |
| 📅 日付変更線 | 00:00をブルーの縦線でマーク |
| 💎 キリバン | 100pips刻みの切りのいい価格に水平線（M1・M5・M15対応） |
| 📈 前日高値・安値・終値 | 全時間足で常時表示 |
| 🎯 日足ピボット | PP / R1〜R5 / S1〜S5 を5日分（H1以下で自動表示） |
| 📊 週足ピボット | PP / R1〜R5 / S1〜S5 を5週分（H4以下で自動表示） |

---

## ダウンロード・公開ページ

🌐 **公開ページ（GitHub Pages）**  
https://ossan-niconico.github.io/nico-time/

📖 **マニュアル・配布記事（note）**  
https://note.com/ossan_niconico

---

## インストール方法

1. `nico-time.mq4` をダウンロード
2. MT4メニュー →「ファイル」→「データフォルダを開く」
3. `MQL4` → `Indicators` フォルダに `nico-time.mq4` をコピー
4. MT4を再起動（またはMetaEditorでF7コンパイル）
5. ナビゲーター →「nico-time」をチャートにドラッグ → OK

### JstOffset の設定

ご使用のブローカーのサーバー時間に合わせて `JstOffset` を調整してください。

| サーバー時間 | JstOffset |
|------------|-----------|
| UTC | 9 |
| UTC+2（冬時間） | 7 |
| UTC+2（夏時間）| **6（デフォルト）** |

---

## ファイル構成

```
nico-time/
├── nico-time.mq4       # インジケーター本体
├── nico-time.set       # プリセット設定ファイル
├── index.html          # GitHub Pages 公開ページ
└── README.md
```

---

## 関連インジケーター

nico-time は以下のインジケーターと組み合わせて使うことを想定しています。

- **[nico-band-7TF（MT4）](https://github.com/ossan-niconico/nico-band-7TF)** ― 7TFのATRトレンドバンド
- **[nico-band（TradingView）](https://github.com/ossan-niconico/nico-band-TradingView)** ― TradingView版
- **[nico-panel（MT4）](https://github.com/ossan-niconico/nico-panel)** ― ワンクリック注文パネル

---

## 作者

**ossan_niconico**  
note: https://note.com/ossan_niconico  
X: https://x.com/ossan_niconico

---

## ライセンス

無料で自由にご利用ください。  
再配布・改変の際は作者名（ossan_niconico）の表記をお願いします。
