import 'dart:math';
import 'compound_interest_model.dart'; // To reuse YearlyBreakdown

class SavingsGoalInput {
  final double targetAmount;
  final double initialPrincipal;
  final double expectedAnnualReturn; // in %
  final int years;
  final bool contributionAtBeginning;

  SavingsGoalInput({
    required this.targetAmount,
    required this.initialPrincipal,
    required this.expectedAnnualReturn,
    required this.years,
    this.contributionAtBeginning = false,
  });
}

class SavingsGoalResult {
  final double requiredMonthlyContribution;
  final double totalContributions;
  final double totalInterest;
  final List<YearlyBreakdown> yearlyBreakdown;

  SavingsGoalResult({
    required this.requiredMonthlyContribution,
    required this.totalContributions,
    required this.totalInterest,
    required this.yearlyBreakdown,
  });

  factory SavingsGoalResult.calculate(SavingsGoalInput input) {
    double fv = input.targetAmount;
    double pv = input.initialPrincipal;
    double r = input.expectedAnnualReturn / 100.0;
    int n = input.years * 12;
    double i = r / 12.0;

    double requiredMonthly = 0.0;

    if (i == 0) {
      requiredMonthly = (fv - pv) / n;
      if (requiredMonthly < 0) requiredMonthly = 0;
    } else {
      double fvFromPv = pv * pow(1.0 + i, n);
      double remainingFv = fv - fvFromPv;

      if (remainingFv <= 0) {
        requiredMonthly = 0;
      } else {
        double annuityFactor = (pow(1.0 + i, n) - 1.0) / i;
        if (input.contributionAtBeginning) {
          annuityFactor *= (1.0 + i);
        }
        requiredMonthly = remainingFv / annuityFactor;
      }
    }

    // Now calculate the breakdown using the calculated requiredMonthly
    double balance = pv;
    double cumulativeContributions = 0.0;
    double cumulativeInterest = 0.0;
    List<YearlyBreakdown> breakdown = [];

    double yearInterest = 0.0;

    for (int month = 1; month <= n; month++) {
      double contributionThisMonth = requiredMonthly;

      if (input.contributionAtBeginning) {
        balance += contributionThisMonth;
        cumulativeContributions += contributionThisMonth;
      }

      double interestThisMonth = balance * i;
      balance += interestThisMonth;
      cumulativeInterest += interestThisMonth;
      yearInterest += interestThisMonth;

      if (!input.contributionAtBeginning) {
        balance += contributionThisMonth;
        cumulativeContributions += contributionThisMonth;
      }

      if (month % 12 == 0) {
        int currentYear = month ~/ 12;
        breakdown.add(YearlyBreakdown(
          year: currentYear,
          principal: pv + cumulativeContributions,
          interest: yearInterest,
          cumulativeContributions: cumulativeContributions,
          cumulativeInterest: cumulativeInterest,
          balance: balance,
        ));
        yearInterest = 0.0;
      }
    }

    return SavingsGoalResult(
      requiredMonthlyContribution: requiredMonthly,
      totalContributions: cumulativeContributions,
      totalInterest: cumulativeInterest,
      yearlyBreakdown: breakdown,
    );
  }
}
