//+------------------------------------------------------------------+
//|                                             RB_XAUUSD_MT5.mq5     |
//|  RB XAU/USD MT5 - source-only research Expert Advisor for MT5.    |
//|  Public GPL-3.0-only export. No presets, reports or binaries.     |
//|  Review, test and compile locally in MetaEditor before any use.   |
//+------------------------------------------------------------------+
#property strict
#property version "1.00"

#include <Trade/Trade.mqh>
CTrade trade;

//==================== SAFETY ====================//
input string InpAllowedSymbol = "XAUUSD";
input bool   InpEnableLiveOrders = false;
input bool   InpEnableTesterOrders = true;
input int    InpMagicNumber = 26060201;

//==================== MODE ====================//
// 0 = selective profile | 1 = robust profile
input int InpMode = 1;

//==================== INPUTS ====================//
input int session_reset_hour = 20;
input int cooldown_minutes_after_sl = 15;

input int SpreadMax_points     = 35;
input int SlippageMax_points  = 30;

input double risk_base_pct     = 0.007;
input double max_daily_loss_R  = 3.0;
input int    max_trades_day    = 6;

// SESSION (power windows)
input bool use_session_filter = true;
input int session1_start_hour = 8;
input int session1_end_hour   = 11;
input int session2_start_hour = 13;
input int session2_end_hour   = 16;
input string trade_hour_mask = "";      // e.g. "8,9,10,13,14"; empty uses session windows
input string trade_weekday_mask = "";   // 1=Mon ... 5=Fri; empty allows all broker weekdays
input string weekday_risk_multipliers = ""; // e.g. "1:1.0,2:0.8,3:0.8"
input string hour_risk_multipliers = "";    // e.g. "8:1.0,13:0.8"
input double min_quality_for_trade = 0.05;
input double weak_quality_threshold = 0.35;
input double weak_quality_adx_bonus = 5.0;
input double weak_quality_impulse_bonus = 0.30;
input double weak_quality_close_pos_bonus = 0.04;
input int avoid_first_minutes_of_hour = 2;
input int cooldown_seconds_after_order_fail = 60;
input bool allow_buy = true;
input bool allow_sell = true;

// BASE
input int ATR_period   = 14;   // ATR M1
input int ADX_period   = 14;   // ADX M1
input double ADX_min   = 25.0;
input int MinATR_points = 120;

input ENUM_TIMEFRAMES TF_bias     = PERIOD_H1;
input int EMA_bias_fast = 50;
input int EMA_bias_slow = 200;

input ENUM_TIMEFRAMES TF_structure = PERIOD_M15;
input int structure_lookback = 14;

input double impulse_mult      = 2.2;
input double close_pos_min     = 0.70;

input double structural_buffer_ATR = 0.25;
input int    MinSL_points = 80;

input double TP_R = 2.0;

// REGIME (M5)
input bool use_vol_regime = true;
input ENUM_TIMEFRAMES TF_vol = PERIOD_M5;
input int ATR_vol_period = 14;
input int ATR_vol_sma_len = 200;
input double atr_exp_mult = 1.00;

// Risk scaler
input bool use_risk_scaler = true;
input double risk_min_pct = 0.004;
input double risk_max_pct = 0.010;
input double risk_scaler_k = 0.8;

// SQUEEZE (M5)
input bool use_squeeze_filter = true;
input ENUM_TIMEFRAMES TF_squeeze = PERIOD_M5;
input int bb_period = 20;
input double bb_dev = 2.0;
input int kc_ema_period = 20;
input int kc_atr_period = 20;
input double kc_mult = 1.30;
input int squeeze_release_window_bars = 10;

// Cycle filter
input bool use_cycle_filter = true;
input int cycle_lookback_bars = 36;

// Volatility Expansion Trigger (M1)
input bool use_atr_accel = true;
input int  atr_accel_sma_len = 200;
input double exp_ratio_min = 1.15;

input bool use_range_expansion = true;
input double range_exp_mult = 2.4;

// ADX M15 gate
input bool use_adx_m15_gate = true;
input int  ADX_M15_period = 14;
input double ADX_M15_min_selective = 18.0;
input double ADX_M15_min_robust    = 16.0;

// allow_no_squeeze by mode
input bool allow_no_squeeze_selective = false;
input bool allow_no_squeeze_robust    = true;

// QUALITY STACK
input bool use_mtf_ema_confirm = false;
input ENUM_TIMEFRAMES TF_confirm_fast = PERIOD_M5;
input ENUM_TIMEFRAMES TF_confirm_mid  = PERIOD_M15;
input int EMA_confirm_fast = 21;
input int EMA_confirm_slow = 55;

// BREAKOUT / RETEST
input bool use_breakout_extension_guard = false;
input double max_breakout_extension_ATR = 0.85;
input bool use_retest_entry = false;
input bool allow_direct_breakout_when_retest = true;
input int retest_window_bars = 8;
input double retest_zone_ATR = 0.45;
input double retest_invalidation_ATR = 1.20;
input double retest_sl_ATR = 1.10;
input double retest_resume_close_pos_min = 0.58;

// POSITION MANAGEMENT
input bool use_break_even = false;
input double break_even_trigger_R = 1.00;
input int break_even_lock_points = 5;
input bool use_atr_trailing = false;
input double trail_start_R = 1.40;
input double trail_atr_mult = 1.00;

// EQUITY RISK GUARD
input bool use_equity_risk_guard = false;
input double equity_dd_cutoff_pct = 0.18;
input double equity_dd_risk_mult = 0.65;

// EQUITY DD HARD STOP
input bool use_equity_dd_hard_stop = false;
input double equity_dd_hard_stop_pct = 0.25;
input bool equity_dd_hard_stop_block_new_entries = false;
input bool equity_dd_hard_stop_lock_forever = false;

// MACRO REGIME FILTER
input bool use_macro_regime_filter = false;
input ENUM_TIMEFRAMES TF_macro = PERIOD_D1;
input int EMA_macro_fast = 50;
input int EMA_macro_slow = 200;
input bool macro_use_closed_bar = true;
input bool macro_require_fast_above_slow = true;
input bool macro_require_price_above_fast = false;
input int macro_slope_bars = 5;
input double macro_min_slope_ATR = 0.0;

//==================== STATE ====================//
double daily_loss_R=0.0;
int trades_today=0;
bool locked_today=false;
int session_day_key=-1;
datetime last_sl_time=0;
datetime last_order_failure_time=0;

bool squeeze_prev_on=false;
int squeeze_release_countdown=0;
datetime last_squeeze_bar_time=0;

bool squeeze_seen_recent=false;
double equity_peak=0.0;
bool equity_dd_hard_stop_locked=false;

bool pending_retest=false;
bool pending_retest_buy=true;
datetime pending_retest_expire=0;
double pending_retest_level=0.0;
double pending_retest_sl_ref=0.0;
double pending_retest_atr_points=0.0;

// handles
int atr_m1_handle=INVALID_HANDLE;
int adx_m1_handle=INVALID_HANDLE;
int ema_fast_handle=INVALID_HANDLE;
int ema_slow_handle=INVALID_HANDLE;

int atr_vol_handle=INVALID_HANDLE;

int bb_handle=INVALID_HANDLE;
int kc_ema_handle=INVALID_HANDLE;
int kc_atr_handle=INVALID_HANDLE;

int adx_m15_handle=INVALID_HANDLE;
int ema_confirm_fast_1_handle=INVALID_HANDLE;
int ema_confirm_slow_1_handle=INVALID_HANDLE;
int ema_confirm_fast_2_handle=INVALID_HANDLE;
int ema_confirm_slow_2_handle=INVALID_HANDLE;
int ema_macro_fast_handle=INVALID_HANDLE;
int ema_macro_slow_handle=INVALID_HANDLE;
int atr_macro_handle=INVALID_HANDLE;

//==================== HELPERS ====================//
int GetSessionDayKey(datetime t)
{
   datetime shifted = t - (session_reset_hour * 3600);
   MqlDateTime tm; TimeToStruct(shifted, tm);
   return (tm.year*10000 + tm.mon*100 + tm.day);
}

void ResetDailyIfNeeded()
{
   int key=GetSessionDayKey(TimeCurrent());
   if(key!=session_day_key)
   {
      session_day_key=key;
      daily_loss_R=0.0;
      trades_today=0;
      locked_today=false;
      last_sl_time=0;
      last_order_failure_time=0;

      squeeze_prev_on=false;
      squeeze_release_countdown=0;
      last_squeeze_bar_time=0;
      squeeze_seen_recent=false;
   }
}

double GetValuePerPoint()
{
   double tick_value=SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tick_size =SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double point     =SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   if(tick_size<=0.0) return 0.0;
   return tick_value*(point/tick_size);
}

double NormalizeLots(double lots)
{
   double step=SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   double minLot=SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot=SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   if(step<=0.0) return 0.0;
   lots=MathFloor(lots/step)*step;
   if(lots<minLot) return 0.0;
   if(lots>maxLot) lots=maxLot;
   return lots;
}

double CalcLots(double sl_points, double risk_pct)
{
   if(sl_points<=0.0) return 0.0;
   double equity=AccountInfoDouble(ACCOUNT_EQUITY);
   double risk_money=equity*risk_pct;
   double vpp=GetValuePerPoint();
   if(vpp<=0.0) return 0.0;
   return NormalizeLots(risk_money/(sl_points*vpp));
}

bool SpreadOK()
{
   double spread_points=(SymbolInfoDouble(_Symbol,SYMBOL_ASK)-SymbolInfoDouble(_Symbol,SYMBOL_BID))/_Point;
   return (spread_points<=SpreadMax_points);
}

bool InWindow(int h,int start,int end_exclusive)
{
   if(start<end_exclusive) return (h>=start && h<end_exclusive);
   if(start>end_exclusive) return (h>=start || h<end_exclusive);
   return false;
}

bool MaskAllowsInt(string mask_value,int value)
{
   string mask=mask_value;
   StringTrimLeft(mask);
   StringTrimRight(mask);
   if(StringLen(mask)==0)
      return true;

   string parts[];
   int count=StringSplit(mask, ',', parts);
   for(int i=0; i<count; i++)
   {
      string item_text=parts[i];
      StringTrimLeft(item_text);
      StringTrimRight(item_text);
      if(StringLen(item_text)==0)
         continue;

      int allowed=(int)StringToInteger(item_text);
      if(allowed==value)
         return true;
   }
   return false;
}

double LookupMultiplier(string map_value,int key,double fallback)
{
   string map=map_value;
   StringTrimLeft(map);
   StringTrimRight(map);
   if(StringLen(map)==0)
      return fallback;

   string parts[];
   int count=StringSplit(map, ',', parts);
   for(int i=0; i<count; i++)
   {
      string item_text=parts[i];
      StringTrimLeft(item_text);
      StringTrimRight(item_text);
      if(StringLen(item_text)==0)
         continue;

      int colon=StringFind(item_text, ":");
      if(colon<=0)
         continue;

      string key_text=StringSubstr(item_text, 0, colon);
      string value_text=StringSubstr(item_text, colon+1);
      StringTrimLeft(key_text);
      StringTrimRight(key_text);
      StringTrimLeft(value_text);
      StringTrimRight(value_text);

      if((int)StringToInteger(key_text)==key)
         return StringToDouble(value_text);
   }

   return fallback;
}

double CurrentContextQuality()
{
   MqlDateTime tm; TimeToStruct(TimeCurrent(), tm);
   double weekday_quality=LookupMultiplier(weekday_risk_multipliers, tm.day_of_week, 1.0);
   double hour_quality=LookupMultiplier(hour_risk_multipliers, tm.hour, 1.0);
   double quality=weekday_quality*hour_quality;
   if(quality<0.0)
      quality=0.0;
   return quality;
}

bool SessionOK()
{
   if(!use_session_filter) return true;
   MqlDateTime tm; TimeToStruct(TimeCurrent(), tm);
   if(!MaskAllowsInt(trade_weekday_mask, tm.day_of_week))
      return false;

   if(avoid_first_minutes_of_hour > 0 && tm.min < avoid_first_minutes_of_hour)
      return false;

   int h=tm.hour;
   string hour_mask=trade_hour_mask;
   StringTrimLeft(hour_mask);
   StringTrimRight(hour_mask);
   if(StringLen(hour_mask)>0)
      return MaskAllowsInt(hour_mask,h);

   return (InWindow(h,session1_start_hour,session1_end_hour) ||
           InWindow(h,session2_start_hour,session2_end_hour));
}

bool BiasUp()
{
   double f[1], s[1];
   if(CopyBuffer(ema_fast_handle,0,0,1,f)!=1) return false;
   if(CopyBuffer(ema_slow_handle,0,0,1,s)!=1) return false;
   return (f[0]>s[0]);
}
bool BiasDown()
{
   double f[1], s[1];
   if(CopyBuffer(ema_fast_handle,0,0,1,f)!=1) return false;
   if(CopyBuffer(ema_slow_handle,0,0,1,s)!=1) return false;
   return (f[0]<s[0]);
}

bool GetM15StructureLevels(double &HH15,double &LL15)
{
   int idxH=iHighest(_Symbol, TF_structure, MODE_HIGH, structure_lookback, 1);
   int idxL=iLowest(_Symbol, TF_structure, MODE_LOW,  structure_lookback, 1);
   if(idxH<0 || idxL<0) return false;
   HH15=iHigh(_Symbol, TF_structure, idxH);
   LL15=iLow(_Symbol,  TF_structure, idxL);
   return true;
}

// Regime + risk
bool GetVolRatio(double &ratio)
{
   ratio=1.0;
   if(!use_vol_regime && !use_risk_scaler) return true;
   int need=MathMax(ATR_vol_sma_len,2);
   double buf[];
   ArrayResize(buf,need);
   if(CopyBuffer(atr_vol_handle,0,0,need,buf)!=need) return false;
   double atr_now=buf[0];
   double sum=0.0;
   for(int i=0;i<ATR_vol_sma_len && i<need;i++) sum+=buf[i];
   double atr_avg=sum/ATR_vol_sma_len;
   if(atr_avg<=0.0) return false;
   ratio=atr_now/atr_avg;
   return true;
}

bool VolatilityRegimeOK(double vol_ratio)
{
   if(!use_vol_regime) return true;
   return (vol_ratio>=atr_exp_mult);
}

double CalcRiskPct(double vol_ratio)
{
   double r=risk_base_pct;
   if(use_risk_scaler)
   {
      double mult=1.0 + risk_scaler_k*(vol_ratio-1.0);
      r=risk_base_pct*mult;
      if(r<risk_min_pct) r=risk_min_pct;
      if(r>risk_max_pct) r=risk_max_pct;
   }
   return r;
}

double ApplyContextRisk(double risk_pct,double context_quality)
{
   double adjusted=risk_pct*context_quality;
   if(adjusted>risk_max_pct)
      adjusted=risk_max_pct;
   return adjusted;
}

double CurrentEquityDrawdownPct()
{
   double equity=AccountInfoDouble(ACCOUNT_EQUITY);
   if(equity_peak<=0.0 || equity>equity_peak)
      equity_peak=equity;

   if(equity_peak<=0.0)
      return 0.0;

   return (equity_peak-equity)/equity_peak;
}

double ApplyEquityRiskGuard(double risk_pct)
{
   if(!use_equity_risk_guard)
      return risk_pct;

   double dd_pct=CurrentEquityDrawdownPct();
   if(dd_pct >= equity_dd_cutoff_pct)
      risk_pct *= equity_dd_risk_mult;

   return risk_pct;
}

bool HandleEquityDdHardStop()
{
   if(!use_equity_dd_hard_stop)
      return false;

   if(equity_dd_hard_stop_locked)
      return true;

   double dd_pct=CurrentEquityDrawdownPct();
   if(dd_pct < equity_dd_hard_stop_pct)
      return false;

   bool has_position=PositionSelect(_Symbol);
   if(has_position && CanSendOrders())
      trade.PositionClose(_Symbol);

   if(has_position || equity_dd_hard_stop_block_new_entries || equity_dd_hard_stop_lock_forever)
      locked_today=true;

   if(equity_dd_hard_stop_lock_forever)
      equity_dd_hard_stop_locked=true;

   if(has_position)
      return true;

   return equity_dd_hard_stop_block_new_entries || equity_dd_hard_stop_lock_forever;
}

bool MTFConfirmOK(bool want_buy)
{
   if(!use_mtf_ema_confirm)
      return true;

   double f1[1], s1[1], f2[1], s2[1];
   if(CopyBuffer(ema_confirm_fast_1_handle,0,0,1,f1)!=1) return false;
   if(CopyBuffer(ema_confirm_slow_1_handle,0,0,1,s1)!=1) return false;
   if(CopyBuffer(ema_confirm_fast_2_handle,0,0,1,f2)!=1) return false;
   if(CopyBuffer(ema_confirm_slow_2_handle,0,0,1,s2)!=1) return false;

   if(want_buy)
      return (f1[0]>s1[0] && f2[0]>s2[0]);

   return (f1[0]<s1[0] && f2[0]<s2[0]);
}

bool MacroRegimeOK(bool want_buy)
{
   if(!use_macro_regime_filter)
      return true;

   int shift = macro_use_closed_bar ? 1 : 0;
   int slope_bars = macro_slope_bars;
   if(slope_bars<0)
      slope_bars=0;

   double fast_now[1], slow_now[1], fast_old[1];
   if(CopyBuffer(ema_macro_fast_handle,0,shift,1,fast_now)!=1) return false;
   if(CopyBuffer(ema_macro_slow_handle,0,shift,1,slow_now)!=1) return false;
   if(CopyBuffer(ema_macro_fast_handle,0,shift+slope_bars,1,fast_old)!=1) return false;

   double close_macro=iClose(_Symbol, TF_macro, shift);
   if(close_macro<=0.0)
      return false;

   if(want_buy)
   {
      if(macro_require_fast_above_slow && fast_now[0]<=slow_now[0]) return false;
      if(macro_require_price_above_fast && close_macro<=fast_now[0]) return false;

      if(macro_min_slope_ATR>0.0 && slope_bars>0)
      {
         double atr_now[1];
         if(CopyBuffer(atr_macro_handle,0,shift,1,atr_now)!=1) return false;
         if(atr_now[0]<=0.0) return false;
         if((fast_now[0]-fast_old[0]) < macro_min_slope_ATR*atr_now[0]) return false;
      }
      return true;
   }

   if(macro_require_fast_above_slow && fast_now[0]>=slow_now[0]) return false;
   if(macro_require_price_above_fast && close_macro>=fast_now[0]) return false;

   if(macro_min_slope_ATR>0.0 && slope_bars>0)
   {
      double atr_now[1];
      if(CopyBuffer(atr_macro_handle,0,shift,1,atr_now)!=1) return false;
      if(atr_now[0]<=0.0) return false;
      if((fast_old[0]-fast_now[0]) < macro_min_slope_ATR*atr_now[0]) return false;
   }

   return true;
}

void ClearRetest()
{
   pending_retest=false;
   pending_retest_expire=0;
   pending_retest_level=0.0;
   pending_retest_sl_ref=0.0;
   pending_retest_atr_points=0.0;
}

void ArmRetest(bool buy,double level,double sl_ref,double atr_points)
{
   if(!use_retest_entry)
      return;

   pending_retest=true;
   pending_retest_buy=buy;
   pending_retest_level=level;
   pending_retest_sl_ref=sl_ref;
   pending_retest_atr_points=atr_points;
   pending_retest_expire=TimeCurrent() + retest_window_bars*PeriodSeconds(PERIOD_M1);
}

bool TryRetestEntry(double risk_pct,
                    double atr_points,
                    double active_close_pos_min,
                    bool bias_up,
                    bool bias_dn,
                    double high0,
                    double low0,
                    double close0,
                    double close_pos)
{
   if(!use_retest_entry || !pending_retest)
      return false;

   if(TimeCurrent()>pending_retest_expire)
   {
      ClearRetest();
      return false;
   }

   double ask=SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid=SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double zone_points=retest_zone_ATR*atr_points;
   double invalid_points=retest_invalidation_ATR*atr_points;
   double resume_min=MathMax(retest_resume_close_pos_min, active_close_pos_min-0.10);

   if(pending_retest_buy)
   {
      if(bid < pending_retest_level - invalid_points*_Point)
      {
         ClearRetest();
         return false;
      }

      double extension_points=(bid-pending_retest_level)/_Point;
      bool touched=(low0 <= pending_retest_level + zone_points*_Point);
      bool resumed=(close0 > pending_retest_level && close_pos>=resume_min);
      bool not_extended=(!use_breakout_extension_guard || extension_points<=max_breakout_extension_ATR*atr_points);

      if(!(bias_up && touched && resumed && not_extended && MTFConfirmOK(true)))
         return false;

      double buffer_points=structural_buffer_ATR*atr_points;
      double sl_struct=pending_retest_sl_ref - buffer_points*_Point;
      double sl_retest=pending_retest_level - retest_sl_ATR*atr_points*_Point;
      double sl_price=MathMax(sl_struct, sl_retest);
      double sl_points=(ask-sl_price)/_Point;
      if(sl_points < MinSL_points)
      {
         sl_points=MinSL_points;
         sl_price=ask-sl_points*_Point;
      }

      double lots=CalcLots(sl_points, risk_pct);
      if(lots<=0.0) return true;

      double tp_price=ask + (TP_R*sl_points)*_Point;
      if(CanSendOrders())
      {
         if(trade.Buy(lots,_Symbol,ask,sl_price,tp_price))
         {
            trades_today++;
            ClearRetest();
         }
         else
            last_order_failure_time=TimeCurrent();
      }
      return true;
   }

   if(ask > pending_retest_level + invalid_points*_Point)
   {
      ClearRetest();
      return false;
   }

   double extension_points=(pending_retest_level-ask)/_Point;
   bool touched=(high0 >= pending_retest_level - zone_points*_Point);
   bool resumed=(close0 < pending_retest_level && close_pos <= (1.0-resume_min));
   bool not_extended=(!use_breakout_extension_guard || extension_points<=max_breakout_extension_ATR*atr_points);

   if(!(bias_dn && touched && resumed && not_extended && MTFConfirmOK(false)))
      return false;

   double buffer_points=structural_buffer_ATR*atr_points;
   double sl_struct=pending_retest_sl_ref + buffer_points*_Point;
   double sl_retest=pending_retest_level + retest_sl_ATR*atr_points*_Point;
   double sl_price=MathMin(sl_struct, sl_retest);
   double sl_points=(sl_price-bid)/_Point;
   if(sl_points < MinSL_points)
   {
      sl_points=MinSL_points;
      sl_price=bid+sl_points*_Point;
   }

   double lots=CalcLots(sl_points, risk_pct);
   if(lots<=0.0) return true;

   double tp_price=bid - (TP_R*sl_points)*_Point;
   if(CanSendOrders())
   {
      if(trade.Sell(lots,_Symbol,bid,sl_price,tp_price))
      {
         trades_today++;
         ClearRetest();
      }
      else
         last_order_failure_time=TimeCurrent();
   }
   return true;
}

void ManageOpenPosition()
{
   if(!use_break_even && !use_atr_trailing)
      return;
   if(!CanSendOrders())
      return;
   if(!PositionSelect(_Symbol))
      return;

   long type=PositionGetInteger(POSITION_TYPE);
   double open_price=PositionGetDouble(POSITION_PRICE_OPEN);
   double sl=PositionGetDouble(POSITION_SL);
   double tp=PositionGetDouble(POSITION_TP);
   if(sl<=0.0)
      return;

   double bid=SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask=SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double price=(type==POSITION_TYPE_BUY) ? bid : ask;
   double risk_points=(type==POSITION_TYPE_BUY) ? ((open_price-sl)/_Point) : ((sl-open_price)/_Point);
   double profit_points=(type==POSITION_TYPE_BUY) ? ((price-open_price)/_Point) : ((open_price-price)/_Point);
   if(risk_points<=0.0 || profit_points<=0.0)
      return;

   double new_sl=sl;

   if(use_break_even && profit_points >= break_even_trigger_R*risk_points)
   {
      double be=(type==POSITION_TYPE_BUY) ? open_price + break_even_lock_points*_Point
                                          : open_price - break_even_lock_points*_Point;
      if(type==POSITION_TYPE_BUY && be>new_sl)
         new_sl=be;
      if(type==POSITION_TYPE_SELL && be<new_sl)
         new_sl=be;
   }

   if(use_atr_trailing && profit_points >= trail_start_R*risk_points)
   {
      double atr_buf[1];
      if(CopyBuffer(atr_m1_handle,0,0,1,atr_buf)==1)
      {
         double trail=(type==POSITION_TYPE_BUY) ? price - trail_atr_mult*atr_buf[0]
                                                : price + trail_atr_mult*atr_buf[0];
         if(type==POSITION_TYPE_BUY && trail>new_sl)
            new_sl=trail;
         if(type==POSITION_TYPE_SELL && trail<new_sl)
            new_sl=trail;
      }
   }

   new_sl=NormalizeDouble(new_sl, _Digits);
   if(MathAbs(new_sl-sl) < _Point)
      return;

   double min_stop_points=(double)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   if(type==POSITION_TYPE_BUY && new_sl >= bid-min_stop_points*_Point)
      return;
   if(type==POSITION_TYPE_SELL && new_sl <= ask+min_stop_points*_Point)
      return;

   trade.PositionModify(_Symbol, new_sl, tp);
}

// Squeeze computations
bool ComputeSqueezeOn(bool &squeeze_on)
{
   squeeze_on=false;
   if(!use_squeeze_filter) return true;

   double bb_up[1], bb_dn[1];
   if(CopyBuffer(bb_handle,0,0,1,bb_up)!=1) return false;
   if(CopyBuffer(bb_handle,2,0,1,bb_dn)!=1) return false;

   double ema_mid[1], atr_kc[1];
   if(CopyBuffer(kc_ema_handle,0,0,1,ema_mid)!=1) return false;
   if(CopyBuffer(kc_atr_handle,0,0,1,atr_kc)!=1) return false;

   double kc_upper=ema_mid[0] + kc_mult*atr_kc[0];
   double kc_lower=ema_mid[0] - kc_mult*atr_kc[0];

   squeeze_on = (bb_up[0] < kc_upper) && (bb_dn[0] > kc_lower);
   return true;
}

void UpdateCycleMemory()
{
   if(!use_squeeze_filter || !use_cycle_filter) return;

   datetime t0=iTime(_Symbol, TF_squeeze, 0);
   if(t0==0) return;

   static int bars_since_squeeze=1000000;

   if(last_squeeze_bar_time==0) last_squeeze_bar_time=t0;

   if(t0!=last_squeeze_bar_time)
   {
      last_squeeze_bar_time=t0;

      bool squeeze_on=false;
      if(ComputeSqueezeOn(squeeze_on))
      {
         if(squeeze_on){ squeeze_seen_recent=true; bars_since_squeeze=0; }
         else bars_since_squeeze++;
      }

      if(bars_since_squeeze > cycle_lookback_bars) squeeze_seen_recent=false;

      if(squeeze_release_countdown>0) squeeze_release_countdown--;
   }
}

bool SqueezeGateOK()
{
   if(!use_squeeze_filter) return true;

   UpdateCycleMemory();

   bool squeeze_on=false;
   if(!ComputeSqueezeOn(squeeze_on)) return false;

   if(squeeze_prev_on && !squeeze_on)
      squeeze_release_countdown=squeeze_release_window_bars;

   squeeze_prev_on=squeeze_on;

   if(squeeze_on) return false;

   bool in_release = (squeeze_release_countdown>0);

   bool allow_no_squeeze = (InpMode==0) ? allow_no_squeeze_selective : allow_no_squeeze_robust;
   double adx_m15_min = (InpMode==0) ? ADX_M15_min_selective : ADX_M15_min_robust;

   // store adx_m15_min via global static? we'll query in ADX_M15_OK()
   // Cycle logic
   if(use_cycle_filter)
   {
      if(squeeze_seen_recent && in_release) return true;
      return allow_no_squeeze;
   }

   if(in_release) return true;
   return allow_no_squeeze;
}

// Vol expansion trigger
bool ATRAccelerationOK()
{
   if(!use_atr_accel) return true;
   int need=MathMax(atr_accel_sma_len,2);
   double buf[];
   ArrayResize(buf,need);
   if(CopyBuffer(atr_m1_handle,0,0,need,buf)!=need) return false;
   double atr_now=buf[0];
   double sum=0.0;
   for(int i=0;i<atr_accel_sma_len && i<need;i++) sum+=buf[i];
   double atr_avg=sum/atr_accel_sma_len;
   if(atr_avg<=0.0) return false;
   return (atr_now >= atr_avg*exp_ratio_min);
}

bool RangeExpansionOK(double atr_points)
{
   if(!use_range_expansion) return true;
   double high0=iHigh(_Symbol, PERIOD_M1, 0);
   double low0 =iLow(_Symbol,  PERIOD_M1, 0);
   double range_points=(high0-low0)/_Point;
   return (range_points >= range_exp_mult*atr_points);
}

bool VolExpansionTriggerOK(double atr_points)
{
   bool a=ATRAccelerationOK();
   bool b=RangeExpansionOK(atr_points);

   if(use_atr_accel && use_range_expansion) return (a || b);
   if(use_atr_accel) return a;
   if(use_range_expansion) return b;
   return true;
}

bool ADX_M15_OK()
{
   if(!use_adx_m15_gate) return true;
   double buf[1];
   if(CopyBuffer(adx_m15_handle,0,0,1,buf)!=1) return false;
   double minv = (InpMode==0) ? ADX_M15_min_selective : ADX_M15_min_robust;
   return (buf[0] >= minv);
}

//==================== ONINIT ====================//
int OnInit()
{
   trade.SetExpertMagicNumber(InpMagicNumber);

   atr_m1_handle = iATR(_Symbol, PERIOD_M1, ATR_period);
   adx_m1_handle = iADX(_Symbol, PERIOD_M1, ADX_period);
   ema_fast_handle = iMA(_Symbol, TF_bias, EMA_bias_fast, 0, MODE_EMA, PRICE_CLOSE);
   ema_slow_handle = iMA(_Symbol, TF_bias, EMA_bias_slow, 0, MODE_EMA, PRICE_CLOSE);

   if(use_vol_regime || use_risk_scaler)
      atr_vol_handle = iATR(_Symbol, TF_vol, ATR_vol_period);

   if(use_squeeze_filter)
   {
      bb_handle = iBands(_Symbol, TF_squeeze, bb_period, 0, bb_dev, PRICE_CLOSE);
      kc_ema_handle = iMA(_Symbol, TF_squeeze, kc_ema_period, 0, MODE_EMA, PRICE_CLOSE);
      kc_atr_handle = iATR(_Symbol, TF_squeeze, kc_atr_period);
   }

   if(use_adx_m15_gate)
      adx_m15_handle = iADX(_Symbol, PERIOD_M15, ADX_M15_period);

   if(use_mtf_ema_confirm)
   {
      ema_confirm_fast_1_handle = iMA(_Symbol, TF_confirm_fast, EMA_confirm_fast, 0, MODE_EMA, PRICE_CLOSE);
      ema_confirm_slow_1_handle = iMA(_Symbol, TF_confirm_fast, EMA_confirm_slow, 0, MODE_EMA, PRICE_CLOSE);
      ema_confirm_fast_2_handle = iMA(_Symbol, TF_confirm_mid,  EMA_confirm_fast, 0, MODE_EMA, PRICE_CLOSE);
      ema_confirm_slow_2_handle = iMA(_Symbol, TF_confirm_mid,  EMA_confirm_slow, 0, MODE_EMA, PRICE_CLOSE);
   }

   if(use_macro_regime_filter)
   {
      ema_macro_fast_handle = iMA(_Symbol, TF_macro, EMA_macro_fast, 0, MODE_EMA, PRICE_CLOSE);
      ema_macro_slow_handle = iMA(_Symbol, TF_macro, EMA_macro_slow, 0, MODE_EMA, PRICE_CLOSE);
      if(macro_min_slope_ATR>0.0)
         atr_macro_handle = iATR(_Symbol, TF_macro, 14);
   }

   if(atr_m1_handle==INVALID_HANDLE || adx_m1_handle==INVALID_HANDLE ||
      ema_fast_handle==INVALID_HANDLE || ema_slow_handle==INVALID_HANDLE)
      return INIT_FAILED;

   if((use_vol_regime || use_risk_scaler) && atr_vol_handle==INVALID_HANDLE)
      return INIT_FAILED;

   if(use_squeeze_filter && (bb_handle==INVALID_HANDLE || kc_ema_handle==INVALID_HANDLE || kc_atr_handle==INVALID_HANDLE))
      return INIT_FAILED;

   if(use_adx_m15_gate && adx_m15_handle==INVALID_HANDLE)
      return INIT_FAILED;

   if(use_mtf_ema_confirm &&
      (ema_confirm_fast_1_handle==INVALID_HANDLE || ema_confirm_slow_1_handle==INVALID_HANDLE ||
       ema_confirm_fast_2_handle==INVALID_HANDLE || ema_confirm_slow_2_handle==INVALID_HANDLE))
      return INIT_FAILED;

   if(use_macro_regime_filter &&
      (ema_macro_fast_handle==INVALID_HANDLE || ema_macro_slow_handle==INVALID_HANDLE ||
       (macro_min_slope_ATR>0.0 && atr_macro_handle==INVALID_HANDLE)))
      return INIT_FAILED;

   trade.SetDeviationInPoints(SlippageMax_points);
   session_day_key = GetSessionDayKey(TimeCurrent());
   equity_peak=AccountInfoDouble(ACCOUNT_EQUITY);
   ClearRetest();
   return INIT_SUCCEEDED;
}

//==================== ONTICK ====================//
void OnTick()
{
   if(_Symbol != InpAllowedSymbol)
      return;

   ResetDailyIfNeeded();

   if(HandleEquityDdHardStop())
      return;

   if(PositionSelect(_Symbol))
   {
      ManageOpenPosition();
      return;
   }

   if(last_sl_time>0 && (TimeCurrent()-last_sl_time) < cooldown_minutes_after_sl*60) return;
   if(last_order_failure_time>0 && (TimeCurrent()-last_order_failure_time) < cooldown_seconds_after_order_fail) return;
   if(!SessionOK()) return;

   if(locked_today) return;
   if(trades_today >= max_trades_day) return;
   if(!SpreadOK()) return;

   double vol_ratio=1.0;
   if(!GetVolRatio(vol_ratio)) return;
   if(!VolatilityRegimeOK(vol_ratio)) return;
   double context_quality=CurrentContextQuality();
   if(context_quality < min_quality_for_trade) return;

   double risk_pct=ApplyContextRisk(CalcRiskPct(vol_ratio), context_quality);
   risk_pct=ApplyEquityRiskGuard(risk_pct);
   if(risk_pct<=0.0) return;

   double active_adx_min=ADX_min;
   double active_impulse_mult=impulse_mult;
   double active_close_pos_min=close_pos_min;
   if(context_quality <= weak_quality_threshold)
   {
      active_adx_min += weak_quality_adx_bonus;
      active_impulse_mult += weak_quality_impulse_bonus;
      active_close_pos_min += weak_quality_close_pos_bonus;
      if(active_close_pos_min>0.95)
         active_close_pos_min=0.95;
   }

   if(!SqueezeGateOK()) return;
   if(!ADX_M15_OK()) return;

   bool bias_up=BiasUp();
   bool bias_dn=BiasDown();
   if(bias_up && !MacroRegimeOK(true))
      bias_up=false;
   if(bias_dn && !MacroRegimeOK(false))
      bias_dn=false;
   if(!bias_up && !bias_dn) return;

   double atr_buf[1];
   if(CopyBuffer(atr_m1_handle,0,0,1,atr_buf)!=1) return;
   double atr_points=atr_buf[0]/_Point;
   if(atr_points < MinATR_points) return;

   if(!VolExpansionTriggerOK(atr_points)) return;

   double adx_buf[1];
   if(CopyBuffer(adx_m1_handle,0,0,1,adx_buf)!=1) return;
   if(adx_buf[0] < active_adx_min) return;

   double HH15=0.0, LL15=0.0;
   if(!GetM15StructureLevels(HH15,LL15)) return;

   double high0=iHigh(_Symbol, PERIOD_M1, 0);
   double low0 =iLow(_Symbol,  PERIOD_M1, 0);
   double close0=iClose(_Symbol, PERIOD_M1, 0);

   double range_points=(high0-low0)/_Point;
   if(range_points < active_impulse_mult*atr_points) return;

   double close_pos = (high0>low0) ? ((close0-low0)/(high0-low0)) : 0.5;

   double ask=SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid=SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double buffer_points=structural_buffer_ATR*atr_points;

   if(TryRetestEntry(risk_pct, atr_points, active_close_pos_min, bias_up, bias_dn,
                     high0, low0, close0, close_pos))
      return;

   if(allow_buy && bias_up && bid>HH15 && close_pos>=active_close_pos_min)
   {
      double extension_points=(bid-HH15)/_Point;
      if(use_retest_entry && !allow_direct_breakout_when_retest)
      {
         ArmRetest(true, HH15, LL15, atr_points);
         return;
      }
      if(use_breakout_extension_guard && extension_points>max_breakout_extension_ATR*atr_points)
      {
         ArmRetest(true, HH15, LL15, atr_points);
         return;
      }
      if(!MTFConfirmOK(true)) return;

      double sl_price = LL15 - buffer_points*_Point;
      double sl_points = (ask - sl_price)/_Point;
      if(sl_points < MinSL_points) sl_points = MinSL_points;

      double lots=CalcLots(sl_points, risk_pct);
      if(lots<=0.0) return;

      double tp_price = ask + (TP_R*sl_points)*_Point;

      if(CanSendOrders())
      {
         if(trade.Buy(lots,_Symbol,ask,sl_price,tp_price))
            trades_today++;
         else
            last_order_failure_time=TimeCurrent();
      }
      return;
   }

   if(allow_sell && bias_dn && ask<LL15 && close_pos <= (1.0-active_close_pos_min))
   {
      double extension_points=(LL15-ask)/_Point;
      if(use_retest_entry && !allow_direct_breakout_when_retest)
      {
         ArmRetest(false, LL15, HH15, atr_points);
         return;
      }
      if(use_breakout_extension_guard && extension_points>max_breakout_extension_ATR*atr_points)
      {
         ArmRetest(false, LL15, HH15, atr_points);
         return;
      }
      if(!MTFConfirmOK(false)) return;

      double sl_price = HH15 + buffer_points*_Point;
      double sl_points = (sl_price - bid)/_Point;
      if(sl_points < MinSL_points) sl_points = MinSL_points;

      double lots=CalcLots(sl_points, risk_pct);
      if(lots<=0.0) return;

      double tp_price = bid - (TP_R*sl_points)*_Point;

      if(CanSendOrders())
      {
         if(trade.Sell(lots,_Symbol,bid,sl_price,tp_price))
            trades_today++;
         else
            last_order_failure_time=TimeCurrent();
      }
      return;
   }
}

//==================== ONTRADETRANSACTION ====================//
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
{
   if(trans.type!=TRADE_TRANSACTION_DEAL_ADD) return;
   if(trans.deal<=0) return;

   datetime now=TimeCurrent();
   HistorySelect(now-86400, now+60);

   long reason=(long)HistoryDealGetInteger(trans.deal, DEAL_REASON);
   double deal_pnl=HistoryDealGetDouble(trans.deal, DEAL_PROFIT) +
                   HistoryDealGetDouble(trans.deal, DEAL_SWAP) +
                   HistoryDealGetDouble(trans.deal, DEAL_COMMISSION);
   if(reason==DEAL_REASON_SL && deal_pnl<0.0)
   {
      daily_loss_R -= 1.0;
      last_sl_time = TimeCurrent();
      if(daily_loss_R <= -max_daily_loss_R) locked_today=true;
   }
}

bool CanSendOrders()
{
   return InpEnableLiveOrders ||
      (InpEnableTesterOrders && (bool)MQLInfoInteger(MQL_TESTER));
}
