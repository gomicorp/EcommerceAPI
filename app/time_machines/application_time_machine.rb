class ApplicationTimeMachine
  attr_reader :subject

  def initialize(subject)
    @subject = subject.class.includes(index_graph).find(subject.id)
  end

  def version_at(timestamp)
    @subject = subject.version_at timestamp
    yield(subject) if block_given?
    subject
  end

  def self.checkout(subject, timestamp = Time.zone.now)
    new(subject).version_at(timestamp)
  end

  private

  def index_graph
    {} # stuff
  end
end
