import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../domain/models/compound_interest_model.dart';
import '../../domain/models/retirement_model.dart';

enum ChartType {
  standard, // CI or SG
  retirement,
}

class GrowthChart extends StatelessWidget {
  final ChartType type;
  final List<YearlyBreakdown>? standardBreakdown;
  final List<RetirementYearlyBreakdown>? retirementBreakdown;
  final double initialPrincipal;

  const GrowthChart({
    super.key,
    required this.type,
    this.standardBreakdown,
    this.retirementBreakdown,
    this.initialPrincipal = 0.0,
  });

  String _formatCurrency(double value) {
    if (value >= 10000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}k';
    }
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gridColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textStyle = TextStyle(
      fontSize: 10,
      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
    );

    if (type == ChartType.standard) {
      return _buildStandardChart(gridColor, textStyle, isDark);
    } else {
      return _buildRetirementChart(gridColor, textStyle, isDark);
    }
  }

  Widget _buildStandardChart(Color gridColor, TextStyle textStyle, bool isDark) {
    final breakdown = standardBreakdown ?? [];
    if (breakdown.isEmpty) return const SizedBox(height: 220, child: Center(child: Text('ไม่มีข้อมูล')));

    // Generate spots
    List<FlSpot> balanceSpots = [FlSpot(0, initialPrincipal)];
    List<FlSpot> principalSpots = [FlSpot(0, initialPrincipal)];

    for (var item in breakdown) {
      balanceSpots.add(FlSpot(item.year.toDouble(), item.balance));
      principalSpots.add(FlSpot(item.year.toDouble(), item.principal));
    }

    double maxVal = breakdown.last.balance;
    
    // Determine interval for grid/labels
    int totalYears = breakdown.length;
    double xInterval = (totalYears / 5).ceilToDouble();
    if (xInterval < 1) xInterval = 1;

    return SizedBox(
      height: 220,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, top: 12.0, bottom: 4.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: maxVal > 0 ? maxVal / 4 : 10000,
              getDrawingHorizontalLine: (value) => FlLine(
                color: gridColor,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 26,
                  interval: xInterval,
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return Text('ปี 0', style: textStyle);
                    // Prevent drawing off-bounds
                    if (value > totalYears) return const Text('');
                    return SideTitleWidget(
                      meta: meta,
                      child: Text('ปี ${value.toInt()}', style: textStyle),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 45,
                  interval: maxVal > 0 ? maxVal / 4 : 10000,
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return Text('฿0', style: textStyle);
                    return SideTitleWidget(
                      meta: meta,
                      child: Text('฿${_formatCurrency(value)}', style: textStyle),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              // Principal Line (Bottom)
              LineChartBarData(
                spots: principalSpots,
                isCurved: true,
                curveSmoothness: 0.15,
                color: const Color(0xFF818CF8),
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: const Color(0xFF818CF8).withOpacity(0.15),
                ),
              ),
              // Balance Line (Top)
              LineChartBarData(
                spots: balanceSpots,
                isCurved: true,
                curveSmoothness: 0.15,
                color: const Color(0xFF10B981),
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF10B981).withOpacity(0.3),
                      const Color(0xFF10B981).withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => isDark ? const Color(0xFF1E293B) : Colors.white,
                tooltipBorder: BorderSide(color: gridColor, width: 1),
                tooltipBorderRadius: BorderRadius.circular(8),
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((touchedSpot) {
                    final isBalance = touchedSpot.barIndex == 1;
                    final formattedVal = NumberFormat.decimalPattern('th_TH').format(touchedSpot.y.round());
                    return LineTooltipItem(
                      '${isBalance ? "ยอดรวม" : "เงินต้น"}: ฿$formattedVal',
                      TextStyle(
                        color: isBalance ? const Color(0xFF10B981) : const Color(0xFF818CF8),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRetirementChart(Color gridColor, TextStyle textStyle, bool isDark) {
    final breakdown = retirementBreakdown ?? [];
    if (breakdown.isEmpty) return const SizedBox(height: 220, child: Center(child: Text('ไม่มีข้อมูล')));

    List<FlSpot> spots = [];

    double maxVal = 0.0;
    for (var item in breakdown) {
      spots.add(FlSpot(item.age.toDouble(), item.balance));
      if (item.balance > maxVal) maxVal = item.balance;
    }
    
    // Find age interval
    int startAge = breakdown.first.age;
    int endAge = breakdown.last.age;
    double xInterval = ((endAge - startAge) / 5).ceilToDouble();
    if (xInterval < 1) xInterval = 1;

    return SizedBox(
      height: 220,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, top: 12.0, bottom: 4.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: maxVal > 0 ? maxVal / 4 : 10000,
              getDrawingHorizontalLine: (value) => FlLine(
                color: gridColor,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 26,
                  interval: xInterval,
                  getTitlesWidget: (value, meta) {
                    if (value < startAge || value > endAge) return const Text('');
                    return SideTitleWidget(
                      meta: meta,
                      child: Text('อายุ ${value.toInt()}', style: textStyle),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 45,
                  interval: maxVal > 0 ? maxVal / 4 : 10000,
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return Text('฿0', style: textStyle);
                    return SideTitleWidget(
                      meta: meta,
                      child: Text('฿${_formatCurrency(value)}', style: textStyle),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              // Combined Accumulation + Drawdown Curve
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.1,
                color: const Color(0xFF6366F1),
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF6366F1).withOpacity(0.3),
                      const Color(0xFF6366F1).withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => isDark ? const Color(0xFF1E293B) : Colors.white,
                tooltipBorder: BorderSide(color: gridColor, width: 1),
                tooltipBorderRadius: BorderRadius.circular(8),
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((touchedSpot) {
                    final formattedVal = NumberFormat.decimalPattern('th_TH').format(touchedSpot.y.round());
                    // Find if retired at this age
                    final breakdownIndex = breakdown.indexWhere((element) => element.age == touchedSpot.x.toInt());
                    String status = "สะสม";
                    if (breakdownIndex != -1 && breakdown[breakdownIndex].isRetired) {
                      status = "หลังเกษียณ";
                    }
                    return LineTooltipItem(
                      'อายุ ${touchedSpot.x.toInt()} ($status)\n฿$formattedVal',
                      const TextStyle(
                        color: Color(0xFF6366F1),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
