import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/compound_interest_model.dart';
import '../models/retirement_model.dart';
import 'custom_card.dart';

class BreakdownTable extends StatefulWidget {
  final List<YearlyBreakdown>? standardBreakdown;
  final List<RetirementYearlyBreakdown>? retirementBreakdown;
  final bool isRetirement;

  const BreakdownTable({
    super.key,
    this.standardBreakdown,
    this.retirementBreakdown,
    this.isRetirement = false,
  });

  @override
  State<BreakdownTable> createState() => _BreakdownTableState();
}

class _BreakdownTableState extends State<BreakdownTable> {

  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(locale: 'th_TH', symbol: '฿', decimalDigits: 0);
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rowCount = widget.isRetirement
        ? (widget.retirementBreakdown?.length ?? 0)
        : (widget.standardBreakdown?.length ?? 0);

    if (rowCount == 0) return const SizedBox.shrink();

    return CustomCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        title: Text(
          widget.isRetirement ? 'ตารางรายปี (Accumulation & Drawdown)' : 'ตารางแจกแจงรายปี (Yearly Growth Table)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        subtitle: Text(
          'ดูตัวเลขอย่างละเอียดรายปี',
          style: TextStyle(
            fontSize: 11,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        leading: Icon(
          Icons.table_chart_outlined,
          color: Theme.of(context).primaryColor,
        ),
        shape: const Border(),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: isDark ? const Color(0xFF0F172A).withOpacity(0.5) : const Color(0xFFF8FAFC),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                horizontalMargin: 8,
                headingRowHeight: 40,
                dataRowMinHeight: 36,
                dataRowMaxHeight: 48,
                columns: widget.isRetirement
                    ? const [
                        DataColumn(label: Text('อายุ (Age)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        DataColumn(label: Text('สถานะ (Status)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        DataColumn(label: Text('ฝาก/ถอนต่อปี', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        DataColumn(label: Text('ดอกเบี้ยต่อปี', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        DataColumn(label: Text('เงินคงเหลือ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      ]
                    : const [
                        DataColumn(label: Text('ปีที่ (Year)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        DataColumn(label: Text('เงินต้นสะสม', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        DataColumn(label: Text('ดอกเบี้ยปีนี้', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        DataColumn(label: Text('ดอกเบี้ยสะสม', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        DataColumn(label: Text('เงินรวมปลายปี', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      ],
                rows: widget.isRetirement
                    ? widget.retirementBreakdown!.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text('${item.age}', style: const TextStyle(fontSize: 12))),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: item.isRetired
                                      ? const Color(0xFFEC4899).withOpacity(0.1)
                                      : const Color(0xFF10B981).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.isRetired ? 'เกษียณ' : 'สะสม',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: item.isRetired ? const Color(0xFFEC4899) : const Color(0xFF10B981),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(
                              _formatCurrency(item.annualContribution),
                              style: TextStyle(
                                fontSize: 12,
                                color: item.annualContribution < 0 ? const Color(0xFFEF4444) : (isDark ? Colors.white : Colors.black),
                              ),
                            )),
                            DataCell(Text(_formatCurrency(item.annualInterestEarned), style: const TextStyle(fontSize: 12))),
                            DataCell(Text(
                              _formatCurrency(item.balance),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            )),
                          ],
                        );
                      }).toList()
                    : widget.standardBreakdown!.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text('${item.year}', style: const TextStyle(fontSize: 12))),
                            DataCell(Text(_formatCurrency(item.principal), style: const TextStyle(fontSize: 12))),
                            DataCell(Text(_formatCurrency(item.interest), style: const TextStyle(fontSize: 12))),
                            DataCell(Text(_formatCurrency(item.cumulativeInterest), style: const TextStyle(fontSize: 12))),
                            DataCell(Text(
                              _formatCurrency(item.balance),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            )),
                          ],
                        );
                      }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
