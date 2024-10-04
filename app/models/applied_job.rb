class AppliedJob < ApplicationRecord
  JOINING_DURATION = ['Immediate', '1 Week', '15 Days', '1 Month', '2 Month']

  belongs_to :job
  belongs_to :job_seeker, class_name: 'User', foreign_key: 'user_id'

  validates :cover_letter, :expected_ctc, :current_ctc, :contact_number, presence: true

  # callbacks

  after_create :notify_employeers_and_job_seekers

  private

  def notify_employeers_and_job_seekers
    AppliedJobNotificationJob.perform_later(job_seeker, job)
  end
end
