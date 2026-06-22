import 'package:flutter/material.dart';
import '../models/compound_interest_model.dart';
import '../models/savings_goal_model.dart';
import '../models/retirement_model.dart';

class CalculatorProvider with ChangeNotifier {
  // Theme management
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Tabs management
  int _activeTab = 0;
  int get activeTab => _activeTab;

  void setActiveTab(int index) {
    _activeTab = index;
    notifyListeners();
  }

  // --- 1. Compound Interest Inputs & Results ---
  double _ciInitialPrincipal = 100000;
  double _ciMonthlyContribution = 5000;
  double _ciAnnualRate = 6.0;
  int _ciYears = 10;
  int _ciFrequency = 12;
  bool _ciTimingBeginning = true;

  double get ciInitialPrincipal => _ciInitialPrincipal;
  double get ciMonthlyContribution => _ciMonthlyContribution;
  double get ciAnnualRate => _ciAnnualRate;
  int get ciYears => _ciYears;
  int get ciFrequency => _ciFrequency;
  bool get ciTimingBeginning => _ciTimingBeginning;

  CompoundInterestResult get ciResult {
    return CompoundInterestResult.calculate(
      CompoundInterestInput(
        initialPrincipal: _ciInitialPrincipal,
        monthlyContribution: _ciMonthlyContribution,
        annualInterestRate: _ciAnnualRate,
        years: _ciYears,
        compoundingFrequency: _ciFrequency,
        contributionAtBeginning: _ciTimingBeginning,
      ),
    );
  }

  void updateCI({
    double? initialPrincipal,
    double? monthlyContribution,
    double? annualRate,
    int? years,
    int? frequency,
    bool? timingBeginning,
  }) {
    if (initialPrincipal != null) _ciInitialPrincipal = initialPrincipal;
    if (monthlyContribution != null) _ciMonthlyContribution = monthlyContribution;
    if (annualRate != null) _ciAnnualRate = annualRate;
    if (years != null) _ciYears = years;
    if (frequency != null) _ciFrequency = frequency;
    if (timingBeginning != null) _ciTimingBeginning = timingBeginning;
    notifyListeners();
  }

  // --- 2. Savings Goal Inputs & Results ---
  double _sgTargetAmount = 1000000;
  double _sgInitialPrincipal = 100000;
  double _sgExpectedReturn = 7.0;
  int _sgYears = 5;
  bool _sgTimingBeginning = true;

  double get sgTargetAmount => _sgTargetAmount;
  double get sgInitialPrincipal => _sgInitialPrincipal;
  double get sgExpectedReturn => _sgExpectedReturn;
  int get sgYears => _sgYears;
  bool get sgTimingBeginning => _sgTimingBeginning;

  SavingsGoalResult get sgResult {
    return SavingsGoalResult.calculate(
      SavingsGoalInput(
        targetAmount: _sgTargetAmount,
        initialPrincipal: _sgInitialPrincipal,
        expectedAnnualReturn: _sgExpectedReturn,
        years: _sgYears,
        contributionAtBeginning: _sgTimingBeginning,
      ),
    );
  }

  void updateSG({
    double? targetAmount,
    double? initialPrincipal,
    double? expectedReturn,
    int? years,
    bool? timingBeginning,
  }) {
    if (targetAmount != null) _sgTargetAmount = targetAmount;
    if (initialPrincipal != null) _sgInitialPrincipal = initialPrincipal;
    if (expectedReturn != null) _sgExpectedReturn = expectedReturn;
    if (years != null) _sgYears = years;
    if (timingBeginning != null) _sgTimingBeginning = timingBeginning;
    notifyListeners();
  }

  // --- 3. Retirement Planner Inputs & Results ---
  int _retCurrentAge = 30;
  int _retRetirementAge = 60;
  int _retLifeExpectancy = 85;
  double _retMonthlyExpenseToday = 30000;
  double _retInflationRate = 3.0;
  double _retPreReturn = 8.0;
  double _retPostReturn = 4.0;
  double _retCurrentSavings = 200000;

  int get retCurrentAge => _retCurrentAge;
  int get retRetirementAge => _retRetirementAge;
  int get retLifeExpectancy => _retLifeExpectancy;
  double get retMonthlyExpenseToday => _retMonthlyExpenseToday;
  double get retInflationRate => _retInflationRate;
  double get retPreReturn => _retPreReturn;
  double get retPostReturn => _retPostReturn;
  double get retCurrentSavings => _retCurrentSavings;

  RetirementResult get retResult {
    return RetirementResult.calculate(
      RetirementInput(
        currentAge: _retCurrentAge,
        retirementAge: _retRetirementAge,
        lifeExpectancy: _retLifeExpectancy,
        monthlyExpenseToday: _retMonthlyExpenseToday,
        inflationRate: _retInflationRate,
        preRetirementReturn: _retPreReturn,
        postRetirementReturn: _retPostReturn,
        currentSavings: _retCurrentSavings,
      ),
    );
  }

  void updateRetirement({
    int? currentAge,
    int? retirementAge,
    int? lifeExpectancy,
    double? monthlyExpenseToday,
    double? inflationRate,
    double? preReturn,
    double? postReturn,
    double? currentSavings,
  }) {
    // We enforce age order: currentAge < retirementAge < lifeExpectancy
    int nextCurrentAge = currentAge ?? _retCurrentAge;
    int nextRetirementAge = retirementAge ?? _retRetirementAge;
    int nextLifeExpectancy = lifeExpectancy ?? _retLifeExpectancy;

    if (currentAge != null) {
      if (nextCurrentAge >= nextRetirementAge) {
        nextRetirementAge = nextCurrentAge + 5;
      }
      if (nextRetirementAge >= nextLifeExpectancy) {
        nextLifeExpectancy = nextRetirementAge + 5;
      }
    } else if (retirementAge != null) {
      if (nextRetirementAge <= nextCurrentAge) {
        nextCurrentAge = nextRetirementAge - 5;
        if (nextCurrentAge < 0) nextCurrentAge = 0;
      }
      if (nextRetirementAge >= nextLifeExpectancy) {
        nextLifeExpectancy = nextRetirementAge + 5;
      }
    } else if (lifeExpectancy != null) {
      if (nextLifeExpectancy <= nextRetirementAge) {
        nextRetirementAge = nextLifeExpectancy - 5;
        if (nextRetirementAge <= nextCurrentAge) {
          nextCurrentAge = nextRetirementAge - 5;
          if (nextCurrentAge < 0) nextCurrentAge = 0;
        }
      }
    }

    _retCurrentAge = nextCurrentAge;
    _retRetirementAge = nextRetirementAge;
    _retLifeExpectancy = nextLifeExpectancy;

    if (monthlyExpenseToday != null) _retMonthlyExpenseToday = monthlyExpenseToday;
    if (inflationRate != null) _retInflationRate = inflationRate;
    if (preReturn != null) _retPreReturn = preReturn;
    if (postReturn != null) _retPostReturn = postReturn;
    if (currentSavings != null) _retCurrentSavings = currentSavings;
    notifyListeners();
  }
}
