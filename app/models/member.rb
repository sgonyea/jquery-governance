class Member < ActiveRecord::Base
  include Voting

  # Include default devise modules:
  devise :database_authenticatable, :recoverable, :rememberable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  has_many :active_memberships
  has_many :motions
  has_many :events
  has_many :member_conflicts
  has_many :conflicts,        :through    => :member_conflicts
  has_many :seconded_motions, :through    => :events,
                              :source     => :motion,
                              :conditions => { :events => {:event_type => 'second'} }

  default_scope {
    joins(:active_memberships).where(:active_memberships => {:ended_at => nil})
  }

  after_create :begin_membership

  # The destroying of members is expressly prohibited
  def destroy
    update_attribute(:is_active, false) if is_active?
    _run_destroy_callbacks
  end
  alias :delete :destroy

  # Checks membership status at a given Date/Time
  #   @param [Date, Time, DateTime] time The time for which membership status should be checked
  #   @return [true, false] Whether or not member was active as true or false, respectively
  def active_at?(time)
    active_memberships.active_at(time).first
  end

  # Returns the active membership status, of this member
  #   @return [true, false] Whether or not member is currently active as true or false, respectively
  def membership_active?
    active_at?(Time.now)
  end

  # Check if the member has permissions to perform the given action over the given motion or member
  #   @param [Symbol] action The action the member wants to perform
  #   @param [Member, Motion] motion or member The motion or member over which the member wants to perform the action
  #   @return [true, false] Whether or not the member has permissions to perform the action over the motion, respectively
  def can?(action, permissible_object)
    permissible_object.permit?(action, self)
  end

  # Check if the member is allowed to perform the given action
  #   @param [Symbol] action The action the member wants to perform
  #   @param [Member] member The member who wants to perfrom the action
  #   @return [true, false] Whether or not it permits the member to perform the action, respectively
  def permit?(action, member)
    case action
    when :destroy
      member.membership_active? && member.is_admin?
    end
  end

  # Check if Member has voted on a given motion
  #   @param [Motion] motion The motion in question
  #   @return [true, false] If Member has voted on a given motion
  def has_voted_on?(motion)
    votes.where(:motion_id => motion.id).present?
  end

  # Check if Member has seconded a given motion
  #   @param [Motion] motion The motion in question
  #   @return [true, false] If Member has seconded a given motion
  def has_seconded?(motion)
    seconds.where(:motion_id => motion.id).present?
  end

  # @eturn The display name for this member. Returns their name if present, email otherwise
  def display_name
    self.name || self.email
  end

private

  def begin_membership
    active_memberships.create(:active_at => Time.now)
  end
end
