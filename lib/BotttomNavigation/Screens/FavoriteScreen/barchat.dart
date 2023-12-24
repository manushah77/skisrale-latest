import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skisreal/BotttomNavigation/Models/snow_model.dart';

class BarChartSample extends StatefulWidget {
  String? resortName;
  String? selectedTime; // Add this line

  BarChartSample({this.resortName,this.selectedTime});

  @override
  State<BarChartSample> createState() => _BarChartSampleState();
}

class _BarChartSampleState extends State<BarChartSample> {
  List<Forecast5Day> forecast5days = [];

  void fetchSnowWeather() async {
    String bearerToken = '1978|6mhSMOD8fIh0Ukp758oHXWLMeBYzzDXRLygfMcNG';

    Uri uri = Uri.parse(
        "https://zylalabs.com/api/1454/ski+resort+forecast+weather+api/1196/five+day+forecast?resort=${widget.resortName}");
    var res = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );
    var decodeBody = json.decode(res.body);
    setState(() {
      forecast5days = (decodeBody['topLift']['forecast5Day'] as List)
          .map((item) => Forecast5Day.fromJson(item))
          .toList();
    });
    print('wasdasda${forecast5days}');
  }

  @override
  void initState() {
    super.initState();
    fetchSnowWeather();
  }

  @override
  Widget build(BuildContext context) {
    const gapWidth = 10.0; // Adjust this value as needed for the desired gap width

    return AspectRatio(
      aspectRatio: 1.3,
      child: forecast5days.isEmpty
          ? Center(child: CircularProgressIndicator())
          : BarChart(
        BarChartData(
          maxY: 10,
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  rod.toY.round().toString(),
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            handleBuiltInTouches: false,
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value,TileMode) {
                  int index = value.toInt();
                  if (index >= 0 && index < forecast5days.length) {
                    String dayOfWeek = forecast5days[index].dayOfWeek ?? '';
                    // Convert the full name to a short name
                    return Text('${_getShortDayName(dayOfWeek)}');
                  }
                  return Text('');
                },
              ),
            ),

          ),

          gridData: FlGridData(
            show: false,
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              top: BorderSide(color: Colors.transparent),
              left: BorderSide(color: Colors.transparent),
              right: BorderSide(
                color: const Color(0xff37434d),
                width: 1,
              ),
              bottom: BorderSide(
                color: const Color(0xff37434d),
                width: 1,
              ),
            ),
          ),
          barGroups: forecast5days
              .asMap()
              .entries
              .map(
                (entry) => BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  color: Colors.blue,
                  toY: _parseSnowValue(
                    widget.selectedTime == 'AM' ? entry.value.am?.snow :
                    widget.selectedTime == 'PM' ? entry.value.pm?.snow :
                    widget.selectedTime == 'Night' ? entry.value.night?.snow : null,
                  ),
                  width: 30,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(3), topLeft: Radius.circular(3)),
                ),
              ],
            ),
          )
              .toList(),


        ),
      ),
    );
  }
  double _parseSnowValue(String? snow) {
    if (snow != null && snow.isNotEmpty) {
      try {
        // Remove the "in" suffix and then parse the string
        String snowWithoutSuffix = snow.replaceAll('in', '').trim();
        return double.parse(snowWithoutSuffix);
      } catch (e) {
        // Handle parsing errors, non-numeric values, or other scenarios
      }
    }
    return 0.0; // Default to 0.0 for invalid or empty values
  }

  String _getShortDayName(String fullDayName) {
    switch (fullDayName.toLowerCase()) {
      case 'sunday':
        return 'Sun';
      case 'monday':
        return 'Mon';
      case 'tuesday':
        return 'Tue';
      case 'wednesday':
        return 'Wed';
      case 'thursday':
        return 'Thu';
      case 'friday':
        return 'Fri';
      case 'saturday':
        return 'Sat';
      default:
        return '';
    }
  }

}
