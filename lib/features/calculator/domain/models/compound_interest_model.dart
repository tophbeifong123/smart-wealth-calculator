import 'dart:math';

class YearlyBreakdown {
  final int year;
  final double principal;
  final double interest;
  final double cumulativeContributions;
  final double cumulativeInterest;
  final double balance;

  YearlyBreakdown({
    required this.year,
    required this.principal,
    required this.interest,
    required this.cumulativeContributions,
    required this.cumulativeInterest,
    required this.balance,
  });
}

class CompoundInterestInput {
  final double initialPrincipal;
  final double monthlyContribution;
  final double annualInterestRate; // in %
  final int years;
  final int compoundingFrequency; // 1 = Annually, 2 = Semi-Annually, 4 = Quarterly, 12 = Monthly, 365 = Daily
  final bool contributionAtBeginning; // true = beginning, false = end

  CompoundInterestInput({
    required this.initialPrincipal,
    required this.monthlyContribution,
    required this.annualInterestRate,
    required this.years,
    this.compoundingFrequency = 12,
    this.contributionAtBeginning = false,
  });
}

class CompoundInterestResult {
  final double finalBalance;
  final double totalContributions;
  final double totalInterest;
  final List<YearlyBreakdown> yearlyBreakdown;

  CompoundInterestResult({
    required this.finalBalance,
    required this.totalContributions,
    required this.totalInterest,
    required this.yearlyBreakdown,
  });

  factory CompoundInterestResult.calculate(CompoundInterestInput input) {
    double balance = input.initialPrincipal;
    double r = input.annualInterestRate / 100.0;
    int totalMonths = input.years * 12;
    double cumulativeContributions = 0.0;
    double cumulativeInterest = 0.0;

    List<YearlyBreakdown> breakdown = [];

    double yearInterest = 0.0;

    for (int month = 1; month <= totalMonths; month++) {
      double contributionThisMonth = input.monthlyContribution;

      if (input.contributionAtBeginning) {
        balance += contributionThisMonth;
        cumulativeContributions += contributionThisMonth;
      }

      double monthlyRate = MathHelper.getMonthlyEffectiveRate(r, input.compoundingFrequency);

      double interestThisMonth = balance * monthlyRate;
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
          principal: input.initialPrincipal + cumulativeContributions,
          interest: yearInterest,
          cumulativeContributions: cumulativeContributions,
          cumulativeInterest: cumulativeInterest,
          balance: balance,
        ));
        yearInterest = 0.0;
      }
    }

    return CompoundInterestResult(
      finalBalance: balance,
      totalContributions: cumulativeContributions,
      totalInterest: cumulativeInterest,
      yearlyBreakdown: breakdown,
    );
  }
}

class MathHelper {
  static double getMonthlyEffectiveRate(double annualRate, int frequency) {
    if (annualRate == 0) return 0;
    if (frequency == 12) return annualRate / 12.0;
    // (1 + r / f) ^ (f / 12) - 1
    return pow(1.0 + annualRate / frequency, frequency / 12.0) - 1.0;
  }
}
