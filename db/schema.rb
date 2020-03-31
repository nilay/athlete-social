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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160628165417) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "athlete_authorizations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider",        limit: 50
    t.string   "uid"
    t.string   "token",           limit: 500
    t.datetime "expires_at"
    t.datetime "last_session_at"
    t.string   "last_session_ip"
    t.integer  "session_count",               default: 0
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["token"], name: "index_athlete_authorizations_on_token", using: :btree
    t.index ["uid"], name: "index_athlete_authorizations_on_uid", using: :btree
    t.index ["user_id", "provider"], name: "index_athlete_authorizations_on_user_id_and_provider", using: :btree
    t.index ["user_id"], name: "index_athlete_authorizations_on_user_id", using: :btree
  end

  create_table "athletes", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "email_hash"
    t.string   "persistence_token"
    t.string   "api_key"
    t.integer  "role_id",           default: 0
    t.datetime "last_session_at"
    t.string   "last_session_ip"
    t.integer  "session_count",     default: 0
    t.integer  "failed_auth_count", default: 0
    t.integer  "created_by",        default: 0
    t.integer  "updated_by",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",            default: 0
    t.integer  "account_status",    default: 0
    t.boolean  "visible",           default: true
    t.index ["api_key"], name: "index_athletes_on_api_key", using: :btree
    t.index ["email"], name: "index_athletes_on_email", using: :btree
    t.index ["first_name"], name: "index_athletes_on_first_name", using: :btree
    t.index ["last_name"], name: "index_athletes_on_last_name", using: :btree
    t.index ["role_id"], name: "index_athletes_on_role_id", using: :btree
  end

  create_table "avatars", force: :cascade do |t|
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.integer  "avatar_owner_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "is_uploaded",       default: false
    t.integer  "avatar_owner_type"
    t.index ["avatar_owner_id", "avatar_owner_type"], name: "index_avatars_on_avatar_owner_id_and_avatar_owner_type", using: :btree
  end

  create_table "blockings", force: :cascade do |t|
    t.integer  "blocker_id"
    t.integer  "blocker_type"
    t.integer  "blocked_user_id"
    t.integer  "blocked_user_type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["blocker_id", "blocker_type"], name: "index_blockings_on_blocker_id_and_blocker_type", using: :btree
  end

  create_table "brand_user_authorizations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider",        limit: 50
    t.string   "uid"
    t.string   "token",           limit: 500
    t.datetime "expires_at"
    t.datetime "last_session_at"
    t.string   "last_session_ip"
    t.integer  "session_count",               default: 0
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["token"], name: "index_brand_user_authorizations_on_token", using: :btree
    t.index ["uid"], name: "index_brand_user_authorizations_on_uid", using: :btree
    t.index ["user_id", "provider"], name: "index_brand_user_authorizations_on_user_id_and_provider", using: :btree
    t.index ["user_id"], name: "index_brand_user_authorizations_on_user_id", using: :btree
  end

  create_table "brand_users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "email_hash"
    t.string   "persistence_token"
    t.string   "api_key"
    t.integer  "role_id",           default: 0
    t.datetime "last_session_at"
    t.string   "last_session_ip"
    t.integer  "session_count",     default: 0
    t.integer  "failed_auth_count", default: 0
    t.integer  "created_by",        default: 0
    t.integer  "updated_by",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "brand_id"
    t.integer  "status",            default: 0
    t.integer  "account_status",    default: 0
    t.index ["api_key"], name: "index_brand_users_on_api_key", using: :btree
    t.index ["brand_id"], name: "index_brand_users_on_brand_id", using: :btree
    t.index ["email"], name: "index_brand_users_on_email", using: :btree
    t.index ["first_name"], name: "index_brand_users_on_first_name", using: :btree
    t.index ["last_name"], name: "index_brand_users_on_last_name", using: :btree
    t.index ["role_id"], name: "index_brand_users_on_role_id", using: :btree
  end

  create_table "brands", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "contact_name"
    t.string   "phone"
    t.string   "email"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "deactivated_at"
  end

  create_table "cms_admin_authorizations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider",        limit: 50
    t.string   "uid"
    t.string   "token",           limit: 500
    t.datetime "expires_at"
    t.datetime "last_session_at"
    t.string   "last_session_ip"
    t.integer  "session_count",               default: 0
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["token"], name: "index_cms_admin_authorizations_on_token", using: :btree
    t.index ["uid"], name: "index_cms_admin_authorizations_on_uid", using: :btree
    t.index ["user_id", "provider"], name: "index_cms_admin_authorizations_on_user_id_and_provider", using: :btree
    t.index ["user_id"], name: "index_cms_admin_authorizations_on_user_id", using: :btree
  end

  create_table "cms_admins", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "email_hash"
    t.string   "persistence_token"
    t.string   "api_key"
    t.integer  "role_id",           default: 0
    t.datetime "last_session_at"
    t.string   "last_session_ip"
    t.integer  "session_count",     default: 0
    t.integer  "failed_auth_count", default: 0
    t.integer  "created_by",        default: 0
    t.integer  "updated_by",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",            default: 0
    t.integer  "account_status",    default: 0
    t.boolean  "opt_in_to_emails",  default: true
    t.index ["api_key"], name: "index_cms_admins_on_api_key", using: :btree
    t.index ["email"], name: "index_cms_admins_on_email", using: :btree
    t.index ["first_name"], name: "index_cms_admins_on_first_name", using: :btree
    t.index ["last_name"], name: "index_cms_admins_on_last_name", using: :btree
    t.index ["role_id"], name: "index_cms_admins_on_role_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "athlete_id"
    t.text     "text"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.index ["athlete_id"], name: "index_comments_on_athlete_id", using: :btree
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
  end

  create_table "fan_authorizations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider",        limit: 50
    t.string   "uid"
    t.string   "token",           limit: 500
    t.datetime "expires_at"
    t.datetime "last_session_at"
    t.string   "last_session_ip"
    t.integer  "session_count",               default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["token"], name: "index_fan_authorizations_on_token", using: :btree
    t.index ["uid"], name: "index_fan_authorizations_on_uid", using: :btree
    t.index ["user_id", "provider"], name: "index_fan_authorizations_on_user_id_and_provider", using: :btree
    t.index ["user_id"], name: "index_fan_authorizations_on_user_id", using: :btree
  end

  create_table "fans", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "email_hash"
    t.string   "persistence_token"
    t.string   "api_key"
    t.integer  "role_id",           default: 0
    t.datetime "last_session_at"
    t.string   "last_session_ip"
    t.integer  "session_count",     default: 0
    t.integer  "failed_auth_count", default: 0
    t.integer  "created_by",        default: 0
    t.integer  "updated_by",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",            default: 0
    t.integer  "account_status",    default: 0
    t.index ["api_key"], name: "index_fans_on_api_key", using: :btree
    t.index ["email"], name: "index_fans_on_email", using: :btree
    t.index ["first_name"], name: "index_fans_on_first_name", using: :btree
    t.index ["last_name"], name: "index_fans_on_last_name", using: :btree
    t.index ["role_id"], name: "index_fans_on_role_id", using: :btree
  end

  create_table "flaggings", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "flagger_id"
    t.integer  "flagger_type"
    t.integer  "moderator_id"
    t.integer  "status",            default: 0
    t.datetime "status_changed_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "follows", force: :cascade do |t|
    t.string   "followable_type",                 null: false
    t.integer  "followable_id",                   null: false
    t.string   "follower_type",                   null: false
    t.integer  "follower_id",                     null: false
    t.boolean  "blocked",         default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["followable_id", "followable_type"], name: "fk_followables", using: :btree
    t.index ["follower_id", "follower_type"], name: "fk_follows", using: :btree
  end

  create_table "images", force: :cascade do |t|
    t.integer  "post_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "guid"
    t.index ["post_id"], name: "index_images_on_post_id", using: :btree
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "inviter_id"
    t.integer  "invitee_id"
    t.string   "email"
    t.string   "invite_token"
    t.datetime "expires_on"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "inviter_type", default: 0
    t.string   "phone_number"
    t.string   "invitee_name"
    t.index ["invite_token"], name: "index_invitations_on_invite_token", using: :btree
    t.index ["invitee_id"], name: "index_invitations_on_invitee_id", using: :btree
    t.index ["inviter_id", "inviter_type"], name: "index_invitations_on_inviter_id_and_inviter_type", using: :btree
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "athlete_id"
    t.integer  "parent_id"
    t.integer  "content_type"
    t.string   "thumbnail_url"
    t.string   "url"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "status",        default: 0
    t.string   "parent_type",   default: "Post"
    t.integer  "share_count",   default: 0
    t.decimal  "rank",          default: "0.0"
    t.index ["athlete_id"], name: "index_posts_on_athlete_id", using: :btree
    t.index ["parent_id", "parent_type"], name: "index_posts_on_parent_id_and_parent_type", using: :btree
    t.index ["rank"], name: "index_posts_on_rank", order: {"rank"=>:desc}, using: :btree
  end

  create_table "push_notifications", force: :cascade do |t|
    t.string   "message"
    t.integer  "status",     default: 0
    t.jsonb    "details",    default: {}
    t.jsonb    "result",     default: {}
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["details"], name: "index_push_notifications_on_details", using: :gin
    t.index ["result"], name: "index_push_notifications_on_result", using: :gin
    t.index ["status"], name: "index_push_notifications_on_status", using: :btree
  end

  create_table "questions", force: :cascade do |t|
    t.text     "text"
    t.boolean  "sponsored"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "questioner_id"
    t.integer  "questioner_type"
    t.integer  "status",          default: 0
    t.index ["questioner_id", "questioner_type"], name: "index_questions_on_questioner_id_and_questioner_type", using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "videos", force: :cascade do |t|
    t.integer  "post_id"
    t.string   "thumbnail_url"
    t.string   "base_url"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "panda_video_id"
    t.string   "guid"
    t.json     "profiles"
    t.index ["guid"], name: "index_videos_on_guid", using: :btree
    t.index ["post_id"], name: "index_videos_on_post_id", using: :btree
  end

  create_table "votes", force: :cascade do |t|
    t.string   "votable_type"
    t.integer  "votable_id"
    t.string   "voter_type"
    t.integer  "voter_id"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree
  end

end
