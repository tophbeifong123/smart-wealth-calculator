import 'package:equatable/equatable.dart';

abstract class CalculatorEvent extends Equatable {
  const CalculatorEvent();

  @override
  List<Object?> get props => [];
}

class ChangeTabEvent extends CalculatorEvent {
  final int activeTab;

  const ChangeTabEvent(this.activeTab);

  @override
  List<Object?> get props => [activeTab];
}

class UpdateCIEvent extends CalculatorEvent {
  final double? initialPrincipal;
  final double? monthlyContribution;
  final double? annualRate;
  final int? years;
  final int? frequency;
  final bool? timingBeginning;

  const UpdateCIEvent({
    this.initialPrincipal,
    this.monthlyContribution,
    this.annualRate,
    this.years,
    this.frequency,
    this.timingBeginning,
  });

  @override
  List<Object?> get props => [
        initialPrincipal,
        monthlyContribution,
        annualRate,
        years,
        frequency,
        timingBeginning,
      ];
}

class UpdateSGEvent extends CalculatorEvent {
  final double? targetAmount;
  final double? initialPrincipal;
  final double? expectedReturn;
  final int? years;
  final bool? timingBeginning;

  const UpdateSGEvent({
    this.targetAmount,
    this.initialPrincipal,
    this.expectedReturn,
    this.years,
    this.timingBeginning,
  });

  @override
  List<Object?> get props => [
        targetAmount,
        initialPrincipal,
        expectedReturn,
        years,
        timingBeginning,
      ];
}

class UpdateRetirementEvent extends CalculatorEvent {
  final int? currentAge;
  final int? retirementAge;
  final int? lifeExpectancy;
  final double? monthlyExpenseToday;
  final double? inflationRate;
  final double? preReturn;
  final double? postReturn;
  final double? currentSavings;

  const UpdateRetirementEvent({
    this.currentAge,
    this.retirementAge,
    this.lifeExpectancy,
    this.monthlyExpenseToday,
    this.inflationRate,
    this.preReturn,
    this.postReturn,
    this.currentSavings,
  });

  @override
  List<Object?> get props => [
        currentAge,
        retirementAge,
        lifeExpectancy,
        monthlyExpenseToday,
        inflationRate,
        preReturn,
        postReturn,
        currentSavings,
      ];
}
