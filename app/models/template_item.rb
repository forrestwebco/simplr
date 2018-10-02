class TemplateItem < ApplicationRecord
  validates_presence_of :tag

  before_create :gen_unique_token
  before_create :better_ipsum

  mount_uploader :image, ImageUploader

  scope :priced_items, -> { where item_type: "priced" }

  private

  def better_ipsum
    if Rails.env.development? and not self.body.present?
      self.title = Faker::StarWars.call_sign
      self.name = Faker::StarWars.character
      self.body = Faker::StarWars.quote self.name
      self.description = Faker::StarWars.wookiee_sentence
    elsif not self.body.present?
      for _attr in [:title, :name, :body, :description]
        self.send(_attr) = "This template item has not been set."
      end
    end
    self.start_date = DateTime.current
    self.total_classes = rand 1..3
  end

  def gen_unique_token
    begin
      self.unique_token = $name_generator.next_name[0..5].downcase
      self.unique_token << "_" + SecureRandom.urlsafe_base64.split('').sample(2).join.downcase.gsub("_", "").gsub("-", "")
    end while TemplateItem.exists? unique_token: self.unique_token
  end
end
