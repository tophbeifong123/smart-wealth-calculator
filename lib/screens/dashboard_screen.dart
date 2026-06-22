import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/calculator_provider.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_slider.dart';
import '../widgets/result_card.dart';
import '../widgets/growth_chart.dart';
import '../widgets/breakdown_table.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(locale: 'th_TH', symbol: '฿', decimalDigits: 0);
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalculatorProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF6366F1)),
            SizedBox(width: 8),
            Text('Smart Wealth Calculator'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              provider.themeMode == ThemeMode.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: const Color(0xFF6366F1),
            ),
            onPressed: () => provider.toggleTheme(),
            tooltip: 'เปลี่ยนธีม',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Sliding Segmented Tabs
            _buildCustomTabBar(context, provider, isDark),
            
            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildActiveTabContent(provider, context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Beautiful segmented bar
  Widget _buildCustomTabBar(BuildContext context, CalculatorProvider provider, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildTabItem(context, provider, 0, 'ดอกเบี้ยทบต้น', Icons.trending_up, isDark),
          _buildTabItem(context, provider, 1, 'เป้าหมายออม', Icons.track_changes, isDark),
          _buildTabItem(context, provider, 2, 'วางแผนเกษียณ', Icons.elderly, isDark),
        ],
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    CalculatorProvider provider,
    int index,
    String label,
    IconData icon,
    bool isDark,
  ) {
    final isSelected = provider.activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => provider.setActiveTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF334155) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected && !isDark
                ? [
                    const BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? const Color(0xFF6366F1)
                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? (isDark ? Colors.white : const Color(0xFF0F172A))
                      : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTabContent(CalculatorProvider provider, BuildContext context) {
    switch (provider.activeTab) {
      case 0:
        return _buildCompoundInterestTab(provider, context);
      case 1:
        return _buildSavingsGoalTab(provider, context);
      case 2:
        return _buildRetirementTab(provider, context);
      default:
        return const SizedBox.shrink();
    }
  }

  // --- TAB 1: COMPOUND INTEREST ---
  Widget _buildCompoundInterestTab(CalculatorProvider provider, BuildContext context) {
    final result = provider.ciResult;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      key: const ValueKey('ci_tab'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Form Inputs Card
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ข้อมูลการคำนวณเงินออม',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 16),
              
              CustomSlider(
                title: 'เงินต้นเริ่มต้น (Initial Principal)',
                value: provider.ciInitialPrincipal,
                min: 0,
                max: 5000000,
                unit: 'บาท',
                isCurrency: true,
                onChanged: (val) => provider.updateCI(initialPrincipal: (val / 5000).round() * 5000),
              ),
              const SizedBox(height: 12),
              
              CustomSlider(
                title: 'เงินฝากรายเดือน (Monthly Savings)',
                value: provider.ciMonthlyContribution,
                min: 0,
                max: 100000,
                unit: 'บาท',
                isCurrency: true,
                onChanged: (val) => provider.updateCI(monthlyContribution: (val / 500).round() * 500),
              ),
              const SizedBox(height: 12),
              
              CustomSlider(
                title: 'อัตราดอกเบี้ยต่อปี (Annual Rate)',
                value: provider.ciAnnualRate,
                min: 0.0,
                max: 20.0,
                unit: '%',
                decimalPlaces: 2,
                onChanged: (val) => provider.updateCI(annualRate: double.parse(val.toStringAsFixed(2))),
              ),
              const SizedBox(height: 12),
              
              CustomSlider(
                title: 'ระยะเวลาลงทุน (Years)',
                value: provider.ciYears.toDouble(),
                min: 1,
                max: 50,
                unit: 'ปี',
                onChanged: (val) => provider.updateCI(years: val.round()),
              ),
              const SizedBox(height: 16),
              
              // Advanced Options Row
              Row(
                children: [
                  // Compounding Frequency
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('การทบต้น (Compounding)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: provider.ciFrequency,
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(value: 1, child: Text('ทุกปี (Annually)', style: TextStyle(fontSize: 13))),
                                DropdownMenuItem(value: 4, child: Text('ทุกไตรมาส (Quarterly)', style: TextStyle(fontSize: 13))),
                                DropdownMenuItem(value: 12, child: Text('ทุกเดือน (Monthly)', style: TextStyle(fontSize: 13))),
                                DropdownMenuItem(value: 365, child: Text('ทุกวัน (Daily)', style: TextStyle(fontSize: 13))),
                              ],
                              onChanged: (val) => provider.updateCI(frequency: val),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Contribution Timing
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('เวลาฝากเงิน', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => provider.updateCI(timingBeginning: true),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: provider.ciTimingBeginning
                                          ? const Color(0xFF6366F1)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'ต้นงวด',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: provider.ciTimingBeginning
                                            ? Colors.white
                                            : (isDark ? Colors.grey[400] : Colors.grey[600]),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () => provider.updateCI(timingBeginning: false),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: !provider.ciTimingBeginning
                                          ? const Color(0xFF6366F1)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'สิ้นงวด',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: !provider.ciTimingBeginning
                                            ? Colors.white
                                            : (isDark ? Colors.grey[400] : Colors.grey[600]),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Result Title
        Text(
          'สรุปผลลัพธ์การออมทรัพย์',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),

        // Result Card
        ResultCard(
          finalBalance: result.finalBalance,
          totalPrincipal: result.totalContributions + provider.ciInitialPrincipal,
          totalInterest: result.totalInterest,
          subtitleText: 'เงินฝากต่อเดือน',
          subtitleValue: '${_formatCurrency(provider.ciMonthlyContribution)} / เดือน',
        ),
        const SizedBox(height: 20),

        // Graph Card
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'การเติบโตของเงินออมรายปี',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      _buildIndicatorChip(const Color(0xFF10B981), 'ยอดรวม'),
                      const SizedBox(width: 8),
                      _buildIndicatorChip(const Color(0xFF818CF8), 'เงินต้น'),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              GrowthChart(
                type: ChartType.standard,
                standardBreakdown: result.yearlyBreakdown,
                initialPrincipal: provider.ciInitialPrincipal,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Table
        BreakdownTable(standardBreakdown: result.yearlyBreakdown),
      ],
    );
  }

  // Helper chip for chart legends
  Widget _buildIndicatorChip(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  // --- TAB 2: SAVINGS GOAL ---
  Widget _buildSavingsGoalTab(CalculatorProvider provider, BuildContext context) {
    final result = provider.sgResult;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      key: const ValueKey('sg_tab'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Form Card
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ตั้งค่าเป้าหมายการออมเงิน',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 16),
              
              CustomSlider(
                title: 'เป้าหมายเงินออม (Target Amount)',
                value: provider.sgTargetAmount,
                min: 50000,
                max: 20000000,
                unit: 'บาท',
                isCurrency: true,
                onChanged: (val) => provider.updateSG(targetAmount: (val / 10000).round() * 10000),
              ),
              const SizedBox(height: 12),
              
              CustomSlider(
                title: 'เงินออมเริ่มต้นที่มีแล้ว (Initial Savings)',
                value: provider.sgInitialPrincipal,
                min: 0,
                max: 5000000,
                unit: 'บาท',
                isCurrency: true,
                onChanged: (val) => provider.updateSG(initialPrincipal: (val / 5000).round() * 5000),
              ),
              const SizedBox(height: 12),
              
              CustomSlider(
                title: 'อัตราผลตอบแทนคาดหวังต่อปี (Annual Yield)',
                value: provider.sgExpectedReturn,
                min: 0.0,
                max: 20.0,
                unit: '%',
                decimalPlaces: 2,
                onChanged: (val) => provider.updateSG(expectedReturn: double.parse(val.toStringAsFixed(2))),
              ),
              const SizedBox(height: 12),
              
              CustomSlider(
                title: 'ระยะเวลาบรรลุเป้าหมาย (Years)',
                value: provider.sgYears.toDouble(),
                min: 1,
                max: 40,
                unit: 'ปี',
                onChanged: (val) => provider.updateSG(years: val.round()),
              ),
              const SizedBox(height: 16),
              
              // Timing options
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ฝากเงินช่วงไหนของเดือน?', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => provider.updateSG(timingBeginning: true),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: provider.sgTimingBeginning
                                    ? const Color(0xFF6366F1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'ต้นเดือน (Beginning of Month)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: provider.sgTimingBeginning
                                      ? Colors.white
                                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => provider.updateSG(timingBeginning: false),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: !provider.sgTimingBeginning
                                    ? const Color(0xFF6366F1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'สิ้นเดือน (End of Month)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: !provider.sgTimingBeginning
                                      ? Colors.white
                                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Result title
        Text(
          'เงินฝากรายเดือนที่ต้องทำ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),

        // Result card
        ResultCard(
          title: 'ยอดเงินออมต่อเดือนที่ต้องเก็บเพิ่ม',
          finalBalance: result.requiredMonthlyContribution,
          totalPrincipal: result.totalContributions + provider.sgInitialPrincipal,
          totalInterest: result.totalInterest,
          subtitleText: 'เป้าหมายออมรวม',
          subtitleValue: _formatCurrency(provider.sgTargetAmount),
        ),
        const SizedBox(height: 20),

        // Chart Card
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'การสะสมไปสู่เป้าหมาย',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      _buildIndicatorChip(const Color(0xFF10B981), 'ยอดเงินสะสม'),
                      const SizedBox(width: 8),
                      _buildIndicatorChip(const Color(0xFF818CF8), 'เงินต้นรวม'),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              GrowthChart(
                type: ChartType.standard,
                standardBreakdown: result.yearlyBreakdown,
                initialPrincipal: provider.sgInitialPrincipal,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Table
        BreakdownTable(standardBreakdown: result.yearlyBreakdown),
      ],
    );
  }

  // --- TAB 3: RETIREMENT ---
  Widget _buildRetirementTab(CalculatorProvider provider, BuildContext context) {
    final result = provider.retResult;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate total principal and interest for retirement at retirement age
    double totalPrincipal = provider.retCurrentSavings;
    int preRetYears = provider.retRetirementAge - provider.retCurrentAge;
    if (preRetYears > 0) {
      totalPrincipal += result.requiredMonthlySavings * preRetYears * 12;
    }
    double totalInterest = result.totalFundNeeded - totalPrincipal;
    if (totalInterest < 0) totalInterest = 0;

    return Column(
      key: const ValueKey('ret_tab'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Form Inputs Card
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ข้อมูลการวางแผนเพื่อวัยเกษียณ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 16),
              
              // Age settings
              Row(
                children: [
                  Expanded(
                    child: CustomSlider(
                      title: 'อายุปัจจุบัน',
                      value: provider.retCurrentAge.toDouble(),
                      min: 15,
                      max: 75,
                      unit: 'ปี',
                      onChanged: (val) => provider.updateRetirement(currentAge: val.round()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomSlider(
                      title: 'อายุเกษียณ',
                      value: provider.retRetirementAge.toDouble(),
                      min: 40,
                      max: 85,
                      unit: 'ปี',
                      onChanged: (val) => provider.updateRetirement(retirementAge: val.round()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              CustomSlider(
                title: 'อายุขัยคาดเดา (Life Expectancy)',
                value: provider.retLifeExpectancy.toDouble(),
                min: 60,
                max: 100,
                unit: 'ปี',
                onChanged: (val) => provider.updateRetirement(lifeExpectancy: val.round()),
              ),
              const SizedBox(height: 12),
              
              CustomSlider(
                title: 'ค่าใช้จ่ายวันนี้ (หลังเกษียณต่อเดือน)',
                value: provider.retMonthlyExpenseToday,
                min: 5000,
                max: 300000,
                unit: 'บาท/เดือน',
                isCurrency: true,
                onChanged: (val) => provider.updateRetirement(monthlyExpenseToday: (val / 1000).round() * 1000),
              ),
              const SizedBox(height: 12),
              
              CustomSlider(
                title: 'เงินเก็บที่มีอยู่ ณ ตอนนี้',
                value: provider.retCurrentSavings,
                min: 0,
                max: 10000000,
                unit: 'บาท',
                isCurrency: true,
                onChanged: (val) => provider.updateRetirement(currentSavings: (val / 5000).round() * 5000),
              ),
              const SizedBox(height: 12),
              
              CustomSlider(
                title: 'เงินเฟ้อคาดหวังเฉลี่ยต่อปี',
                value: provider.retInflationRate,
                min: 0.0,
                max: 8.0,
                unit: '%',
                decimalPlaces: 1,
                onChanged: (val) => provider.updateRetirement(inflationRate: double.parse(val.toStringAsFixed(1))),
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: CustomSlider(
                      title: 'ผลตอบแทนก่อนเกษียณ',
                      value: provider.retPreReturn,
                      min: 0.0,
                      max: 15.0,
                      unit: '%',
                      decimalPlaces: 1,
                      onChanged: (val) => provider.updateRetirement(preReturn: double.parse(val.toStringAsFixed(1))),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomSlider(
                      title: 'ผลตอบแทนหลังเกษียณ',
                      value: provider.retPostReturn,
                      min: 0.0,
                      max: 10.0,
                      unit: '%',
                      decimalPlaces: 1,
                      onChanged: (val) => provider.updateRetirement(postReturn: double.parse(val.toStringAsFixed(1))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Inflation adjusted info panel
        CustomCard(
          color: isDark ? const Color(0xFF1E1E38) : const Color(0xFFEEF2FF),
          border: Border.all(color: const Color(0xFF818CF8).withOpacity(0.3)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, color: Color(0xFF6366F1)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ผลกระทบของเงินเฟ้อต่อแผนการเงิน',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF312E81),
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.4,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF3730A3),
                        ),
                        children: [
                          const TextSpan(text: 'ค่าใช้จ่ายวันนี้ '),
                          TextSpan(
                            text: _formatCurrency(provider.retMonthlyExpenseToday),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' ในอีก '),
                          TextSpan(
                            text: '${provider.retRetirementAge - provider.retCurrentAge} ปี',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' ข้างหน้า จะกลายเป็น '),
                          TextSpan(
                            text: _formatCurrency(result.inflationAdjustedExpense),
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEC4899)),
                          ),
                          const TextSpan(text: ' ต่อเดือน เพื่อให้สอดคล้องกับค่าเงินที่ลดลง'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Result title
        Text(
          'เป้าหมายกองทุน & การออมต่อเดือน',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),

        // Result card
        ResultCard(
          title: 'เงินกองทุนเกษียณรวมที่ควรมี ณ วันเกษียณ',
          finalBalance: result.totalFundNeeded,
          totalPrincipal: totalPrincipal,
          totalInterest: totalInterest,
          subtitleText: 'เงินต้องเก็บต่อเดือนเริ่มวันนี้',
          subtitleValue: result.requiredMonthlySavings > 0
              ? '${_formatCurrency(result.requiredMonthlySavings)}/เดือน'
              : 'เงินเตรียมพร้อมแล้ว (ไม่ต้องเก็บเพิ่ม)',
        ),
        const SizedBox(height: 20),

        // Graph Card
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'แนวโน้มกองทุน (สะสม & ทยอยถอน)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  _buildIndicatorChip(const Color(0xFF6366F1), 'ยอดเงินคงเหลือในกองทุน'),
                ],
              ),
              const SizedBox(height: 20),
              GrowthChart(
                type: ChartType.retirement,
                retirementBreakdown: result.yearlyBreakdown,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Table
        BreakdownTable(
          retirementBreakdown: result.yearlyBreakdown,
          isRetirement: true,
        ),
      ],
    );
  }
}
