import 'package:candlesticks/src/models/candle.dart';
import 'package:candlesticks/src/theme/theme_data.dart';
import 'package:candlesticks/src/utils/helper_functions.dart';
import 'package:flutter/material.dart';

class CandleInfoText extends StatelessWidget {
  const CandleInfoText({
    Key? key,
    required this.candle,
  }) : super(key: key);

  final Candle candle;

  String numberFormat(int value) {
    return "${value < 10 ? 0 : ""}$value";
  }

  String dateFormatter(DateTime date) {
    //return "${date.year}-${numberFormat(date.month)}-${numberFormat(date.day)} ${numberFormat(date.hour)}:${numberFormat(date.minute)}";
    return "${date.year}-${numberFormat(date.month)}-${numberFormat(date.day)}";
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: dateFormatter(candle.date),
        style: TextStyle(color: Theme.of(context).grayColor, fontSize: 11),
        children: <TextSpan>[
          TextSpan(text: " O:"),
          TextSpan(
              text: HelperFunctions.priceToString(candle.open),
              style: TextStyle(
                  color: candle.isBull
                      ? Theme.of(context).primaryGreen
                      : Theme.of(context).primaryRed)),
          TextSpan(text: " H:"),
          TextSpan(
              text: HelperFunctions.priceToString(candle.high),
              style: TextStyle(
                  color: candle.isBull
                      ? Theme.of(context).primaryGreen
                      : Theme.of(context).primaryRed)),
          TextSpan(text: " L:"),
          TextSpan(
              text: HelperFunctions.priceToString(candle.low),
              style: TextStyle(
                  color: candle.isBull
                      ? Theme.of(context).primaryGreen
                      : Theme.of(context).primaryRed)),
          TextSpan(text: " C:"),
          TextSpan(
              text: HelperFunctions.priceToString(candle.close),
              style: TextStyle(
                  color: candle.isBull
                      ? Theme.of(context).primaryGreen
                      : Theme.of(context).primaryRed)),
        ],
      ),
    );
  }
}

class CandleThumb extends StatelessWidget {
  const CandleThumb({
    Key? key,
    required this.candle,
    double? xPos,
    double? yPos,
  }) : super(key: key);

  final Candle candle;
  final double? xPos = null;
  final double? yPos = null;

  @override
  Widget build(BuildContext context) {
    //String str = candle.diffRatio.toString()+x.toString();
    print(xPos);
    //return Positioned(left: xPos, right: yPos, child: Text(candle.diffRatio.toString(), style: Colors.red,));
    return Container(
      
      //color: Colors.red,
      child: Text(
        candle.diffRatio.toString(),
        //str
        //x.toString()
      ),
    );
  }
}
