//+------------------------------------------------------------------+
//|                                                    nico-time.mq4 |
//|                    日本時間 縦線＋時刻ラベル インジケーター        |
//+------------------------------------------------------------------+
#property copyright   "ossan_niconico"
#property version     "4.00"
#property strict
#property indicator_chart_window

//=== 時刻ライン：時間足ごとON/OFF ===
input bool   Show_M1   = true;   // M1  ( 1分足) 時刻ライン
input bool   Show_M5   = true;   // M5  ( 5分足) 時刻ライン
input bool   Show_M15  = false;  // M15 (15分足) 時刻ライン
input bool   Show_M30  = false;  // M30 (30分足) 時刻ライン
input bool   Show_H1   = false;  // H1  ( 1時間足) 時刻ライン
input bool   Show_H4   = false;  // H4  ( 4時間足) 時刻ライン
input bool   Show_D1   = false;  // D1  (日足) 時刻ライン
input bool   Show_W1   = false;  // W1  (週足) 時刻ライン
input bool   Show_MN   = false;  // MN  (月足) 時刻ライン

//=== 日付変更線：時間足ごとON/OFF ===
input bool   ShowDate_M1   = true;   // M1  ( 1分足) 日付変更線
input bool   ShowDate_M5   = true;   // M5  ( 5分足) 日付変更線
input bool   ShowDate_M15  = true;   // M15 (15分足) 日付変更線
input bool   ShowDate_M30  = true;   // M30 (30分足) 日付変更線
input bool   ShowDate_H1   = true;   // H1  ( 1時間足) 日付変更線
input bool   ShowDate_H4   = false;  // H4  ( 4時間足) 日付変更線
input bool   ShowDate_D1   = false;  // D1  (日足) 日付変更線
input bool   ShowDate_W1   = false;  // W1  (週足) 日付変更線
input bool   ShowDate_MN   = false;  // MN  (月足) 日付変更線

//=== キリバン設定 ===
input bool   ShowKiriban      = true;            // キリバン 表示
input bool   ShowKiri_M1      = true;            // M1  ( 1分足) キリバン
input bool   ShowKiri_M5      = true;            // M5  ( 5分足) キリバン
input bool   ShowKiri_M15     = true;            // M15 (15分足) キリバン
input int    KiribanPips      = 100;             // キリバン単位（pips）
input color  KiribanColor     = clrRoyalBlue;    // キリバン 色
input ENUM_LINE_STYLE KiribanStyle = STYLE_DOT;  // キリバン スタイル
input int    KiribanWidth     = 1;               // キリバン 太さ

//=== 前日高値・安値・終値設定 ===
input bool   ShowPrevDay      = true;            // 前日ライン 表示
input color  PrevHighColor    = clrCrimson;      // 前日高値 色
input color  PrevLowColor     = clrDodgerBlue;   // 前日安値 色
input color  PrevCloseColor   = clrDarkOrange;   // 前日終値 色
input ENUM_LINE_STYLE PrevHighStyle   = STYLE_DASH; // 前日高値 スタイル
input ENUM_LINE_STYLE PrevLowStyle    = STYLE_DASH; // 前日安値 スタイル
input ENUM_LINE_STYLE PrevCloseStyle  = STYLE_DOT;  // 前日終値 スタイル
input int    PrevLineWidth    = 1;               // 前日ライン 太さ

//=== 時刻ライン スタイル設定 ===
input int    JstOffset        = 6;              // JSTオフセット（日本: 夏=6 / 冬=7）
input color  LineColorNormal  = clrDimGray;     // 縦線色（通常）
input ENUM_LINE_STYLE LineStyleNormal = STYLE_DOT;   // スタイル（通常）
input int    LineWidthNormal  = 1;              // 太さ（通常）
input color  LineColorMain    = clrDeepPink;    // 縦線色（主要時間）
input ENUM_LINE_STYLE LineStyleMain   = STYLE_DOT;   // スタイル（主要時間）
input int    LineWidthMain    = 1;              // 太さ（主要時間）
input color  LineColorDate    = clrRoyalBlue;   // 縦線色（日付変更線）
input ENUM_LINE_STYLE LineStyleDate   = STYLE_DOT;   // スタイル（日付変更線）
input int    LineWidthDate    = 1;              // 太さ（日付変更線）
input color  LabelColorNormal = clrDimGray;     // ラベル文字色（通常）
input color  LabelColorMain   = clrDeepPink;    // ラベル文字色（主要時間）
input color  LabelColorDate   = clrRoyalBlue;   // ラベル文字色（日付変更線）
input int    LabelFontSize    = 7;              // ラベル フォントサイズ
input int    LabelOffsetPx    = 8;              // ラベル上からのピクセル数

input int    MaxBars          = 1000;           // 処理する最大バー数

//====================================================================
// 日足ピボット
// MaxTF: この時間足より小さい足でのみ表示（例: H4→H1以下, 0=常に表示）
// スタイル: 0=実線 1=破線 2=点線 3=一点鎖線 4=二点鎖線
//====================================================================
input bool            ShowDailyPivot = true;        // 日足ピボット 表示
input ENUM_TIMEFRAMES DP_MaxTF       = PERIOD_H4;   // 日足ピボット 表示時間足（この足未満）
input color           DP_Color       = clrDeepPink; // 日足ピボット 色
input int             DP_PWidth      = 2;           // 日足 P線 太さ
input int             DP_PStyle      = 0;           // 日足 P線 スタイル
input int             DP_Width       = 1;           // 日足 R/S線 太さ
input int             DP_Style       = 2;           // 日足 R/S線 スタイル
input int             DP_Lookback    = 5;           // 日足 表示日数

//====================================================================
// 週足ピボット
// MaxTF: この時間足より小さい足でのみ表示（例: D1→H4以下, 0=常に表示）
//====================================================================
input bool            ShowWeeklyPivot = true;       // 週足ピボット 表示
input ENUM_TIMEFRAMES WP_MaxTF        = PERIOD_D1;  // 週足ピボット 表示時間足（この足未満）
input color           WP_Color        = clrPurple;  // 週足ピボット 色
input int             WP_PWidth       = 2;          // 週足 P線 太さ
input int             WP_PStyle       = 0;          // 週足 P線 スタイル
input int             WP_Width        = 1;          // 週足 R/S線 太さ
input int             WP_Style        = 1;          // 週足 R/S線 スタイル
input int             WP_Lookback     = 5;          // 週足 表示週数

//--- 主要時間帯（日本時間）
int MainHours[] = {9, 15, 22};

string PREFIX      = "NICOT_";
string KIRI_PREFIX = "NICOK_";
string PREV_PREFIX = "NICOP_";
string DP_PREFIX   = "NICOV_DP_";
string WP_PREFIX   = "NICOV_WP_";

//====================================================================
// ピボット構造体
//====================================================================
struct PivotLevels
{
   double pp, r1, s1, r2, s2, r3, s3, r4, s4, r5, s5;
};

//+------------------------------------------------------------------+
bool IsAllowedPeriod()
{
   switch(Period())
   {
      case PERIOD_M1:  return Show_M1;
      case PERIOD_M5:  return Show_M5;
      case PERIOD_M15: return Show_M15;
      case PERIOD_M30: return Show_M30;
      case PERIOD_H1:  return Show_H1;
      case PERIOD_H4:  return Show_H4;
      case PERIOD_D1:  return Show_D1;
      case PERIOD_W1:  return Show_W1;
      case PERIOD_MN1: return Show_MN;
   }
   return false;
}

bool IsDateLineAllowed()
{
   switch(Period())
   {
      case PERIOD_M1:  return ShowDate_M1;
      case PERIOD_M5:  return ShowDate_M5;
      case PERIOD_M15: return ShowDate_M15;
      case PERIOD_M30: return ShowDate_M30;
      case PERIOD_H1:  return ShowDate_H1;
      case PERIOD_H4:  return ShowDate_H4;
      case PERIOD_D1:  return ShowDate_D1;
      case PERIOD_W1:  return ShowDate_W1;
      case PERIOD_MN1: return ShowDate_MN;
   }
   return false;
}

bool IsKiribanAllowed()
{
   if(!ShowKiriban) return false;
   switch(Period())
   {
      case PERIOD_M1:  return ShowKiri_M1;
      case PERIOD_M5:  return ShowKiri_M5;
      case PERIOD_M15: return ShowKiri_M15;
      default:         return false;
   }
}

bool IsMainHour(int hour)
{
   for(int i = 0; i < ArraySize(MainHours); i++)
      if(MainHours[i] == hour) return true;
   return false;
}

//+------------------------------------------------------------------+
void CreateHLine(string name, double price, color col,
                 ENUM_LINE_STYLE style, int width)
{
   if(ObjectFind(0, name) >= 0) ObjectDelete(0, name);
   ObjectCreate(0, name, OBJ_HLINE, 0, 0, price);
   ObjectSetInteger(0, name, OBJPROP_COLOR,      col);
   ObjectSetInteger(0, name, OBJPROP_STYLE,      style);
   ObjectSetInteger(0, name, OBJPROP_WIDTH,      width);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN,     true);
   ObjectSetInteger(0, name, OBJPROP_BACK,       false);
}

//+------------------------------------------------------------------+
int OnInit()
{
   DeleteAllObjects();
   EventSetTimer(1);
   return(INIT_SUCCEEDED);
}

void OnTimer() { Redraw(); }

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[], const double &high[],
                const double &low[], const double &close[],
                const long &tick_volume[], const long &volume[],
                const int &spread[])
{
   Redraw();
   return(rates_total);
}

void OnChartEvent(const int id, const long &lparam,
                  const double &dparam, const string &sparam)
{
   if(id == CHARTEVENT_CHART_CHANGE) Redraw();
}

void OnDeinit(const int reason)
{
   EventKillTimer();
   DeleteAllObjects();
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
void Redraw()
{
   DeleteAllObjects();

   if(IsAllowedPeriod() || IsDateLineAllowed())
   {
      int bars = MathMin(Bars, MaxBars);
      datetime t[];
      ArrayResize(t, bars);
      for(int i = 0; i < bars; i++) t[i] = Time[i];
      DrawLines(bars, t);
   }

   if(IsKiribanAllowed()) DrawKiriban();
   if(ShowPrevDay)        DrawPrevDay();

   DrawDailyPivots();
   DrawWeeklyPivots();

   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| 時刻縦線・ラベル描画                                              |
//+------------------------------------------------------------------+
void DrawLines(const int rates_total, const datetime &time[])
{
   bool showTime = IsAllowedPeriod();
   bool showDate = IsDateLineAllowed();

   int      limit     = MathMin(rates_total, MaxBars);
   int      periodSec = PeriodSeconds();
   datetime lastTime  = -1;

   double chartHigh   = ChartGetDouble(0, CHART_PRICE_MAX);
   double chartLow    = ChartGetDouble(0, CHART_PRICE_MIN);
   long   chartHeight = ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);
   double pxPrice     = (chartHeight > 0) ? (chartHigh - chartLow) / (double)chartHeight : 0;
   double labelPrice  = chartHigh - pxPrice * LabelOffsetPx;

   for(int i = limit - 1; i >= 0; i--)
   {
      datetime jst        = time[i] + JstOffset * 3600;
      datetime barJstHour = (jst / 3600) * 3600;
      if(barJstHour == lastTime) continue;
      lastTime = barJstHour;

      MqlDateTime mdt;
      TimeToStruct(jst, mdt);

      if(periodSec < 3600 && mdt.min != 0) continue;

      bool isDate = (mdt.hour == 0);
      if(isDate && !showDate) continue;
      if(!isDate && !showTime) continue;

      bool main = (!isDate && IsMainHour(mdt.hour));

      string vName = StringFormat("%sV_%d_%02d", PREFIX, i, mdt.hour);
      string lName = StringFormat("%sL_%d_%02d", PREFIX, i, mdt.hour);

      color           lColor  = isDate ? LineColorDate  : (main ? LineColorMain  : LineColorNormal);
      ENUM_LINE_STYLE lStyle  = isDate ? LineStyleDate  : (main ? LineStyleMain  : LineStyleNormal);
      int             lWidth  = isDate ? LineWidthDate  : (main ? LineWidthMain  : LineWidthNormal);
      color           txColor = isDate ? LabelColorDate : (main ? LabelColorMain : LabelColorNormal);
      int             txSize  = (isDate || main) ? LabelFontSize + 1 : LabelFontSize;
      string          txFont  = (isDate || main) ? "Arial Bold" : "Arial";
      string          label   = isDate ? StringFormat("%d/%d", mdt.mon, mdt.day)
                                       : StringFormat("%d", mdt.hour);

      ObjectCreate(0, vName, OBJ_VLINE, 0, time[i], 0);
      ObjectSetInteger(0, vName, OBJPROP_COLOR,      lColor);
      ObjectSetInteger(0, vName, OBJPROP_STYLE,      lStyle);
      ObjectSetInteger(0, vName, OBJPROP_WIDTH,      lWidth);
      ObjectSetInteger(0, vName, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, vName, OBJPROP_HIDDEN,     true);
      ObjectSetInteger(0, vName, OBJPROP_BACK,       true);

      ObjectCreate(0, lName, OBJ_TEXT, 0, time[i], labelPrice);
      ObjectSetString (0, lName, OBJPROP_TEXT,       label);
      ObjectSetInteger(0, lName, OBJPROP_COLOR,      txColor);
      ObjectSetInteger(0, lName, OBJPROP_FONTSIZE,   txSize);
      ObjectSetString (0, lName, OBJPROP_FONT,       txFont);
      ObjectSetInteger(0, lName, OBJPROP_ANCHOR,     ANCHOR_LEFT_UPPER);
      ObjectSetInteger(0, lName, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, lName, OBJPROP_HIDDEN,     true);
      ObjectSetInteger(0, lName, OBJPROP_BACK,       false);
   }
}

//+------------------------------------------------------------------+
//| キリバン描画                                                      |
//+------------------------------------------------------------------+
void DrawKiriban()
{
   double point    = MarketInfo(Symbol(), MODE_POINT);
   int    digits   = (int)MarketInfo(Symbol(), MODE_DIGITS);
   double pipSize  = (digits == 3 || digits == 5) ? point * 10.0 : point;
   double stepSize = pipSize * KiribanPips;

   double chartHigh = ChartGetDouble(0, CHART_PRICE_MAX);
   double chartLow  = ChartGetDouble(0, CHART_PRICE_MIN);

   double firstKiri = MathFloor(chartLow / stepSize) * stepSize;
   int idx = 0;

   for(double price = firstKiri; price <= chartHigh + stepSize; price += stepSize)
   {
      double rp   = NormalizeDouble(price, digits);
      string name = StringFormat("%sL_%d", KIRI_PREFIX, idx);
      CreateHLine(name, rp, KiribanColor, KiribanStyle, KiribanWidth);
      idx++;
   }
}

//+------------------------------------------------------------------+
//| 前日高値・安値・終値 描画                                         |
//+------------------------------------------------------------------+
void DrawPrevDay()
{
   double prevHigh  = iHigh (Symbol(), PERIOD_D1, 1);
   double prevLow   = iLow  (Symbol(), PERIOD_D1, 1);
   double prevClose = iClose(Symbol(), PERIOD_D1, 1);

   CreateHLine(PREV_PREFIX + "H", prevHigh,  PrevHighColor,  PrevHighStyle,  PrevLineWidth);
   CreateHLine(PREV_PREFIX + "L", prevLow,   PrevLowColor,   PrevLowStyle,   PrevLineWidth);
   CreateHLine(PREV_PREFIX + "C", prevClose, PrevCloseColor, PrevCloseStyle, PrevLineWidth);
}

//+------------------------------------------------------------------+
//| ピボット計算                                                      |
//+------------------------------------------------------------------+
PivotLevels CalcPivots(double H, double L, double C)
{
   PivotLevels v;
   v.pp = (H + L + C) / 3.0;
   double r = H - L;
   v.r1 = 2*v.pp - L;  v.s1 = 2*v.pp - H;
   v.r2 = v.pp + r;    v.s2 = v.pp - r;
   v.r3 = v.r1 + r;    v.s3 = v.s1 - r;
   v.r4 = v.r3 + r;    v.s4 = v.s3 - r;
   v.r5 = v.r4 + r;    v.s5 = v.s4 - r;
   return v;
}

//+------------------------------------------------------------------+
//| ピボット OBJ_TREND セグメントを作成                               |
//+------------------------------------------------------------------+
void PivotSeg(string pfx, string id,
              datetime t1, double p1, datetime t2, double p2,
              color clr, int wid, int sty, string tip, bool ray)
{
   string name = pfx + id;
   if(ObjectFind(0, name) >= 0) ObjectDelete(0, name);
   if(!ObjectCreate(0, name, OBJ_TREND, 0, t1, p1, t2, p2)) return;
   ObjectSetInteger(0, name, OBJPROP_COLOR,      clr);
   ObjectSetInteger(0, name, OBJPROP_WIDTH,      wid);
   ObjectSetInteger(0, name, OBJPROP_STYLE,      sty);
   ObjectSetInteger(0, name, OBJPROP_RAY,        ray);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN,     true);
   ObjectSetInteger(0, name, OBJPROP_BACK,       false);
   if(tip != "") ObjectSetString(0, name, OBJPROP_TOOLTIP, tip);
}

//+------------------------------------------------------------------+
//| 1期間分のピボット水平線＋接続線を描画                             |
//+------------------------------------------------------------------+
void DrawPeriodPivots(string pfx, int idx,
                      PivotLevels &cur, PivotLevels &prev, bool hasPrev,
                      datetime tStart, datetime tEnd,
                      datetime tConn,
                      color clr, int pw, int ps, int rw, int rs,
                      bool isCurrent, string tag)
{
   string p  = IntegerToString(idx);
   string lp = (idx == 0) ? ""
             : (idx == 1) ? "(前" + (tag=="D"?"日":"週") + ")"
             :               "(" + p + "期前)";

   // 水平線（11本）
   PivotSeg(pfx, "hP_" +p, tStart,cur.pp,tEnd,cur.pp, clr,pw,ps, tag+"-P" +lp+" : "+DoubleToString(cur.pp,Digits), isCurrent);
   PivotSeg(pfx, "hR1_"+p, tStart,cur.r1,tEnd,cur.r1, clr,rw,rs, tag+"-R1"+lp+" : "+DoubleToString(cur.r1,Digits), isCurrent);
   PivotSeg(pfx, "hS1_"+p, tStart,cur.s1,tEnd,cur.s1, clr,rw,rs, tag+"-S1"+lp+" : "+DoubleToString(cur.s1,Digits), isCurrent);
   PivotSeg(pfx, "hR2_"+p, tStart,cur.r2,tEnd,cur.r2, clr,rw,rs, tag+"-R2"+lp+" : "+DoubleToString(cur.r2,Digits), isCurrent);
   PivotSeg(pfx, "hS2_"+p, tStart,cur.s2,tEnd,cur.s2, clr,rw,rs, tag+"-S2"+lp+" : "+DoubleToString(cur.s2,Digits), isCurrent);
   PivotSeg(pfx, "hR3_"+p, tStart,cur.r3,tEnd,cur.r3, clr,rw,rs, tag+"-R3"+lp+" : "+DoubleToString(cur.r3,Digits), isCurrent);
   PivotSeg(pfx, "hS3_"+p, tStart,cur.s3,tEnd,cur.s3, clr,rw,rs, tag+"-S3"+lp+" : "+DoubleToString(cur.s3,Digits), isCurrent);
   PivotSeg(pfx, "hR4_"+p, tStart,cur.r4,tEnd,cur.r4, clr,rw,rs, tag+"-R4"+lp+" : "+DoubleToString(cur.r4,Digits), isCurrent);
   PivotSeg(pfx, "hS4_"+p, tStart,cur.s4,tEnd,cur.s4, clr,rw,rs, tag+"-S4"+lp+" : "+DoubleToString(cur.s4,Digits), isCurrent);
   PivotSeg(pfx, "hR5_"+p, tStart,cur.r5,tEnd,cur.r5, clr,rw,rs, tag+"-R5"+lp+" : "+DoubleToString(cur.r5,Digits), isCurrent);
   PivotSeg(pfx, "hS5_"+p, tStart,cur.s5,tEnd,cur.s5, clr,rw,rs, tag+"-S5"+lp+" : "+DoubleToString(cur.s5,Digits), isCurrent);

   // 接続線（階段の縦部分）
   if(hasPrev)
   {
      PivotSeg(pfx, "vP_" +p, tStart,prev.pp,tConn,cur.pp, clr,pw,ps, "", false);
      PivotSeg(pfx, "vR1_"+p, tStart,prev.r1,tConn,cur.r1, clr,rw,rs, "", false);
      PivotSeg(pfx, "vS1_"+p, tStart,prev.s1,tConn,cur.s1, clr,rw,rs, "", false);
      PivotSeg(pfx, "vR2_"+p, tStart,prev.r2,tConn,cur.r2, clr,rw,rs, "", false);
      PivotSeg(pfx, "vS2_"+p, tStart,prev.s2,tConn,cur.s2, clr,rw,rs, "", false);
      PivotSeg(pfx, "vR3_"+p, tStart,prev.r3,tConn,cur.r3, clr,rw,rs, "", false);
      PivotSeg(pfx, "vS3_"+p, tStart,prev.s3,tConn,cur.s3, clr,rw,rs, "", false);
      PivotSeg(pfx, "vR4_"+p, tStart,prev.r4,tConn,cur.r4, clr,rw,rs, "", false);
      PivotSeg(pfx, "vS4_"+p, tStart,prev.s4,tConn,cur.s4, clr,rw,rs, "", false);
      PivotSeg(pfx, "vR5_"+p, tStart,prev.r5,tConn,cur.r5, clr,rw,rs, "", false);
      PivotSeg(pfx, "vS5_"+p, tStart,prev.s5,tConn,cur.s5, clr,rw,rs, "", false);
   }
}

//+------------------------------------------------------------------+
//| 日足ピボット描画                                                  |
//| Redraw() の中で呼ばれるため DeleteAllObjects() 後に必ず実行される |
//| → 「消える」問題なし                                              |
//+------------------------------------------------------------------+
void DrawDailyPivots()
{
   if(!ShowDailyPivot) return;
   if(DP_MaxTF != PERIOD_CURRENT && Period() >= (int)DP_MaxTF) return;

   int lb    = MathMax(1, DP_Lookback);
   int total = iBars(Symbol(), PERIOD_D1);
   if(total < lb + 2) return;

   datetime connW = (datetime)(Period() * 60);

   // 全期間分のデータを先に取得
   PivotLevels lvArr[];
   datetime    tArr[];
   ArrayResize(lvArr, lb);
   ArrayResize(tArr,  lb);
   int validCount = 0;

   for(int i = lb-1; i >= 0; i--)
   {
      int src = i + 1;
      if(src >= total) continue;
      double H = iHigh (Symbol(), PERIOD_D1, src);
      double L = iLow  (Symbol(), PERIOD_D1, src);
      double C = iClose(Symbol(), PERIOD_D1, src);
      if(H == 0 || L == 0 || C == 0) continue;
      datetime tStart = iTime(Symbol(), PERIOD_D1, i);
      if(tStart == 0) continue;
      lvArr[i] = CalcPivots(H, L, C);
      tArr[i]  = tStart;
      validCount++;
   }
   if(validCount == 0) return;

   PivotLevels prev;
   ZeroMemory(prev);
   bool hasPrev = false;

   for(int i = lb-1; i >= 0; i--)
   {
      if(tArr[i] == 0) { hasPrev = false; ZeroMemory(prev); continue; }

      datetime tStart = tArr[i];
      datetime tEnd   = (i == 0) ? tStart + 86400
                                  : (tArr[i-1] != 0 ? tArr[i-1] : tStart + 86400);
      datetime tConn  = tStart + connW;

      DrawPeriodPivots(DP_PREFIX, i, lvArr[i], prev, hasPrev,
                       tStart, tEnd, tConn,
                       DP_Color, DP_PWidth, DP_PStyle, DP_Width, DP_Style,
                       (i == 0), "D");
      prev    = lvArr[i];
      hasPrev = true;
   }
}

//+------------------------------------------------------------------+
//| 週足ピボット描画                                                  |
//+------------------------------------------------------------------+
void DrawWeeklyPivots()
{
   if(!ShowWeeklyPivot) return;
   if(WP_MaxTF != PERIOD_CURRENT && Period() >= (int)WP_MaxTF) return;

   int lb    = MathMax(1, WP_Lookback);
   int total = iBars(Symbol(), PERIOD_W1);
   if(total < lb + 2) return;

   datetime connW = (datetime)(Period() * 60);

   PivotLevels lvArr[];
   datetime    tArr[];
   ArrayResize(lvArr, lb);
   ArrayResize(tArr,  lb);
   int validCount = 0;

   for(int i = lb-1; i >= 0; i--)
   {
      int src = i + 1;
      if(src >= total) continue;
      double H = iHigh (Symbol(), PERIOD_W1, src);
      double L = iLow  (Symbol(), PERIOD_W1, src);
      double C = iClose(Symbol(), PERIOD_W1, src);
      if(H == 0 || L == 0 || C == 0) continue;
      datetime tStart = iTime(Symbol(), PERIOD_W1, i);
      if(tStart == 0) continue;
      lvArr[i] = CalcPivots(H, L, C);
      tArr[i]  = tStart;
      validCount++;
   }
   if(validCount == 0) return;

   PivotLevels prev;
   ZeroMemory(prev);
   bool hasPrev = false;

   for(int i = lb-1; i >= 0; i--)
   {
      if(tArr[i] == 0) { hasPrev = false; ZeroMemory(prev); continue; }

      datetime tStart = tArr[i];
      datetime tEnd   = (i == 0) ? tStart + 86400*7
                                  : (tArr[i-1] != 0 ? tArr[i-1] : tStart + 86400*7);
      datetime tConn  = tStart + connW;

      DrawPeriodPivots(WP_PREFIX, i, lvArr[i], prev, hasPrev,
                       tStart, tEnd, tConn,
                       WP_Color, WP_PWidth, WP_PStyle, WP_Width, WP_Style,
                       (i == 0), "W");
      prev    = lvArr[i];
      hasPrev = true;
   }
}

//+------------------------------------------------------------------+
void DeleteAllObjects()
{
   for(int i = ObjectsTotal(0, 0, -1) - 1; i >= 0; i--)
   {
      string n = ObjectName(0, i);
      if(StringFind(n, PREFIX)      == 0) { ObjectDelete(0, n); continue; }
      if(StringFind(n, KIRI_PREFIX) == 0) { ObjectDelete(0, n); continue; }
      if(StringFind(n, PREV_PREFIX) == 0) { ObjectDelete(0, n); continue; }
      if(StringFind(n, DP_PREFIX)   == 0) { ObjectDelete(0, n); continue; }
      if(StringFind(n, WP_PREFIX)   == 0) { ObjectDelete(0, n); continue; }
   }
}
//+------------------------------------------------------------------+