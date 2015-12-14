module DataMask
  module Shell
    def self.postgres_migrate(from, to)
      remote = "pg_dump -h %{host} -p %{port} -U %{user} %{database}" % from
      local = "psql -p %{port} %{database}" % to
      system "#{remote} | #{local}"
    end

    def self.mysql_migrate(from, to)
      remote = "mysqldump -h %{host} -P %{port} -u %{user} %{database}" % from
      local = "mysql -P %{port} %{database}" % to
      system "#{remote} | #{local}"
    end

    def self.postgres_export(db)
      system "pg_dump -h %{host} -p %{port} -U %{user} %{database} > %{database}-masking-#{Time.now.to_f.to_i}.sql" % db
    end

    def self.mysql_export(db)
      system "mysqldump -h %{host} -P %{port} -u %{user} %{database} > %{database}-masking-#{Time.now.to_f.to_i}.sql" % db
    end
  end
end