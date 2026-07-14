import '../../domain/models/compound_interest_model.dart';
import '../../domain/models/savings_goal_model.dart';
import '../../domain/models/retirement_model.dart';
import '../../domain/repositories/calculator_repository.dart';

class CalculatorRepositoryImpl implements CalculatorRepository {
  @override
  CompoundInterestResult calculateCompoundInterest(CompoundInterestInput input) {
    return CompoundInterestResult.calculate(input);
  }

  @override
  SavingsGoalResult calculateSavingsGoal(SavingsGoalInput input) {
    return SavingsGoalResult.calculate(input);
  }

  @override
  RetirementResult calculateRetirement(RetirementInput input) {
    return RetirementResult.calculate(input);
  }
}
