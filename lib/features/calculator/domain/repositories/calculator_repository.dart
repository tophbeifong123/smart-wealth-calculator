import '../models/compound_interest_model.dart';
import '../models/savings_goal_model.dart';
import '../models/retirement_model.dart';

abstract class CalculatorRepository {
  CompoundInterestResult calculateCompoundInterest(CompoundInterestInput input);
  SavingsGoalResult calculateSavingsGoal(SavingsGoalInput input);
  RetirementResult calculateRetirement(RetirementInput input);
}
