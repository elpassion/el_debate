class InitialsAvatarGenerator
  def self.call
    ReceiveAllowedColors.call.sample
  end
end
