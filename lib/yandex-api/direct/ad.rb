module Yandex::API::Direct
  class Ad < Base
    ATTRIBUTES = :Id, :CampaignId, :AdGroupId, :Status, :StatusClarification, :State, :AdCategories, :AgeLabel, :Type, :Subtype
    TF = :Title, :Text, :Href

    attr_accessor *ATTRIBUTES, :TextAd

    def self.get(selection_criteria)
      response = Yandex::API::Direct.request('get', self.path, selection_criteria.fields(*ATTRIBUTES).text_ad_fields(*TF))
      response.fetch('Ads',[]).map{|attributes| self.new(attributes)}
    end

    def self.resume(selection_criteria)
      response = Yandex::API::Direct.request('resume', self.path, selection_criteria)
      response.fetch('ResumeResults',[]).map{|attributes| Yandex::API::Direct::ActionResult.new(attributes)}
    end

    def resume
      self.class.where(Ids: [self.Id]).call(:resume).first
    end

    def self.suspend(selection_criteria)
      response = Yandex::API::Direct.request('suspend', self.path, selection_criteria)
      response.fetch('SuspendResults',[]).map{|attributes| Yandex::API::Direct::ActionResult.new(attributes)}
    end

    def suspend
      self.class.where(Ids: [self.Id]).call(:suspend).first
    end
  end
end
