module DataMask
  class DBShell
    attr_accessor :options

    def initialize(options)
      @options = options
    end

    def export(**opt)
      cmd = ''
      cmd += send("#{@options[:adapter]}_cmd", 'export')
      cmd += "> %{database}-masking-#{Time.now.to_f.to_i}.sql" % @options if opt[:to_file]
      cmd
    end

    def import(filepath=nil)
      cmd = ''
      cmd += send("#{@options[:adapter]}_cmd", 'import')
      cmd += "< #{filepath}" if filepath
      cmd
    end

    private

    def postgres_cmd(type)
      cmd = "#{type=='export' ? 'pg_dump' : 'psql'} "
      cmd += "-h %{host} " % @options if @options[:host]
      cmd += "-p %{port} " % @options if @options[:port]
      cmd += "-U %{user} " % @options if @options[:user]
      cmd += "%{database} " % @options if @options[:database]
      cmd
    end

    def mysql_cmd(type)
      cmd = "#{type=='export' ? 'mysqldump' : 'mysql'} "
      cmd += "-h %{host} " % @options if @options[:host]
      cmd += "-P %{port} " % @options if @options[:port]
      cmd += "-u %{user} " % @options if @options[:user]
      cmd += "-p %{password} " % @options if @options[:password]
      cmd += "%{database} " % @options
      cmd
    end
  end
end