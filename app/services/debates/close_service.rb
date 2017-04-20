module Debates
  class CloseService < DebateService
    def call
      debate.update!(closed_at: Time.current) unless debate.closed?
      notify
    end
  end
end
