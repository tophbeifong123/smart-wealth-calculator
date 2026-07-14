import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/compound_interest_model.dart';
import '../../domain/models/savings_goal_model.dart';
import '../../domain/models/retirement_model.dart';
import '../../domain/repositories/calculator_repository.dart';
import 'calculator_event.dart';
import 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  final CalculatorRepository _calculatorRepository;

  CalculatorBloc({required CalculatorRepository calculatorRepository})
      : _calculatorRepository = calculatorRepository,
        super(CalculatorState.initial(
          initialCiResult: calculatorRepository.calculateCompoundInterest(
            CompoundInterestInput(
              initialPrincipal: 100000,
              monthlyContribution: 5000,
              annualInterestRate: 6.0,
              years: 10,
              compoundingFrequency: 12,
              contributionAtBeginning: true,
            ),
          ),
          initialSgResult: calculatorRepository.calculateSavingsGoal(
            SavingsGoalInput(
              targetAmount: 1000000,
              initialPrincipal: 100000,
              expectedAnnualReturn: 7.0,
              years: 5,
              contributionAtBeginning: true,
            ),
          ),
          initialRetResult: calculatorRepository.calculateRetirement(
            RetirementInput(
              currentAge: 30,
              retirementAge: 60,
              lifeExpectancy: 85,
              monthlyExpenseToday: 30000,
              inflationRate: 3.0,
              preRetirementReturn: 8.0,
              postRetirementReturn: 4.0,
              currentSavings: 200000,
            ),
          ),
        )) {
    on<ChangeTabEvent>(_onChangeTab);
    on<UpdateCIEvent>(_onUpdateCI);
    on<UpdateSGEvent>(_onUpdateSG);
    on<UpdateRetirementEvent>(_onUpdateRetirement);
  }

  void _onChangeTab(ChangeTabEvent event, Emitter<CalculatorState> emit) {
    emit(state.copyWith(activeTab: event.activeTab));
  }

  void _onUpdateCI(UpdateCIEvent event, Emitter<CalculatorState> emit) {
    final nextInitialPrincipal = event.initialPrincipal ?? state.ciInitialPrincipal;
    final nextMonthlyContribution = event.monthlyContribution ?? state.ciMonthlyContribution;
    final nextAnnualRate = event.annualRate ?? state.ciAnnualRate;
    final nextYears = event.years ?? state.ciYears;
    final nextFrequency = event.frequency ?? state.ciFrequency;
    final nextTimingBeginning = event.timingBeginning ?? state.ciTimingBeginning;

    final nextResult = _calculatorRepository.calculateCompoundInterest(
      CompoundInterestInput(
        initialPrincipal: nextInitialPrincipal,
        monthlyContribution: nextMonthlyContribution,
        annualInterestRate: nextAnnualRate,
        years: nextYears,
        compoundingFrequency: nextFrequency,
        contributionAtBeginning: nextTimingBeginning,
      ),
    );

    emit(state.copyWith(
      ciInitialPrincipal: nextInitialPrincipal,
      ciMonthlyContribution: nextMonthlyContribution,
      ciAnnualRate: nextAnnualRate,
      ciYears: nextYears,
      ciFrequency: nextFrequency,
      ciTimingBeginning: nextTimingBeginning,
      ciResult: nextResult,
    ));
  }

  void _onUpdateSG(UpdateSGEvent event, Emitter<CalculatorState> emit) {
    final nextTargetAmount = event.targetAmount ?? state.sgTargetAmount;
    final nextInitialPrincipal = event.initialPrincipal ?? state.sgInitialPrincipal;
    final nextExpectedReturn = event.expectedReturn ?? state.sgExpectedReturn;
    final nextYears = event.years ?? state.sgYears;
    final nextTimingBeginning = event.timingBeginning ?? state.sgTimingBeginning;

    final nextResult = _calculatorRepository.calculateSavingsGoal(
      SavingsGoalInput(
        targetAmount: nextTargetAmount,
        initialPrincipal: nextInitialPrincipal,
        expectedAnnualReturn: nextExpectedReturn,
        years: nextYears,
        contributionAtBeginning: nextTimingBeginning,
      ),
    );

    emit(state.copyWith(
      sgTargetAmount: nextTargetAmount,
      sgInitialPrincipal: nextInitialPrincipal,
      sgExpectedReturn: nextExpectedReturn,
      sgYears: nextYears,
      sgTimingBeginning: nextTimingBeginning,
      sgResult: nextResult,
    ));
  }

  void _onUpdateRetirement(UpdateRetirementEvent event, Emitter<CalculatorState> emit) {
    // Enforce age order: currentAge < retirementAge < lifeExpectancy
    int nextCurrentAge = event.currentAge ?? state.retCurrentAge;
    int nextRetirementAge = event.retirementAge ?? state.retRetirementAge;
    int nextLifeExpectancy = event.lifeExpectancy ?? state.retLifeExpectancy;

    if (event.currentAge != null) {
      if (nextCurrentAge >= nextRetirementAge) {
        nextRetirementAge = nextCurrentAge + 5;
      }
      if (nextRetirementAge >= nextLifeExpectancy) {
        nextLifeExpectancy = nextRetirementAge + 5;
      }
    } else if (event.retirementAge != null) {
      if (nextRetirementAge <= nextCurrentAge) {
        nextCurrentAge = nextRetirementAge - 5;
        if (nextCurrentAge < 0) nextCurrentAge = 0;
      }
      if (nextRetirementAge >= nextLifeExpectancy) {
        nextLifeExpectancy = nextRetirementAge + 5;
      }
    } else if (event.lifeExpectancy != null) {
      if (nextLifeExpectancy <= nextRetirementAge) {
        nextRetirementAge = nextLifeExpectancy - 5;
        if (nextRetirementAge <= nextCurrentAge) {
          nextCurrentAge = nextRetirementAge - 5;
          if (nextCurrentAge < 0) nextCurrentAge = 0;
        }
      }
    }

    final nextMonthlyExpenseToday = event.monthlyExpenseToday ?? state.retMonthlyExpenseToday;
    final nextInflationRate = event.inflationRate ?? state.retInflationRate;
    final nextPreReturn = event.preReturn ?? state.retPreReturn;
    final nextPostReturn = event.postReturn ?? state.retPostReturn;
    final nextCurrentSavings = event.currentSavings ?? state.retCurrentSavings;

    final nextResult = _calculatorRepository.calculateRetirement(
      RetirementInput(
        currentAge: nextCurrentAge,
        retirementAge: nextRetirementAge,
        lifeExpectancy: nextLifeExpectancy,
        monthlyExpenseToday: nextMonthlyExpenseToday,
        inflationRate: nextInflationRate,
        preRetirementReturn: nextPreReturn,
        postRetirementReturn: nextPostReturn,
        currentSavings: nextCurrentSavings,
      ),
    );

    emit(state.copyWith(
      retCurrentAge: nextCurrentAge,
      retRetirementAge: nextRetirementAge,
      retLifeExpectancy: nextLifeExpectancy,
      retMonthlyExpenseToday: nextMonthlyExpenseToday,
      retInflationRate: nextInflationRate,
      retPreReturn: nextPreReturn,
      retPostReturn: nextPostReturn,
      retCurrentSavings: nextCurrentSavings,
      retResult: nextResult,
    ));
  }
}
