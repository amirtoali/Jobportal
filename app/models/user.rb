class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable
  
  belongs_to :company, optional: true
 User_role = ['employeer', 'job_seeker']
  has_many :user_saved_jobs
  has_many :jobs, through: :user_saved_jobs
  has_many :applied_jobs
  has_one :notification_setting

  validates :first_name, :last_name, presence: true
  validates :contact_number, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: User_role , message: "%{value} is not a valid status" }
  validate :company_required_if_employeer

  def employeer?
    role == 'employeer'
  end

  def job_seeker?
    role == 'job_seeker'
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  private

  def company_required_if_employeer
    if employeer? && company.nil?
      errors.add(:company, "must exist if user is an employer")
    end
  end
end
