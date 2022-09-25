import 'dart:math';
import 'package:candlesticks/src/models/candle.dart';
import 'package:candlesticks/src/theme/theme_data.dart';
import 'package:candlesticks/src/widgets/toolbar_action.dart';
import 'package:candlesticks/src/widgets/mobile_chart.dart';
import 'package:candlesticks/src/widgets/desktop_chart.dart';
import 'package:candlesticks/src/widgets/toolbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'models/candle.dart';
import 'dart:io' show Platform;
// import 'package:macos_kairos/view_models/home_page_view_model.dart';
// import 'package:macos_kairos/common/stock_func.dart';
// import 'package:macos_kairos/theme.dart';
// import 'package:provider/provider.dart';
// import 'package:macos_kairos/models/theme.dart';

/// StatefulWidget that holds Chart's State (index of
/// current position and candles width).
class Candlesticks extends StatefulWidget {
  /// The arrangement of the array should be such that
  ///  the newest item is in position 0
  final List<Candle> candles;

  //final KrStockViewModel krstock;

  /// this callback calls when the last candle gets visible
  final Future<void> Function()? onLoadMoreCandles;

  /// list of buttons you what to add on top tool bar
  final List<ToolBarAction> actions;

  Candlesticks({
    Key? key,
    required this.candles,
    //required this.krstock,
    this.onLoadMoreCandles,
    this.actions = const [],
  }) : super(key: key);

  @override
  _CandlesticksState createState() => _CandlesticksState();
}

class _CandlesticksState extends State<Candlesticks> {
  /// index of the newest candle to be displayed
  /// changes when user scrolls along the chart
  int index = -10;
  double lastX = 0;
  int lastIndex = -10;

  /// candleWidth controls the width of the single candles.
  ///  range: [2...10]
  double candleWidth = 6;

  /// true when widget.onLoadMoreCandles is fetching new candles.
  bool isCallingLoadMore = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chart Title 작성 - 심정민
        // Container(
        //   height: 48,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       ClipRRect(
        //         borderRadius: BorderRadius.circular(15.0),
        //         child: Image.asset(
        //           'assets/images/ci/${widget.krstock.code}.png',
        //           width: 35.0,
        //           height: 35.0,
        //         ),
        //       ),
        //       Text(
        //         widget.krstock.name,
        //         textAlign: TextAlign.center,
        //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        //       ),
        //       Text(
        //         changePriceFormat(widget.krstock.price),
        //         textAlign: TextAlign.center,
        //         style: "${widget.krstock.price}".substring(0, 1) == "-"
        //             ? Theme.of(context).textTheme.bodyMedium!.copyWith(
        //                 color: Provider.of<ThemeModel>(context).themeType ==
        //                         ThemeType.Light
        //                     ? lightThemeNegativeColor
        //                     : darkThemeNegativeColor,
        //                 fontSize: 15)
        //             : Theme.of(context).textTheme.bodyMedium!.copyWith(
        //                 color: Provider.of<ThemeModel>(context).themeType ==
        //                         ThemeType.Light
        //                     ? lightThemePositiveColor
        //                     : darkThemePositiveColor,
        //                 fontSize: 15),
        //       ),
        //       Text("${widget.krstock.diffRatio}%",
        //           style: "${widget.krstock.diffRatio}".substring(0, 1) == "-"
        //               ? Theme.of(context).textTheme.bodyMedium!.copyWith(
        //                   color: Provider.of<ThemeModel>(context).themeType ==
        //                           ThemeType.Light
        //                       ? lightThemeNegativeColor
        //                       : darkThemeNegativeColor)
        //               : Theme.of(context).textTheme.bodyMedium!.copyWith(
        //                   color: Provider.of<ThemeModel>(context).themeType ==
        //                           ThemeType.Light
        //                       ? lightThemePositiveColor
        //                       : darkThemePositiveColor)),
        //       Text("거래량 : ${changePriceFormat(widget.krstock.volumn)}")
        //     ],
        //   ),
        // ),
        ToolBar(
          onZoomInPressed: () {
            setState(() {
              candleWidth += 2;
              candleWidth = min(candleWidth, 16);
            });
          },
          onZoomOutPressed: () {
            setState(() {
              candleWidth -= 2;
              candleWidth = max(candleWidth, 4);
            });
          },
          children: widget.actions,
        ),
        if (widget.candles.length == 0)
          Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).gold,
              ),
            ),
          )
        else
          Expanded(
            child: TweenAnimationBuilder(
              tween: Tween(begin: 6.toDouble(), end: candleWidth),
              duration: Duration(milliseconds: 120),
              builder: (_, double width, __) {
                if (kIsWeb ||
                    Platform.isMacOS ||
                    Platform.isWindows ||
                    Platform.isLinux) {
                  return DesktopChart(
                    onScaleUpdate: (double scale) {
                      scale = max(0.90, scale);
                      scale = min(1.1, scale);
                      setState(() {
                        candleWidth *= scale;
                        candleWidth = min(candleWidth, 16);
                        candleWidth = max(candleWidth, 4);
                      });
                    },
                    onPanEnd: () {
                      lastIndex = index;
                    },
                    onHorizontalDragUpdate: (double x) {
                      setState(() {
                        x = x - lastX;
                        index = lastIndex + x ~/ candleWidth;
                        index = max(index, -10);
                        index = min(index, widget.candles.length - 1);
                      });
                    },
                    onPanDown: (double value) {
                      lastX = value;
                      lastIndex = index;
                    },
                    onReachEnd: () {
                      if (isCallingLoadMore == false &&
                          widget.onLoadMoreCandles != null) {
                        isCallingLoadMore = true;
                        widget.onLoadMoreCandles!().then((_) {
                          isCallingLoadMore = false;
                        });
                      }
                    },
                    candleWidth: width,
                    candles: widget.candles,
                    index: index,
                  );
                } else {
                  return MobileChart(
                    onScaleUpdate: (double scale) {
                      scale = max(0.90, scale);
                      scale = min(1.1, scale);
                      setState(() {
                        candleWidth *= scale;
                        candleWidth = min(candleWidth, 16);
                        candleWidth = max(candleWidth, 4);
                      });
                    },
                    onPanEnd: () {
                      lastIndex = index;
                    },
                    onHorizontalDragUpdate: (double x) {
                      setState(() {
                        x = x - lastX;
                        index = lastIndex + x ~/ candleWidth;
                        index = max(index, -10);
                        index = min(index, widget.candles.length - 1);
                      });
                    },
                    onPanDown: (double value) {
                      lastX = value;
                      lastIndex = index;
                    },
                    onReachEnd: () {
                      if (isCallingLoadMore == false &&
                          widget.onLoadMoreCandles != null) {
                        isCallingLoadMore = true;
                        widget.onLoadMoreCandles!().then((_) {
                          isCallingLoadMore = false;
                        });
                      }
                    },
                    candleWidth: width,
                    candles: widget.candles,
                    index: index,
                  );
                }
              },
            ),
          ),
      ],
    );
  }
}
