require 'daru/io/importers/rds'

module Daru
  module IO
    module Importers
      class RData < RDS
        Daru::DataFrame.register_io_module :from_rdata, self

        # Imports a +Daru::DataFrame+ from a RData file and variable
        #
        # @param path [String] Path to the RData file
        # @param variable [String or Symbol] The variable to be imported from the
        #   variables stored in the RData file
        #
        # @return A +Daru::DataFrame+ imported from the given RData file and variable name
        #
        # @example Importing from an RData file
        #   df = Daru::IO::Importers::RData.new('ACScounty.RData', :ACS3).call
        #   df
        #
        #   #=>   #<Daru::DataFrame(1629x30)>
        #   #           Abbreviati       FIPS     Non.US      State       cnty females.di  ...
        #   #         0         AL       1001       14.7    alabama    autauga       13.8  ...
        #   #         1         AL       1003       13.5    alabama    baldwin       14.1  ...
        #   #         2         AL       1005       20.1    alabama    barbour       16.1  ...
        #   #         3         AL       1009       18.0    alabama     blount       13.7  ...
        #   #         4         AL       1015       18.6    alabama    calhoun       12.9  ...
        #   #       ...        ...        ...        ...        ...        ...        ...  ...
        def initialize(path, variable)
          super(path)
          @variable = variable.to_sym
        end

        def call
          @instance = RSRuby.instance
          @instance.eval_R("load('#{@path}')")
          @vals = @instance
                  .send(@variable)
                  .map { |k, v| [k.to_sym, v] }.to_h
          Daru::DataFrame.new(@vals)
        end
      end
    end
  end
end