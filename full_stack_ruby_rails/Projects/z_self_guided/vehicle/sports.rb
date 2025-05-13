module Sports
  def make_sports
    self.rate += 2
    self.engine = self.engine == 'V4' ? 'V6' : 'V8'
    self.frame.concat(' (sport)')
    @sport = true
    @noise = true
  end

  def sport?
    false unless self.sport
  end

  def noisy?
    if self.sport?
      puts "VROOOOM"
    else
      puts "shreeeeee"
    end
  end
end
