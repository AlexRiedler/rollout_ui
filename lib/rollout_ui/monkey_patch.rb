class Rollout
  alias_method :original_active?, :active?

  def active?(feature, user=nil)
    RolloutUi::Wrapper.add_feature(self, feature)
    original_active?(feature, user)
  end
end
