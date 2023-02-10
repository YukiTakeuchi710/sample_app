# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#  activation_digest :string
#  admin             :boolean
#  email             :string
#  name              :string
#  password_digest   :string
#  remember_digest   :string
#  reset_digest      :string
#  reset_sent_at     :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  # ほかのユーザーをフォローする。
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  # ほかのユーザーにフォローされる。
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy
  # ほかのユーザーをミュートする。
  has_many :mute_relationships, class_name:  "Mute",
                                foreign_key: "muter_id",
                                dependent:   :destroy
  # ほかのユーザーにミュートされる。
  has_many :muted_relationships, class_name:  "Mute",
                                 foreign_key: "muted_id",
                                 dependent:   :destroy
  # フォロー
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # ミュート
  has_many :muting, through: :mute_relationships, source: :muted
  has_many :mutedusers, through: :muted_relationships, source: :muter

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true




  @joins_followed_relation_sql_char =
    "LEFT OUTER JOIN relationships  followed_relation ON
      microposts.user_id = followed_relation.followed_id
      followed_relation.follower_id = ?"


  @joins_following_relation_sql =
    "LEFT OUTER JOIN relationships following_relation ON
      microposts.user_id = followed_relation.follower_id
      following_relation.followed_id = ?"

  # メモとして、こういうSQLにしたい
  @ideal_query = <<-SQL
        SELECT
          microposts.*
        FROM microposts
        LEFT outer join relationships  followed_relation on
          followed_relation.follower_id = :viewer_id  
          AND microposts.user_id = followed_relation.followed_id
        LEFT outer join relationships  following_relation on
          following_relation.followed_id = :viewer_id
          AND microposts.user_id = following_relation.follower_id
        LEFT outer join users ON 
          microposts.user_id = users.id
        WHERE
          users.name like :keyword
          AND (
            microposts.range = 0
            OR (microposts.range = 1
              AND (
                (followed_relation.id IS NOT NULL) 
                OR (microposts.user_id = :viewer_id))
            )
            OR (microposts.range = 2 AND ((followed_relation.id IS NOT NULL AND following_relation.id IS NOT NULL) OR (microposts.user_id = :viewer_id)) )
            OR (microposts.range = 3 AND microposts.user_id = :viewer_id )
          )
  SQL

  @based_condition = <<~SQL

  SQL

  # 基本的な検索条件
  def create_joind_record_with_follow_relationship
    # joined_records
    # 目標とするクエリ
    joins_followed_relation_sql = <<~SQL
    LEFT OUTER JOIN relationships  followed_relation ON
      microposts.user_id = followed_relation.followed_id
      AND followed_relation.follower_id = #{id}
    SQL
    joins_following_relation_sql = <<~SQL
      LEFT OUTER JOIN relationships following_relation ON
      microposts.user_id = followed_relation.follower_id
      AND following_relation.followed_id = #{id}
    SQL
    Micropost.joins(joins_followed_relation_sql)
             .joins(joins_following_relation_sql)
  end

  def create_joind_record_with_follow_relationship_and_user
    # joined_records
    create_joind_record_with_follow_relation_ship.left_joins(:user)
  end

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
             BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # セッションハイジャック防止のためにセッショントークンを返す
  # この記憶ダイジェストを再利用しているのは単に利便性のため
  def session_token
    remember_digest || remember
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end


  # ユーザーのステータスフィードを返す
  def feed
    # 目標とするクエリ
    joins_followed_relation_sql = <<~SQL
    LEFT OUTER JOIN relationships  followed_relation ON
      microposts.user_id = followed_relation.followed_id
      AND followed_relation.follower_id = #{id}
    SQL
    joins_following_relation_sql = <<~SQL
      LEFT OUTER JOIN relationships following_relation ON
      microposts.user_id = followed_relation.follower_id
      AND following_relation.followed_id = #{id}
    SQL
    joined_records = Micropost.joins(joins_followed_relation_sql)
                              .joins(joins_following_relation_sql)

    joined_records.where(range: 0)
              .or(joined_records.where(range: [1, 2, 3], user_id: id))
              .or(joined_records.where(range: 1).where.not(followed_relation: { id: nil }))
              .or(joined_records.where(range: 2).where.not(followed_relation: { id: nil }).where.not(following_relation: { id: nil }))
  end

  def personal_feed(viewer_id)
    feed.where({user_id: id})
  end

  def search_microposts(params)
    search_type = params[:search_type]
    keyword =  '%' + params[:search_content] + '%'
    if keyword.blank?
      feed
    else
      if SearchType::SEARCH_TYPE_MICROPOST == search_type
          feed.where("content like ?", keyword)
      else

        user_joins = <<~SQL
          LEFT OUTER JOIN users ON
            microposts.user_id = users.id
        SQL
        searched_feeds = Micropost.find_by_sql([query,{viewer_id: id, keyword: keyword} ])
        Micropost.where(id: searched_feeds.map(&:id))
        feed.joins(user_joins).where("user.name like ?", keyword)
      end
    end
  end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user unless self == other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    following.delete(other_user)
  end

  # ユーザーをミュートする
  def mute(other_user)
    muting << other_user unless self == other_user
  end

  # ユーザーをミュートする
  def unmute(other_user)
    muting.delete(other_user)
  end

  # 現在のユーザーが他のユーザーをフォローしていればtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end


  # 現在のユーザーが他のユーザーをフォローしていればtrueを返す
  def muting?(other_user)
    muting.include?(other_user)
  end

  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
