PublicActivity::Activity.module_eval do

  acts_as_readable :on => :updated_at

end