import 'dart:math';

class RetirementYearlyBreakdown {
  final int age;
  final double balance;
  final double annualContribution; // negative for withdrawals during retirement
  final double annualInterestEarned;
  final bool isRetired;

  RetirementYearlyBreakdown({
    required this.age,
    required this.balance,
    required this.annualContribution,
    required this.annualInterestEarned,
    required this.isRetired,
  });
}

class RetirementInput {
  final int currentAge;
  final int retirementAge;
  final int lifeExpectancy;
  final double monthlyExpenseToday;
  final double inflationRate; // %
  final double preRetirementReturn; // %
  final double postRetirementReturn; // %
  final double currentSavings;

  RetirementInput({
    required this.currentAge,
    required this.retirementAge,
    required this.lifeExpectancy,
    required this.monthlyExpenseToday,
    required this.inflationRate,
    required this.preRetirementReturn,
    required this.postRetirementReturn,
    required this.currentSavings,
  });
}

class RetirementResult {
  final double inflationAdjustedExpense; // Monthly expense at retirement age
  final double totalFundNeeded; // Fund required at retirement age
  final double requiredMonthlySavings; // How much to save per month before retirement
  final List<RetirementYearlyBreakdown> yearlyBreakdown;

  RetirementResult({
    required this.inflationAdjustedExpense,
    required this.totalFundNeeded,
    required this.requiredMonthlySavings,
    required this.yearlyBreakdown,
  });

  factory RetirementResult.calculate(RetirementInput input) {
    int preRetirementYears = input.retirementAge - input.currentAge;
    int postRetirementYears = input.lifeExpectancy - input.retirementAge;

    if (preRetirementYears <= 0) {
      // Already retired or invalid
      return RetirementResult(
        inflationAdjustedExpense: input.monthlyExpenseToday,
        totalFundNeeded: 0,
        requiredMonthlySavings: 0,
        yearlyBreakdown: [],
      );
    }

    double inf = input.inflationRate / 100.0;
    double rPre = input.preRetirementReturn / 100.0;
    double rPost = input.postRetirementReturn / 100.0;

    // 1. Inflation adjusted monthly expense at retirement age
    double adjustedExpense = input.monthlyExpenseToday * pow(1.0 + inf, preRetirementYears);

    // 2. Fund needed at retirement age (drawdown phase)
    int nRet = postRetirementYears * 12;
    double iPost = rPost / 12.0;
    double iInf = inf / 12.0;
    double iNet = (1.0 + iPost) / (1.0 + iInf) - 1.0;

    double fundNeeded = 0.0;
    if (iNet == 0) {
      fundNeeded = adjustedExpense * nRet;
    } else {
      // Assuming beginning-of-month withdrawals
      fundNeeded = adjustedExpense * ((1.0 - pow(1.0 + iNet, -nRet)) / iNet) * (1.0 + iNet);
    }

    // 3. Required monthly savings in pre-retirement phase
    int nSave = preRetirementYears * 12;
    double iPre = rPre / 12.0;
    double requiredMonthlySavings = 0.0;

    double fvFromCurrentSavings = input.currentSavings * pow(1.0 + iPre, nSave);
    double remainingFundNeeded = fundNeeded - fvFromCurrentSavings;

    if (remainingFundNeeded > 0) {
      if (iPre == 0) {
        requiredMonthlySavings = remainingFundNeeded / nSave;
      } else {
        // Savings made at the end of each month
        double annuityFactor = (pow(1.0 + iPre, nSave) - 1.0) / iPre;
        requiredMonthlySavings = remainingFundNeeded / annuityFactor;
      }
    }

    // 4. Lifecycle Simulation (Accumulation & Drawdown)
    List<RetirementYearlyBreakdown> breakdown = [];
    double balance = input.currentSavings;

    // Accumulation Phase
    double accumContributionYear = 0.0;
    double accumInterestYear = 0.0;
    for (int month = 1; month <= nSave; month++) {
      balance += requiredMonthlySavings;
      accumContributionYear += requiredMonthlySavings;

      double interest = balance * iPre;
      balance += interest;
      accumInterestYear += interest;

      if (month % 12 == 0) {
        int age = input.currentAge + (month ~/ 12);
        breakdown.add(RetirementYearlyBreakdown(
          age: age,
          balance: balance,
          annualContribution: accumContributionYear,
          annualInterestEarned: accumInterestYear,
          isRetired: false,
        ));
        accumContributionYear = 0.0;
        accumInterestYear = 0.0;
      }
    }

    // Drawdown Phase
    double drawdownExpense = adjustedExpense;
    double drawdownContributionYear = 0.0;
    double drawdownInterestYear = 0.0;

    for (int month = 1; month <= nRet; month++) {
      // Adjust drawdown expense for inflation at the start of each post-retirement year
      if (month > 1 && (month - 1) % 12 == 0) {
        drawdownExpense *= (1.0 + inf);
      }

      // Withdraw at the beginning of month
      balance -= drawdownExpense;
      drawdownContributionYear -= drawdownExpense;

      // Apply interest
      double interest = 0.0;
      if (balance > 0) {
        interest = balance * iPost;
        balance += interest;
      } else {
        balance = 0.0; // Ran out of money!
      }
      drawdownInterestYear += interest;

      if (month % 12 == 0) {
        int age = input.retirementAge + (month ~/ 12);
        breakdown.add(RetirementYearlyBreakdown(
          age: age,
          balance: balance,
          annualContribution: drawdownContributionYear,
          annualInterestEarned: drawdownInterestYear,
          isRetired: true,
        ));
        drawdownContributionYear = 0.0;
        drawdownInterestYear = 0.0;
      }
    }

    return RetirementResult(
      inflationAdjustedExpense: adjustedExpense,
      totalFundNeeded: fundNeeded,
      requiredMonthlySavings: requiredMonthlySavings,
      yearlyBreakdown: breakdown,
    );
  }
}
