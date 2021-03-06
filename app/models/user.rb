class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :name, presence: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]


  has_many :sns_credentials, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_items, through: :favorites, source: :item, dependent: :destroy
  has_many :items, foreign_key: "seller_id"
  has_many :buyed_items, foreign_key: "buyer_id", class_name: "Item" #userが買った商品
  has_many :selling_items, -> { where("buyer_id is NULL")}, foreign_key: "seller_id", class_name: "Item" #現在売っている商品
  has_many :sold_items, -> { where("buyer_id is not NULL") }, foreign_key: "seller_id", class_name: "Item" #userが既に売った商品
  has_one :profile, dependent: :destroy
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :profile
  
  has_one :payment_card, dependent: :destroy


  def self.from_omniauth(auth)
    sns = SnsCredential.where(provider: auth.provider, uid: auth.uid).first_or_create
    user = sns.user || User.where(email: auth.info.email).first_or_initialize(
      name: auth.info.name,
      email: auth.info.email
    )
    if user.persisted?
      sns.user = user
      sns.save
    end
    {user: user, sns: sns}
  end
end