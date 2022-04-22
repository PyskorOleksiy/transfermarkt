class TournamentClub < ApplicationRecord
  has_many :homes, dependent: :destroy
	has_many :aways, dependent: :destroy
  has_many :players, dependent: :destroy
  has_one :coach, dependent: :destroy
end
