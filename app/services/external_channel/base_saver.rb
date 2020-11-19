module ExternalChannel
  class BaseSaver

    def save_all(data)
      data.all? { |each| save(each) }
    end

    # === Saver는 저장 책임만 진다.
    # === 저장에 실패한 뒤의 로직은 saver 밖에서 처리해야 한다.
    def save(data)
      ActiveRecord::Base.transaction do
        save_data(data)
      rescue StandardError => e
        ActiveRecord::Rollback
        Rails.logger.error "#{Time.now} | Error : #{e.inspect} occured\nFIND here:\n#{e.backtrace.last(20)}"
      end
    end

    protected

    # === 실제로 데이터를 저장하는 로직이 담기는 함수이다.
    # === 하위 클래스에서는 이 부분을 구현하는 경우가 많다.
    def save_data(data); end
  end
end
