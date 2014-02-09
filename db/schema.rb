# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140209140731) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "activities", :force => true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "activities", ["owner_id", "owner_type"], :name => "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], :name => "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], :name => "index_activities_on_trackable_id_and_trackable_type"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "oauth_token"
    t.string   "oauth_token_secret"
  end

  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "beautyclasses", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "view_count"
    t.integer  "capacity"
    t.boolean  "closed"
    t.boolean  "published"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "user_id"
    t.string   "slug"
    t.string   "review_url"
    t.string   "supply"
    t.integer  "price"
    t.integer  "location_id"
    t.integer  "picture_id"
    t.string   "entry_code"
    t.string   "image"
  end

  add_index "beautyclasses", ["location_id"], :name => "index_beautyclasses_on_location_id"
  add_index "beautyclasses", ["picture_id"], :name => "index_beautyclasses_on_picture_id"
  add_index "beautyclasses", ["slug"], :name => "index_beautyclasses_on_slug"
  add_index "beautyclasses", ["user_id"], :name => "index_beautyclasses_on_user_id"

  create_table "beautystars", :force => true do |t|
    t.text     "introduction"
    t.string   "fullname"
    t.string   "view_count"
    t.string   "job_title"
    t.string   "vimeo_url"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "slug"
    t.string   "image"
  end

  add_index "beautystars", ["slug"], :name => "index_beautystars_on_slug"

  create_table "boards", :force => true do |t|
    t.string   "title"
    t.integer  "picture_id"
    t.integer  "user_id"
    t.integer  "view_count"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.boolean  "published"
    t.text     "description"
    t.string   "slug"
  end

  add_index "boards", ["picture_id"], :name => "index_boards_on_picture_id"
  add_index "boards", ["user_id"], :name => "index_boards_on_user_id"

  create_table "bookmark_types", :force => true do |t|
    t.string   "model"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bookmarks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "bookmarkable_id"
    t.string   "bookmarkable_type"
    t.text     "note"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "model_id"
    t.integer  "model_type_id"
  end

  add_index "bookmarks", ["model_id", "model_type_id"], :name => "index_bookmarks_on_model_id_and_model_type_id"

  create_table "brands", :force => true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.text     "description"
    t.string   "image"
    t.integer  "view_count"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "slug"
    t.integer  "picture_id"
  end

  add_index "brands", ["company_id"], :name => "index_brands_on_company_id"
  add_index "brands", ["picture_id"], :name => "index_brands_on_picture_id"
  add_index "brands", ["slug"], :name => "index_brands_on_slug"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "view_count"
    t.string   "slug"
  end

  add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"
  add_index "categories", ["slug"], :name => "index_categories_on_slug"

  create_table "categorizations", :force => true do |t|
    t.integer  "category_id"
    t.integer  "categorizeable_id"
    t.string   "categorizeable_type"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "categorizations", ["categorizeable_id", "categorizeable_type"], :name => "index_categorizations_on_categorizable_id_and_categorizable_type"

  create_table "checkout_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "checkouts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "beautyclass_id"
    t.integer  "checkout_status_id"
    t.text     "description"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "buyer_name"
    t.string   "buyer_tel"
    t.string   "request_note"
    t.datetime "private_start_date"
    t.datetime "private_end_date"
    t.integer  "private_seat"
  end

  add_index "checkouts", ["beautyclass_id"], :name => "index_checkouts_on_beautyclass_id"

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",   :default => 0
    t.string   "commentable_type", :default => ""
    t.string   "title",            :default => ""
    t.text     "body"
    t.string   "subject",          :default => ""
    t.integer  "user_id",          :default => 0,  :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "view_count"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "event_entries", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "event_entries", ["event_id"], :name => "index_event_entries_on_event_id"
  add_index "event_entries", ["user_id"], :name => "index_event_entries_on_user_id"

  create_table "events", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.integer  "picture_id"
    t.integer  "view_count"
    t.datetime "start_from"
    t.datetime "finish_on"
    t.datetime "win_released_at"
    t.datetime "released_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "description"
    t.string   "slug"
    t.string   "target_url"
  end

  add_index "events", ["picture_id"], :name => "index_events_on_picture_id"
  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "galleries", :force => true do |t|
    t.string   "image"
    t.integer  "galleriable_id"
    t.string   "galleriable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "galleries", ["galleriable_id", "galleriable_type"], :name => "index_galleries_on_galleriable_id_and_galleriable_type"

  create_table "genders", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "itemizations", :force => true do |t|
    t.integer  "item_id"
    t.integer  "itemizable_id"
    t.string   "itemizable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "itemizations", ["itemizable_id", "itemizable_type"], :name => "index_itemizations_on_itemizable_id_and_itemizable_type"

  create_table "items", :force => true do |t|
    t.integer  "brand_id"
    t.string   "name"
    t.text     "description"
    t.integer  "view_count"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "slug"
    t.integer  "picture_id"
    t.string   "image"
  end

  add_index "items", ["brand_id"], :name => "index_items_on_brand_id"
  add_index "items", ["picture_id"], :name => "index_items_on_picture_id"
  add_index "items", ["slug"], :name => "index_items_on_slug"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.integer  "view_count"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "address"
    t.string   "slug"
    t.integer  "shop_id"
  end

  add_index "locations", ["shop_id"], :name => "index_locations_on_shop_id"
  add_index "locations", ["slug"], :name => "index_locations_on_slug"

  create_table "member_profiles", :force => true do |t|
    t.integer  "year_of_birth"
    t.integer  "gender_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "member_profiles", ["gender_id"], :name => "index_member_profiles_on_gender_id"

  create_table "members", :force => true do |t|
    t.integer  "gender_id"
    t.integer  "year_of_birth"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "slug"
  end

  add_index "members", ["gender_id"], :name => "index_members_on_gender_id"
  add_index "members", ["slug"], :name => "index_members_on_slug"

  create_table "pictures", :force => true do |t|
    t.string   "image"
    t.integer  "pictureable_id"
    t.string   "pictureable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "description"
  end

  add_index "pictures", ["pictureable_id", "pictureable_type"], :name => "index_pictures_on_pictureable_id_and_pictureable_type"

  create_table "products", :force => true do |t|
    t.integer  "brand_id"
    t.string   "name"
    t.text     "description"
    t.integer  "view_count"
    t.string   "image"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "products", ["brand_id"], :name => "index_products_on_brand_id"

  create_table "read_marks", :force => true do |t|
    t.integer  "readable_id"
    t.integer  "user_id",                     :null => false
    t.string   "readable_type", :limit => 20, :null => false
    t.datetime "timestamp"
  end

  add_index "read_marks", ["user_id", "readable_type", "readable_id"], :name => "index_read_marks_on_user_id_and_readable_type_and_readable_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "shops", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "location_id"
    t.string   "slug"
  end

  add_index "shops", ["location_id"], :name => "index_shops_on_location_id"
  add_index "shops", ["slug"], :name => "index_shops_on_slug"

  create_table "skin_trouble_maps", :force => true do |t|
    t.integer  "skin_trouble_id"
    t.integer  "member_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "skin_trouble_maps", ["member_id"], :name => "index_skin_trouble_maps_on_member_id"
  add_index "skin_trouble_maps", ["skin_trouble_id"], :name => "index_skin_trouble_maps_on_skin_trouble_id"

  create_table "skin_troubles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "skin_type_maps", :force => true do |t|
    t.integer  "skin_type_id"
    t.integer  "member_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "skin_type_maps", ["member_id"], :name => "index_skin_type_maps_on_member_id"
  add_index "skin_type_maps", ["skin_type_id"], :name => "index_skin_type_maps_on_skin_type_id"

  create_table "skin_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tutorials", :force => true do |t|
    t.string   "title"
    t.string   "vimeo_url"
    t.integer  "user_id"
    t.integer  "view_count"
    t.boolean  "published"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
    t.string   "slug"
    t.integer  "duration"
    t.integer  "picture_id"
    t.string   "image"
  end

  add_index "tutorials", ["picture_id"], :name => "index_tutorials_on_picture_id"
  add_index "tutorials", ["slug"], :name => "index_tutorials_on_slug"
  add_index "tutorials", ["user_id"], :name => "index_tutorials_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "username"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "image"
    t.integer  "profile_id"
    t.string   "profile_type"
    t.string   "remote_image_url"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["profile_id"], :name => "index_users_on_profile_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

  create_table "video_groups", :force => true do |t|
    t.string   "name"
    t.string   "home_url"
    t.string   "thumb_url"
    t.string   "image"
    t.string   "youtube_id"
    t.integer  "view_count"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "slug"
    t.string   "header_bg_url"
    t.text     "description"
    t.integer  "videos_watched"
    t.datetime "join_date"
    t.integer  "subscribers"
  end

  add_index "video_groups", ["slug"], :name => "index_video_groups_on_slug"

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "view_count"
    t.integer  "video_group_id"
    t.string   "thumb_url"
    t.string   "image"
    t.string   "video_url"
    t.datetime "published_at"
    t.boolean  "published"
    t.integer  "duration"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "yt_vi_id"
    t.integer  "favorite_count"
    t.string   "slug"
  end

  add_index "videos", ["video_group_id"], :name => "index_videos_on_video_group_id"

end
