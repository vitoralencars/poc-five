import 'package:flutter/material.dart';
import 'package:pocs_flutter/model/player_history_data.dart';
import 'package:pocs_flutter/util/app_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';

class PlayerHistory extends StatefulWidget {
  const PlayerHistory({
    Key? key,
    required this.historyData
  }) : super(key: key);

  final PlayerHistoryData historyData;

  @override
  State<PlayerHistory> createState() => _PlayerHistoryState();
}

class _PlayerHistoryState extends State<PlayerHistory> {
  @override
  Widget build(BuildContext context) {
    var data = widget.historyData;

    return Wrap(
      children: [
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Color(AppColors.homeBackground),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25)
            )
          ),
          child: Column(
            children: [
              _buildHistoryTitleContainer(),
              const SizedBox(height: 20),
              _buildHistoryDataRow(data),
              const SizedBox(height: 30),
              Text(
                "Tentativas",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(AppColors.defaultTextColor),
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              _buildTriesChart(data)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTitleContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(AppColors.selectedRowLetterBoxBackground),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25)
        )
      ),
      child: (
        Text(
          "Histórico",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(AppColors.defaultTextColor),
            fontSize: 22,
            fontWeight: FontWeight.bold
          ),
        )
      ),
    );
  }

  Widget _buildHistoryDataRow(PlayerHistoryData data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: _buildHistoryData(
                "Jogos",
                data.playedGames().toString()
            ),
            flex: 1
        ),
        Expanded(
            child: _buildHistoryData(
                "Acertos",
                data.winPercentage()
            ),
            flex: 1
        ),
        Expanded(
            child: _buildHistoryData(
                "Acertos em sequência",
                data.currentSequence.toString()
            ),
            flex: 1
        ),
        Expanded(
            child: _buildHistoryData(
                "Maior sequência",
                data.bestSequence.toString()
            ),
            flex: 1
        ),
      ],
    );
  }

  Widget _buildHistoryData(String description, String data) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Text(
            data,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(AppColors.defaultTextColor),
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(AppColors.defaultTextColor),
                fontSize: 14
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTriesChart(PlayerHistoryData data) {
    var tries = List<int>.from(data.tries.reversed);
    tries.insert(0, data.defeats);

    var maxTriesValue = tries.reduce(max);

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      margin: const EdgeInsets.only(left: 20, right: 40),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(width: 0, size: 15),
        axisLine: const AxisLine(width: 0),
        isVisible: true,
        interval: 1,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Color(AppColors.defaultTextColor)
        )
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: (maxTriesValue + 5).toDouble(),
        interval: 1,
        isVisible: false,
      ),
      series: <ChartSeries<int, String>>[
        BarSeries<int, String>(
          dataSource: tries,
          xValueMapper: (_, index) => _getXValueMapper(index, tries.length),
          yValueMapper: (int value, _) => value,
          width: 0.5,
          borderRadius: const BorderRadius.horizontal(right: Radius.circular(5)),
          color: Color(AppColors.selectedRowLetterBoxBackground),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top,
            textStyle: TextStyle(
              fontSize: 14,
              color: Color(AppColors.defaultTextColor)
            )
          )
        )
      ]
    );
  }

  String _getXValueMapper(int index, triesLength) {
    return index > 0 ? ((index - triesLength).abs()).toString() : "#";
  }
}
