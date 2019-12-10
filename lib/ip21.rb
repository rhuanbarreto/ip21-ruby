# frozen_string_literal: true

# Aspentech IP21 Adapter for executing queries using SQLPlus
#
# This library uses Windows Authentication for connecting to SQLPlus
#
# @author Rhuan Barreto
#
# @example
#   IP21.new(
#     auth: {
#       account: 'john.doe',
#       domain: 'contoso.com',
#       password: 'set_your_own_password'
#     },
#     sqlplus_address: '127.0.0.1',
#     ip21_address: '127.0.0.1',
#   ).query('SELECT IP_PLANT_AREA, Name, IP_DESCRIPTION FROM IP_AnalogDef')
class IP21
  # Initializes the connection
  #
  # @param [Hash] auth The Windows account, domain and password for connecting
  #   to SQLPLus
  # @param [String] sqlplus_address The hostname or IP address for connecting
  #   to SQLPlus
  # @param [String] ip21_address The hostname or IP address for connecting to
  #   the IP21 Database
  # @param [Boolean] debug Set this parameter to true for enabling debug
  #   information
  def initialize(
    auth: {
      account: 'john.doe',
      domain: 'contoso.com',
      password: 'set_your_own_password'
    },
    sqlplus_address: '127.0.0.1',
    ip21_address: '127.0.0.1',
    debug: false
  )
    @account = auth[:account]
    @domain = auth[:domain]
    @password = auth[:password]
    @sqlplus_address = sqlplus_address
    @ip21_address = ip21_address
    @debug = debug
  end

  # Executes a direct query againt the database
  #
  # @param [String] sql The query to be executed
  # @param [Integer] limit The maximum number of rows that the query will output
  #
  # @return [Hash] Response from the query
  def query(sql, limit = 100)
    parse_rest(
      rest_request('SQL', sql_query_body(sql, limit))
    )
  end

  # Fetch data from IP21 History
  #
  # @param [String] tag The tag to be queried
  # @param [Integer] start_time The unix timestamp in miliseconds for the start
  #   of the query period
  # @param [Integer] end_time The unix timestamp in miliseconds for the end of
  #   the query period
  # @param [Hash] opts Optional extra values
  # @option opts [Integer] limit The maximum number of items to be retrieved
  # @option opts [Integer] outsiders The maximum number of items to be retrieved
  # @option opts [Integer] history_format The value format during retrieval.
  #   Possible values are:
  #   - 0: Raw
  #   - 1: Record as String
  # @option opts [Integer] retrieval_type The retrieval type of the query.
  #   Possible values are:
  #   0 - Actual
  #   1 - Interpolated
  #   2 - Best Fit
  #   3 - Manual
  #   10 - Not Good
  #   11 - Good
  #   12 - Average
  #   13 - Maximum
  #   14 - Minimum
  #   15 - Range
  #   16 - Sum
  #   17 - Standard Deviation
  #   18 - Variance
  #   19 - Good Only
  #   20 - Suspect Only
  #   21 - First
  #   22 - Last
  # @option opts [Integer] outsiders Whether or not to include outsiders
  #   0 - False
  #   1 - True
  #
  # @return [Hash] Response from IP21
  def history(tag, start_time, end_time, opts = {
    limit: 1000, outsiders: 1, history_format: 0, retrieval_type: 0
  })
    parse_rest(
      rest_request(
        'History',
        history_query_body(tag, start_time, end_time, opts)
      )
    )
  end

  def kpi(tag)
    parse_rest(rest_request('KPI', kpi_query_body(tag)))
  end

  private

  def rest_request(type, body)
    require 'net/http'
    require 'ntlm/http'
    uri = URI(rest_address(type))
    http = Net::HTTP.new(uri.host)
    request = Net::HTTP::Post.new(uri)
    request.body = body
    request.ntlm_auth(@account, @domain, @password)
    response = http.request(request)
    debug_info(uri, request.body, response) if @debug
    response
  end

  def debug_info(address, body, response)
    puts "Request: #{address}"
    puts "Body: #{body}"
    puts "Response: #{response.body}"
  end

  def parse_rest(response)
    if response.code == '200'
      require 'json'
      JSON.parse(response.body)
    else
      {
        status: response.code,
        message: "Error on IP21: #{response.message}"
      }
    end
  end

  def rest_address(type)
    "http://#{@sqlplus_address}/ProcessData/AtProcessDataREST.dll/#{type}"
  end

  def sql_query_body(sql, limit = 1000)
    "<SQL c=\"DRIVER={AspenTech SQLplus};HOST=#{@ip21_address};Port=10014;" \
    "CHARINT=N;CHARFLOAT=N;CHARTIME=N;CONVERTERRORS=N;\" m=\"#{limit}\" " \
    "to=\"30\" s=\"#{select?(sql) ? 1 : 0}\"><![CDATA[#{sql}]]></SQL>"
  end

  def kpi_query_body(tag)
    require 'active_support'
    require 'active_support/core_ext/object/to_query'
    {
      dataSource: @ip21_address,
      tag: tag,
      allQuotes: 1
    }.to_query
  end

  def history_query_body(tag, start_time, end_time, opts)
    '<Q f="D" allQuotes="1"><Tag>' + "<N><![CDATA[#{tag}]]></N>" \
      "<D><![CDATA[#{@ip21_address}]]></D>" + "<HF>#{opts[:history_format]}</HF>" \
      "<St>#{start_time}</St>" + "<Et>#{end_time}</Et>" \
      "<RT>#{opts[:retrieval_type]}</RT>" + "<X>#{opts[:limit]}</X>" \
      "<O>#{opts[:outsiders]}</O>" + '</Tag></Q>'
  end

  def select?(query)
    /^select/i.match?(query)
  end
end
