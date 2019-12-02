class Translator
  attr_reader :record

  DIC = {}

  def initialize(record)
    @record = record
  end

  private

  def parse(key, lang)
    dic[key].dig((lang || I18n.locale).to_sym, record.send(key).to_s.to_sym)
  end

  def dic
    self.class::DIC
  end
end
