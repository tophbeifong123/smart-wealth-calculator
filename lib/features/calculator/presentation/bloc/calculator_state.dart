import 'package:equatable/equatable.dart';
import '../../domain/models/compound_interest_model.dart';
import '../../domain/models/savings_goal_model.dart';
import '../../domain/models/retirement_model.dart';

class CalculatorState extends Equatable {
  final int activeTab;

  // Compound Interest Inputs
  final double ciInitialPrincipal;
  final double ciMonthlyContribution;
  final double ciAnnualRate;
  final int ciYears;
  final int ciFrequency;
  final bool ciTimingBeginning;

  // Savings Goal Inputs
  final double sgTargetAmount;
  final double sgInitialPrincipal;
  final double sgExpectedReturn;
  final int sgYears;
  final bool sgTimingBeginning;

  // Retirement Inputs
  final int retCurrentAge;
  final int retRetirementAge;
  final int retLifeExpectancy;
  final double retMonthlyExpenseToday;
  final double retInflationRate;
  final double retPreReturn;
  final double retPostReturn;
  final double retCurrentSavings;

  // Computed Results
  final CompoundInterestResult ciResult;
  final SavingsGoalResult sgResult;
  final RetirementResult retResult;

  const CalculatorState({
    required this.activeTab,
    required this.ciInitialPrincipal,
    required this.ciMonthlyContribution,
    required this.ciAnnualRate,
    required this.ciYears,
    required this.ciFrequency,
    required this.ciTimingBeginning,
    required this.sgTargetAmount,
    required this.sgInitialPrincipal,
    required this.sgExpectedReturn,
    required this.sgYears,
    required this.sgTimingBeginning,
    required this.retCurrentAge,
    required this.retRetirementAge,
    required this.retLifeExpectancy,
    required this.retMonthlyExpenseToday,
    required this.retInflationRate,
    required this.retPreReturn,
    required this.retPostReturn,
    required this.retCurrentSavings,
    required this.ciResult,
    required this.sgResult,
    required this.retResult,
  });

  factory CalculatorState.initial({
    required CompoundInterestResult initialCiResult,
    required SavingsGoalResult initialSgResult,
    required RetirementResult initialRetResult,
  }) {
    return CalculatorState(
      activeTab: 0,
      ciInitialPrincipal: 100000,
      ciMonthlyContribution: 5000,
      ciAnnualRate: 6.0,
      ciYears: 10,
      ciFrequency: 12,
      ciTimingBeginning: true,
      sgTargetAmount: 1000000,
      sgInitialPrincipal: 100000,
      sgExpectedReturn: 7.0,
      sgYears: 5,
      sgTimingBeginning: true,
      retCurrentAge: 30,
      retRetirementAge: 60,
      retLifeExpectancy: 85,
      retMonthlyExpenseToday: 30000,
      retInflationRate: 3.0,
      retPreReturn: 8.0,
      retPostReturn: 4.0,
      retCurrentSavings: 200000,
      ciResult: initialCiResult,
      sgResult: initialSgResult,
      retResult: initialRetResult,
    );
  }

  CalculatorState copyWith({
    int? activeTab,
    double? ciInitialPrincipal,
    double? ciMonthlyContribution,
    double? ciAnnualRate,
    int? ciYears,
    int? ciFrequency,
    bool? ciTimingBeginning,
    double? sgTargetAmount,
    double? sgInitialPrincipal,
    double? sgExpectedReturn,
    int? sgYears,
    bool? sgTimingBeginning,
    int? retCurrentAge,
    int? retRetirementAge,
    int? retLifeExpectancy,
    double? retMonthlyExpenseToday,
    double? retInflationRate,
    double? retPreReturn,
    double? retPostReturn,
    double? retCurrentSavings,
    CompoundInterestResult? ciResult,
    SavingsGoalResult? sgResult,
    RetirementResult? retResult,
  }) {
    return CalculatorState(
      activeTab: activeTab ?? this.activeTab,
      ciInitialPrincipal: ciInitialPrincipal ?? this.ciInitialPrincipal,
      ciMonthlyContribution: ciMonthlyContribution ?? this.ciMonthlyContribution,
      ciAnnualRate: ciAnnualRate ?? this.ciAnnualRate,
      ciYears: ciYears ?? this.ciYears,
      ciFrequency: ciFrequency ?? this.ciFrequency,
      ciTimingBeginning: ciTimingBeginning ?? this.ciTimingBeginning,
      sgTargetAmount: sgTargetAmount ?? this.sgTargetAmount,
      sgInitialPrincipal: sgInitialPrincipal ?? this.sgInitialPrincipal,
      sgExpectedReturn: sgExpectedReturn ?? this.sgExpectedReturn,
      sgYears: sgYears ?? this.sgYears,
      sgTimingBeginning: sgTimingBeginning ?? this.sgTimingBeginning,
      retCurrentAge: retCurrentAge ?? this.retCurrentAge,
      retRetirementAge: retRetirementAge ?? this.retRetirementAge,
      retLifeExpectancy: retLifeExpectancy ?? this.retLifeExpectancy,
      retMonthlyExpenseToday: retMonthlyExpenseToday ?? this.retMonthlyExpenseToday,
      retInflationRate: retInflationRate ?? this.retInflationRate,
      retPreReturn: retPreReturn ?? this.retPreReturn,
      retPostReturn: retPostReturn ?? this.retPostReturn,
      retCurrentSavings: retCurrentSavings ?? this.retCurrentSavings,
      ciResult: ciResult ?? this.ciResult,
      sgResult: sgResult ?? this.sgResult,
      retResult: retResult ?? this.retResult,
    );
  }

  @override
  List<Object?> get props => [
        activeTab,
        ciInitialPrincipal,
        ciMonthlyContribution,
        ciAnnualRate,
        ciYears,
        ciFrequency,
        ciTimingBeginning,
        sgTargetAmount,
        sgInitialPrincipal,
        sgExpectedReturn,
        sgYears,
        sgTimingBeginning,
        retCurrentAge,
        retRetirementAge,
        retLifeExpectancy,
        retMonthlyExpenseToday,
        retInflationRate,
        retPreReturn,
        retPostReturn,
        retCurrentSavings,
        ciResult,
        sgResult,
        retResult,
      ];
}
