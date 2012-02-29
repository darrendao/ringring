class OncallAssignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :call_list
  default_scope :order => 'position'
  validates :retry, :numericality => {:only_integer => true, :greater_than => 0}, :presence => true

  after_initialize :default_values

  private
  def default_values
    self.retry ||= AppConfig.default_retry || 2
  end
end
