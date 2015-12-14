module DataMask
  module Export
    def self.postgres(db)
     system  "pg_dump -h %{host} -p %{port} -U %{user} %{database} > %{database}-masking-#{Time.now.to_f.to_i}.sql" % db
    end

    def self.mysql(db)
      system "mysqldump -h %{host} -P %{port} -u %{user} %{database} > %{database}-masking-#{Time.now.to_f.to_i}.sql" % db
    end
  end
end