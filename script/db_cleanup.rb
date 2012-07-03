# Clean up old oncall assignments
OncallAssignment.where('ends_at < ?', AppConfig.events_retention.months.ago).destroy_all

# Clean up old vacations
Vacation.where('ends_at < ?', AppConfig.events_retention.months.ago).destroy_all
