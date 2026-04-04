# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "🌱 Seeding Interest Rates..."

interest_rates = [

  # -------------------------------
  # Flat rate loans
  # -------------------------------
  {
    loan_type: "ML",
    loan_type_name: "Mortgage Loan",
    rate: 15.5
  },
  {
    loan_type: "SE",
    loan_type_name: "Self Employment Loan",
    rate: 15.5
  },
  {
    loan_type: "LICNSC",
    loan_type_name: "LIC / NSC Loan",
    rate: 15.5
  },
  {
    loan_type: "VL",
    loan_type_name: "Vehicle Loan",
    rate: 8.0
  },
  {
    loan_type: "SL",
    loan_type_name: "Staff Loan",
    rate: 16.5
  },
  {
    loan_type: "EL",
    loan_type_name: "Education Loan",
    rate: 14.0
  },
  {
    loan_type: "BL",
    loan_type_name: "Business Loan",
    rate: 16.0
  },
  {
    loan_type: "OTHER",
    loan_type_name: "Other Loan",
    rate: 13.0
  },
  {
    loan_type: "STL",
    loan_type_name: "Short Term Loan",
    rate: 12.0
  },
  {
    loan_type: "DRPL",
    loan_type_name: "Demand Recovery Personal Loan",
    rate: 18.5
  },

  # -------------------------------
  # Housing Loan (Slab Based)
  # -------------------------------
  {
    loan_type: "HOUSING LOAN",
    loan_type_name: "Housing Loan",
    min_amount: 0,
    max_amount: 1_000_000,
    rate: 10.5
  },
  {
    loan_type: "HOUSING LOAN",
    loan_type_name: "Housing Loan",
    min_amount: 1_000_001,
    max_amount: 2_500_000,
    rate: 12.0
  },
  {
    loan_type: "HOUSING LOAN",
    loan_type_name: "Housing Loan",
    min_amount: 2_500_001,
    max_amount: nil,
    rate: 12.5
  }
]

interest_rates.each do |attrs|
  InterestRate.find_or_create_by!(
    loan_type: attrs[:loan_type],
    min_amount: attrs[:min_amount],
    max_amount: attrs[:max_amount]
  ) do |rate|
    rate.loan_type_name = attrs[:loan_type_name]
    rate.rate           = attrs[:rate]
    rate.active         = true
  end
end

puts "✅ Interest Rates Seeded Successfully"

puts "🌱 Seeding Loan Types..."
LoanType.seed_defaults
puts "✅ Loan Types Seeded Successfully (#{LoanType.count} records)"

puts "🌱 Seeding Loan Purposes..."
LoanPurpose.seed_defaults
puts "✅ Loan Purposes Seeded Successfully (#{LoanPurpose.count} records)"
