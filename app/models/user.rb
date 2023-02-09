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
  has_many :muters, through: :muted_relationships, source: :muter

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
    query = <<-SQL
      SELECT
        microposts.*
      FROM microposts
      LEFT outer join relationships  followed_relation on
        followed_relation.follower_id = :user_id  
        AND microposts.user_id = followed_relation.followed_id
      LEFT outer join relationships  following_relation on
        following_relation.followed_id = :user_id
        AND microposts.user_id = following_relation.follower_id
      WHERE 
        microposts.range = 0
        OR (microposts.range = 1
          AND (
              (followed_relation.id IS NOT NULL) 
              OR (microposts.user_id = :user_id))
            )
        OR (microposts.range = 2 AND ((followed_relation.id IS NOT NULL AND following_relation.id IS NOT NULL) OR (microposts.user_id = :user_id)) )
        OR (microposts.range = 3 AND microposts.user_id = :user_id )
    SQL

    part_of_feed = "relationships.follower_id = :id or microposts.user_id = :id"
    followed_relation_join_query = %|LEFT outer join relationships  followed_relation on
                                     followed_relation.follower_id = :user_id
                                     AND microposts.user_id = followed_relation.followed_id|
    following_relation_join_query = %|LEFT outer join relationships  following_relation on
                                      following_relation.followed_id = :user_id
                                      AND microposts.user_id = following_relation.follower_id|
    where_condition = "microposts.range = 0
                       OR (microposts.range = 1 AND followed_relations.id IS NOT NULL )
                       OR (microposts.range = 2 AND followed_relations.id IS NOT NULL AND following_relations.id IS NOT NULL )
                       OR (microposts.range = 3 AND microposts.user_id = :user_id )"

    # もう少しメソッドを使ったほうがいい。というのは分かっている
    # Micropost.left_joins([followed_relation_join_query, {user_id: id}])
    #           .left_joins([following_relation_join_query, {user_id: id}])
    #          .where([where_condition, {user_id: id}])
    #          .distinct
    #          .includes(:user, image_attachment: :blob)

    # これは何とかしたくはある。。。。
    # 普通にキャストするメソッドあってもいいのにな
    micropostFeeds = Micropost.find_by_sql([query,{user_id: id} ])
    Micropost.where(id: micropostFeeds.map(&:id))
  end

  def personal_feed(viewer_id)

    query = <<-SQL
      SELECT
        microposts.*
      FROM microposts
      LEFT outer join relationships  followed_relation on
        followed_relation.follower_id = :viewer_id  
        AND microposts.user_id = followed_relation.followed_id
      LEFT outer join relationships  following_relation on
        following_relation.followed_id = :viewer_id
        AND microposts.user_id = following_relation.follower_id
      WHERE
        microposts.user_id = :user_id
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
    followed_join = "
      relationships  followed_relation on
        followed_relation.follower_id = :viewer_id
        AND microposts.user_id = followed_relation.followed_id"
    following_join = "
      relationships  following_relation on
        following_relation.followed_id = :viewer_id
        AND microposts.user_id = following_relation.follower_id"

    where_cond = "
      microposts.user_id = :user_id
        AND (
          microposts.range = 0
          OR (microposts.range = 1
            AND (
                (followed_relation.id IS NOT NULL)
                OR (microposts.user_id = :viewer_id))
            )
          OR (microposts.range = 2 AND ((followed_relation.id IS NOT NULL AND following_relation.id IS NOT NULL) OR (microposts.user_id = :viewer_id)) )
          OR (microposts.range = 3 AND microposts.user_id = :viewer_id )
        )"
    # Micropost.left_joins([followed_join, { viewer_id: viewer_id}])
    #            .left_joins([following_join, { viewer_id: viewer_id}])
    #            .where([where_cond, {user_id: id, viewer_id: viewer_id}])

    # これは何とかしたくはある。。。。
    # 普通にキャストするメソッドあってもいいのに
    personalFeeds = Micropost.find_by_sql([query,{user_id: id, viewer_id: viewer_id} ])
    Micropost.where(id: personalFeeds.map(&:id))

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
    following << other_user unless self == other_user
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
    muting?.include?(other_user)
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
