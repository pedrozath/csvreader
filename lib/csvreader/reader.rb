# encoding: utf-8


module Csv    ## check: rename to CsvSettings / CsvPref / CsvGlobals or similar - why? why not???

  ## STD_CSV_ENGINE = CSV   ## to avoid name confusion use longer name - why? why not? find a better name?
  ## use __CSV__ or similar? or just ::CSV ??


class Dialect   ## todo: use a module - it's just a namespace/module now - why? why not?
  ###
  # (auto-)add these flavors/dialects:
  #     :tab                   -> uses TabReader(!)
  #     :strict|:rfc4180
  #     :unix                   -> uses unix-style escapes e.g. \n \" etc.
  #     :windows|:excel
  #     :guess|:auto     -> guess (auto-detect) separator - why? why not?

  ##  e.g. use Dialect.registry[:unix] = { ... } etc.
  ##   note use @@ - there is only one registry
  def self.registry() @@registry ||={} end

  ## add built-in dialects:
  ##    trim - use strip? why? why not? use alias?
  registry[:tab]     = {}   ##{ class: TabReader }
  registry[:strict]  = { strict: true, trim: false }   ## add no comments, blank lines, etc. ???
  registry[:rfc4180] = :strict    ## alternative name
  registry[:windows] = {}
  registry[:excel]   = :windows
  registry[:unix]    = {}

  ## todo: add some more
end  # class Dialect



  class Configuration

    puts "CSV::VERSION:"
    puts CSV::VERSION

    puts "builtin CSV::Converters:"
    pp CSV::Converters

    puts "CSV::DEFAULT_OPTIONS:"
    pp CSV::DEFAULT_OPTIONS

    ##  register our own converters
    ## check if strip gets called for nil values too?
    CSV::Converters[:strip] = ->(field) { field.strip }


    attr_accessor :sep   ## col_sep (column separator)
    attr_accessor :na    ## not available (string or array of strings or nil) - rename to nas/nils/nulls - why? why not?
    attr_accessor :trim        ### allow ltrim/rtrim/trim - why? why not?
    attr_accessor :dialect

    def initialize
      @sep = ','
      ## note: do NOT add headers as global - should ALWAYS be explicit
      ##   headers (true/false) - changes resultset and requires different processing!!!

      self  ## return self for chaining
    end

    def trim?() @trim; end   ## strip leading and trailing spaces

    def blank?( line )
      ## note:  blank line does NOT include "blank" with spaces only!!
      ##          use BLANK_REGEX in skip_lines to clean-up/skip/remove/ignore
      ##  see skip_blanks in default_options
      line.empty?
    end

    ## lines starting with # (note: only leading spaces allowed)
    COMMENTS_REGEX = /^\s*#/
    BLANK_REGEX    = /^\s*$/   ## skip all whitespace lines - note: use "" or , for a blank record!!!
    SKIP_REGEX = Regexp.union( COMMENTS_REGEX, BLANK_REGEX )

    def skip?( line )
      ## check if comment line - skip comments
      ##  see skip_lines in default_options
      line =~ SKIP_REGEX
    end

    ## built-in (default) options
    ##  todo: find a better name?
    def default_options
      ## note:
      ##   do NOT include sep character and
      ##   do NOT include headers true/false here
      ##
      ##  make default sep its own "global" default config
      ##   e.g. Csv.config.sep =

      ## common options
      ##   skip comments starting with #
      ##   skip blank lines
      ##   strip leading and trailing spaces
      ##    NOTE/WARN:  leading and trailing spaces NOT allowed/working with double quoted values!!!!
      defaults = {
        skip_blanks: true,    ## note: skips lines with no whitespaces only!! (e.g. line with space is NOT blank!!)
        skip_lines:  SKIP_REGEX,
        :converters => :strip
      }
      defaults
    end
  end # class Configuration


  ## lets you use
  ##   Csv.configure do |config|
  ##      config.sep = ','   ## or "/t"
  ##   end

  def self.configure
    yield( config )
  end

  def self.config
    @config ||= Configuration.new
  end
end   # module Csvv



####
## use our own wrapper

class CsvReader

  def self.parse_line( txt, sep:        Csv.config.sep,
                            trim:       Csv.config.trim?,
                            na:         Csv.config.na,
                            dialect:    Csv.config.dialect,
                            converters: nil)
    ## note: do NOT include headers option (otherwise single row gets skipped as first header row :-)
    csv_options = Csv.config.default_options.merge(
                    headers: false,  ## note: always turn off headers!!!!!!
                    col_sep: sep
    )
    ## pp csv_options
    CSV.parse_line( txt, csv_options )
  end

  def self.parse( txt, sep: Csv.config.sep, headers: false )
    csv_options = Csv.config.default_options.merge(
                     headers: headers,
                     col_sep: sep
    )
    ## pp csv_options
    CSV.parse( txt, csv_options )
  end

  def self.read( path, sep: Csv.config.sep, headers: false )
    ## note: use our own file.open
    ##   always use utf-8 for now
    ##    check/todo: add skip option bom too - why? why not?
    txt = File.open( path, 'r:bom|utf-8' )
    parse( txt, sep: sep, headers: headers )
  end

  def self.foreach( path, sep: Csv.config.sep, headers: false )
    csv_options = Csv.config.default_options.merge(
                     headers: headers,
                     col_sep: sep,
                     external_encoding: 'utf-8'  ## note:  always (auto-)add utf-8 external encoding for now!!!
    )

    ##  todo/check/fix:
    ##  can use bom e.g. 'bom|utf-8' - how?
    ##   raises ArgumentError: unknown encoding name - bom|utf-8


    CSV.foreach( path, csv_options ) do |row|
      yield( row )    ## check/todo: use block.call( row ) ## why? why not?
    end
  end

  def self.header( path, sep: Csv.config.sep )   ## use header or headers - or use both (with alias)?
      # read first lines (only)
      #  and parse with csv to get header from csv library itself
      #
      #  check - if there's an easier or built-in way for the csv library

      ## readlines until
      ##  - NOT a comments line or
      ##  - NOT a blank line

      lines = ''
      File.open( path, 'r:bom|utf-8' ) do |f|

        ## todo/fix: how to handle empty files or files without headers?!

        ## todo/check if readline includes \n\r too??
        ## yes! - line include \n e.g.
        ##   "Brewery,City,Name,Abv\n" or
        ##   "#######\n#  try with some comments\n#   and blank lines even before header\n\nBrewery,City,Name,Abv\n"
        loop do
          line = f.readline
          lines << line
          break unless  Csv.config.skip?( line ) || Csv.config.blank?( line )
        end
      end

      ## puts "lines:"
      ## pp lines

      ## note: do NOT use headers: true to get "plain" data array (no hash records)
      ##   hash record does NOT work for single line/row
      parse_line( lines, sep: sep )
    end  # method self.header

end # class CsvReader



class CsvHashReader

def self.parse( txt, sep: Csv.config.sep, headers: true )
  CsvReader.parse( txt, sep: sep, headers: headers )
end

def self.read( path, sep: Csv.config.sep, headers: true )
  CsvReader.read( path, sep: sep, headers: headers )
end

def self.foreach( path, sep: Csv.config.sep, headers: true, &block )
  CsvReader.foreach( path, sep: sep, headers: headers, &block )
end

def self.header( path, sep: Csv.config.sep )   ## add header too? why? why not?
  CsvReader.header( path, sep: sep )
end

end # class CsvHashReader
