require 'pg'

module DBConnect
  def self.connect(db_params=self.get_params)
    begin
      @connection ||= PG.connect(db_params)
    rescue PG::Error => e
      puts e.message
    end
  end

  private
    def self.get_params
      db_params = {
        host: 'localhost',
        dbname: 'terminal_game_development',
        user: 'terminal_user',
        password: 'terminal_games_are_cool',
        port: 5433
      }
    end

end
