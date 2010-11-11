require 'rest_client'

class LuTze
  def self.gather_and_send
    LuTze.new.upload
  end
  
  def initialize
    save && compress
  end
  
  def save
    system dump_command
  end
  
  def compress
    system compress_command
  end
  
  def upload
    file = File.new(compressed_file_name, 'r')
    RestClient.post 'http://historian.heroku.com/api/data_backups',
      :site_key  => ENV['historian_key'],
      :backup    => file
  end
  
  private
  
  def config
    @config ||= ActiveRecord::Base.connection.instance_variable_get(:@config)
  end
  
  def dump_command
    cmd = ""
    
    if config[:adapter] == 'postgresql'
      cmd += "echo #{config[:password]} | " if config[:password].present?
      cmd += "pg_dump --format=p --file=#{file_name}"
      cmd += " --host=#{config[:host]}" if config[:host].present?
      cmd += " --port=#{config[:port]}" if config[:port].present?
      cmd += " --username=#{config[:username]}" if config[:username].present?
      cmd += " #{config[:database]}"
    else
      cmd += "mysqldump --format=p --result-file=#{file_name}"
      cmd += " --host=#{config[:host]}" if config[:host].present?
      cmd += " --port=#{config[:port]}" if config[:port].present?
      cmd += " --user=#{config[:username]}" if config[:username].present?
      cmd += " --password=#{config[:password]}" if config[:username].present?
      cmd += " #{config[:database]}"
    end
    
    cmd
  end
  
  def compress_command
    "cd #{tmp}; tar -czvf #{short_compressed_file_name} #{short_file_name}"
  end
  
  def short_file_name
    "database.sql"
  end
  
  def file_name
    "#{tmp}/#{short_file_name}"
  end
  
  def short_compressed_file_name
    "database.tar.gz"
  end
  
  def compressed_file_name
    "#{tmp}/#{short_compressed_file_name}"
  end
  
  def tmp
    "#{RAILS_ROOT}/tmp"
  end
end
