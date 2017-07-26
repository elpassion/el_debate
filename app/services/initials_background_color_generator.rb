class InitialsBackgroundColorGenerator

  POSSIBLE_COLORS = %w[#1abc9c, #c2efd5, #7cffcf, #cef6ff, #c2cbef, #dbd4fc, #e9e0ff, #fad1ff, #ffcce8, #efc2c2,
                       #f2e7ba, #efe0d2, #e74c3c, #f9ceca, #b9cdce, #efdec2, #efdbce, #ff8477, #e1e9ef, #d0eff2]

  def self.call
    POSSIBLE_COLORS.sample
  end
end
