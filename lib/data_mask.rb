require 'sequel'

require 'data_mask/config'
require 'data_mask/migrate'
require 'data_mask/export'

module DataMask
  class Mask
    def initialize(path = 'config')
      @db_conf = Config.parse(path + '/database.yml')
      @tasks = Config.parse(path + '/tasks.yml')
    end

    def operate_db(op)
      execute_sql "#{op.upcase} DATABASE %{database}" % @db_conf[:to]
    end

    def migrate
      Migrate.send(@db_conf[:to][:adapter], @db_conf[:from], @db_conf[:to])
    end

    def play
      mask(@db_conf[:to], @tasks)
    end

    def export
      Export.send(@db_conf[:to][:adapter], @db_conf[:to])
    end

    def tmp_db_clear
      return if
      if @db_conf[:to][:adapter] == 'postgres'
        # Force drop db while others may be connected
        execute_sql 'select pg_terminate_backend(procpid)' \
          " from pg_stat_activity where datname=’%{database}’" % @db_conf[:to]
      end
      execute_sql "DROP DATABASE  IF EXISTS %{database}" % @db_conf[:to]
    end

    def run
      tmp_db_clear
      operate_db('create')
      migrate
      play
      export
    end


    private

    def build_url_without_db(data)
      "%{adapter}://%{host}:%{port}" % data
    end

    def build_url(data)
      "%{adapter}://%{host}:%{port}/%{database}" % data
    end

    def parse_mask(mask, binding)
      return mask unless mask.is_a?(String) && mask.start_with?('%=')

      result = eval(mask[2..-1], binding)
      return result if result.is_a?(String) || result.is_a?(Integer)
      throw ArgumentError('wrong value type')
    end

    def mask(config, tasks)
      db = Sequel.connect(build_url(config))

      tasks.each do |table, task|
        table = db[table]
        task.each do |key, value|
          if key == :each_row
            value.each do |sub_k, sub_v|
              # Iterate table and update each item
              table.each { |row| table.where(id: row[:id]).update(sub_k => parse_mask(sub_v, binding)) }
            end
          else
            table.update(key => parse_mask(value, binding))
          end
        end
      end

      db.disconnect
    end

    def execute_sql(sql)
      Sequel.connect(build_url_without_db(@db_conf[:to])) do |db|
        begin
          db.run sql
        rescue
        end
      end
    end

  end
end