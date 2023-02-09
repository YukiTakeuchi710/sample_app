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
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  #has_many :following_relation, through: :active_relationships, source: :followed
  #has_many :followed_relation, through: :passive_relationships, source: :follower
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

    condition = "micropost.range == 0
        OR (micropost.range == 1 AND followed_relation.id IS NOT NULL )
        OR (micropost.range == 2 AND followed_relation.id IS NOT NULL AND following_relation.id IS NOT NULL )
        OR (micropost.range == 3 AND micropost.user_id == :id )"

    lf_join_1 = "relationship AS followed_relation on
        :user_id == followed_relation.followed_id
        AND micropost.user_id == followed_relation.follower_id"
    lf_join_2 = "LEFT outer join relationship AS following_relation on
        :user_id == follow_relation.follower_id
        AND micropost.user_id == follow_relation.followed_id"
    query = <<-SQL
      SELECT DISTINCT
        microposts.*
      FROM microposts
      LEFT outer join relationships AS followed_relation on
        :user_id == followed_relation.followed_id
        AND microposts.user_id == followed_relation.follower_id
      LEFT outer join relationships AS following_relation on
        :user_id == following_relation.follower_id
        AND microposts.user_id == following_relation.followed_id
      WHERE 
        microposts.range == 0
        OR (microposts.range == 1 AND followed_relation.id IS NOT NULL )
        OR (microposts.range == 2 AND followed_relation.id IS NOT NULL AND following_relation.id IS NOT NULL )
        OR (microposts.range == 3 AND microposts.user_id == :user_id )
    SQL

    #Micropost.where()
    part_of_feed = "relationships.follower_id = :id or microposts.user_id = :id"
    # p Micropost.left_outer_joins(user: :followers)
    #          .where(part_of_feed, { id: id }).distinct
    #          .includes(:user, image_attachment: :blob).class
    #Relationship.followed_relation(id)
    #Relationship.following_relation(id)
    p Micropost.left_outer_joins(:followed_post)
               .left_outer_joins(:following_post)
    # Micropost.left_outer_joins(user: :followers)
    #          .left_outer_joins(user: :following)
    #          #.where(part_of_feed, { id: id })
    #          .distinct
    #          .includes(:user, image_attachment: :blob)

    Micropost.left_outer_joins(:followed_post)
               .left_outer_joins(:following_post)
               .distinct
               .includes(:user, image_attachment: :blob)

    #Micropost..class
    #Micropost.find_by_sql([query,{user_id: id} ]).class
    #.includes(:user, image_attachment: :blob)
    # Micropost.left_outer_joins(user: :followers).left_outer_joins(user: :following)
    #          .where(part_of_feed, { id: id }).distinct
    #          .includes(:user, image_attachment: :blob)
  end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user unless self == other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    following.delete(other_user)
  end

  # 現在のユーザーが他のユーザーをフォローしていればtrueを返す
  def following?(other_user)
    following.include?(other_user)
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
