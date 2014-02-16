class Activity < PublicActivity::Activity
  acts_as_readable :on => :updated_at
end
