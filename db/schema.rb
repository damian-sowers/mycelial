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

ActiveRecord::Schema.define(:version => 20121231222129) do

  create_table "beta_invites", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "email"
  end

  create_table "comments", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "project_id"
    t.integer  "user_id"
    t.text     "comment"
    t.string   "ancestry"
    t.string   "username"
  end

  add_index "comments", ["ancestry"], :name => "index_comments_on_ancestry"

  create_table "likes", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "username"
  end

  create_table "notifications", :force => true do |t|
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.integer  "notification_id"
    t.string   "notification_type"
    t.integer  "viewed"
  end

  create_table "pages", :force => true do |t|
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "name"
    t.string   "hnusername"
    t.string   "linkedin_username"
    t.string   "personal_site"
    t.string   "github_username"
    t.integer  "user_id"
    t.text     "about_text"
    t.string   "image"
    t.string   "twitter_username"
    t.string   "user_name_class"
  end

  create_table "projects", :force => true do |t|
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "project_name"
    t.text     "short_description"
    t.text     "long_description"
    t.string   "main_language"
    t.text     "other_interesting"
    t.string   "picture"
    t.string   "url"
    t.string   "github_repo"
    t.integer  "page_id"
    t.integer  "project_type"
    t.integer  "widget_type"
    t.integer  "image_width"
    t.integer  "image_height"
    t.integer  "likes_count",       :default => 0
    t.integer  "position"
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

  create_table "tagowners", :force => true do |t|
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "project_id"
    t.integer  "tech_tag_id"
  end

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tech_tags", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
    t.string   "picture"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "username"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
