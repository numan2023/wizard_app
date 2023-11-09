class Address < ApplicationRecord
  belongs_to :user, optional: true # user_idは住所情報入力時点では値なし -> バリデーション引っかかる。 / 一方でDB保存段階でuser_idの保存が必要 -> migrate "null: false"
  validates :postal_code, :address, presence: true
end
